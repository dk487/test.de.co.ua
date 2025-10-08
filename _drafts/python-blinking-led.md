---
title: MicroPython та блимаючий світлодіод
placeholder: here
---

Привіт, світ! Сьогодні я [знову][1] буду блимати світлодіодом.

Цього разу я звернуся до класичного жанру, одного з найжорстокіших та найбезглуздіших дисциплін «спеціальної олімпіади» з програмування: це DRY, «[don't repeat yourself][2]». Міф про універсальний код, який чудово буде працювати всюди без модифікацій. Як на мене, гонитва за цим DRY буває навіть гіршою за синдромом «[not invented here][4]».

Оскільки я все це роблю задля своєї розваги, то можу собі дозволити такі брутальні експерименти.


## Опис завдання

За моїм задумом, жменька простого, тупого (місцями тривіального) коду на Python має працювати більш-менш однаково на двох достатньо різних платформах:

 - на якійсь ESP8266 (WeMos D1 mini) через MQTT + Wi-Fi, та
 - на Raspberry Pi Pico через `/dev/ttyASM0`, shell-скрипти та `socat`

Що має робити цей код? Те саме, [що я вже робив][4] півтора роки тому:

 - блимати світлодіодом
 - вмикати/вимикати блимання світлодіодом по команді, отриманій з MQTT
 - вмикати/вимикати блимання через натискання на кнопку локально
    - в тому числі при втраті зв'язку з брокером MQTT
 - передавати брокеру MQTT поточний стан (блимає/не блимає)

Додатковий бонус для ESP8266:

 - звітувати брокеру MQTT про свою наявність онлайн
 - звітувати (через last will) про перехід в офлайн
 - використовувати флаг retain для індикації стану онлайн/офлайн

Заради цього мені знадобиться купа допоміжного коду. Ну шо, погнали.


## Реалізація

У мене було декілька спроб зробити це нормально. Я починав з налаштування мережі, комунікації з брокером MQTT, і виходило якось кострубато і некрасиво.

Але потім я підійшов з іншого боку. Взагалі відклав всю цю возню з мережею. У центрі мають бути не технічні деталі підключення до брокера, а внутрішні процеси і зв'язки. А, забув сказати, це має бути асинхронний код. Тож архітектура важлива.

Почнемо з головного, зі світлодіода.


### Чернетка

Просто поблимаємо світлодіодом. Повільно і спокійно, на частоті 1 Гц, з затримкою 0,5 секунди.

```python
import asyncio
import machine

class BlinkingLED:
    def __init__(self, gpio):
        self.gpio = gpio
        self.is_blinking = True

    async def main(self):
        while True:
            await asyncio.sleep_ms(500)
            self.gpio.value(int(self.is_blinking))
            await asyncio.sleep_ms(500)
            self.gpio.value(0)

try:
    # WeMos D1 mini: built-in LED = pin D4 = GPIO2
    led = machine.Pin(2, machine.Pin.OUT)
    
    # Raspberry Pi Pico: built-in LED = GPIO25
    #led = machine.Pin(25, machine.Pin.OUT)

    led_task = BlinkingLED(led)
    asyncio.run(led_task.main())
except KeyboardInterrupt:
    print('Stopped')
```

Окей. Це один процес. Мені знадобиться декілька різних процесів, які будуть щось робити: блимати світлодіодом, зчитувати стан кнопки, комунікувати з зовнішнім світом. Кожен з цих процесів — якийсь об'єкт з методом `main`, всередині якого нескінченний цикл.

Додамо ще один процес, який кожні 5 секунд буде вмикати або вимикати режим блимання цього світлодіода. І ще додамо якийсь клас, який запускатиме декілька різних процесів разом. І, звісно, зміниться шматок кода для запуска цього. Але клас `BlinkingLED` з попереднього лістингу кода залишається без змін.

```python
class DemoScenario:
    def __init__(self, led_task):
        self.led_task = led_task

    async def main(self):
        while True:
            await asyncio.sleep(5)
            self.led_task.is_blinking = not self.led_task.is_blinking

class App:
    tasks = []

    async def main(self):
        tasks = [task.main() for task in self.tasks]
        await asyncio.gather(*tasks)

try:
    led = machine.Pin(2, machine.Pin.OUT)
    led_task = BlinkingLED(led)
    demo = DemoScenario(led_task)
    app = App()
    app.tasks.append(led_task)
    app.tasks.append(demo)
    asyncio.run(app.main())
except KeyboardInterrupt:
    print('Stopped')
```

Вже цікавіше! Але тут я бачу одну _слабку_ ділянку архітектури: _сильну_ зв'язаність між об'єктами класів `DemoScenario` та `BlinkingLED`. Клас сценарію напряму керує станом світлодіода. Хочу, щоб керування це відбувалося не напряму, а через повідомлення, як з брокером MQTT.


### Про повідомлення MQTT

Вся ця фігня задумана для використання з красивими дашбордами на Node-RED. Має бути вимикач на дашборді, в який можна ткнути мишкою.

Кожен пристрій має своє ім'я, наприклад `board98` та `board99`. Всі повідомлення в MQTT, що стосуються певної плати, повинні мати топік з певним префіксом — `dev/board99`, `home/kitchen/board99` або просто `board99`.

Традиційно, вся комунікація з _одним_ світлодіодом має відбуватися через _два_ різних топіки: назвемо їх `board99/led` та `board99/led/set`.

Topic             | Payload     | Напрямок передачі повідомлення
------------------|-------------|--------------------------------
`board99/led`     | `0` або `1` | звіт пристрою про стан
`board99/led/set` | `0` або `1` | команда від брокера до пристрою

Префікс потрібний для комунікації з зовнішнім світом, а внутрішні зв'язки (наприклад, між кнопкою і світлодіодом) обходяться без префіксу.


### Локальний хаб повідомлень

Задум такий: без всякого зовнішнього брокера MQTT передавати повідомлення всім зацікавленим процесам. Кожен з процесів, в свою чергу, може щось з цим зробити на свій розсуд.

Цього разу всі класи змінилися, включаючи `BlinkingLED`.

```python
import asyncio
import machine

class App:
    tasks = []
    listeners = []

    def add(self, obj):
        if hasattr(obj, 'main'):
            self.tasks.append(obj)
        if hasattr(obj, 'handle'):
            self.listeners.append(obj)

    async def main(self):
        tasks = [task.main(self) for task in self.tasks]
        await asyncio.gather(*tasks)

    def handle(self, topic, payload):
        for listener in self.listeners:
            listener.handle(topic, payload)

class BlinkingLED:
    def __init__(self, gpio, topic):
        self.gpio = gpio
        self.is_blinking = True
        self.topic = topic

    async def main(self, app):
        while True:
            await asyncio.sleep_ms(500)
            self.gpio.value(int(self.is_blinking))
            app.handle(self.topic, int(self.is_blinking))
            await asyncio.sleep_ms(500)
            self.gpio.value(0)
            app.handle(self.topic, 0)

    def handle(self, topic, payload):
        if topic == self.topic+'/set':
            self.is_blinking = bool(int(payload))

class DemoScenario:
    def __init__(self, led_topic):
        self.led_topic = led_topic

    async def main(self, app):
        while True:
            await asyncio.sleep(5)
            app.handle(self.led_topic, 0)
            await asyncio.sleep(5)
            app.handle(self.led_topic, 1)

class DebugMessages:
    def handle(self, topic, payload):
        print(topic, payload)

try:
    app = App()
    led = machine.Pin(2, machine.Pin.OUT)
    app.add(BlinkingLED(led, 'led'))
    app.add(DemoScenario('led/set'))
    app.add(DebugMessages())
    asyncio.run(app.main())
except KeyboardInterrupt:
    print('Stopped')
```

Є певна асиметричність у поведінці цих класів. Клас `BlinkingLED` як приймає повідомлення, так і відправляє. Клас `DemoScenario` лише відправляє повідомлення. Клас `DebugMessages` лише приймає. і у нього немає метода `main`.

У попередній версії я намагався на рівні класа `App` визначати, які процеси мають отримати кожне окреме повідомлення. Цього разу я відправляю всі повідомлення всім слухачам, а вони розбираються, що їм треба. Наприклад, клас `DebugMessages` опрацьовує всі повідомлення.

Коли я в IDE Thonny запускаю на мікроконтролері цей код, то бачу в консолі щось таке:

```
led 1
led 0
led 1
led 0
led 1
led 0
led 1
led 0
led 1
led/set 0
led 0
led 0
led 0
led 0
```

Спочатку блимали світлодіодом, потім не блимаємо. Видно як стан світлодіода, так і команду, яка переменула режим.

Дико переускладнений варіант: 64 рядки асинхронного коду там, де того ж самого результату можна було б досягти в три рядки і два цикли :) але, на мою думку, це має бути більш-менш правильний підхід, з точки зору мого задуму. Бо далі буде більше коду.


### З'єднання з зовнішнім світом

Це буде розповідь про ESP8266, яку ми любимо за її Wi-Fi.

Припустимо, весь попередній код ми писали в `main.py`, що є цілком традиційним підходом. Нехай у нас також є `boot.py`, і там ми напишемо пароль від вайфаю:

```
import network

wlan = network.WLAN(network.STA_IF)
wlan.active(True)
if not wlan.isconnected():
    wlan.connect('ssid', 'password')
```

Оцей от `wlan.connect` лише _розпочинає_ процес з'єднання. Тобто весь цей фрагмент коду не заблокує нам виконання програми на декілька секунд.

Тепер в основному `main.py` додамо ось такий клас:

```python
import umqtt.simple

class WirelessMQTT:
    def __init__(self, server, prefix, **kwargs):
        self.wlan = network.WLAN(network.STA_IF)
        self.prefix = prefix+'/'
        kwargs['keepalive'] = 2
        self.mq = umqtt.simple.MQTTClient(prefix, server, **kwargs)
        self.mq.set_last_will(self.prefix+'online', b'0', retain=True)
        self.mq.set_callback(self.mqtt_callback)
        self.nodup_t = self.nodup_p = None

    async def main(self, app):
        self.app = app
        while not self.wlan.isconnected():
            await asyncio.sleep(0)
        self.mq.connect()
        self.mq.publish(self.prefix+'online', b'1', retain=True)
        self.mq.subscribe(self.prefix+'+/set')
        await asyncio.gather(self.ping(), self.check_msg())

    async def ping(self):
        while True:
            self.mq.ping()
            await asyncio.sleep(1)

    async def check_msg(self):
        while True:
            self.mq.check_msg()
            await asyncio.sleep(0)

    def mqtt_callback(self, topic, payload):
        topic, payload = topic.decode(), payload.decode()
        if topic.startswith(self.prefix):
            topic = topic[len(self.prefix):]
            self.nodup_t, self.nodup_p = topic, payload
            self.app.handle(topic, payload)
            self.nodup_t = self.nodup_p = None

    def handle(self, topic, payload):
        if self.mq and self.mq.sock:
            if isinstance(payload, int):
                payload = str(payload)
            if topic != self.nodup_t or payload != self.nodup_p:
                self.mq.publish(self.prefix+topic, payload)
```

І в кінці файлу, там де ми ініціалізуємо всі процеси і складаємо їх в один клас `App`, додаємо виклик цього класу:

```python
app.add(WirelessMQTT('192.168.0.123', 'board99'))
```

Коли ESPшка з'єднається з мережею і підключиться до брокера MQTT, то всі наші повідомлення почнуть передаватися назовні. І, відповідно, зовнішні повідомлення передаватимуться класам, таким як `BlinkingLED`.

Цей код не дуже елегантний, але він працює.


### З'єднання з зовнішнім світом _через кабель_

Тепер черга для Raspberry Pi Pico, до якої можна дістатися через `/dev/ttyACM0` за допомогою [програми `socat` та моїх скриптів][4]. Тут все інакше і дикіше.

```python
import sys
import select

class StdioConnector:
    def __init__(self, prefix):
        self.prefix = prefix+'/'
        self.nodup_t = self.nodup_p = None

    async def main(self, app):
        poller = select.poll()
        poller.register(sys.stdin, select.POLLIN)
        while True:
            res = poller.poll(0)
            if res:
                line = sys.stdin.readline().strip()
                if line:
                    topic, payload = line.split(' ', 1)
                    if topic.startswith(self.prefix):
                        topic = topic[len(self.prefix):]
                        self.nodup_t, self.nodup_p = topic, payload
                        app.handle(topic, payload)
                        self.nodup_t = self.nodup_p = None
            await asyncio.sleep(0)
    
    def handle(self, topic, payload):
        if topic != self.nodup_t or payload != self.nodup_p:
            print(self.prefix+topic, payload)
```

Отак.


## Висновки

Я пропущу питання з кнопкою, тим більше що у мене нашвидкоруч зроблений варіант без debounce. Також пропущу незграбні моменти з тим, що onboard світлодіод на ESPшці інвертований, а на Pi Pico він нормальний. Просто обмежусь тим, що в «фінальній» версії (тобто фінальній на сьогодні) я блимаю світлодіодом у енергійному темпі, коли кнопка натиснена.

Головне: вся ця катавасія дійсно працює, як локально, так і з зовнішнім брокером MQTT. Як по Wi-Fi, так і по кабелю. Можна в Node-RED робити зв'язки однієї плати з іншою. Зашибісь.

 * [Код для ESP8266][5]
 * [Код для RP2040][6]

Невелике відео демонстрації роботи на YouTube: <https://youtu.be/_cbC2cjzg2k>

[1]: /2025/03/23/pro-svitlodiody.html
[2]: https://uk.wikipedia.org/wiki/Don%27t_repeat_yourself
[3]: https://uk.wikipedia.org/wiki/%D0%92%D0%B8%D0%BD%D0%B0%D0%B9%D0%B4%D0%B5%D0%BD%D0%BE_%D0%BD%D0%B5_%D0%BD%D0%B0%D0%BC%D0%B8
[4]: /2024/03/18/mqtt-oop.html
[5]: https://github.com/kastaneda/mpy_sandbox/blob/master/just_pep8/f/main.py
[6]: https://github.com/kastaneda/mpy_sandbox/blob/master/just_pep8/f/main_rp2040.py
