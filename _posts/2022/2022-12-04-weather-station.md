---
title: Пого́дна станція
date: 2022-12-04 13:30:03 +02:00
mtime: 2023-03-03 17:03:34 +02:00
opengraph: uploads/weather_station.png
---

Я колись вже слідкував за температурою за [допомогою Arduino та термі́стора][1]. Тепер роблю це з платою ESP8266 (NodeMCU), датчика BMP280 та програми на MicroPython.

Те, що варто було зробити за один вечір, через вимкнення електроенергії розтягнулося на кілька днів. З іншого боку, саме через відключення світла та опалення я став цікавитися температурою в своїй оселі.


## Залізо

Підключення плати BMP280 цілком тривіальне: земля, живлення, шина I²C.

![Схема підключення](/uploads/weather_station.png)

Так, плата NodeMCU в моїй схемі висить між двома маленькими SYB-170. Ну а що ще з нею робити? :) Вона надто широка, щоб поміститися на звичайну маке́тну плату.

Контакт D0 (GPIO16) підключений до RST. Це звичайне рішення для режиму deep sleep у ESP8266. Коли спрацьовує таймер в RTC (в моєму випадку через 1 хвилину), то він подає сигнал на GPIO16 і, відповідно, перезаванта́жує модуль.

Є деяка не дуже типо́ва деталь: контакт D5 (GPIO14) підключений до землі. Це у мене такий типу як «запобі́жник», бо deep sleep досить-таки небезпечний при неакуратному використанні. Тож мій код запускає deep sleep тільки в тому випадку, якщо є з'єднання GPIO14 з землею. Якщо від'єдна́ти відповідний дріт, то після однократного вимірювання код завершить виконання і REPL буде доступним, а значить, можна буде модифікувати програму.


## Софт

На внутрішній файловій системі модуля ESP8266 лежать два файли: [`bmp280.py`][2], який я взяв прямо з GitHub'у, та мій `main.py`:

### `main.py`

<div lang="en" markdown=1>
```python
import machine
import network
import time
import urequests
from bmp280 import *

config_wifi_essid = '...FIXME...'
config_wifi_password = '...FIXME...'
config_station_id = 'board02'
config_endpoint_url = 'http://192.168.0.12/iot/weather.php'

def wifi_setup():
    global sta_if
    sta_if = network.WLAN(network.STA_IF)
    sta_if.active(True)
    sta_if.scan()
    sta_if.connect(config_wifi_essid, config_wifi_password)

def wifi_wait_connect(timeout_ms=2500):
    while timeout_ms:
        if (sta_if.isconnected()):
            return True
        time.sleep_ms(250)
        timeout_ms = timeout_ms - 250
    return sta_if.isconnected()

def i2c_setup():
    global i2c
    i2c = machine.I2C(scl=machine.Pin(5), sda=machine.Pin(4))

def bmp_setup():
    global bmp
    bmp = BMP280(i2c)
    bmp.use_case(BMP280_CASE_WEATHER)
    bmp.oversample(BMP280_OS_HIGH)
    bmp.temp_os = BMP280_TEMP_OS_8
    bmp.press_os = BMP280_PRES_OS_4
    bmp.iir = BMP280_IIR_FILTER_2

def bmp_measure():
    bmp.force_measure()
    result = { 'temperature': bmp.temperature, 'pressure': bmp.pressure }
    bmp.sleep()
    return result

def send_measurements(bmp_data):
    bmp_data['station'] = config_station_id
    response = urequests.post(config_endpoint_url, json=bmp_data)
    return response.status_code

def go_deepsleep(timeout_ms=60000):
    rtc = machine.RTC()
    rtc.irq(trigger=rtc.ALARM0, wake=machine.DEEPSLEEP)
    rtc.alarm(rtc.ALARM0, timeout_ms)
    machine.deepsleep()

# D4 / GPIO2 / LED
d4 = machine.Pin(2, machine.Pin.OUT)

# Turn on the LED
d4.value(0)

# Connect to WiFi
wifi_setup()
if wifi_wait_connect():
    i2c_setup()
    bmp_setup()
    send_measurements(bmp_measure())

# What if there is no WiFi?
# Should I write measurement to some log file?
# TODO

# Turn off the LED
d4.value(1)

# D5 / GPIO14
d5 = machine.Pin(14, machine.Pin.IN, machine.Pin.PULL_UP)

# value 1 == pin D5 not connected, use it for debug mode
# value 0 == pin D5 connected to G, so it's safe to use deep sleep
if (d5.value() == 0):
    go_deepsleep()
else:
    print('Pin D5 is not grounded')
    print('Not going to the deep sleep mode')
```
</div>

Все! Ну або майже все. Треба ще якийсь backend.


## REST API

Треба кудись ці дані покласти. Наприклад, в базу.

### Схема

<div lang="en" markdown=1>
```sql
CREATE TABLE `weather` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `station` varchar(12) CHARACTER SET ascii DEFAULT NULL,
  `temperature` decimal(4,2) DEFAULT NULL,
  `pressure` int(6) UNSIGNED DEFAULT NULL,
  `humidity` decimal(5,2) UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
```
</div>

Python на мікроконтролері це чудово, але у веб-сервері мені якось приємніше бачити PHP.

### `weather.php`

<div lang="en" markdown=1>
```php
<?php
declare(strict_types=1);

error_reporting(E_ALL);
ini_set('display_errors', '1');

if ($_SERVER['REQUEST_METHOD'] != 'POST') {
    echo '<h1>IoT API</h1> <p>This page is for robots only</p>';
    die();
}

$json = file_get_contents('php://input');
$payload = json_decode($json, true);

if (!is_array($payload) || !count($payload)) {
    echo '<h1>IoT API</h1> <p>JSON playload required</p>';
    die();
}

$db_config = [
    'dsn' => 'mysql:host=localhost;dbname=home_iot',
    'username' => '...FIXME...',
    'password' => '...FIXME...',
    'options' => [
        \PDO::ATTR_PERSISTENT => true,
    ],
];

// For PHP 8:
// $dbh = new \PDO(...$db_config);

// For PHP 7.4:
$dbh = new PDO(
    $db_config['dsn'],
    $db_config['username'],
    $db_config['password'],
    $db_config['options'],
);

$sth = $dbh->prepare('INSERT INTO `weather`'
    . ' (`station`, `temperature`, `pressure`, `humidity`) '
    . ' VALUES (:station, :temperature, :pressure, :humidity)');

$keys = ['station', 'temperature', 'pressure', 'humidity'];
foreach ($keys as $key) {
    if (array_key_exists($key, $payload)) {
        $sth->bindValue($key, $payload[$key]);
    } else {
        $sth->bindValue($key, null, PDO::PARAM_NULL);
    }
}

$sth->execute();

if ($sth->rowCount()) {
    echo '<h1>IoT API</h1> <p>OK</p>';
} else {
    echo '<h1>IoT API</h1> <p>Error</p>';
}
```
</div>

От тепер все. Поки писав цей пост, в базу потрапило десь приблизно 40 нових вимірювань.

[1]: https://flo.de.co.ua/2021/05/23/arduino.html
[2]: https://github.com/dafvid/micropython-bmp280/blob/master/bmp280.py
