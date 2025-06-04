---
title: MicroPython та блимаючий світлодіод
placeholder: here
---

Привіт, світ! Сьогодні я [знову][1] буду блимати світлодіодом.

Цього разу я звернуся до класичного жанру, одного з найжорстокіших та найбезглуздіших дисциплін «спеціальної олімпіади» з програмування: це DRY, «[don't repeat yourself][2]». Міф про універсальний код, який чудово буде працювати всюди без модифікацій. Як на мене, гонитва за цим DRY буває навіть гіршою за синдромом «[not invented here][4]».

Оскільки я все це роблю задля своєї розваги, то можу собі дозволити такі брутальні експерименти.


## Опис завдання

За задумом, жменька простого, тупого (і навіть тривіального) коду на Python працюватиме більш-менш однаково на двох достатньо різних платформах:

 - на якійсь ESP8266 (WeMos D1 mini) через MQTT + Wi-Fi, та
 - на Raspberry Pi Pico через `/dev/ttyASM0`, shell-скрипти та `socat`

Що має робити цей код? Те саме, [що я вже робив][4] приблизно рік тому:

 - блимати світлодіодом
 - вмикати/вимикати блимання світлодіодом по команді, отриманій з MQTT
 - вмикати/вимикати блимання через натискання на кнопку локально
    - в тому числі при втраті зв'язку з брокером MQTT
 - передавати брокеру MQTT поточний стан (блимає/не блимає)

Додатковий бонус для ESP8266:

 - звітувати брокеру MQTT про свою наявність онлайн
 - звітувати (через last will) у випадку переходу в офлайн
 - використовувати флаг retain для звіту про онлайн/офлайн

Заради цього мені знадобиться до біса допоміжного коду. Ну шо, погнали.


## Вступ

### Про повідомлення MQTT

Вся ця фігня задумана для використання з красивими дашбордами на Node-RED. Має бути вимикач, в який можна ткнути мишкою і вплинути на світлодіод. А при натисканні фізичної кнопки на пристрої, при наявності зв'язку, вимикач на дашборді має сам по собі змінити стан.

Традиційно, вся комунікація має відбуватися через два різних топіки: назвемо їх `dev/board07/led` та `dev/board07/led/set`. Їх призначення достатньо очевидне.

Topic                 | Payload     | Напрямок передачі повідомлення
----------------------|-------------|--------------------------------
`dev/board07/led`     | `0` або `1` | звіт пристрою про стан
`dev/board07/led/set` | `0` або `1` | команда від брокера до пристрою

Сенс у тому, що один фізичний пристрій може керувати _декількома_ світлодіодами :) але наразі ми обійдемося лише одним.

Просто така вже у мене склалася схема найменувань топіків. У моїй схемі, топік складається з частин, які я назву `global_prefix` (може бути порожнім), `topic_prefix` (завжди наявний) та `topic_suffix` (теж може бути порожнім):

`global_prefix` | `topic_prefix` | `topic_suffix`
----------------|----------------|-------------
`dev/board07/`  | `led`          | `/set`


### Базовий клас `BaseHandler`

Кожен з _декількох_ світлодіодів, кожна кнопка, кожен серводвигун, кожен датчик температури і тиску — все це різний код, який має спільні риси. Тож мені потрібні певні рівні абстракції.

По-перше, він повинен мати можливість спілкуватися з зовнішнім світом, приймати та відправляти повідомлення.

По-друге, він має якось _працювати_. Овва, забув сказати, тут буде асинхронний код.

```python
class BaseHandler:
    def __init__(self, broker, topic_prefix):
        self.broker = broker
        self.topic_prefix = topic_prefix
        broker.subscribe(self)

    def send(self, topic_suffix, payload):
        topic = self.topic_prefix + topic_suffix
        self.broker.send(topic, payload)

    def handle(self, topic_suffix, payload):
        pass

    async def main(self):
        pass
```

Як бачите, ми тут посилаємося на якийсь брокер повідомлень; клас брокера мусить реалізувати методи `subscribe()` та `send()`, щось типу такого:

```python
class Broker:
    def __init__(self, global_prefix):
        self.handlers = []
        self.global_prefix = global_prefix

    def subscribe(self, handler):
        self.handlers.append(handler)

    def send(self, topic, payload):
        topic = self.global_prefix + topic
        # тут має бути відправка повідомлення до MQTT брокера
        raise NotImplementedError

    def handle(self, topic, payload):
        if topic.startswith(self.global_prefix):
            topic = topic[len(self.global_prefix):]
            for handler in self.handlers:
                if topic.startswith(handler.topic_prefix):
                    topic_suffix = topic[len(handler.topic_prefix):]
                    handler.handle(topic_suffix, payload)
```

## Реалізація

### Клас `DemoLED`: нарешті, _блимаємо світлодіодом!_

Ось вони, два десятки рядків кода, заради яких все це.

```python
import asyncio

class DemoLED(BaseHandler):
    def __init__(self, broker, topic_prefix, pin):
        super().__init__(broker, topic_prefix)
        self.pin = pin
        self.blinking = False

    def handle(self, topic_suffix, payload):
        if topic_suffix == '/set':
            self.set(bool(int(payload)))

    def set(self, new_blinking):
        self.blinking = new_blinking
        self.send('', int(self.blinking))

    async def main(self):
        while True:
            self.pin.value(int(self.blinking))
            await asyncio.sleep_ms(500)
            self.pin.value(0)
            await asyncio.sleep_ms(500)
            self.send('', int(self.blinking))
```


### Клас `DemoButton`

TODO FIXME: debounce, onPress / onRelease callbacks


### Зберемо все це докупи

TODO FIXME

Отут має бути купа спагетті-кода, який я ще не написав. Попередня версія прошивки для керування кроковими двигунами не годиться, її треба переписати.

До того ж, підключення до Wi-Fi треба переробити таким чином, щоб воно відбувалося асинхронно.


## Розбіжності, яких не вдалося уникнути


### Кнопка BOOTSEL

На платі Raspberry Pi Pico є кнопка BOOTSEL, стан якої (натиснута/не натиснута) можна зчитати через функцію `rp2.bootsel_button()`. На жаль, через стандартний для GPIO клас `machine.Pin` дістатися цієї кнопки неможливо.

Але що як я хочу використовувати BOOTSEL замість окремої кнопки? Зокрема, у класі `DemoButton`?

Нам же насправді від цього класу треба лише один метод `value()`, тож…

```python
import rp2

class BootselPinIn:
    def value(self):
        return 1 - rp2.bootsel_button()
```

Значення інвертується, щоб поведінка була як у `Pin.IN` в режимі `Pin.PULL_UP`.

Об'єкт цього класу можна передавати в `DemoButton` замість `machine.Pin`.


### Інвертований світлодіод

На платі Raspberry Pi Pico є вбудований світлодіод (GPIO25), і на платах ESP8266 теж є вбудований світлодіод (GPIO2). Але є важлива різниця.

Вбудований світлодіод Raspberry Pi Pico світиться, якщо подати на відповідний GPIO високий рівень сигналу, і не світиться якщо встановити низький рівень сигналу. Поведінка ESP8266 протилежна: високий рівень сигналу там _вимикає_ світлодіод.

Тобто, клас `DemoLED` в режимі «не блимати» має різну поведінку на Raspberry Pi Pico та ESP8266: для RP2 вимикання режиму блимання робить світлодіод неактивним, а для ESP8266 вимикання режиму блимання врубає світлодіод на повну. (В режимі «блимати» вони все ж виглядають однаково). Тож треба з цим щось зробити, чи не так?

Окей, давайте і тут зробимо щось сумнівне… 

```python
class InvertedPinOut:
    def __init__(self, pin):
        self.pin = pin

    def value(self, new_value):
        self.pin.value(1 - new_value)
```

Об'єкт цього класу можна передавати в `DemoLED` замість `machine.Pin`. Норм чи крінж?

Альтернативно, ми можемо додати в клас `DemoLED` властивість `is_inverted` і додаткову логіку:

```diff
     async def main(self):
         while True:
-            self.pin.value(int(self.blinking))
+            self.pin.value(int(self.blinking ^ self.is_inverted))
             await asyncio.sleep_ms(500)
-            self.pin.value(0)
+            self.pin.value(int(self.is_inverted)
             await asyncio.sleep_ms(500)
             self.send('', int(self.blinking))
```


Або так: зробити в класі властивості `value_on` та `value_off` (за замовчанням (для звичайних світлодіоів), значення 1 та 0, відповідно). Ще довше, але у певному сенсі наочніше.

```diff
     async def main(self):
         while True:
-            self.pin.value(int(self.blinking))
+            self.pin.value(self.value_on if self.blinking else self.value_off)
             await asyncio.sleep_ms(500)
-            self.pin.value(0)
+            self.pin.value(self.value_off)
             await asyncio.sleep_ms(500)
             self.send('', int(self.blinking))
```

Як краще? Треба подумати.


## Результат

TODO FIXME

Хочу зробити красиву фотку цих двох плат, і ще хочу декілька скріншотів Node-RED.


## Висновки

TODO FIXME


[1]: /2025/03/23/pro-svitlodiody.html
[2]: https://uk.wikipedia.org/wiki/Don%27t_repeat_yourself
[3]: https://uk.wikipedia.org/wiki/%D0%92%D0%B8%D0%BD%D0%B0%D0%B9%D0%B4%D0%B5%D0%BD%D0%BE_%D0%BD%D0%B5_%D0%BD%D0%B0%D0%BC%D0%B8
[4]: /2024/03/18/mqtt-oop.html
