#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	Год = Параметры.Год;
	ДанныеОтпусков = ПолучитьИзВременногоХранилища(Параметры.Адрес);
	
	АвтоЗаголовок = Ложь;
	Заголовок = СтрШаблон("График отпусков на %1 год", Формат(Год, "ДФ=yyyy"));
	
	// Строим Диаграмму Ганта
	ДиаграммаГанта.Очистить();
	Для Каждого Отпуск Из ДанныеОтпусков Цикл
		
		Точка = ДиаграммаГанта.УстановитьТочку(Отпуск.Сотрудник);
		Серия = ДиаграммаГанта.УстановитьСерию("Отпуск");
		
		Значение = ДиаграммаГанта.ПолучитьЗначение(Точка, Серия);
		Интервал = Значение.Добавить();
		Интервал.Начало = Отпуск.ДатаНачала;
		Интервал.Конец = Отпуск.ДатаОкончания;
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти