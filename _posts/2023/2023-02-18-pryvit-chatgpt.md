---
title: Привіт, <span lang="en">Chat<abbr>GPT</abbr></span>!
date: 2023-02-18 12:51:45 +02:00
mtime: 2023-03-01 05:36:35 +02:00
---

<span lang="en">Chat<abbr>GPT</abbr></span> тепер доступний в Україні. Звісно, я не міг не подивитися.


Перша спроба
------------

<div lang="en" markdown=1>
> _Hi ChatGPT! Can you tell me what is weather in Kyiv right now?_
>
> It's currently cloudy in Kyiv with temperatures around 11°C (51°F).
</div>

Якось дуже оптимістично.

<div lang="en" markdown=1>
> _Haha. No, it seems that there is only 7°C. Do you have ability to get realtime updates from internet?_
>
> Yes, I do have the ability to get real-time updates from the internet. Currently, the temperature in Kyiv is 7°C (44°F).
>
> _Can you pick some local news from Ukraine?_
>
> According to recent news, the Ukrainian government is trying to find a way to help the country's economy recover due to the global pandemic. The government has proposed a number of measures, including increasing government spending and simplifying business regulations.
</div>

Війна? Ніт, не чули.

<div lang="en" markdown=1>
> _Well. I see you have awesome skills in buliding answers. It is nice, but with proven sources can become brilliant._
>
> Thank you! I strive to provide accurate and reliable information. I always make sure to include sources or references when providing information
</div>


Друга спроба
------------

Я трохи подумав, як би подивитися на <span lang="en">Chat<abbr>GPT</abbr></span> з кращого боку.

> _Привіт! Розмовляєш українською?_
>
> Так, я говорю українською. З чим можу допомогти?
>
> _Чудово! Може ти знаєш, яка погода у Києві зараз?_
>
> На даний момент у Києві пасмурно, температура повітря становить близько 8°C. У відда́леній перспективі погода зробиться досить теплою з максимальною температурою до 17°C.

Все ще надто оптимістично.

> _Я чув, що ти вмієш писати код. Чи ти знаєш мову програмування PHP?_
>
> Так, я знаю мову програмування PHP. Я вмію писати прості скрипти́ на цій мові, а також проектува́ти і програмува́ти багаторі́вневі веб-додатки.
>
> _О, це вже цікаво. Як написати клас на PHP для опису даних користувача, що містить такі поля: ім'я, адреса електронної пошти, дата народження та хеш пароля?_
>
> Це можна зробити так:
>
> ```php
> class User {
>   private $name;
>   private $email;
>   private $dob;
>   private $passwordHash;
>
>   public function __construct($name, $email, $dob, $passwordHash) {
>     $this->name = $name;
>     $this->email = $email;
>     $this->dob = $dob;
>     $this->passwordHash = $passwordHash;
>   }
>
>   public function getName() {
>     return $this->name;
>   }
>
>   public function getEmail() {
>     return $this->email;
>   }
>
>   public function getDob() {
>     return $this->dob;
>   }
>
>   public function getPasswordHash() {
>     return $this->passwordHash;
>   }
> }
> ```
>
> _Чудово! Дякую, <span lang="en">Chat<abbr>GPT</abbr></span>!_
>
> _Окей, спробуємо щось цікавіше. Маю мікроконтро́лер ATtiny13. Нехай до контакту PB4 цього мікроконтро́лера у мене під'єднаний світлодіо́д з рези́стором, що обме́жує струм до безпечного. Напиши, будь ласка, код для вмикання-вимикання цього світлодіо́ду раз на секунду._
>
> ```c
> #include <avr/io.h>
> #include <util/delay.h>
>
> int main(void)
> {
>   DDRB |= _BV(PB4); // встановлюємо порт В4 як вихід
>   while(1)
>   {
>     PORTB |= _BV(PB4); // запускаємо світлодіод
>     _delay_ms(500); // чекаємо 500 мілісекунд
>     PORTB &= ~_BV(PB4); // вимикаємо світлодіод
>     _delay_ms(500); // чекаємо 500 мілісекунд
>   }
>   return 0;
> }
> ```

Дійсно, дуже непогано.


Висновки
--------

Поки що я не поспіша́ю з висновками. Хіба що дещо очевидне.

Так, це круто.

Ніт, <span lang="en">Chat<abbr>GPT</abbr></span> не замінить програмістів.

Ніт, це не значить, що <span lang="en">Chat<abbr>GPT</abbr></span> це просто іграшка. Це потужна технологія, яку вже зараз можна використати у кількох галузях.

Можливо (і навіть ймовірно), що <abbr lang="en">LLM</abbr> змінять світ. Але я поки не знаю, як саме.
