---
title: Перегляд показників температури
placeholder: here
---

Я зібрав собі [погодну станцію][1], а потім ще одну. Тепер треба щось робити з ціми даними, якось подивитися на них. Для візуалізації в мене є Grafana.

...

TODO FIXME

...

Треба написати, що робити з Графаною «з нуля» і до отримання візуалізації.

```sh
mkdir -m0777 data
docker run -p 3000:3000 -v $(pwd)/data:/var/lib/grafana grafana/grafana:main
```
...

Окрема лажа: треба зробити так, щоб Графана коректно показувала розриви у графіках, а не мовчки з'єднувала їх. І для цього їй обов'язково треба вставити в той розрив хоч один рядок зі значенням null.


```sql
CREATE VIEW weather_gap AS
  SELECT
    NULL AS id,
    w1.station AS station,
    DATE_ADD(w1.created_at, INTERVAL 1 SECOND) as created_at,
    NULL AS temperature,
    NULL AS pressure,
    NULL AS humidity
  FROM weather w1
  LEFT JOIN weather w2 ON (
    (w2.station = w1.station) AND
    (w2.created_at > w1.created_at) AND
    (TIMEDIFF(w2.created_at, w1.created_at) < '00:03:00'))
  WHERE w2.id IS NULL;

CREATE VIEW weather_grafana AS
  SELECT created_at, station, temperature, pressure FROM weather
  UNION
  SELECT created_at, station, temperature, pressure FROM weather_gap;
```

...

...

Цей weather_gap нікуди не годиться, воно страшенно гальмує. Треба спробувати генерувати ту таблицю раз на півгодини, INSERT SELECT чи шо.

RTFM: <https://dev.mysql.com/doc/refman/5.7/en/create-event.html>

[1]: /2022/12/04/weather-station.html
