---
title: Інвертований світлодіод
date: 2025-10-11 23:15:28 +03:00
mtime: 2025-10-12 00:21:16 +03:00
---

На платі Raspberry Pi Pico є вбудований світлодіод (GPIO25), і на платах ESP8266 теж є вбудований світлодіод (GPIO2). Але є важлива різниця.

Вбудований світлодіод Raspberry Pi Pico світиться, якщо подати на відповідний GPIO високий рівень сигналу, і не світиться якщо встановити низький рівень сигналу. Поведінка ESP8266 протилежна: високий рівень сигналу там _вимикає_ світлодіод.

Тобто, клас `BlinkingLED` з [попередьного посту][1] в режимі «не блимати» має різну поведінку на Raspberry Pi Pico та ESP8266: для RP2 вимикання режиму блимання робить світлодіод неактивним, а для ESP8266 вимикання режиму блимання врубає світлодіод на повну. (В режимі «блимати» вони все ж виглядають однаково). Тож треба з цим щось зробити, чи не так?

Окей, давайте і тут зробимо щось сумнівне… 

```python
class InvertedPinOut:
    def __init__(self, pin):
        self.pin = pin

    def value(self, new_value):
        self.pin.value(1 - new_value)
```

Об'єкт цього класу можна передавати в `BlinkingLED` замість `machine.Pin`. Норм чи крінж?

Альтернативно, ми можемо додати в клас `BlinkingLED` властивість `is_inverted` і додаткову логіку:

```diff
     async def main(self):
         while True:
-            self.pin.value(int(self.blinking))
+            self.pin.value(int(self.blinking ^ self.is_inverted))
             await asyncio.sleep_ms(500)
-            self.pin.value(0)
+            self.pin.value(int(self.is_inverted)
             await asyncio.sleep_ms(500)
```

Це скоріше крінж.

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
```

Зовсім крінж. Як же краще?

Увага, правильна відповідь, щойно випадково знайдена в документації: можна використати вже наявний в стандартній бібліотеці [клас `machine.Signal`][2]:

```python
led = machine.Signal(machine.Pin(2, machine.Pin.OUT), invert=True)
```

Яка проста і прикольна штука!

[1]: /2025/10/09/python-blinking-led.html
[2]: https://docs.micropython.org/en/latest/library/machine.Signal.html
