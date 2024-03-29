---
title: Камера для Raspberry Pi
date: 2021-07-08 15:31:10 +03:00
mtime: 2021-07-08 16:00:10 +03:00
---

Звісно, я часто підключав звичайні веб-камери до своїх Raspberry Pi. А тепер у мене нарешті дійшли руки до спеціального інтерфейсу камери.

Камера прикольна. Коли працює, жере більше ніж весь Pi Zero. Камера дешева китайська, я навіть захисну плівку ще не зняв, але знімки виходять нормальні. Принаймні, для моїх задач цього достатньо.

Як робити окремі знімки, питань нема.

```sh
ssh rpi0 raspistill -n -o - | feh -
```

Зі стрімінгом відео поки успіхів небагато. Щось якось можна подивитись отак:

```sh
raspivid -w 800 -h 600 -fps 60 -t 0 -o - | nc -k -l 5000
```

І на клієнті:

```sh
mplayer -x 800 -y 600 -fps 200 -demuxer h264es ffmpeg://tcp://192.168.0.80:5000
```

Де `192.168.0.80` — адреса Raspberry Pi.

P.S. Ще не пробував, але планую: можна додати у `config.txt` щось таке

```
disable_camera_led=1
```
