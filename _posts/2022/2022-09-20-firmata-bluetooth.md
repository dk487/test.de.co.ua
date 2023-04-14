---
title: Firmata + Bluetooth
date: 2022-09-20 22:47:08 +03:00
mtime: 2023-01-08 22:38:51 +02:00
opengraph: uploads/HC-06.png
---

Запустив сабж.

Крім [двох нових модулів][1], маю [старий HC-06][4]. На відміну від нових, старий працює. От з ним [StandardFirmataPlus][2] і злеті́ла.

![Схема підключення HC-06 до Arduino Nano](/uploads/HC-06.png)

Модуль жере під час роботи десь 30–40 мА, окрім самого Arduino (і той ще 20). З таким рівнем споживання не зробиш пристрій, що місяцями працює від батарейок. Але взагалі щось якось робити з цим можна.

А ще прошивка у мого старого HC-06, схоже, крім `AT+NAME` не знає жодної команди. Тому я на ньому не можу змінити pin-код зі стандартного 1234 на щось інше; а саме сумне, що його швидкість там завжди 9600. Але цього для блимання світлодіодом вистачає.

Та до біса. Я додав всього кілька рядків коду до StandardFirmataPlus, і все запрацюва́ло, дашборд на Node-RED працює. Це ж кльово!

* * *

_Оновлення 21 вересня:_ на всяк випадок ось [StandardFirmataPlus з моїми змінами][3].

```diff
--- StandardFirmataPlus/StandardFirmataPlus.ino	2022-09-21 15:53:19.551743905 +0300
+++ StandardFirmataPlus_BT/StandardFirmataPlus_BT.ino	2022-09-20 22:25:21.343698266 +0300
@@ -746,6 +746,9 @@
     previousPINs[i] = 0;
   }

+  Firmata.setPinMode(10, PIN_MODE_IGNORE);
+  Firmata.setPinMode(11, PIN_MODE_IGNORE);
+
   for (byte i = 0; i < TOTAL_PINS; i++) {
     // pins with analog capability default to analog input
     // otherwise, pins default to digital output
@@ -777,6 +780,8 @@
   isResetting = false;
 }

+SoftwareSerial BluetoothSerial(10, 11);
+
 void setup()
 {
   Firmata.setFirmwareVersion(FIRMATA_FIRMWARE_MAJOR_VERSION, FIRMATA_FIRMWARE_MINOR_VERSION);
@@ -795,14 +800,14 @@

   // to use a port other than Serial, such as Serial1 on an Arduino Leonardo or Mega,
   // Call begin(baud) on the alternate serial port and pass it to Firmata to begin like this:
-  // Serial1.begin(57600);
-  // Firmata.begin(Serial1);
+  BluetoothSerial.begin(9600);
+  Firmata.begin(BluetoothSerial);
   // However do not do this if you are using SERIAL_MESSAGE

-  Firmata.begin(57600);
-  while (!Serial) {
-    ; // wait for serial port to connect. Needed for ATmega32u4-based boards and Arduino 101
-  }
+  //Firmata.begin(57600);
+  //while (!Serial) {
+  //  ; // wait for serial port to connect. Needed for ATmega32u4-based boards and Arduino 101
+  //}

   systemResetCallback();  // reset to default config
 }
```

[1]: /2022/09/19/bluetooth.html
[2]: /2022/09/12/firmata.html
[3]: https://github.com/kastaneda/arduino_sandbox/blob/master/StandardFirmataPlus_BT/StandardFirmataPlus_BT.ino
[4]: /2021/01/08/Bluetooth-HC-06.html
