---
title: Arduino та MQTT
date: 2024-02-20 23:59:59 +02:00
mtime: 2024-02-23 22:53:34 +02:00
opengraph_generator:
  template: clickbait01
  label_row1: Arduino
  label_row2: та MQTT
---

Колись я навчився блимати світлодіо́дом, [використовуючи прошивку Firmata][1]. А сьогодні я придумав, як робити те саме без неї, використовуючи в якості транспорта стандартний <abbr>MQTT</abbr>.


## Прошивка

Почнімо з простого і зрозумілого. Припустимо, у мене є прошивка, яка передає кілька раз на секунду показники аналогового порта `A0`, а також чекає на команду увімкнення чи вимкнення світлодіо́да.

```cpp
void setup() {
  Serial.begin(9600);
  pinMode(LED_BUILTIN, OUTPUT);
  digitalWrite(LED_BUILTIN, LOW);
}

unsigned long lastUpdate_A0 = 0;

const unsigned int readBufSize = 64;
char readBuf[readBufSize];
unsigned int readBufCount = 0;

char myLedControl[] = "dev/board05/led/set";

void handleCommand() {
  unsigned int i;
  for(i = 0; myLedControl[i]; i++) {
    if (myLedControl[i] != readBuf[i]) return;
  }
  digitalWrite(LED_BUILTIN, (readBuf[i+1] == '1') ? HIGH : LOW);
}

void loop() {
  unsigned long timeNow = micros();

  if ((timeNow - lastUpdate_A0) >= 500000) {
    Serial.print("dev/board05/A0 ");
    Serial.println(analogRead(A0), DEC);
    lastUpdate_A0 = timeNow;
  }

  if (Serial.available() > 0) {
    char incomingChar = Serial.read();
    if (readBufCount < readBufSize) {
      readBuf[readBufCount++] = incomingChar;
    }
    if (incomingChar == '\n') {
      handleCommand();
      readBufCount = 0;
    }
  }
}
```

Можна скомпілювати і прошити цей код в Arduino IDE, потім відкрити монітор послідовного порту і дивитися, що воно пише.

```
dev/board05/A0 652
dev/board05/A0 652
dev/board05/A0 651
dev/board05/A0 652
```

Можна в моніторі послідовного порту відправити команду `dev/board05/led/set 1` для увімкнення, або команду `dev/board05/led/set 0` для вимкнення вбудованого світлодіо́да. Команда має завершуватися символом нового рядка. Всі інші команди ігноруються.

Як можна помітити, `dev/board05/A0` та `dev/board05/led/set` виглядає схоже на топіки в <abbr>MQTT</abbr>. Так і є :)


## Node-RED

Колись у мене вже був пост з невеличким [лікне́пом про Node-RED][2]. У мене сьогодні проста схема: один вимикач, один <span lang="en">gauge</span>, два підключення до <abbr>MQTT</abbr>.

![Знімок екрану Node-RED зі сконфігуро́ваними потоками](/uploads/2024_nodered_flow.png)

Цілком зрозуміло, як цей дашборд має виглядати. Один вимикач, один <span lang="en">gauge</span>.

![Знімок екрану дашборду Node-RED](/uploads/2024_nodered_dashboard.png)


## Магія

Прошивку я написав швидко і як попа́ло, конфігурацію Node-RED зробив ще швидше. Там все тривіально. Лишається тільки якимось чином поєднати Arduino з <abbr>MQTT</abbr>.

Ось воно. Два маленькі shell-скрипти́, які зжерли мені трохи нервів і весь вечір.

### Скрипт `./run_ttyUSB0`

```sh
#!/bin/sh
while /bin/true; do
  socat -d -d -v /dev/ttyUSB0,b9600 exec:./io
  sleep 5
done
```

### Скрипт `./io`

```sh
#!/bin/sh
HOST="192.168.0.82"
SUBSCRIBE="#"
(mosquitto_sub -h "$HOST" -t "$SUBSCRIBE" -F "%t %p") &
while read TOPIC PAYLOAD; do
  if [ ! -z "$TOPIC" ]; then
    mosquitto_pub -h "$HOST" -t "$TOPIC" -m "$PAYLOAD"
  fi
done
```

Чорт, я сам в шоці. Після всіх експериментів фінальна версія вийшла така проста.

Так, вочевидь, це рішення має проблеми з швидкоді́єю: на кожне повідомлення запускати окремий `mosquitto_pub` може бути надто повільно. І взагалі це несерйозно. Але, чорт забирай, воно працює і воно абсолютно прозоре.

[Відео на YouTube: демонстрація роботи][3].


## Нахіба́ все це?

### Чому не Firmata? Вона створена саме для цього!

Firmata — це вже існуюче рішення, якісне і надійне. Але воно є «річ у собі». Firmata побудована навколо однієї ідеї: треба віддати назовні контроль за станом всього, що підклю́чено до мікроконтро́лера, _і все_. Керування підключеними світлодіо́дами та моторчиками має відбуватися тільки і виключно на хості.

А ще Firmata одна на всіх. Це більше готовий продукт, аніж бібліотека. Там, де її використовують за призначенням, можна один раз навічно прошити `StandardFirmataPlus` і цього досить.

Я хочу передавати на Arduino відносно високорі́вневі команди. В принципі, з Firmata це якось можна робити. Можна якось викрутитись. Створити віртуальні пристрої, наприклад. Але коли так робиш, то відчуваєш певний спротив: воно не для цього призначено, все йде «проти шерсті».

### Чому взагалі `/dev/ttyUSB0` і якісь дроти?

Для всюдисущих ESP32 керування і передача телеметрії робиться по Wi-Fi. Дуже зручно. Дуже кльово. Ніяких зайвих дротів. Всі так роблять. І ви робіть, якщо хочете. Це мейнстрім.

Та я вірю, що деяка ніша застосування є і у класичних Arduino зі старенькими <abbr>AVR</abbr>, підключених до хоста́ по <abbr>USB</abbr>. Обмежуся одним лише аргументом: прості рішення мають свою цінність.

### Чому свій «велосипед»? Може є інше готове рішення?

Є аналогічні готові рішення. Колись рік тому я нагугли́в аж два: [serial2mqtt][4] та [tty2mqtt][5]. Комусь вони підійдуть. Наче норм, теж непогані рішення, але мені щось муляє.

Моє рішення не створює додаткових складних залежностей. Нічого не треба компілюва́ти, не треба Java.  Тут треба встановити лише два невеликих пакети з консо́льними програмами, що вже є в репозитарії Debian: `socat` та `mosquitto-clients`. І оці маленькі shell-скрипти́.

Якщо серйозно, я ні на що і не претендую. Просто блимаю тут світлодіо́дом :)


[1]: /2022/09/12/firmata.html
[2]: /2022/11/14/running-mosquitto-and-nodered.html
[3]: https://www.youtube.com/watch?v=mkD1_YADdKg
[4]: https://github.com/vortex314/serial2mqtt
[5]: https://www.metacodes.pro/manpages/tty2mqtt_manpage/
