---
title: Arduino-Makefile
title_lang: en
date: 2024-05-28 15:33:33 +03:00
---

Сьогодні буде простий пост. Є багато способів скомпілювати і завантажити програму для Arduino. Хочу розповісти про свій улюблений метод: з використанням чудового проекту [Arduino-Makefile][1], спеціального `Makefile` для роботи з Arduino.

Застереження: я знаю, що також є новий проект [Arduino&nbsp;<abbr>CLI</abbr>][3]. Тут йдеться не про нього. 


Arduino&nbsp;<abbr>IDE</abbr>
-----------------------------

Писати код в Arduino&nbsp;<abbr>IDE</abbr> часів версій 1.x мені чомусь ніколи не подобалося. З виходом Arduino&nbsp;<abbr>IDE</abbr>&nbsp;2 інтерфейс став помітно краще, але у будь-якому разі я не хочу обмежувати себе.

Я редагую код в різних текстових редакторах та <abbr>IDE</abbr>, які відповідають моїм смакам та моїм поточним потребам, від Vim до Visual&nbsp;Studio&nbsp;Code. Зокрема, цей пост я пишу в [Geany][2], легкому і потужному редакторі для повсякденних задач; всі інші супутні дії (збірку сайту з Jekyll, коміти в Git тощо) я роблю в консолі.

Так само в консолі я компілюю свої програми для Arduino.


Інсталяція
----------

Для Debian та Ubuntu все потрібне є в репозиторіях дистрибутива. Нам треба буде встановити застарілий Arduino&nbsp;<abbr>IDE</abbr>&nbsp;1.x, навіть якщо ми не будемо користуватися його інтерфейсом.

```sh
sudo apt install arduino arduino-mk
```

Для інших систем (зокрема, якщо встановити Arduino&nbsp;<abbr>IDE</abbr> вручну) все може бути складніше.


Blink
-----

Не знаєш що робити — блимай світлодіодом :)

Отже, нам треба зробити каталог для нашого нового проекту і покласти в нього `Blink.ino` з повністю передбачуваним вмістом:

```cpp
void setup() {
  pinMode(13, OUTPUT);
}

void loop() {
  digitalWrite(13, HIGH);
  delay(1000);
  digitalWrite(13, LOW);
  delay(1000);
}
```

В тому ж каталозі створюємо файл `Makefile` ось такого вигляду:

```Makefile
BOARD_TAG = uno
include /usr/share/arduino/Arduino.mk
```

Запускаємо команду `make` і дивимось, що відбувається. Може щось піти не так, на те є мільйон різних причин. На моїй системі компіляція працює. Також я перевірив, що в абстрактній Ubuntu ~~в вакуумі~~ теж працює:

```sh
docker run -it --rm -v $(pwd):/test ubuntu
apt update
apt install arduino arduino-mk
cd /test
make
```

Якщо ніде нічого не зламалося, то має з'явитися каталог `build-uno` з купою файлів. Це результат компіляції. (Зазвичай я додаю `build*` в `.gitignore` проекту).

Останній крок: команда `make upload` для прошивки вашого Arduino&nbsp;Uno. Якщо не вказувати порт, то воно визначить його автоматично.

Також треба знати про команду `make help`.


### Що як у мене не Arduino&nbsp;Uno, а Arduino&nbsp;Nano?

Тоді в `Makefile` замість `BOARD_TAG = uno` треба написати щось таке:

```Makefile
BOARD_TAG = nano
BOARD_SUB = atmega328
```

Збірка буде відбуватися в каталог `build-nano-atmega328`. (Цілком нормально, що для різних плат використовуються різні збірки).

Також у мене є декілька китайських клонів Arduino Nano з дешевшим мікроконтролером, який потребує такої конфігурації:


```Makefile
BOARD_TAG = nano
BOARD_SUB = atmega168
```

Запустіть `make show_boards` та `make show_submenu`, щоб подивитися інші варіанти.


### Файли з розширенням `.cpp` замість `.ino`

Може з якихось причин виникнути бажання перейменувати `Blink.ino` в щось типу `Blink.cpp`, бо врешті-решт це ж і є C++. У такому разі знадобиться додати один рядок на початку цього файлу:

```cpp
#include <Arduino.h>
```


### Додаткові бібліотеки

Якщо в Arduino&nbsp;<abbr>IDE</abbr> встановити через його внутрішній менеджер бібліотек якісь додаткові зовнішні бібліотеки, то для їх використання треба буде їх явно вказати в `Makefile`:

```Makefile
ARDUINO_LIBS = Servo
```

Далі бібліотека використовується звичним чином:

```cpp
#include <Servo.h>
```


Мораль і висновки
-----------------

Власне, це і все. Цей інструмент економить мені нерви та час. Може ще комусь підійде :)


[1]: https://github.com/sudar/Arduino-Makefile
[2]: https://geany.org/
[3]: https://arduino.github.io/arduino-cli/
