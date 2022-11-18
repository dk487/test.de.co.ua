---
title: Запуск <span lang="en">Mosquitto</span> та <span lang="en">Node-RED</span>
date: 2022-11-14 15:04:43 +02:00
---

Я так подумав: раз в мене вже тут вийшов у [попередньому пості́][1] такий собі лікнеп для чайників, то треба розповісти останні деталі, а саме про <span lang="en">Mosquitto</span> та <span lang="en">Node-RED</span>.


## Що це все таке

<abbr lang="en">MQTT</abbr> — це стандарт де-факто на комунікацію між пристроями в <abbr lang="en" title="Internet of Things">IoT</abbr>.

Брокер <abbr lang="en">MQTT</abbr> просто приймає від клієнтів повідомлення і відправляє їх іншим клієнтам-підпи́сникам. Це дуже схоже на <abbr lang="en">IRC</abbr>, тільки сервер тут зветься «брокер», а про канал кажуть «топік». Існують різні брокери, та майже завжди йдеться про <span lang="en">Mosquitto</span>.

<span lang="en">Node-RED</span> це така своєрідна платформа, яка підходить для поєднання всякої низькорі́вневої хріні з усякою іншою низькорі́вневою хрінню: <abbr lang="en">MQTT</abbr>, бази даних, <abbr lang="en">REST API</abbr>, скрипти́.


## Запуск

<span lang="en">Mosquitto</span> в Debian та Ubuntu можна поставити просто з репозито́рію (десь у ме́не так і є), але зазвичай мені буває зручно запускати його через <span lang="en">Docker Compose</span> разом з <span lang="en">Node-RED</span>.

<div lang="en" markdown=1>

### `docker-compose.yml`

```yaml
version: '3'

services:
  mqtt:
    image: eclipse-mosquitto
    ports:
      - 1883:1883
    volumes:
      - ./mosquitto.conf:/mosquitto/config/mosquitto.conf:ro

  nodered:
    image: nodered/node-red
    ports:
      - 1880:1880
    volumes:
      - ./node-red-data:/data
    links:
      - mqtt
```

</div>

Як видно з цього файлу, тут ще треба зробити підкаталог <span lang="en">`node-red-data`</span>, у якому зберігатимуться всі нутрощі <span lang="en">Node-RED</span>, та конфіг <span lang="en">Mosquitto</span>.

<div lang="en" markdown=1>

### `mosquitto.conf`

```
allow_anonymous true

listener 1883
```

</div>

Ну і все, можна запускати <span lang="en">`docker-compose up`</span> і все ма́є запусти́тися.


## Приклад використання <span lang="en">Node-RED</span>

<span lang="en">Node-RED</span> після запуску з дефо́лтними налаштува́ннями доступна за адресою <u>http://localhost:1880/</u> і не потребує паро́лю.

<div lang="en" markdown=1>

> The S in IoT Stands for Security

</div>

Насправді тут можна і пароль зробити, і різні види аутентифікац́ії прикрути́ти десь на <span lang="en">reverse proxy</span>, але ж ми просто граємося і бли́маємо світлодіо́дом.

![Знімок екрану: порожня чиста нова Node-RED](/uploads/nodered_new.png)

Так, що ще треба. В головному меню <span lang="en">Node-RED</span> (правий верхній кут, три рисочки) треба зайти в <span lang="en">`Manage palette`</span> (це типу як паке́тний менеджер) та встановити модуль <span lang="en">`node-red-dashboard`</span>. Навіть не знаю, чому він не входить до стандартного комплекту.

Нам треба додати на наш <span lang="en">flow</span> два вузли з групи <span lang="en">network</span>, а саме <span lang="en">`mqtt in`</span> та <span lang="en">`mqtt out`</span>. Також нам треба вузол <span lang="en">`switch`</span> з групи <span lang="en">dashboard</span>. От я їх просто перетягну́в кудись і ще не сконфігурува́в.

![Знімок екрану: три несконфігуро́ваних вузла Node-RED](/uploads/nodered_new_3_nodes.png)

Двічі клацніть на вузол <span lang="en">`mqtt in`</span>. Відкриється вікно редагування. Нам треба налаштувати сервер та топік. Сервер ми ще жоден не налашто́вували, тому треба його створити; достатньо вказати хост <span lang="en">`mqtt` (не 127.0.0.1, а ім'я хосту з <span lang="en">Docker Compose</span>) і все інше лишити як є. Топік для вхідних повідомлень на цьому вузлі має бути <span lang="en">`board01/led`</span>.

Аналогічним чином конфігуру́ємо вузол <span lang="en">`mqtt out`</span>. Тільки топік там має бути <span lang="en">`board01/led/set`</span>, а раніше сконфігуро́ваний сервер вже буде вка́зано за замовчанням.

Тепер вузол <span lang="en">`switch`</span>. Треба створити групу (стовпчик, де він має відображатися), при створенні групи треба буде створити нову <span lang="en">dashboard tab</span> (сторінку, де воно все буде). Якщо нічого не міняти, то зі значеннями по замо́вченню у вас створиться <span lang="en">tab</span> з назвою <span lang="en">Home</span> та група <span lang="en">Default</span>.

Далі трошки неочеви́дне. Треба визначити, які значення відповідають стану «увімкнено» і що вважається станом «вимкнено» (<span lang="en">On Payload</span> та <span lang="en">Off Payload</span>, відповідно). Встанові́ть для обох тип <span lang="en">number</span>. Значення 1 та 0, відповідно.

Наостанок, встанові́ть йому якийсь зрозумілий <span lang="en">label</span>. Наприклад «<abbr lang="en">LED</abbr>».

![Знімок екрану: конфігурація вузла switch в Node-RED](/uploads/nodered_switch.png)

Тепер лишається поєднати мишкою всі три вузли та натиснути на <span lang="en">Deploy</span>.

![Знімок екрану: три з'єднанних вузла Node-RED](/uploads/nodered_connected_3_nodes.png)

Все! <span lang="en">Dashboard</span> знаходиться за адресою <u>http://127.0.0.1:1880/ui/</u> (теж без паро́лю).

![Знімок екрану: Node-RED dashboard з одним вимикаче́м](/uploads/nodered_new_dashboard.png)

Якщо все вийшло правильно, то цей перемикач буде вмикати-вимика́ти світлодіо́д на платі <span lang="en">Node<abbr>MCU</abbr></span> з попереднього поста.

Вхідні повідомлення з топіку <span lang="en">`board01/led`</span> змінюють стан перемикача. Зміна стану перемикача (будь-яка) призводить до надсилання вихідного повідомлення до топіку <span lang="en">`board01/led/set`</span>. Дещо неефекти́вно, та йой, най буде. Краще було б не надсилати до <abbr lang="en">MQTT</abbr> повідомлення про ту зміну стану, яка і так є реакцією на <abbr lang="en">MQTT</abbr>, але я поки не знаю, як це зробити просто і елегантно.


## Тестування dashboard'у

Не завжди все виходить правильно з першого разу.

Для відла́годження та для експериментів з <abbr lang="en">MQTT</abbr> варто встановити пакет <span lang="en">`mosquitto-clients`</span>, навіть якщо у вас <span lang="en">Mosquitto</span> тільки в Docker'і.

Зокрема, так я дивлюся, що відбувається на всіх топіках (<span lang="en">wildcard `#`</span>):

```sh
mosquitto_sub -h 127.0.0.1 -t "#" -v
```

Цей `mosquitto_sub` працює як `tail -f`, для його зупинки треба <span lang="en"><kbd>Ctrl</kbd>&nbsp;<kbd>C</kbd></span>. Коли ви натиска́єте на перемика́ч, мають з'являтися нові повідомлення з топіком <span lang="en">`board01/led/set`</span>.

А ось так я вручну́ відправля́ю повідомлення з текстом `1` на топік <span lang="en">`board01/led`</span>, імітуючи повідомлення від <span lang="en">Node<abbr>MCU</abbr></span>:

```sh
mosquitto_pub -t board01/led -m 1
```

Ну, в принципі, і все. Отака фігня.

[1]: /2022/11/14/micropython-on-esp8266.html
