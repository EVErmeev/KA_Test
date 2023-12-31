﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий
 
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиОсновнойСхемы = КомпоновщикНастроек.ПолучитьНастройки();
	
	УстановитьПараметрыОтчета(НастройкиОсновнойСхемы);
	
	ОбесценениеВНАСервер.УстановитьВидимостьДанныхОбесцененияВОтчете(НастройкиОсновнойСхемы);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОсновнойСхемы, ДанныеРасшифровки);	
	
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, Неопределено, ДанныеРасшифровки, Истина);
	
	ПроцессорВыводаВТабличныйДокумент = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаВТабличныйДокумент.УстановитьДокумент(ДокументРезультат);	
	ПроцессорВыводаВТабличныйДокумент.Вывести(ПроцессорКомпоновкиДанных);
	
	ОформитьШапкуОтчета(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ФормированиеОтчета
 
Процедура ОформитьШапкуОтчета(ТабДок)
	
	СписокГруппЯчеек = Новый Массив;
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Показатели'"));
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Дата принятия к учету'"));
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Первоначальная стоимость'"));
	
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Стоимость'"));
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Амортизация'"));
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Остаточная стоимость'"));
	
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Увеличение стоимости'"));
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Начисление амортизации'"));
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Уменьшение стоимости'"));
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Списание амортизации'"));
	
	СписокГруппЯчеек.Добавить(НСтр("ru = 'Обесценение'"));
	
	СписокПодчиненныхЯчеек = Новый Массив;
	СписокПодчиненныхЯчеек.Добавить(НСтр("ru = 'БУ'"));
	СписокПодчиненныхЯчеек.Добавить(НСтр("ru = 'УУ'"));
	
	ВнеоборотныеАктивыСлужебный.ОбъединитьПодчиненныеЯчейки(ТабДок, СписокГруппЯчеек, СписокПодчиненныхЯчеек);
	
КонецПроцедуры

Процедура УстановитьПараметрыОтчета(НастройкиОсновнойСхемы)

	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ПоказательБУ", НСтр("ru = 'БУ'"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ПоказательУУ", НСтр("ru = 'УУ'"));
	
	// ТипыДокументовСписаниеАмортизации
	ТипыДокументов = Новый СписокЗначений;
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПринятиеКУчетуОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПереоценкаОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.СписаниеОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.КорректировкаРегистров"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПодготовкаКПередачеОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РазукомплектацияОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ОбъединениеОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.КорректировкаСтоимостиИАмортизацииОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ИзменениеУсловийДоговораАренды"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ТипыДокументовСписаниеАмортизации", ТипыДокументов);
	
	// ТипыДокументовНачислениеАмортизации
	ТипыДокументов = Новый СписокЗначений;
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПринятиеКУчетуОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ВводОстатковВнеоборотныхАктивов2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.АмортизацияОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПереоценкаОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РаспределениеНДС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.КорректировкаСтоимостиИАмортизацииОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.КорректировкаРегистров"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ИзменениеУсловийДоговораАренды"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ТипыДокументовНачислениеАмортизации", ТипыДокументов);
	
	// ТипыДокументовУвеличениеСтоимости
	ТипыДокументов = Новый СписокЗначений;
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПринятиеКУчетуОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ВводОстатковВнеоборотныхАктивов2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПереоценкаОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РаспределениеНДС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.МодернизацияОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПоступлениеАрендованныхОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ОбъединениеОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РазукомплектацияОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.КорректировкаСтоимостиИАмортизацииОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.КорректировкаРегистров"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ИзменениеУсловийДоговораАренды"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ТипыДокументовУвеличениеСтоимости", ТипыДокументов);
	
	// ТипыДокументовУменьшениеСтоимости
	ТипыДокументов = Новый СписокЗначений;
	ТипыДокументов.Добавить(Тип("ДокументСсылка.АмортизацияОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПринятиеКУчетуОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПереоценкаОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.МодернизацияОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ПодготовкаКПередачеОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.СписаниеОС2_4"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ВыбытиеАрендованныхОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РаспределениеНДС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ОбъединениеОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.РазукомплектацияОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.КорректировкаСтоимостиИАмортизацииОС"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.КорректировкаРегистров"));
	ТипыДокументов.Добавить(Тип("ДокументСсылка.ИзменениеУсловийДоговораАренды"));
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиОсновнойСхемы, "ТипыДокументовУменьшениеСтоимости", ТипыДокументов);
	
КонецПроцедуры
 
#КонецОбласти

#КонецОбласти

#КонецЕсли