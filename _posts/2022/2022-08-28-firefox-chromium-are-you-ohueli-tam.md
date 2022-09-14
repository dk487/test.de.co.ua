---
title: Firefox & Chromium, are you ohueli tam?
date: 2022-08-28 00:44:39 +03:00
---

Недавно [онови́лася][1] у мене `tzdata`. Ну, і полі́зли глюки.

<div lang="en" markdown=1>
```
$ timedatectl 
               Local time: Sun 2022-08-28 00:38:47 EEST
           Universal time: Sat 2022-08-27 21:38:47 UTC
                 RTC time: Sat 2022-08-27 21:38:47
                Time zone: Europe/Kyiv (EEST, +0300)
System clock synchronized: yes
              NTP service: active
          RTC in local TZ: no
```
</div>

Firefox:

<div lang="en" markdown=1>
```
>> (new Date()).toLocaleString("en", {timeZone: "Europe/Kyiv"})
Uncaught RangeError: invalid time zone in DateTimeFormat(): Europe/Kyiv
    <anonymous> debugger eval code:1
```
</div>

Chromium:

<div lang="en" markdown=1>
```
>> (new Date()).toLocaleString("en", {timeZone: "Europe/Kyiv"})
VM12:1 Uncaught RangeError: Invalid time zone specified: Europe/Kyiv
    at Date.toLocaleString (<anonymous>)
    at <anonymous>:1:14
```
</div>

Якого хуя ці обидва браузери включають в себе застарілу копію `tzdata` і використовують тільки її?

[1]: /2022/08/23/kyiv-not-kiev.html
