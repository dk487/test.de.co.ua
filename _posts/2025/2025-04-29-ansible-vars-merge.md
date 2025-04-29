---
title: Об'єднання змінних в Ansible
date: 2025-04-29 21:36:30 +03:00
mtime: 2025-04-30 02:07:15 +03:00
---

Сьогодні маю настрій дещо розповісти про Ansible.

Що в Ansible мені особливо подобається, так це те, що там знаходяться змінні з усією нашою інфраструктурою. Всі назви серверів, всі домени сайтів, всі параметри, всі дрібні нюанси, все те що підлягає контролю і керуванню — це зазвичай знаходиться в YAML, десь в каталогах `host_vars` та `group_vars`, в структурі яку автор проекту створює на свій власний розсуд, щоб потім скористатися цими змінними в playbook'ах.

Змінні мають приорітет: спочатку змінні для групи `all`, потім більш специфічні групи, а в кінці кінців специфічні змінні для конкретного хоста. І ось саме це _іноді_ мені не подобається.

Бо суть змінних різна.

Уявімо змінну з назвою `timezone`, яку ми використовуємо щоб налаштувати час на наших хостах. Нехай в групі `all` ця змінна має значення `UTC`, а у одного хоста має значення `Europe/Kyiv`. Абсолютно логічна поведінка, коли йдеться про одну скалярну змінну, яку в рамках одного хоста можна використати лише один раз. У нас тільки один файл `/etc/localtime`, і сервер не може одночасно знаходитися в двох часових поясах.

Уявімо змінну з назвою `packages` (зі списком пакетів, які треба встановити) або `shell_users` (зі списком користувачів, облікові записи яких треба створити). І тут все стає дещо складнішим. Наприклад, я хочу встановити `borgbackup` на всіх без виключень хостах, встановити `vim` та `screen` на хостах з групи `testing`, а на хостах з групи `dbservers` встановити MariaDB.

Вочевидь, я хочу об'єднати ці списки. Як це зробити правильно, красиво і зручно? Ось яке я пропоную рішення: для різних груп я використаю різні змінні, ім'я яких побудовано по певним правилам.

Нехай після базової частини імені, `packages`, йде два підкреслювання, а потім йде назва групи або ім'я хоста. Наприклад, десь у глибині файлу `group_vars/all.yml` може бути щось таке:

```yaml
packages__all:
  - borgbackup
```

А у файлі змінних іншої групи, `group_vars/testing.yml`, нехай буде таке:

```yaml
packages__testing:
  - vim
  - screen
```

Залишається тільки якимось чином об'єднати списки `packages__all` (для всіх хостів) та `packages__testing` (для тих, які входять в цю групу). І ось як я це роблю:

```yaml
#!/usr/bin/env ansible-playbook
---
- hosts: all
  tasks:
    - name: Prepare packages list
      ansible.builtin.set_fact:
        packages: >-
          {{ '{{' }} (packages | default([])) +
             lookup("vars", "packages__{{ '{{' }} item }}", default=[]) }}
      loop: '{{ '{{' }} ["all"] + group_names + [inventory_hostname_short] }}'

    - name: Install packages
      ansible.builtin.package:
        name: '{{ '{{' }} item }}'
        state: present
      loop: '{{ '{{' }} packages }}'
```

Прикольно, правда?

Ми спочатку шукаємо змінну `packages__all`, потім змінні названі за схемою `packages__group_name` для всіх груп до якої входить хост, а в самому кінці змінну виду `packages__hostname`. Якщо якоїсь з цих змінних нема (як, наприклад, `packages__some_other_group`), то нічого страшного, ми це мовчки ігноруємо. Для наведеного прикладу з двох груп получиться список `['borgbackup', 'vim', 'screen']`.

До речі, зверніть увагу на перший рядок (там де `#!`). Playbook можна зробити executable (`chmod +x`), і запускати не громіздку конструкцію `ansible-playbook install-packages.yml`, а просто запускати сам плейбук як скрипт: `./install-packages.yml`.


## `setup-shell-users.yml`

Ось трохи більший приклад, копію якого я [виклав окремо][1].

Нехай у нас є структура з користувачами, яким треба зробити облікові записи і налаштувати параметри доступу:

```yaml
shell_users__all:
  - login: boss
    name: Jane Doe
    shell: /bin/bash
    sudoer: True
    authorized_keys:
      - ssh-ed25519 ...

shell_users__cloud:
  - login: devops
    name: John Doe
    shell: /bin/zsh
    authorized_keys:
      - ssh-ed25519 ...
      - ssh-ed25519 ...
```

Треба створити системних користувачів в `/etc/passwd`, треба налаштувати їм доступ по ключам SSH, і деяким з них треба надати права root'а. У кожного має бути логін, все інше опціональне: ім'я, хеш пароля для `/etc/shadow`, shell, ключі, групи в які треба додати. По суті, це стандартна задача, яка має бути у багатьох проектах на Ansible. І це достатньо універсальний шматок кода, який можна адаптувати під себе, або використовувати таким який він є.

Зацініть використання `subelements`, щоб одним циклом пройти по всім ключам всіх користувачів :)

У якості бонуса, можна видаляти користувачів, облікові записи яких більше не актуальні; але за замовчанням ця задача не запускається, вона потребує явного виклику через вказання тегу. (Це така мікро-оптимізація, яка може бути корисною або шкідливою в залежності від того, як саме ви використовуєте Ansible; може, колись про це я напишу окрему розлогу статтю).

Те саме стосується видалення прав root'а: воно виконується лише з явним вказанням того ж тега. Взагалі значення `sudoer` фактично може мати три різні варіанти: `True` (слід дати права), `False` (слід явно видалити права) та відсутність значення (не змінювати статус). Чорт, весела штука YAML :)

```yaml
#!/usr/bin/env ansible-playbook
---
- hosts: all
  tasks:
    - name: Prepare shell users list
      ansible.builtin.set_fact:
        shell_users: >-
          {{ '{{' }} (shell_users | default([])) +
             lookup("vars", "shell_users__{{ '{{' }} item }}", default=[]) }}
      loop: '{{ '{{' }} ["all"] + group_names + [inventory_hostname_short] }}'
      tags: [always]

    - name: Create user accounts
      ansible.builtin.user:
        name: '{{ '{{' }} item.login }}'
        shell: '{{ '{{' }} item.shell | default(omit) }}'
        comment: '{{ '{{' }} item.name | default(omit) }}'
        password: '{{ '{{' }} item.password | default(omit) }}'
        groups: '{{ '{{' }} item.groups | default(omit) }}'
      loop: '{{ '{{' }} shell_users }}'
      when: not (item.deleted | default(False))

    # To run this task, explicitly specify the tag:
    # ./setup-shell-users.yml --tags delete
    - name: Delete user accounts
      ansible.builtin.user:
        name: '{{ '{{' }} item.login }}'
        state: absent
      loop: '{{ '{{' }} shell_users }}'
      when: item.deleted | default(False)
      tags: [never, delete]

    - name: Set up authorized SSH keys
      ansible.posix.authorized_key:
        user: '{{ '{{' }} item.0.login }}'
        key: '{{ '{{' }} item.1 }}'
        state: present
      loop: >-
         {{ '{{' }} shell_users
            | selectattr('authorized_keys', 'defined')
            | subelements('authorized_keys') }}

    - name: Grant superuser rights
      ansible.builtin.lineinfile:
        path: '/etc/sudoers.d/{{ '{{' }} item.login }}'
        line: '{{ '{{' }} item.login }} ALL=(ALL) NOPASSWD: ALL'
        state: present
        create: True
      loop: '{{ '{{' }} shell_users }}'
      when: item.sudoer | default(False)

    # To run this task, explicitly specify the tag:
    # ./setup-shell-users.yml --tags delete
    - name: Revoke superuser rights
      ansible.builtin.file:
        path: '/etc/sudoers.d/{{ '{{' }} item.login }}'
        state: absent
      loop: '{{ '{{' }} shell_users }}'
      when: not (item.sudoer | default(True))
      tags: [never, delete]
```

Така от цікава штука у мене получилася. Може, комусь стане в пригоді.

[1]: https://gist.github.com/kastaneda/ef4232d8e349d91aaa362fc9b832bed9
