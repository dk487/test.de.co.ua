---
title: Arduino open drain
title_lang: en
date: 2022-11-04 23:26:31 +02:00
opengraph: /uploads/blink2.png
---

Сьогодні я за допомогою Arduino блимав світлодіо́дом. Двома світлодіо́дами. Ха-ха.

![Схема з двома світлодіо́дами](/uploads/blink2.png)

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

Життя бенте́жне.

Оновлення 23:57: запостив в твітер дуже важливе [відео то́го, як працює цей код][1].

[1]: https://twitter.com/kastaneda/status/1588651416910192640
