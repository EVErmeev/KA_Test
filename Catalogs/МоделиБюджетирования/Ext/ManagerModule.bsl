﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс


// Проверяет, действует ли модель бюджетирования.
//
// Параметры:
// 	МодельБюджетирования - СправочникСсылка.МоделиБюджетирования - Модель бюджетирования для проверки.
//
// Возвращаемое значение:
// 	Булево - Истина, если модель бюджетирования действует.
// 				Ложь, если модель бюджетирования не действует.
//
Функция МодельБюджетированияДействует(МодельБюджетирования) Экспорт
	
	Если НЕ ЗначениеЗаполнено(МодельБюджетирования) Тогда
		Действует = Ложь;
	Иначе
		РеквизитыОбъекта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(МодельБюджетирования, 
			Новый Структура("ПометкаУдаления, Статус"));
			
		Действует = НЕ РеквизитыОбъекта.ПометкаУдаления
				И РеквизитыОбъекта.Статус = Перечисления.СтатусыМоделейБюджетирования.Действует;
	КонецЕсли;
		
	Возврат Действует;
	
КонецФункции

// Возвращает количество действующих моделей бюджетирования.
//
// Возвращаемое значение:
// 	 Число - Количество действующих моделей.
//
Функция КоличествоДействующихМоделейБюджетирования() Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ
		|	СУММА(1) КАК Количество
		|ИЗ
		|	Справочник.МоделиБюджетирования КАК МоделиБюджетирования
		|ГДЕ
		|	МоделиБюджетирования.Статус = &Статус
		|	И НЕ МоделиБюджетирования.ПометкаУдаления");
	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусыМоделейБюджетирования.Действует);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат ?(Выборка.Следующий(), Выборка.Количество, 0);
	
КонецФункции

// Получает модель бюджетирования по умолчанию для подстановки.
//
// Возвращаемое значение:
// 	СправочникСсылка.МоделиБюджетирования - Модель бюджетирования по умолчанию или найденная по статистике.
// 	Неопределено - Если действующих моделей бюджетирования нет.
//
Функция МодельБюджетированияПоУмолчанию() Экспорт
	
	МодельБюджетированияПоУмолчанию = Неопределено;
	
	СтатусДействует = Перечисления.СтатусыМоделейБюджетирования.Действует;
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 2
		|	МоделиБюджетирования.Ссылка КАК МодельБюджетирования
		|ИЗ
		|	Справочник.МоделиБюджетирования КАК МоделиБюджетирования
		|ГДЕ
		|	МоделиБюджетирования.Статус = &Статус
		|	И НЕ МоделиБюджетирования.ПометкаУдаления");
	Запрос.УстановитьПараметр("Статус", СтатусДействует);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 1 Тогда
		
		Выборка.Следующий();
		МодельБюджетированияПоУмолчанию = Выборка.МодельБюджетирования;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(МодельБюджетированияПоУмолчанию) И Выборка.Количество() > 1 Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		ОписаниеРеквизитов = Новый Структура;
		ЗаполнениеОбъектовПоСтатистике.ДобавитьОписаниеЗаполняемыхРеквизитов(ОписаниеРеквизитов, "МодельБюджетирования");
		ЗаполняемыеРеквизиты = ЗаполнениеОбъектовПоСтатистике.ПолучитьЗначенияРеквизитов(
			Документы.ЭкземплярБюджета.ПустаяСсылка(), ОписаниеРеквизитов);
		УстановитьПривилегированныйРежим(Ложь);
		
		Если ЗначениеЗаполнено(ЗаполняемыеРеквизиты.МодельБюджетирования)
			И МодельБюджетированияДействует(ЗаполняемыеРеквизиты.МодельБюджетирования) Тогда
			МодельБюджетированияПоУмолчанию = ЗаполняемыеРеквизиты.МодельБюджетирования;
		КонецЕсли;
	КонецЕсли;
	
	Возврат МодельБюджетированияПоУмолчанию;
	
КонецФункции

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
// 
// Возвращаемое значение:
// 	Массив - имена блокируемых реквизитов:
//		* БлокируемыйРеквизит - Строка - Имя блокируемого реквизита.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Периодичность");
	Результат.Добавить("НачалоДействия");
	Результат.Добавить("КонецДействия");
	Результат.Добавить("БюджетыПоОрганизациям");
	Результат.Добавить("БюджетыПоПодразделениям");
	Результат.Добавить("ИспользоватьУтверждениеБюджетов");
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	Дата = '00010101';
	НачалоПериода = '00010101';
	ОкончаниеПериода = '00010101';
	
	ПереопределенныеДанныеВыбора = Неопределено;
	Если Параметры.Свойство("Дата", Дата) Тогда
		
		ПереопределенныеДанныеВыбора = БюджетнаяОтчетностьВызовСервера.МоделиБюджетированияСОтборомПоДате(Дата);
		
	ИначеЕсли Параметры.Свойство("НачалоПериода", НачалоПериода)
			И Параметры.Свойство("ОкончаниеПериода", ОкончаниеПериода) Тогда
		
		ПереопределенныеДанныеВыбора = БюджетнаяОтчетностьВызовСервера.МоделиБюджетированияСОтборомПоПериоду(НачалоПериода, ОкончаниеПериода);
		
	КонецЕсли;
	
	Если ПереопределенныеДанныеВыбора <> Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = ПереопределенныеДанныеВыбора;
		
	Иначе
		
		Параметры.Отбор.Вставить("ПометкаУдаления", Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции


#Область ОбновлениеИнформационнойБазы

//++ НЕ УТ

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.МоделиБюджетирования.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "2.5.9.59";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("1db224bf-662b-4522-8ebf-a0f77a323c07");
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.МоделиБюджетирования.ЗарегистрироватьДанныеДляОбновления";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет функциональную валюту.'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.МоделиБюджетирования.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.МоделиБюджетирования.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.МоделиБюджетирования.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
КонецПроцедуры

Процедура ЗарегистрироватьДанныеДляОбновления(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ЗаменитьЗначениеРеквизитаЗарегистрироватьДанныеКОбработке(
		Параметры, "Справочник.МоделиБюджетирования", "ФункциональнаяВалюта", Перечисления.ВидыУчетаВФункциональнойВалюте.ПустаяСсылка());
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ОбновлениеИнформационнойБазыУТ.ЗаменитьЗначениеРеквизита(
		Параметры, "Справочник.МоделиБюджетирования", "ФункциональнаяВалюта",
		Перечисления.ВидыУчетаВФункциональнойВалюте.ПустаяСсылка(), Перечисления.ВидыУчетаВФункциональнойВалюте.ВВалютеРегл);
	
КонецПроцедуры

//-- НЕ УТ

#КонецОбласти

#КонецОбласти

#КонецЕсли