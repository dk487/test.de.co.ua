---
title: Arduino та бли́маючий світлодіо́д
date: 2024-02-08 18:49:25 +02:00
mtime: 2024-02-16 08:20:44 +02:00
opengraph_generator:
  template: clickbait01
  label_row1: Arduino
  label_row2: blinking LED
  key_color: 6f9
---

Привіт, світ! Сьогодні я буду _тупо блимати світлодіо́дом_, ха-ха.

Це са́ма тривіальна фігня, яку тільки можна зробити з Arduino. Всі це робили. Здається, я вперше грався з блиманням світлодіо́ду у лютому 2013, приблизно одинадцять років тому, і мені це досі не набридло. Звісно, я починав зі стандартного при́клада [Blink][1], вбудованого в Arduino IDE.

```cpp
void setup() {
  pinMode(LED_BUILTIN, OUTPUT);
}

void loop() {
  digitalWrite(LED_BUILTIN, HIGH);
  delay(1000);
  digitalWrite(LED_BUILTIN, LOW);
  delay(1000);
}
```

Просто і елегантно, чи не так?


## Блимаючий світлодіо́д

Сьогодні мені по прико́лу написати важкий, переускла́днений код на C++.

Якщо без іро́нії, то я просто вчу C++.

```cpp
#include "Arduino.h"

class ShouldSetup {
public:
  virtual void setup() = 0;
};

class ShouldLoop {
public:
  virtual void loopAt(unsigned long timeNow) = 0;
  void loop();
};

void ShouldLoop::loop() {
  this->loopAt(micros());
}

class ScheduledLoop: public ShouldLoop {
public:
  unsigned long runPeriod = 1000000; // default: 1s
  void loopAt(unsigned long timeNow);

protected:
  virtual void runScheduled() = 0;

private:
  unsigned long lastRun = 0;
};

void ScheduledLoop::loopAt(unsigned long timeNow) {
  if ((timeNow - this->lastRun) >= this->runPeriod) {
    this->runScheduled();
    this->lastRun = timeNow;
  }
}

class BlinkingLED: public ShouldSetup, public ScheduledLoop {
public:
  bool enabled = true;

  BlinkingLED(byte pin);
  void setup();
  void runScheduled();

private:
  byte pin;
  bool state = false;
};

BlinkingLED::BlinkingLED(byte pin) {
  this->pin = pin;
}

void BlinkingLED::setup() {
  pinMode(this->pin, OUTPUT);
  digitalWrite(this->pin, LOW);
}

void BlinkingLED::runScheduled() {
  this->state = this->enabled && !this->state;
  digitalWrite(this->pin, this->state ? HIGH : LOW);
}

BlinkingLED myBlinker(LED_BUILTIN);

void setup() {
  myBlinker.setup();
  myBlinker.runPeriod = 250000; // 250ms
}

void loop() {
  myBlinker.loop();
}
```

Прикольно, правда? Стандартний Blink вміща́ється в 10 рядків коду (разом з порожніми рядка́ми), а мій новий просу́нутий варіант з <abbr>ООП</abbr> займає більш ніж 70 рядків.

Якби мені платили за рядки коду, то це було б неабияке досягнення!


## Блимаючий світлодіо́д з кнопкою

Припустимо, я хочу додати цій програмі інтеракти́вності. Нехай у мене буде кнопка, яка вмика́тиме та вимика́тиме цей блимаючий світлодіо́д.

![Схема, на якій до Arduino Nano підключена одна кнопка](/uploads/just_a_button.png)

Кнопки зазвичай мають певний [брязкіт контактів][2]. Для боротьби з брязкітом можна використати вбудований в Arduino IDE стандартний приклад [Debounce][3]. Його я теж творчо переускла́днив.

Тож додамо до нашої програми ще один клас.

```cpp
class Debouncer: public ShouldLoop {
public:
  int stateDebounced = 0;
  unsigned long debounceDelay = 50000; // 50ms

  int (*readingSource)() = 0;
  void (*onRaise)() = 0;
  void (*onFall)() = 0;
  void (*onChange)(int state) = 0;

  void loopAt(unsigned long timeNow);

private:
  int lastReading = 0;
  unsigned long lastDebounceTime = 0;
};

void Debouncer::loopAt(unsigned long timeNow) {
  if (this->readingSource) {
    int reading = this->readingSource();

    if (reading != this->lastReading) {
      this->lastDebounceTime = timeNow;
    }

    if ((timeNow - this->lastDebounceTime) >= this->debounceDelay) {
      if (reading != this->stateDebounced) {
        this->stateDebounced = reading;
        if (this->onFall && !reading) this->onFall();
        if (this->onRaise && reading) this->onRaise();
        if (this->onChange) this->onChange(reading);
      }
    }

    this->lastReading = reading;
  }
}
```

І, нарешті, фінальну частину зробимо такого вигляду:

```cpp
BlinkingLED myBlinker(LED_BUILTIN);
const int myButtonPin = 2;
Debouncer myButton;

void setup() {
  myBlinker.setup();
  myBlinker.runPeriod = 250000; // 250ms
  pinMode(myButtonPin, INPUT_PULLUP);
  myButton.readingSource = []() { return digitalRead(myButtonPin); };
  myButton.onFall = []() { myBlinker.enabled = !myBlinker.enabled; };
}

void loop() {
  myBlinker.loop();
  myButton.loop();
}
```

І в цьому, нарешті, є хоч якийсь сенс. Різні частини програми займаються своїми справами, не блокуючи один одного; весь `void loop()` дуже короткий і тривіа́льний.

Очевидно, що клас `Debouncer` можна використовувати для різних кнопок / вимикачів / герко́нів. Менш очевидно, що йому на вхід можна подати результат сканування матриці клавіатури.

На цьому все.

На майбутнє, може треба буде колись зробити софтва́рний <abbr>PWM</abbr> цьому світлодіоду :)

[1]: https://docs.arduino.cc/built-in-examples/basics/Blink/
[2]: https://uk.wikipedia.org/wiki/%D0%91%D1%80%D1%8F%D0%B7%D0%BA%D1%96%D1%82_%D0%BA%D0%BE%D0%BD%D1%82%D0%B0%D0%BA%D1%82%D1%96%D0%B2
[3]: https://docs.arduino.cc/built-in-examples/digital/Debounce/
