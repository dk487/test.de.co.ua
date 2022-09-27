---
title: Про споживання Raspberry Pi Zero
date: 2022-09-27 14:43:16 +03:00
---

Фрагмент з мого `/boot/config.txt`:

<div lang="en" markdown=1>
```
# Downclock CPU
arm_freq=300

# Disable Bluetooth
dtoverlay=disable-bt

# Disable the PWR LED
dtparam=pwr_led_trigger=none
dtparam=pwr_led_activelow=off

# Disable the Activity LED
dtparam=act_led_trigger=none
dtparam=act_led_activelow=off
```
</div>

З такими налаштува́ннями вона споживає 50–60 мА в стані спокою, 150 мА при навантаженні на CPU, ну і 250–350 мА під час використання камери.

Скільки вона з'їсть за добу, якщо робити знімок кожні півгодини?
