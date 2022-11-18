---
title: Невелике відкриття
date: 2022-10-22 01:44:20 +03:00
---

Читав про рівні ізоля́цій транза́кцій і відкрив для себе `SELECT … FOR UPDATE`.

І аж соромно, що я раніше цього не знав. Наче ж я працював з транза́кціями, але чомусь для тих задач завжди якось обходився без locking reads, тільки стандартний режим repeatable read. Ох, яким же чайником я себе відчуваю.

А воно ж, дідько, було ще навіть у фундамента́льному [SQL92][1].

## Приклад

Уявімо, що у нас є отака от табличка. (Тут і далі я використовую варіант синтаксису для MySQL/MariaDB).

```sql
CREATE TABLE IF NOT EXISTS `sample_job` (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `status` enum('new','working','done','failed') NOT NULL DEFAULT 'new',
  `command` varchar(255) NOT NULL,
  `created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `started` TIMESTAMP NULL DEFAULT NULL,
  `finished` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `sample_job` (`command`) VALUES
('echo "it is a command"'),
('echo "an other command"'),
('echo "more and more"'),
('echo "plenty of commands"');
```

Типу, тут у нас є якісь команди, які треба виконати. Час від часу до бази даних під'єднуються програми-виконавці і хочуть взяти собі якусь зада́чку на виконання. Як нам це зробити?

```sql
SELECT @JOB_ID:=`id`
FROM `sample_job`
WHERE `status`='new'
ORDER BY `created` ASC, `id` ASC
LIMIT 1;

UPDATE `sample_job`
SET `status`='working', `started`=NOW()
WHERE `id`=@JOB_ID;
```

Але це два окремих запити, між якими є проміжок часу. Чисто теоретично може бути [стан гонитви][1] (race condition), коли два паралельних виконавці намагаються взяти собі одну і ту саму задачу.

Як же я викручувався раніше? Та бувало, що взагалі без транзакцій, через додаткову умову у `WHERE` та перевірку кількості змінених рядків.

```php
function obtainJobId(\PDO $dbh): int|false
{
    $sth = $dbh->prepare('SELECT `id` FROM `sample_job` '
        . 'WHERE `status`=\'new\' '
        . 'ORDER BY `created` ASC, `id` ASC LIMIT 1');
    $sth->execute();
    $result = $sth->fetchAll(PDO::FETCH_ASSOC);

    if (!count($result)) {
        // No pending jobs
        return false;
    }

    $id = $result[0]['id'];

    $sth = $dbh->prepare('UPDATE `sample_job` '
      . 'SET `status`=\'working\', `started`=CURRENT_TIMESTAMP '
      . 'WHERE `status`=\'new\' AND id=:id');
    $sth->bindValue('id', $id, PDO::PARAM_INT);
    $sth->execute();

    if (empty($sth->rowCount())) {
        // That $id is already used
        return false; 
    }

    return $id;
}
```

Наче непогане рішення, чи не так?

Але.

Але це дуже простий приклад — одна таблиця, один первинний ключ, один `SELECT` та один `UPDATE`. Якби умови потребували кілька різних `UPDATE`, то цей фокус не спрацював би. Треба було б загорнути все в транза́кцію і робити `ROLLBACK`, якщо щось не спрацювало.

Тож ось воно, правильне рішення — злюще, потенційно небезпечне, воно блокує таблиці на читання, але воно і є пра-правда.

```sql
START TRANSACTION;

SELECT @JOB_ID:=`id`
FROM `sample_job`
WHERE `status`='new'
ORDER BY `created` ASC, `id` ASC
LIMIT 1
FOR UPDATE;

UPDATE `sample_job`
SET `status`='working', `started`=CURRENT_TIMESTAMP
WHERE `id`=@JOB_ID;

COMMIT;
```

[1]: https://www.contrib.andrew.cmu.edu/~shadow/sql/sql1992.txt
[2]: https://uk.wikipedia.org/wiki/%D0%A1%D1%82%D0%B0%D0%BD_%D0%B3%D0%BE%D0%BD%D0%B8%D1%82%D0%B2%D0%B8
