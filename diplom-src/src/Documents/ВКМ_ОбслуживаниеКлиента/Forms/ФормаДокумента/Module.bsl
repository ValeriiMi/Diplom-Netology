#Область ОписаниеПеременных

&НаСервере
Перем Специалист, ДатаПроведенияРабот, ВремяНачалаРабот, ВремяОкончанияРабот, Номер; 

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
    ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВКМ_ОбслуживаниеКлиента.Специалист,
	|	ВКМ_ОбслуживаниеКлиента.ДатаПроведенияРабот,
	|	ВКМ_ОбслуживаниеКлиента.ВремяНачалаРабот,
	|	ВКМ_ОбслуживаниеКлиента.ВремяОкончанияРабот,
	|	ВКМ_ОбслуживаниеКлиента.Номер
	|ИЗ
	|	Документ.ВКМ_ОбслуживаниеКлиента КАК ВКМ_ОбслуживаниеКлиента
	|ГДЕ
	|	ВКМ_ОбслуживаниеКлиента.Ссылка = &Ссылка";
		
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
		
	Специалист = Выборка.Специалист;
	ДатаПроведенияРабот = Выборка.ДатаПроведенияРабот;
	ВремяНачалаРабот = Выборка.ВремяНачалаРабот;
	ВремяОкончанияРабот = Выборка.ВремяОкончанияРабот;
		
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ДоговорыКонтрагентов.ВидДоговора
	|ИЗ
	|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
	|ГДЕ
	|	ДоговорыКонтрагентов.Ссылка = &Договор";
	
	Запрос.УстановитьПараметр("Договор", Объект.Договор);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	
	Если Выборка.ВидДоговора <> Перечисления.ВидыДоговоровКонтрагентов.ВКМ_АбоненскоеОбслуживание Тогда
		Отказ = Истина;
		ОбщегоНазначения.СообщитьПользователю("Тип договора с контрагентом не Абонентское обслуживание");
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Ключ.Пустая() Тогда
		Если Специалист <> Объект.Специалист ИЛИ ДатаПроведенияРабот <> Объект.ДатаПроведенияРабот
				ИЛИ ВремяНачалаРабот <> Объект.ВремяНачалаРабот ИЛИ ВремяОкончанияРабот <> Объект.ВремяОкончанияРабот Тогда
				
				ОтказЗаписи = "Уведомление создано";
				УведомлениеОбИзменении = Справочники.ВКМ_УведомленияТелеграмБоту.СоздатьЭлемент();
				УведомлениеОбИзменении.ТекстСообщения = СтрШаблон("Изменения по заявке на обслуживание №%1:%2Специалист - %3,%4Дата проведения работ - %5,%6Время начала работ - %7,%8Время окончания работ - %9",
								Объект.Номер, Символы.ПС, Объект.Специалист, Символы.ПС, Формат(Объект.ДатаПроведенияРабот, "ДФ=dd.MM.yyyy;"), Символы.ПС, Формат(Объект.ВремяНачалаРабот, "ДЛФ=T;"), Символы.ПС, Формат(Объект.ВремяОкончанияРабот, "ДЛФ=T;"));
								
				УведомлениеОбИзменении.Записать();
		Иначе
				ОтказЗаписи = "Уведомление НЕ создано";
		КонецЕсли;
	Иначе
		ОтказЗаписи = "Уведомление создано";
		НовоеУведомление = Справочники.ВКМ_УведомленияТелеграмБоту.СоздатьЭлемент();
		НовоеУведомление.ТекстСообщения = СтрШаблон("Новая заявка на обслуживание:%1Специалист - %2,%3Дата проведения работ - %4,%5Время начала работ - %6,%7Время окончания работ - %8",
								Символы.ПС, Объект.Специалист, Символы.ПС, Формат(Объект.ДатаПроведенияРабот, "ДФ=dd.MM.yyyy;"), Символы.ПС, Формат(Объект.ВремяНачалаРабот, "ДЛФ=T;"), Символы.ПС, Формат(Объект.ВремяОкончанияРабот, "ДЛФ=T;"));						
		НовоеУведомление.Записать();
	КонецЕсли;
	
	ОбщегоНазначения.СообщитьПользователю(ОтказЗаписи);

КонецПроцедуры



#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПодключаемыеКоманды

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

