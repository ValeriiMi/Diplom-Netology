#Область ПрограммныйИнтерфейс

// Преобразует ОбъектJSON в строку.
// Возвращаемое значение: 
// Строка
Функция СтрокаJSON(ОбъектJSON) Экспорт
	
	ПараметрыЗаписи = Новый ПараметрыЗаписиJSON(, Символы.Таб);
	
	Запись = Новый ЗаписьJSON;
	Запись.УстановитьСтроку(ПараметрыЗаписи);
	ЗаписатьJSON(Запись, ОбъектJSON);
	
	Возврат Запись.Закрыть();
		
КонецФункции

// Формирует HTTPОтвет.
// Возвращаемое значение: 
// HTTPОтвет
Функция ОтветJSON(Объект, КодСостояния) Экспорт
	
	Ответ = Новый HTTPСервисОтвет(КодСостояния);
	Ответ.УстановитьТелоИзСтроки(СтрокаJSON(Объект));
	Ответ.Заголовки.Вставить("Content-Type", "application/json");
	
	Возврат Ответ;
		
КонецФункции

// Выполняет post-запрос в телеграм-бот.
// Возвращаемое значение: 
// HTTPОтвет
//
Функция РаботаСТелеграмБотом(ТекстСообщения) Экспорт
	
	Токен = Константы.ВКМ_ТокенУправленияТелеграмБотом.Получить();
	Заголовки = Новый Соответствие;
	Заголовки.Вставить("Content-Type", "application/json");
	
	СоединениеHTTP = Новый HTTPСоединение("api.telegram.org",443,,,,,Новый ЗащищенноеСоединениеOpenSSL());
	ЗапросHTTP = Новый HTTPЗапрос("/bot" + Токен + "/sendMessage", Заголовки);
	
	Результат = Новый Структура;
	
	Результат.Вставить("chat_id", Константы.ВКМ_ИдентификаторГруппыДляОповещения.Получить());
	Результат.Вставить("text", ТекстСообщения);
	
	ЗапросHTTP.УстановитьТелоИзСтроки(СтрокаJSON(Результат));
	
	Ответ = СоединениеHTTP.Получить(ЗапросHTTP);
	
	Если Ответ.КодСостояния <> 200 Тогда
		Ошибка = Ответ.ПолучитьТелоКакСтроку();
		ЗаписьЖурналаРегистрации("HTTPСервисы.Ошибка", УровеньЖурналаРегистрации.Ошибка, , , Ошибка);
	КонецЕсли;
	
	Возврат Ответ;
		
КонецФункции

// Обходит все элементы справочника ВКМ_УведомленияТелеграмБоту, отправляет данные сообщения
// и удаляет эти элементы из справочника
Процедура ВКМ_ОтправкаУведомлений() Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания(Метаданные.РегламентныеЗадания.ВКМ_ОтправкаУведомлений);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ВКМ_УведомленияТелеграмБоту.Ссылка,
	|	ВКМ_УведомленияТелеграмБоту.ТекстСообщения
	|ИЗ
	|	Справочник.ВКМ_УведомленияТелеграмБоту КАК ВКМ_УведомленияТелеграмБоту";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		РаботаСТелеграмБотом(Выборка.ТекстСообщения);
		СправочникОбъект = Выборка.Ссылка.ПолучитьОбъект();
		СправочникОбъект.Удалить();
			
	КонецЦикла;

КонецПроцедуры

#КонецОбласти