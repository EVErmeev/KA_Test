﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	ОписаниеТиповДокументРеализации = Метаданные.Документы.ФормированиеЗаписейРаздела7ДекларацииНДС.ТабличныеЧасти.НеоблагаемыеНДСОперации.Реквизиты.ДокументРеализации.Тип;
	
	Если Параметры.Ключ.Пустая() Тогда
		ЗаполнитьРеквизитыИзПараметровФормы(ЭтаФорма);
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	ТекущаяДатаДокумента = Объект.Дата;
	ТекущаяОрганизация   = Объект.Организация;
	НДСРаспределен       = Истина;
	
	ОбновитьИтогиВПодвале(ЭтаФорма);
	УстановитьУсловноеОформление();
	
	УчетНДСПереопределяемый.ПриСозданииНаСервереДокументаНДС(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
	
	ПодготовитьФормуНаСервере();
	
	УчетНДСПереопределяемый.ПриЧтенииНаСервереДокументаНДС(ЭтотОбъект, ТекущийОбъект);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	УчетНДСКлиентПереопределяемый.ПослеЗаписиДокументаНДС(ЭтотОбъект, ПараметрыЗаписи);
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	УправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	УстановитьСостояниеДокумента();
	
	УчетНДСПереопределяемый.ПослеЗаписиНаСервереДокументаНДС(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	СобытияФормКлиент.ПередЗаписью(ЭтотОбъект, Отказ, ПараметрыЗаписи);
	
	КолвоСтрокНеоблагаемыеНДСОперации = Объект.НеоблагаемыеНДСОперации.Количество();
	МаксимальноеКоличествоСтрок = 99999;
	Если КолвоСтрокНеоблагаемыеНДСОперации > МаксимальноеКоличествоСтрок Тогда
		
		КоличествоСтрокДляПереноса = КолвоСтрокНеоблагаемыеНДСОперации - МаксимальноеКоличествоСтрок;
		КоличествоНовыхДокументов = Цел(КоличествоСтрокДляПереноса / МаксимальноеКоличествоСтрок) + 
			?(КоличествоСтрокДляПереноса % МаксимальноеКоличествоСтрок <> 0, 1, 0);
		Отказ = Истина;
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("КоличествоСтрокДляПереноса",КоличествоСтрокДляПереноса);
		ДополнительныеПараметры.Вставить("РежимЗаписи",ПараметрыЗаписи.РежимЗаписи);
		ДополнительныеПараметры.Вставить("КоличествоНовыхДокументов",КоличествоНовыхДокументов);
		ДополнительныеПараметры.Вставить("МаксимальноеКоличествоСтрок",МаксимальноеКоличествоСтрок);
		ДополнительныеПараметры.Вставить("КоличествоСтрокДляПереноса",КоличествоСтрокДляПереноса);
		Оповещение = Новый ОписаниеОповещения("ВопросПеренестиЛишниеСтрокиТЧВДругойДокумент",ЭтотОбъект,ДополнительныеПараметры);
		
		ТекстВопроса = НСтр("ru='В табличные части можно записать не более '")+
				Строка(МаксимальноеКоличествоСтрок)+ НСтр("ru=' строк.
				|Перенести '")+
				ТекстКоличествоСтрокДляПереноса("последняя строка",КоличествоСтрокДляПереноса)+
				?(КоличествоНовыхДокументов = 1,НСтр("ru=' в новый документ?'"),НСтр("ru=' в новые документы?'"));
		
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;     // Чтобы не вызывалось по умолчанию платформеннная ошибка "Табличная часть содержит более 99999 строк"
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если Объект.НеоблагаемыеНДСОперации.Количество() <> 0
		ИЛИ Объект.ПодтверждающиеДокументы.Количество() <> 0 Тогда 
		ТекстВопроса = НСтр("ru = 'Необходимо очистить табличную часть. Продолжить?'");
		Оповещение = Новый ОписаниеОповещения("ВопросПриИзмененииОрганизацииЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	Иначе
		ПриИзмененииОрганизации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	УстановитьФункциональныеОпцииФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыНеоблагаемыеНДСОперации

&НаКлиенте
Процедура НеоблагаемыеНДСОперацииПодтверждающиеДокументыПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбраннаяСтрока = Элементы.НеоблагаемыеНДСОперации.ТекущаяСтрока;
	ОткрытьФормуРедактированияПодтверждающихДокументов(ВыбраннаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура НеоблагаемыеНДСОперацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "НеоблагаемыеНДСОперацииПодтверждающиеДокументыПредставление" Тогда
		ОткрытьФормуРедактированияПодтверждающихДокументов(ВыбраннаяСтрока);
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "РедактированиеСпискаПодтверждающихДокументов" Тогда 
		
		КлючПоиска = Новый Структура("КлючСтроки", Параметр.КлючСтроки);
		МассивСтрокПодтверждающиеДокументы = Объект.ПодтверждающиеДокументы.НайтиСтроки(КлючПоиска);
		
		Для Каждого СтрокаТЧ Из МассивСтрокПодтверждающиеДокументы Цикл
			Объект.ПодтверждающиеДокументы.Удалить(СтрокаТЧ);
		КонецЦикла;
		
		АдресТаблицыПодтверждающиеДокументы = Параметр.АдресТаблицыПодтверждающиеДокументы;
		ЗагрузитьПодтверждающиеДокументыИзХранилища(Параметр.КлючСтроки);
	
	КонецЕсли;
	
	УчетНДСКлиентПереопределяемый.ДополнительнаяОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
		
КонецПроцедуры

&НаКлиенте
Процедура НеоблагаемыеНДСОперацииКодОперацииПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.НеоблагаемыеНДСОперации.ТекущиеДанные;
	РеквизитыКодаОперации = РеквизитыКодаОперации(ТекущиеДанные.КодОперации);
	ТекущиеДанные.КодСт149НКРФ      = РеквизитыКодаОперации.ОперацияНеПодлежитНалогообложению;
	ТекущиеДанные.ВключаетсяВРеестр = РеквизитыКодаОперации.ВключаетсяВРеестрПодтверждающихДокументов;
	ТекущиеДанные.ТребуетсяЗаполнениеГраф3И4 = РеквизитыКодаОперации.ТребуетсяЗаполнениеГраф3И4;
	ТекущиеДанные.РозничнаяПродажа  = 
		ТипЗнч(ТекущиеДанные.ДокументРеализации) = Тип("ДокументСсылка.ОтчетОРозничныхПродажах");
	
КонецПроцедуры

&НаКлиенте
Процедура НеоблагаемыеНДСОперацииДокументРеализацииПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.НеоблагаемыеНДСОперации.ТекущиеДанные;
	ТекущиеДанные.РозничнаяПродажа = 
		ТипЗнч(ТекущиеДанные.ДокументРеализации) = Тип("ДокументСсылка.ОтчетОРозничныхПродажах");
	
КонецПроцедуры

&НаКлиенте
Процедура НеоблагаемыеНДСОперацииПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		
		ТекДанныеНеоблагаемыеНДСОперации = Элементы.НеоблагаемыеНДСОперации.ТекущиеДанные;
		ТекДанныеНеоблагаемыеНДСОперации.КлючСтроки = Новый УникальныйИдентификатор;
		
		ТекДанныеНеоблагаемыеНДСОперации.ПодтверждающиеДокументыПредставление = "<...>";
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НеоблагаемыеНДСОперацииПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ОбновитьИтогиВПодвале(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура НеоблагаемыеНДСОперацииПослеУдаления(Элемент)
	
	ОбновитьИтогиВПодвале(ЭтаФорма);
	НДСРаспределен = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НеоблагаемыеНДСОперацииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	НДСРаспределен = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НеоблагаемыеНДСОперацииНДСРаспределенныйПриИзменении(Элемент)
	
	НДСРаспределен = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НеоблагаемыеНДСОперацииДокументРеализацииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.НеоблагаемыеНДСОперации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ДоступныеТипы", ОписаниеТиповДокументРеализации);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыборТипаДокументаРасчетов", ЭтотОбъект, ТекущиеДанные.Контрагент);
		ОткрытьФорму("ОбщаяФорма.ВыборТипаИзСписка", ПараметрыФормы, ЭтаФорма, , , , ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьДокумент(Команда)
	
	Если Объект.НеоблагаемыеНДСОперации.Количество() > 0 Тогда 
		Если Объект.Проведен Тогда 
			ТекстВопроса = НСтр("ru = 'Перед заполнением проведение документа будет отменено, а табличные части будут очищены. Заполнить?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Табличные части будут очищены. Заполнить?'");
		КонецЕсли;
		Оповещение = Новый ОписаниеОповещения("ВопросЗаполнитьДокументЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьЗаполнениеДокумента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьНДС(Команда)
	
	РаспределитьНДСНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры


&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

&НаСервере
Процедура УстановитьФункциональныеОпцииФормы()
	
	ПравилаЗаполненияДекларацииС4кв2020 = УчетНДС.ПравилаЗаполненияДекларацииС4кв2020(Объект.Дата);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуРедактированияПодтверждающихДокументов(ВыбранноеЗначение)
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки = Объект.НеоблагаемыеНДСОперации.НайтиПоИдентификатору(ВыбранноеЗначение);
	
	Если НЕ ДанныеСтроки.КодСт149НКРФ
		ИЛИ ДанныеСтроки.КодСт149НКРФ
		И НЕ ЗначениеЗаполнено(ДанныеСтроки.Контрагент) 
		И НЕ ДанныеСтроки.РозничнаяПродажа Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ТолькоПросмотр Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("АдресТаблицыПодтверждающиеДокументы", ПоместитьПодтверждающиеДокументыВХранилище(ДанныеСтроки.КлючСтроки));
	ПараметрыФормы.Вставить("ТолькоПросмотр", ЭтаФорма.ТолькоПросмотр);
	ПараметрыФормы.Вставить("КлючСтроки", ДанныеСтроки.КлючСтроки);
	
	ОткрытьФорму("Документ.ФормированиеЗаписейРаздела7ДекларацииНДС.Форма.ФормаРедактированияПодтверждающихДокументов", ПараметрыФормы,,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаСервере
Функция ПоместитьПодтверждающиеДокументыВХранилище(КлючСтроки)
	
	СтруктураОтбора = Новый Структура("КлючСтроки", КлючСтроки);
	ТаблицаПодтверждающиеДокументы = Объект.ПодтверждающиеДокументы.Выгрузить(СтруктураОтбора);
	АдресТаблицыПодтверждающиеДокументы = ПоместитьВоВременноеХранилище(ТаблицаПодтверждающиеДокументы, УникальныйИдентификатор);
	
	Возврат АдресТаблицыПодтверждающиеДокументы;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодтверждающиеДокументыИзХранилища(КлючСтроки)
	
	ТаблицаПодтверждающиеДокументы = ПолучитьИзВременногоХранилища(АдресТаблицыПодтверждающиеДокументы);
	
	Для Каждого СтрокаТЧ Из ТаблицаПодтверждающиеДокументы Цикл
		НоваяСтрока = Объект.ПодтверждающиеДокументы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТЧ);
	КонецЦикла;
	
	КлючПоиска = Новый Структура("КлючСтроки", КлючСтроки);
	МассивСтрокНеоблагаемыеОперации = Объект.НеоблагаемыеНДСОперации.НайтиСтроки(КлючПоиска);
	Если МассивСтрокНеоблагаемыеОперации.Количество() > 0 Тогда 
		СтрокаТаблицы = МассивСтрокНеоблагаемыеОперации[0];
		Если ТаблицаПодтверждающиеДокументы.Количество() > 0 Тогда 
			ЗаполнитьПодтверждающиеДокументы(СтрокаТаблицы, ТаблицаПодтверждающиеДокументы);
		Иначе
			СтрокаТаблицы.ПодтверждающиеДокументыПредставление = "<...>";
		КонецЕсли;
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗаполнитьДокументЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ВыполнитьЗаполнениеДокумента();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗаполнениеДокумента()

	ИБФайловая = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента().ИнформационнаяБазаФайловая;
	Результат = ЗаполнитьДокументНаСервере(ИБФайловая);
	
	Если Результат.ЗаданиеВыполнено Тогда
		ОповеститьОбИзменении(Объект.Ссылка);
	Иначе
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	ОповеститьОбИзменении(Объект.Ссылка);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Функция ЗаполнитьДокументНаСервере(ИБФайловая)
	
	Если Объект.Проведен Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.ОтменаПроведения));
	КонецЕсли;
	
	Объект.НеоблагаемыеНДСОперации.Очистить();
	Объект.ПодтверждающиеДокументы.Очистить();
	
	СтруктураПараметров = Новый Структура("Организация, Дата", Объект.Организация, Объект.Дата);
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ФормированиеЗаписейРаздела7ДекларацииНДС.ПодготовитьДанныеДляЗаполнения(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
		
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Заполнение документа ""Формирование записей раздела 7 Декларации НДС""'");
		
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор, 
		"Документы.ФормированиеЗаписейРаздела7ДекларацииНДС.ПодготовитьДанныеДляЗаполнения", 
		СтруктураПараметров, 
		НаименованиеЗадания);
		
		АдресХранилища = Результат.АдресХранилища;
		
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("НеоблагаемыеНДСОперации") Тогда
		Объект.НеоблагаемыеНДСОперации.Загрузить(СтруктураДанных.НеоблагаемыеНДСОперации);
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ПодтверждающиеДокументы") Тогда
		Объект.ПодтверждающиеДокументы.Загрузить(СтруктураДанных.ПодтверждающиеДокументы);
	КонецЕсли;
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	ОбновитьИтогиВПодвале(ЭтаФорма);
	Модифицированность = Истина;
	НДСРаспределен = Истина;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьПодтверждающиеДокументы(СтрокаТабличнойЧасти, ПодтверждающиеДокументыПоСтроке)
	
	ПодтверждающиеДокументыПредставление = "";
	КоличествоПодтверждающихДокументов = ПодтверждающиеДокументыПоСтроке.Количество();
	Для Инд = 0 По КоличествоПодтверждающихДокументов - 1 Цикл
		
		ПодтверждающийДокумент = ПодтверждающиеДокументыПоСтроке[Инд];
		Если Инд = 2 Тогда
			ПодтверждающиеДокументыПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1 и еще %2'"),
				ПодтверждающиеДокументыПредставление, 
				КоличествоПодтверждающихДокументов - 2);
				
		Иначе
			ПодтверждающиеДокументыПредставление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = '%1%2%3 №%4 от %5'"),
				ПодтверждающиеДокументыПредставление, 
				?(ЗначениеЗаполнено(ПодтверждающиеДокументыПредставление), ";", ""),
				Строка(ПодтверждающийДокумент.ТипДокумента),
				ПодтверждающийДокумент.НомерДокумента,
				Формат(ПодтверждающийДокумент.ДатаДокумента,"ДЛФ=D"));
		КонецЕсли;
		
	КонецЦикла;
	
	СтрокаТабличнойЧасти.ПодтверждающиеДокументыПредставление = ПодтверждающиеДокументыПредставление;
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ТекущаяДатаДокумента          = Объект.Дата;
	
	ТаблицаОпераций = Объект.НеоблагаемыеНДСОперации.Выгрузить();
	
	УстановитьСостояниеДокумента();
	
	УстановитьФункциональныеОпцииФормы();
	
	ЗаполнитьДобавленныеКолонкиТаблиц();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеДокумента()
	
	СостояниеДокумента = ОбщегоНазначенияБП.СостояниеДокумента(Объект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьРеквизитыИзПараметровФормы(ЭтотОбъект)
	
	ПараметрыЗаполненияФормы = Неопределено;
	
	Если ЭтотОбъект.Параметры.Свойство("ПараметрыЗаполненияФормы",ПараметрыЗаполненияФормы) Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект.Объект,ПараметрыЗаполненияФормы);
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДобавленныеКолонкиТаблиц()
	
	КодыОпераций = ОбщегоНазначения.ВыгрузитьКолонку(Объект.НеоблагаемыеНДСОперации, "КодОперации", Истина);
	РеквизитыКодов = ОбщегоНазначения.ЗначенияРеквизитовОбъектов(
		КодыОпераций,
		"ОперацияНеПодлежитНалогообложению, ВключаетсяВРеестрПодтверждающихДокументов");
	КодыРеализацийНеНаТерриторииРФ = Справочники.КодыОперацийРаздела7ДекларацииПоНДС.КодыРеализацииНеНаТерриторииРФ();
	
	Для каждого СтрокаТаблицы Из Объект.НеоблагаемыеНДСОперации Цикл
		
		РеквизитыКода = РеквизитыКодов.Получить(СтрокаТаблицы.КодОперации);
		
		СтрокаТаблицы.КодСт149НКРФ      = ?(РеквизитыКода <> Неопределено, 
			РеквизитыКода.ОперацияНеПодлежитНалогообложению, Ложь);
		СтрокаТаблицы.ВключаетсяВРеестр = ?(РеквизитыКода <> Неопределено, 
			РеквизитыКода.ВключаетсяВРеестрПодтверждающихДокументов, Ложь);
		СтрокаТаблицы.РозничнаяПродажа = 
			ТипЗнч(СтрокаТаблицы.ДокументРеализации) = Тип("ДокументСсылка.ОтчетОРозничныхПродажах");
		СтрокаТаблицы.ТребуетсяЗаполнениеГраф3И4 = СтрокаТаблицы.КодСт149НКРФ
			ИЛИ ПравилаЗаполненияДекларацииС4кв2020 
			И КодыРеализацийНеНаТерриторииРФ.Найти(СтрокаТаблицы.КодОперации) = Неопределено;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	// Для кодов, которые не попадают в реестр, заполнять подтверждающие документы не требуется.
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(
		ЭлементУО.Поля, "НеоблагаемыеНДСОперацииПодтверждающиеДокументыПредставление");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.НеоблагаемыеНДСОперации.ВключаетсяВРеестр", ВидСравненияКомпоновкиДанных.Равно, Ложь);
		
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не требуются>'"));
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	// Если представление не заполнено, то отображаем ссылку "Подтверждающие документы" до отработки обработчика обновления.
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(
		ЭлементУО.Поля, "НеоблагаемыеНДСОперацииПодтверждающиеДокументыПредставление");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.НеоблагаемыеНДСОперации.ПодтверждающиеДокументыПредставление", ВидСравненияКомпоновкиДанных.НеЗаполнено);
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.НеоблагаемыеНДСОперации.ВключаетсяВРеестр", ВидСравненияКомпоновкиДанных.Равно, Истина);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Подтверждающие документы'"));
	
	// С 01.10.2020 года графы 3 и 4 заполняются по всем операциям 7 раздела декларации, кроме операций реализации не на территории РФ,
	// до 01.10.2020 года по операциям, соответствующим ст. 149 НК РФ
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "НеоблагаемыеНДСОперацииСуммаПриобретения");
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "НеоблагаемыеНДСОперацииНДС");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.НеоблагаемыеНДСОперации.ТребуетсяЗаполнениеГраф3И4", ВидСравненияКомпоновкиДанных.Равно, Ложь);
		
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ТекстЗапрещеннойЯчейкиЦвет);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<не требуется>'"));
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);
	
	// Для документов "ОтчетОРозничныхПродажах" поле "Контрагент" не заполняется.
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "НеоблагаемыеНДСОперацииКонтрагент");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.НеоблагаемыеНДСОперации.РозничнаяПродажа", ВидСравненияКомпоновкиДанных.Равно, Истина);
		
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = 'Розничная продажа'"));
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ТолькоПросмотр", Истина);

	// Для документов "Передача товаров" поле "Контрагент" не всегда заполняется.
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "НеоблагаемыеНДСОперацииКонтрагент");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.НеоблагаемыеНДСОперации.БезвозмезднаяПередача", ВидСравненияКомпоновкиДанных.Равно, Истина);
		
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь);

		
КонецПроцедуры

&НаКлиенте
Процедура НеоблагаемыеНДСОперацииПередУдалением(Элемент, Отказ)
	
	ВыделенныеСтроки = Элементы.НеоблагаемыеНДСОперации.ВыделенныеСтроки;
	
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Для каждого ИдСтроки Из ВыделенныеСтроки Цикл
		ТекДанные = Объект.НеоблагаемыеНДСОперации.НайтиПоИдентификатору(ИдСтроки);
		Если ТекДанные <> Неопределено Тогда
			// Необходимо очистить дополнительные сведения
			НоваяСтрока = ТаблицаУдаленныхКлючей.Добавить();
			НоваяСтрока.КлючСтроки = ТекДанные.КлючСтроки;
		КонецЕсли;
	КонецЦикла;
	ПодключитьОбработчикОжидания("Подключаемый_УдалитьСвязанныеЗаписи", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_УдалитьСвязанныеЗаписи()
	
	УдалитьСвязанныеЗаписиНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСвязанныеЗаписиНаСервере()
	
	Для каждого СтрокаКлюча Из ТаблицаУдаленныхКлючей Цикл
		КлючПоиска = Новый Структура("КлючСтроки", СтрокаКлюча.КлючСтроки);
		МассивСтрокТовары = Объект.ПодтверждающиеДокументы.НайтиСтроки(КлючПоиска);
		
		Для каждого СтрокаТЧ Из МассивСтрокТовары Цикл
			Объект.ПодтверждающиеДокументы.Удалить(СтрокаТЧ);
		КонецЦикла;
	КонецЦикла;
	
	ТаблицаУдаленныхКлючей.Очистить();
	
КонецПроцедуры

&НаСервере
Функция РеквизитыКодаОперации(КодОперации)
	
	РеквизитыКода = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КодОперации, "ОперацияНеПодлежитНалогообложению, ВключаетсяВРеестрПодтверждающихДокументов");
	
	// Дополним признаком необходимости заполнения граф 3 и 4 декларации.
	КодыРеализацийНеНаТерриторииРФ = Справочники.КодыОперацийРаздела7ДекларацииПоНДС.КодыРеализацииНеНаТерриторииРФ();
	ТребуетсяЗаполнениеГраф3И4 = РеквизитыКода.ОперацияНеПодлежитНалогообложению
		ИЛИ ПравилаЗаполненияДекларацииС4кв2020 И КодыРеализацийНеНаТерриторииРФ.Найти(КодОперации) = Неопределено;
	РеквизитыКода.Вставить("ТребуетсяЗаполнениеГраф3И4", ТребуетсяЗаполнениеГраф3И4);
	
	Возврат РеквизитыКода;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьИтогиВПодвале(ЭтотОбъект)
	
	Объект = ЭтотОбъект.Объект;
	
	ЭтотОбъект.ИтогиВсегоНДС = ОбщегоНазначенияБПВызовСервера.ФорматСумм(
		Объект.НеоблагаемыеНДСОперации.Итог("НДСПрямой")
		+ Объект.НеоблагаемыеНДСОперации.Итог("НДСРаспределенный"));
		
КонецПроцедуры

&НаСервере
Процедура РаспределитьНДСНаСервере()
	
	Если Объект.Проведен Тогда
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.ОтменаПроведения));
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура("Организация, Дата", Объект.Организация, Объект.Дата);
	МассивКоэффициентов = Объект.НеоблагаемыеНДСОперации.Выгрузить().ВыгрузитьКолонку("СуммаРеализации");
	УчетНДСОтчетыПереопределяемый.РаспределитьНДСПоКодамРаздела7(
		СтруктураПараметров, 
		Объект.НеоблагаемыеНДСОперации, 
		МассивКоэффициентов);
		
	ОбновитьИтогиВПодвале(ЭтаФорма);
	НДСРаспределен     = Истина;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросПриИзмененииОрганизацииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Объект.НеоблагаемыеНДСОперации.Очистить();
		Объект.ПодтверждающиеДокументы.Очистить();
	Иначе
		Объект.Организация = ТекущаяОрганизация;
	КонецЕсли;
	
	ПриИзмененииОрганизации();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииОрганизации()
	
	ТекущаяОрганизация = Объект.Организация;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы
		И (Модифицированность ИЛИ НЕ НДСРаспределен) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ НДСРаспределен Тогда
		
		Отказ = Истина;
		
		Оповещение = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'НДС не был распределен по операциям. Распределить?'");
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена,, КодВозвратаДиалога.Да);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		РаспределитьНДСНаСервере();
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		НДСРаспределен = Истина;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ТекстКоличествоСтрокДляПереноса(Текст, КоличествоСтрокДляПереноса)
	Массив = ПолучитьСклоненияСтрокиПоЧислу(Текст,КоличествоСтрокДляПереноса,,,"ПД=Винительный");
	Возврат Массив[0];
КонецФункции

&НаКлиенте
Процедура ВопросПеренестиЛишниеСтрокиТЧВДругойДокумент(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПеренестиЛишниеСтрокиТЧВДругойДокумент(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте 
Процедура ПеренестиЛишниеСтрокиТЧВДругойДокумент(ДополнительныеПараметры)
	
	Если ПеренестиЛишниеСтрокиТЧВДругойДокументНаСервере(ДополнительныеПараметры) Тогда
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Создание:'"),,
			ТекстКоличествоСтрокДляПереноса("последняя строка",ДополнительныеПараметры.КоличествоСтрокДляПереноса)+
			НСтр("ru = ' табличных частей перенесли успешно.'"),
			БиблиотекаКартинок.ВажнаяИнформация32,
			СтатусОповещенияПользователя.Информация);
	Иначе
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = ' Не удалось создать новый документ для переноса строк табличных частей.'");
		Сообщение.Сообщить();
		
	КонецЕсли;

	
КонецПроцедуры

&НаСервере
Функция ПеренестиЛишниеСтрокиТЧВДругойДокументНаСервере(ДополнительныеПараметры)
	
	РежимЗаписи = ДополнительныеПараметры.РежимЗаписи;
	
	ИндексПоследнийСтроки = Объект.НеоблагаемыеНДСОперации.Количество()-1;
	МаксимальноеКоличествоСтрок = ДополнительныеПараметры.МаксимальноеКоличествоСтрок;
	КоличествоСтрокДляПереноса = ДополнительныеПараметры.КоличествоСтрокДляПереноса;
	
	ИндексСтроки = 0;
	СтрокиДляУдаленияНеоблагаемыеНДСОперации = Новый Массив;
	СтрокиДляУдаленияПодтверждающиеДокументы = Новый Массив;
	
	НачатьТранзакцию();
	
	Попытка
		
		КоличествоСтрокТЧ = 0;
		
		Пока ИндексСтроки < КоличествоСтрокДляПереноса Цикл
			
			Если КоличествоСтрокТЧ = 0 Тогда
				НовыйДокументОбъект = Документы.ФормированиеЗаписейРаздела7ДекларацииНДС.СоздатьДокумент();
				НовыйДокументОбъект.Дата = Объект.Дата;
				НовыйДокументОбъект.Организация = Объект.Организация;
				НовыйДокументОбъект.Ответственный = Объект.Ответственный;
			КонецЕсли;
			
			СтрокаНеоблагаемыеНДСОперацииНовогоДокумента = НовыйДокументОбъект.НеоблагаемыеНДСОперации.Добавить();
			СтрокаНеоблагаемыеНДСОперацииТекущегоДокумента = Объект.НеоблагаемыеНДСОперации[ИндексПоследнийСтроки - ИндексСтроки];
			СтрокиДляУдаленияНеоблагаемыеНДСОперации.Добавить(СтрокаНеоблагаемыеНДСОперацииТекущегоДокумента);
			ЗаполнитьЗначенияСвойств(СтрокаНеоблагаемыеНДСОперацииНовогоДокумента,СтрокаНеоблагаемыеНДСОперацииТекущегоДокумента);
			
			КлючПоиска = Новый Структура("КлючСтроки", СтрокаНеоблагаемыеНДСОперацииТекущегоДокумента.КлючСтроки);
			МассивСтрокТовары = Объект.ПодтверждающиеДокументы.НайтиСтроки(КлючПоиска);
			
			Для каждого СтрокаТЧ Из МассивСтрокТовары Цикл
				СтрокаПодтверждающиеДокументыНовогоДокумента = НовыйДокументОбъект.ПодтверждающиеДокументы.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаПодтверждающиеДокументыНовогоДокумента,СтрокаТЧ);
				СтрокиДляУдаленияПодтверждающиеДокументы.Добавить(СтрокаТЧ);
			КонецЦикла;
			
			КоличествоСтрокТЧ = КоличествоСтрокТЧ + 1;
			
			ИндексСтроки = ИндексСтроки + 1;
			
			Если КоличествоСтрокТЧ = МаксимальноеКоличествоСтрок
				ИЛИ ИндексСтроки = КоличествоСтрокДляПереноса Тогда
				НовыйДокументОбъект.Записать(РежимЗаписи);
				КоличествоСтрокТЧ = 0;
			КонецЕсли;
			
		КонецЦикла;
		
		Для каждого СтрокаНеоблагаемыеНДСОперации Из СтрокиДляУдаленияНеоблагаемыеНДСОперации Цикл
			Объект.НеоблагаемыеНДСОперации.Удалить(СтрокаНеоблагаемыеНДСОперации);
		КонецЦикла;
			
		Для каждого СтрокаПодтверждающиеДокументы Из СтрокиДляУдаленияПодтверждающиеДокументы Цикл
			Объект.ПодтверждающиеДокументы.Удалить(СтрокаПодтверждающиеДокументы);
		КонецЦикла;
		
		ДокументОбъект = РеквизитФормыВЗначение("Объект");
		ДокументОбъект.Записать(РежимЗаписи);
		
	Исключение
		
		ОтменитьТранзакцию();
		Возврат Ложь;
		
	КонецПопытки;
	
	ЗафиксироватьТранзакцию();
	
	ЭтаФорма.Прочитать();
	
	Возврат Истина;

КонецФункции

&НаКлиенте
Процедура ОбработкаВыборТипаДокументаРасчетов(Результат, Контрагент) Экспорт
	
	ПараметрыФормы = ПараметрыОткрытияФормыВыбораДокументаРасчетов(Результат, Контрагент);
	
	Если ПараметрыФормы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВыбораДокументРеализации", ЭтотОбъект, );
	ОткрытьФорму(
		ПараметрыФормы.ИмяФормыВыбора, 
		ПараметрыФормы.ПараметрыОткрытия, 
		ЭтаФорма, 
		, 
		, 
		, 
		ОписаниеОповещения,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораДокументРеализации(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда 
		Элементы.НеоблагаемыеНДСОперации.ТекущиеДанные.ДокументРеализации = Результат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОткрытияФормыВыбораДокументаРасчетов(ТипЗначения, Контрагент)
	
	Если ТипЗначения = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяФормыВыбора = Метаданные.НайтиПоТипу(ТипЗначения).ПолноеИмя() + ".ФормаВыбора";
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяФормыВыбора", ИмяФормыВыбора);
	
	ДанныеОбъекта = Новый Соответствие;
	ДанныеОбъекта.Вставить("Контрагент", Контрагент);
	ДанныеОбъекта.Вставить("Организация", Объект.Организация);
	
	Отбор = Новый Структура;
	Для каждого Параметр Из СвязиПараметрыОтбора(ТипЗначения) Цикл
		Если Параметр.Ключ = "Партнер" Тогда
			Если ЗначениеЗаполнено(Контрагент)
				И ТипЗнч(Контрагент) = Тип("СправочникСсылка.Контрагенты") Тогда
					Отбор.Вставить(Параметр.Ключ, Контрагент.Партнер);
			КонецЕсли;
		ИначеЕсли ЗначениеЗаполнено(ДанныеОбъекта[Параметр.Значение]) Тогда
			Отбор.Вставить(Параметр.Ключ, ДанныеОбъекта[Параметр.Значение]);
		КонецЕсли;

	КонецЦикла;
	
	Результат.Вставить("ПараметрыОткрытия", Новый Структура("Отбор", Отбор));
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция СвязиПараметрыОтбора(ТипЗначения)
	
	СвязиПараметрыОтбора = Новый Структура;
	
	// связь по организации
	СвязиПараметрыОтбора.Вставить("Организация", "Организация");
	
	// связь по контрагенту
	Если ТипЗначения = Тип("ДокументСсылка.ПередачаТоваровМеждуОрганизациями") Тогда
		СвязиПараметрыОтбора.Вставить("ОрганизацияПолучатель", "Контрагент");
	ИначеЕсли ТипЗначения = Тип("ДокументСсылка.ВозвратТоваровМеждуОрганизациями") Тогда
		СвязиПараметрыОтбора.Вставить("ОрганизацияПолучатель", "Контрагент");
	ИначеЕсли ТипЗначения = Тип("ДокументСсылка.ОтчетКомиссионера") Тогда
		// не добавляем
	ИначеЕсли ТипЗначения = Тип("ДокументСсылка.ОтчетПоКомиссииМеждуОрганизациями") Тогда
		// не добавляем
	ИначеЕсли ТипЗначения = Тип("ДокументСсылка.НачисленияКредитовИДепозитов") Тогда
		// не добавляем
	ИначеЕсли ТипЗначения = Тип("ДокументСсылка.ОтчетОРозничныхПродажах") Тогда
		// не добавляем
	Иначе
		Если ПолучитьФункциональнуюОпцию("ИспользоватьПартнеровИКонтрагентов") Тогда
			СвязиПараметрыОтбора.Вставить("Контрагент", "Контрагент");
		Иначе
			СвязиПараметрыОтбора.Вставить("Партнер", "Партнер");
		КонецЕсли;
	КонецЕсли;
		
	Возврат СвязиПараметрыОтбора;
	
КонецФункции

#КонецОбласти


