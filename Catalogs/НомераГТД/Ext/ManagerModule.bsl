﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Возвращает параметры таможенной декларации - регистрационный номер и признак того, декларировался ли товар в РФ.
// Порядок получения регистрационного номера таможенной декларации см. УчетНДСКлиентСерверЛокализация.ПроверитьКорректностьНомераТаможеннойДекларации.
// Если передан параметр ТипНомераГТД, который содержит не пустое значение, тогда РегистрационныйНомер заполнится
// в зависимости от значения параметра.
// Если РегистрационныйНомер примет значение пустой строки, будет установлен признак, что товар декларировался не в РФ.
//
// Параметры:
//	НомерТаможеннойДекларации - Строка - номер таможенной декларации или регистрационный номер таможенной декларации.
//	ТипНомераГТД - ПеречислениеСсылка.ТипыНомеровГТД, Неопределено - тип элемента справочника НомераГТД.
//
// Возвращаемое значение:
//	Структура - коллекция, содержащая следующие свойства:
//		* РегистрационныйНомер	- Строка -регистрационный номер таможенной декларации либо пустая строка, 
//											если его не удалось определить.
//		* ПорядковыйНомерТовара - Строка - Порядковый номер товара из графы 32 ДТ.
//		* КодОшибки				- Число - код ошибки.
//		* СтранаВвозаНеРФ		- Булево - признак, что товар декларировался не в РФ.
//
Функция РегистрационныйНомерИСтранаВвоза(НомерТаможеннойДекларации, ТипНомераГТД = Неопределено) Экспорт
	
	ДанныеНомера = Новый Структура;
	ДанныеНомера.Вставить("РегистрационныйНомер", "");
	ДанныеНомера.Вставить("ПорядковыйНомерТовара", "");
	ДанныеНомера.Вставить("КодОшибки", 0);
	ДанныеНомера.Вставить("СтранаВвозаНеРФ", Ложь);
	
	УчетПрослеживаемыхТоваровКлиентСерверЛокализация.ЗаполнитьРегистрационныйНомерИСтранаВвоза(
		ДанныеНомера,
		НомерТаможеннойДекларации,
		ТипНомераГТД);
	
	Возврат ДанныеНомера;
	
КонецФункции

// Возвращает дату принятия декларации на товары.
// Если номер таможенной декларации указан некорректно или декларация была выдана 
// не российским таможенным органом - будет возвращена пустая дата.
//
// Параметры:
//    НомерТаможеннойДекларации - Строка - Номер таможенной декларации или регистрационный номер таможенной декларации.
//
// Возвращаемое значение:
//    Дата - Дата принятия декларации на товары, зашифрованная во втором разряде
//                                            номера таможенной декларации.
Функция ДатаПринятияДекларацииНаТовары(НомерТаможеннойДекларации) Экспорт
	
	ДатаПринятияДекларацииНаТовары = '00010101';
	
	Если НЕ ЗначениеЗаполнено(НомерТаможеннойДекларации) Тогда
		Возврат ДатаПринятияДекларацииНаТовары;
	КонецЕсли;
	
	СтруктураНомера = УчетНДСКлиентСерверЛокализация.ПроверитьКорректностьНомераТаможеннойДекларации(НомерТаможеннойДекларации);
	
	Если НЕ ЗначениеЗаполнено(СтруктураНомера.РегистрационныйНомер) Тогда
		Возврат ДатаПринятияДекларацииНаТовары;
	КонецЕсли;
	
	МассивТД = СтрРазделить(СтруктураНомера.РегистрационныйНомер, "/");
	РазрядДатаПринятияДекларацииНаТовары = МассивТД[1];
	
	Возврат СтроковыеФункцииКлиентСервер.СтрокаВДату(РазрядДатаПринятияДекларацииНаТовары)
	
КонецФункции

// Инициализирует структуру параметров для передачи данных в обработчик заполнения элемента справочника НомераГТД.
//
// Параметры:
//	НомерТаможеннойДекларации - Строка - номер таможенной декларации или регистрационный номер таможенной декларации.
//	СтранаПроисхождения - Неопределено, СправочникСсылка.СтраныМира - Необязательный, страна происхождения товара
//																		по таможенной декларации.
//
// Возвращаемое значение:
//	Структура - параметры заполнения элемента справочника НомераГТД, включающие следующие свойства:
//		* Код - Строка - Полный номер грузовой таможенной декларации.
//		* СтранаПроисхождения - СправочникСсылка.СтраныМира, Неопределено - Страна происхождения товара по таможенной
//																			декларации.
//		* РегистрационныйНомер - Строка - Номер таможенной декларации.
//		* ПорядковыйНомерТовара - Строка - Порядковый номер товара (значение поля №32 таможенной декларации).
//		* ТипНомераГТД - ПеречислениеСсылка.ТипыНомеровГТД - тип номера ГТД. Значение по умолчанию "НомерГТД".
//		* ЗаполнитьПорядковыйНомерТовараАвтоматически - Булево - Признак, что ПорядковыйНомерТовара будет вычисляться
//																	непосредственно из свойства Код.
//		* СтранаВвозаНеРФ - Булево - Признак, что товар декларировался не в РФ.
//
Функция ПараметрыДляЗаполненияЭлемента(НомерТаможеннойДекларации, СтранаПроисхождения = Неопределено) Экспорт
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("Код",						НомерТаможеннойДекларации);
	ПараметрыЗаполнения.Вставить("СтранаПроисхождения",		?(ЗначениеЗаполнено(СтранаПроисхождения),
																СтранаПроисхождения,
																Справочники.СтраныМира.ПустаяСсылка()));
	ПараметрыЗаполнения.Вставить("РегистрационныйНомер",	"");
	ПараметрыЗаполнения.Вставить("ПорядковыйНомерТовара",	"");
	ПараметрыЗаполнения.Вставить("ТипНомераГТД",			Перечисления.ТипыНомеровГТД.НомерГТД);
	ПараметрыЗаполнения.Вставить("ЗаполнитьПорядковыйНомерТовараАвтоматически", Ложь);
	ПараметрыЗаполнения.Вставить("СтранаВвозаНеРФ",			Ложь);
	
	Возврат ПараметрыЗаполнения;
	
КонецФункции

// Возвращает имена блокируемых реквизитов для механизма блокирования реквизитов БСП.
//
// Возвращаемое значение:
//	Массив Из Строка- имена блокируемых реквизитов.
//
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив;
	БлокируемыеРеквизиты.Добавить("Код");
	БлокируемыеРеквизиты.Добавить("ТипНомераГТД");
	БлокируемыеРеквизиты.Добавить("СтранаПроисхождения");
	БлокируемыеРеквизиты.Добавить("ПрослеживаемыеКомплектующие");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("Код");
	Поля.Добавить("ТипНомераГТД");
	Поля.Добавить("КоличествоКомплектующих");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Если Данные.ТипНомераГТД <> ПредопределенноеЗначение("Перечисление.ТипыНомеровГТД.НомерРНПТКомплекта") Тогда
		Возврат;
	Иначе
		ЗакупкиВызовСервера.НомераГТДОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка);
	КонецЕсли;
	
КонецПроцедуры

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ЗакупкиВызовСервера.НомераГТДОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецЕсли

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Возвращает порядковый номер товара из полного номера таможенной декларации,  для России это 4 группа символов,
// найденных по разделителю "\".
//
// Параметры:
//	НомерТаможеннойДекларации - Строка - Полный номер таможенной декларации.
//
// Возвращаемое значение:
//	Строка - Порядковый номер товара (значение поля №32 таможенной декларации).
//
Функция ПорядковыйНомерТовараИзНомераТаможеннойДекларации(НомерТаможеннойДекларации) Экспорт
	
	ПорядковыйНомерТовара	= "";
	ДанныеНомераГТД			= СтрРазделить(НомерТаможеннойДекларации, "/");
	
	Если ДанныеНомераГТД.Количество() = 4 Тогда
		ПорядковыйНомерТовара = ДанныеНомераГТД[3];
	КонецЕсли;
	
	Возврат ПорядковыйНомерТовара;
	
КонецФункции

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Справочники.НомераГТД.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.10.18";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("6de74904-9203-416c-9fd7-3c8277f80f5a");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Справочники.НомераГТД.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Заполняет реквизит Тип номера ГТД'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Справочники.НомераГТД.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Справочники.НомераГТД.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Справочники.НомераГТД.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	
КонецПроцедуры

// Регистрирует данные для обработки для перехода на новую версию программы.
//
// Параметры:
//	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке.
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = "Справочник.НомераГТД";
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Ссылка");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НомераГТД.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НомераГТД КАК НомераГТД
	|ГДЕ
	|	НомераГТД.ТипНомераГТД = ЗНАЧЕНИЕ(Перечисление.ТипыНомеровГТД.ПустаяСсылка)";
	
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта	= "Справочник.НомераГТД";
	ОбновляемыеДанные	= ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь,
																							ПолноеИмяОбъекта);
		
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДляОбработки.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТДанныеДляОбработки
	|ИЗ
	|	&ДанныеДляОбработки КАК ДанныеДляОбработки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДанныеДляОбработки.Ссылка	КАК Ссылка,
	|	НомераГТД.ВерсияДанных		КАК ВерсияДанных,
	|	ВЫБОР
	|		КОГДА НомераГТД.Ссылка ЕСТЬ NULL
	|			ТОГДА ЛОЖЬ
	|		ИНАЧЕ НомераГТД.ТипНомераГТД = ЗНАЧЕНИЕ(Перечисление.ТипыНомеровГТД.ПустаяСсылка)
	|	КОНЕЦ						КАК ЗаполнитьТипНомераГТД
	|ИЗ
	|	ВТДанныеДляОбработки КАК ДанныеДляОбработки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.НомераГТД КАК НомераГТД
	|		ПО ДанныеДляОбработки.Ссылка = НомераГТД.Ссылка";
	
	Запрос.УстановитьПараметр("ДанныеДляОбработки", ОбновляемыеДанные);
	
	РезультатЗапроса	= Запрос.Выполнить();
	Выборка				= РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка = Новый БлокировкаДанных;
			
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Выборка.Ссылка);
			ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
			
			Блокировка.Заблокировать();
			
			ДанныеОбъекта = ОбновлениеИнформационнойБазыУТ.ПроверитьПолучитьОбъект(Выборка.Ссылка,
																					Выборка.ВерсияДанных,
																					Параметры.Очередь);
			
			Если ДанныеОбъекта = Неопределено Тогда
				ЗафиксироватьТранзакцию();
				
				Продолжить;
			КонецЕсли;
			
			ОбъектИзменен = Ложь;
			
			Если Выборка.ЗаполнитьТипНомераГТД Тогда
				ОбъектИзменен = Истина;
				
				ДанныеОбъекта.ТипНомераГТД = ?(ДанныеОбъекта.УдалитьРНПТ,
												Перечисления.ТипыНомеровГТД.НомерРНПТ,
												Перечисления.ТипыНомеровГТД.НомерГТД);
			КонецЕсли;
			
			Если ОбъектИзменен Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДанныеОбъекта);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Выборка.Ссылка);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			ОтменитьТранзакцию();
			
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), Выборка.Ссылка);
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь,
																						ПолноеИмяОбъекта);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
