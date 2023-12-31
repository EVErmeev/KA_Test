﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка,
	|	Таблица.Синоним КАК Синоним
	|ПОМЕСТИТЬ ВТТаблицаСпособовВыплаты
	|ИЗ
	|	&ТаблицаСпособовВыплаты КАК Таблица
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таблица.Ссылка КАК Ссылка
	|ИЗ
	|	ВТТаблицаСпособовВыплаты КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка В(&ДоступныеСпособыВыплаты)
	|	И Таблица.Синоним ПОДОБНО &СтрокаПоиска";
	
	Если Параметры.СтрокаПоиска = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И Таблица.Синоним ПОДОБНО &СтрокаПоиска", "");
	КонецЕсли;
	
	// Составляем таблицу способов расчетов.
	ТаблицаСпособовВыплаты = Новый ТаблицаЗначений;
	ТаблицаСпособовВыплаты.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("ПеречислениеСсылка.СпособыВыплатыПрочихДоходов"));
	ТаблицаСпособовВыплаты.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.СпособыВыплатыПрочихДоходов.ЗначенияПеречисления Цикл
		НоваяСтрока = ТаблицаСпособовВыплаты.Добавить();
		НоваяСтрока.Ссылка = Перечисления.СпособыВыплатыПрочихДоходов[ЗначениеПеречисления.Имя];
		НоваяСтрока.Синоним = ЗначениеПеречисления.Синоним;
	КонецЦикла;
	
	// Отбор только по доступным способам с учетом введенной строки.
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаСпособовВыплаты", ТаблицаСпособовВыплаты);
	Запрос.УстановитьПараметр("ДоступныеСпособыВыплаты", Перечисления.СпособыВыплатыПрочихДоходов.ДоступныеСпособыВыплаты());
	Запрос.УстановитьПараметр("СтрокаПоиска", Строка(Параметры.СтрокаПоиска) + "%");
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	СтандартнаяОбработка = Ложь;	
	
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Формируется массив доступных способов выплаты.
//
Функция ДоступныеСпособыВыплаты() Экспорт
	
	СпособыВыплаты = Новый Массив;
	СпособыВыплаты.Добавить(Перечисления.СпособыВыплатыПрочихДоходов.ВыплатыБывшимСотрудникам);
	СпособыВыплаты.Добавить(Перечисления.СпособыВыплатыПрочихДоходов.ВыплатаПрочихДоходов);
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.Дивиденды") Тогда
		СпособыВыплаты.Добавить(Перечисления.СпособыВыплатыПрочихДоходов.Дивиденды);
		СпособыВыплаты.Добавить(Перечисления.СпособыВыплатыПрочихДоходов.ДивидендыСотрудникам);
	КонецЕсли;
	
	Возврат СпособыВыплаты;
	
КонецФункции

// Возвращает способ расчетов указанного способа выплаты.
//
// Параметры:
//   ВидДокумента - ПеречислениеСсылка.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты - вид документа.
//
// Возвращаемое значение: 
//  ПеречислениеСсылка.СпособыРасчетовСФизическимиЛицам.
//
Функция СпособРасчетов(СпособВыплаты) Экспорт
	
	Если СпособВыплаты = Перечисления.СпособыВыплатыПрочихДоходов.Дивиденды Тогда
		Возврат Перечисления.СпособыРасчетовСФизическимиЛицами.Дивиденды
	ИначеЕсли СпособВыплаты = Перечисления.СпособыВыплатыПрочихДоходов.ДивидендыСотрудникам Тогда
		Возврат Перечисления.СпособыРасчетовСФизическимиЛицами.ДивидендыСотрудникам
	ИначеЕсли СпособВыплаты = Перечисления.СпособыВыплатыПрочихДоходов.ВыплатыБывшимСотрудникам	Тогда
		Возврат Перечисления.СпособыРасчетовСФизическимиЛицами.РасчетыСКонтрагентами
	ИначеЕсли СпособВыплаты = Перечисления.СпособыВыплатыПрочихДоходов.ВыплатаПрочихДоходов	Тогда
		Возврат Перечисления.СпособыРасчетовСФизическимиЛицами.РасчетыСКонтрагентами
	Иначе
		Возврат Неопределено
	КонецЕсли;	

КонецФункции

// Возвращает метаданные документа-основания указанного способа выплаты.
//
// Параметры:
//   ВидДокумента - ПеречислениеСсылка.ВидыДокументовОснованийВедомостейНаВыплатуЗарплаты - вид документа.
//
// Возвращаемое значение: 
//  ОбъектМетаданных.
//
Функция МетаданныеОснования(СпособВыплаты) Экспорт
	
	Если СпособВыплаты = Перечисления.СпособыВыплатыПрочихДоходов.Дивиденды Тогда
		Возврат Метаданные.Документы.Найти("ДивидендыФизическимЛицам")
	ИначеЕсли СпособВыплаты = Перечисления.СпособыВыплатыПрочихДоходов.ДивидендыСотрудникам Тогда
		Возврат Метаданные.Документы.Найти("ДивидендыФизическимЛицам")
	ИначеЕсли СпособВыплаты = Перечисления.СпособыВыплатыПрочихДоходов.ВыплатыБывшимСотрудникам	Тогда
		Возврат Метаданные.Документы.Найти("ВыплатаБывшимСотрудникам")
	ИначеЕсли СпособВыплаты = Перечисления.СпособыВыплатыПрочихДоходов.ВыплатаПрочихДоходов	Тогда
		Возврат Метаданные.Документы.Найти("РегистрацияПрочихДоходов")
	Иначе
		Возврат Неопределено
	КонецЕсли;	

КонецФункции

#КонецОбласти

#КонецЕсли