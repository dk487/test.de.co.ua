---
title: Arduino open drain
title_lang: en
date: 2022-11-04 23:26:31 +02:00
---

Сьогодні я за допомогою Arduino блимав світлодіодом. Двома світлодіодами. Ха-ха.

![Схема з двома світлодіодами](/uploads/blink2.png)

Все дуже просто.

```cpp
void setup() {
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
}

void loop() {
  digitalWrite(2, HIGH);
  digitalWrite(3, LOW);
  delay(500);

  digitalWrite(2, LOW);
  digitalWrite(3, HIGH);
  delay(500);
}
```

Прикол тут в тому, що контакт з сигналом `LOW` працює як відкритий колектор. А от, наприклад, наявні в мене мікросхеми серії 74HC595 як відкритий колектор працювати не хочуть.

Життя бентежне.

Оновлення 23:57: запостив в твітер дуже важливе [відео того, як працює цей код][1].

[1]: https://twitter.com/kastaneda/status/1588651416910192640