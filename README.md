Тестовое задание.

В рамках настоящего задания необходимо разработать backend для упрощенной модели банковского сервиса.

Интерфейс делать не нужно, сервис нужно реализовать в формате API. API можно организовать по протоколу REST, однако, плюсом
будет API реализованное по протоколу GraphQL.

Сервис должен иметь следующие функциональные возможности:
1. Возможность создания банковских счетов
2. Возможность осуществления зачислений и списаний
3. Возможность перевода средств со счета на счет
5. Отображать остаток по счету на произвольную дату
6. Отображать оборот по счету за произвольный период

Установка и запуск для проверки
-------------
- Установите [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- Установите [Vagrant](https://www.vagrantup.com/downloads.html)
- Склонируйте этот проект
- Выполните `vagrant up`

В результате будет развёрнута виртуальная машина готовая для запуска проекта.
Виртуальная машина содержит
- ruby
- PostgreSQL и пустую базу данных для приложения
- дополнительные системные пакеты для запуска приложения.

Выполните `vagrant ssh`, а затем `bundle install` для установки гемов.

Выполните rails db:migrate

Для заполнения базы тестовыми `счетами` выполниет rails db:seed

Запуск приложения:
```
make run
```
Запуск тестов:
```
make test
```
