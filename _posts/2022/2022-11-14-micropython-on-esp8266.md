---
title: MicroPython на ESP8266
date: 2022-11-14 04:40:03 +02:00
mtime: 2023-01-08 22:38:51 +02:00
opengraph: uploads/nodemcu_button.png
---

Спробував сабж, сподо́балося.

Не дуже стабільно працює (треба розібра́тися з режимами сну). Дуже багато струму споживає (знов-таки, треба розібра́тися з режимами сну). Документація місцями застаріла, нето́чна, навіть непо́вна. Багато чого зроблено нелогі́чно. Різні версії прошивки та бібліотек ведуть себе по-різному. Треба багато що гуглити і багато про що здогадуватися.

Але я [почита́в мануал][1], погуглив, щось десь здогадався і в ме́не все вийшло. 


## Встановлення прошивки

Для більшості плат на ESP8266 та ESP32 все відбувається одноти́пно.

```sh
sudo apt install esptool

esptool --chip esp8266 --port /dev/ttyUSB0 chip_id
esptool --chip esp8266 --port /dev/ttyUSB0 flash_id

# натиснути і тримати FLASH на платі перед запуском команди
esptool --chip esp8266 --port /dev/ttyUSB0 erase_flash
```

Чомусь у мене `erase_flash` не працює, але (ще більше «чомусь») це не виявилося проблемою, бо при запису прошивки все одно флешка чиститься. Ну і ладно.

Далі. Власне, «прошивка прошивки», бгг. Готову прошивку MicroPython я взяв останню стабільну з [офіційного сайту][2], ліньки було збирати. І…

```sh
# натиснути і тримати FLASH на платі перед запуском команди
esptool --chip esp8266 --port /dev/ttyUSB0 write_flash \
  --flash_mode dio --flash_size detect 0x0 esp8266-20220618-v1.19.1.bin
```

Щоб подивитися і переконатися, що REPL працює, можна спочатку глянути у Minicom.

```sh
minicom -D /dev/ttyUSB0
```

Шкода, WebREPL мені на цій прошивці чомусь (знову чомусь!) запустити не вдалося, команда `import webrepl_setup` падає з якимись матюками на піто́ні. Мені ще гуглити та гуглити, можливо спробувати іншу версію чи іншу збірку.

Так чи інакша, для нормальної роботи з файловою системою MicroPython треба використовувати щось зручне́. Я, як повний чайник, використовував Thonny IDE.

```sh
sudo apt install thonny
```

Далі я в настро́йках Thonny кажу використовувати інтерпретатор на платі ESP8266 (Tools → Options → Interpreter). Усьо, можна виконувати код безпосередньо на платі та писати туди файли.

Файл `boot.py` стартує автоматично, от я його і написав.


## Привіт, світ!

Ось моя перша незгра́бна програма. Це як blink, тільки з Wi-Fi та MQTT.

```python
import network
import time
from machine import Pin
from umqtt.robust import MQTTClient

###########################################
# Configure WiFi

sta_if = network.WLAN(network.STA_IF)
sta_if.active(True)
sta_if.connect("...my_ssid...", "...my_password...")

while not sta_if.isconnected():
    #print("Connecting...")
    time.sleep_ms(250)
    
#print("Connected")

###########################################
# Connect to MQTT broker

c = MQTTClient('ESP8266_board01', '192.168.0.34', keepalive=5)
c.connect()

c.publish('board01/status', '1')
c.set_last_will('board01/status', '0')

###########################################
# Click handler

led = Pin(2, Pin.OUT)
state = True

time_last_click = 0
min_click_delay = 150

def set_led():
    if state:
        led.value(0)
        #print("LED is On")
    else:
        led.value(1)
        #print("LED is Off")

def d1_callback(pin):
    global state
    global time_last_click
    time_now = time.ticks_ms() 
    if ((time_now - time_last_click) > min_click_delay):
        time_last_click = time_now
        state = not state
        set_led()
        #print("Clicked")
        c.publish('board01/d1_button', 'clicked')
        c.publish('board01/led', '1' if state else '0')

d1 = Pin(5, Pin.IN, Pin.PULL_UP)   
d1.irq(trigger=Pin.IRQ_FALLING, handler=d1_callback)

###########################################
# MQTT handler

def mqtt_callback(topic, msg):
    global state
    #print("Topic=%s Msg=%s" % (topic, msg))
    if topic == b'board01/led/set':
        state = True if (msg == b'1') else False
        set_led()

c.set_callback(mqtt_callback)
c.subscribe('board01/+/set')

###########################################

set_led()

while True:
    c.wait_msg()
```


## Схема підключення

Ну, тут все дуже просто: одна плата NodeMCU, одна кнопка.

Непростим є те, що я в реальності маю одну дуже зручну́ і дуже рідкісну маке́тку незви́чної ширини: там не по 5, а по 6 контактів. Не знаю, де таких ще взяти, бо у продажу бачу тільки такі, як на малюнку. 
 
![Схема підключення кнопки до плати NodeMCU](/uploads/nodemcu_button.png)

Як у більшості плат на ESP8266, тут є позначки D0, D1, D2 і так далі, які [не співпада́ють з номерами GPIO][4]. Зокрема, GPIO5 це D1 (це його я підключа́ю до кнопки). Де логіка?

Ну а вбудований світлодіод живе на GPIO2, і він інвертований. Тобто, для нього встановлення значення 0 означає «світитися», а значення 1 це «не світитися». Хаха.


## Як воно працює

Натиска́ю на кнопку — вбудований в модуль світлодіод гасне, ще раз натиска́ю — світлодіод світиться.

А ще ця штука при старті підключається до Wi-Fi. А ще після Wi-Fi вона підключається до брокера MQTT. Всі зміни стану світлодіода передає на окремий топік `board01/led` (значення 0 та 1, не інвертовані, 1 значить увімкенено). Також підписується на топік `board01/led/set` і реагує на значення з цього топіку (1 — увімкнути світлодіод, все інше — вимкнути).

Ну і, наостанок, я до цього прикрути́в dashboard на Node-RED.


## Node-RED

Це сам flow.

![Знімок екрану: Node-RED flow](/uploads/nodered_flow.png)

А це фрагмент dashboard'у.

![Знімок екрану: фрагмент dashboard'у Node-RED](/uploads/nodered_dashboard.png)

Тицяю мишкою в перемикач ­— світлодіо́д реагує. Тицяю пальцем в кнопку на платі — перемикач і світлодіо́д реагують. Магія.

Я навіть зробив експорт цього flow, якщо воно раптом комусь треба.

```json
[
    {
        "id": "8525e52b41372307",
        "type": "mqtt in",
        "z": "666b443292f97b52",
        "name": "",
        "topic": "board01/led",
        "qos": "0",
        "datatype": "auto-detect",
        "broker": "23961fcc55155717",
        "nl": false,
        "rap": true,
        "rh": 0,
        "inputs": 0,
        "x": 230,
        "y": 160,
        "wires": [
            [
                "0de2a29970483d9f"
            ]
        ]
    },
    {
        "id": "952ddde7da23382f",
        "type": "mqtt out",
        "z": "666b443292f97b52",
        "name": "",
        "topic": "board01/led/set",
        "qos": "",
        "retain": "",
        "respTopic": "",
        "contentType": "",
        "userProps": "",
        "correl": "",
        "expiry": "",
        "broker": "23961fcc55155717",
        "x": 610,
        "y": 200,
        "wires": []
    },
    {
        "id": "0de2a29970483d9f",
        "type": "ui_switch",
        "z": "666b443292f97b52",
        "name": "",
        "label": "LED",
        "tooltip": "",
        "group": "ab54f8c19c709aea",
        "order": 1,
        "width": 0,
        "height": 0,
        "passthru": true,
        "decouple": "false",
        "topic": "topic",
        "topicType": "msg",
        "style": "",
        "onvalue": "1",
        "onvalueType": "num",
        "onicon": "",
        "oncolor": "",
        "offvalue": "0",
        "offvalueType": "num",
        "officon": "",
        "offcolor": "",
        "animate": false,
        "className": "",
        "x": 410,
        "y": 180,
        "wires": [
            [
                "952ddde7da23382f"
            ]
        ]
    },
    {
        "id": "23961fcc55155717",
        "type": "mqtt-broker",
        "name": "default",
        "broker": "mqtt",
        "port": "1883",
        "clientid": "",
        "autoConnect": true,
        "usetls": false,
        "protocolVersion": "4",
        "keepalive": "60",
        "cleansession": true,
        "birthTopic": "",
        "birthQos": "0",
        "birthPayload": "",
        "birthMsg": {},
        "closeTopic": "",
        "closeQos": "0",
        "closePayload": "",
        "closeMsg": {},
        "willTopic": "",
        "willQos": "0",
        "willPayload": "",
        "willMsg": {},
        "userProps": "",
        "sessionExpiry": ""
    },
    {
        "id": "ab54f8c19c709aea",
        "type": "ui_group",
        "name": "Default",
        "tab": "6b375bd8aad6411f",
        "order": 1,
        "disp": true,
        "width": 6,
        "collapse": false,
        "className": ""
    },
    {
        "id": "6b375bd8aad6411f",
        "type": "ui_tab",
        "name": "Home",
        "icon": "check",
        "disabled": false,
        "hidden": false
    }
]
```

Ну власне і все. Отака фігня.

_Оновлення о 15:04_: я написав пост-продовження [про Mosquitto та Node-RED][3].

[1]: https://docs.micropython.org/en/latest/esp8266/quickref.html
[2]: https://micropython.org/download/esp8266/
[3]: /2022/11/14/running-mosquitto-and-nodered.html
[4]: https://www.google.com/search?q=esp8266+nodemcu+v3+pinout&tbm=isch
