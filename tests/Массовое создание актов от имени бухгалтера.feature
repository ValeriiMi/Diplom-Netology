﻿#language: ru

@tree

Функционал: Массовое создание актов от имени Бухгалтера

Как разработчик я хочу
создать сценарий автоматического тестирования массового создания актов от имени бухгалтера 
чтобы проверить корректность работы программы   

Контекст:
	И я подключаю TestClient "Диплом Нетология" логин "Баженова Елена (бухгалтер)" пароль ""
	И я закрываю все окна клиентского приложения

Сценарий: Массовое создание актов от имени Бухгалтера

И В командном интерфейсе я выбираю 'Работа с заявками клиентов' 'Массовое создание актов'
Тогда открылось окно 'Массовое создание актов'
И я нажимаю кнопку выбора у поля с именем "Период"
И в поле с именем 'Период' я ввожу текст '05.2024'
И в таблице "Договоры" я нажимаю на кнопку с именем 'ФормаЗаполнитьИСоздать'
И таблица "Договоры" содержит строки по шаблону:
	| 'Договор'                               | 'Реализация'                                                  |
	| 'Договор обслуживания №2 от 01.01.2024' | 'Реализация товаров и услуг 0000000* от *'                    |
	| 'Договор обслуживания №5 от 01.04.2024' | 'Реализация товаров и услуг 0000000* от *'                    |
	| 'Договор обслуживания №7 от 01.05.2024' | 'Реализация товаров и услуг 000000007 от 24.05.2024 12:00:00' |
	| 'Договор обслуживания №8 от 01.05.2024' | 'Реализация товаров и услуг 000000008 от 29.05.2024 12:00:00' |
И В командном интерфейсе я выбираю 'Покупки и продажи' 'Реализации товаров и услуг'
Тогда открылось окно 'Реализации товаров и услуг'
И таблица "Список" содержит строки по шаблону:
	| 'Дата'                | 'Договор'                               | 'Контрагент'                     | 'Номер'     | 'Организация'       | 'Ответственный'              | 'Сумма документа' |
	| '24.05.2024 12:00:00' | 'Договор обслуживания №7 от 01.05.2024' | 'Аксенова Татьяна Владиславовна' | '000000007' | 'ООО Технологии'    | 'Молдованова Валерия'        | '8 400,00'        |
	| '29.05.2024 12:00:00' | 'Договор обслуживания №8 от 01.05.2024' | 'Некифорова Оксана Владимировна' | '000000008' | 'ООО Сервис'        | 'Молдованова Валерия'        | '5 600,00'        |
	| '*'                   | 'Договор обслуживания №2 от 01.01.2024' | 'Петров Петр Петрович'           | '0000000*'  | 'ООО Бизнес и дом'  | 'Баженова Елена (бухгалтер)' | '1 350,00'        |
	| '*'                   | 'Договор обслуживания №5 от 01.04.2024' | 'Иванов Иван Иванович'           | '0000000*'  | 'ООО Легкий бизнес' | 'Баженова Елена (бухгалтер)' | '*'               |
