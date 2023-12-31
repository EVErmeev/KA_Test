﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Представление = НСтр("ru = 'Регистратор расчетов'") + " " + Данные.Номер;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбновлениеИнформационнойБазы

// см. ОбновлениеИнформационнойБазыБСП.ПриДобавленииОбработчиковОбновления
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт

	Обработчик = Обработчики.Добавить();
	Обработчик.Процедура = "Документы.РегистраторРасчетов.ОбработатьДанныеДляПереходаНаНовуюВерсию";
	Обработчик.Версия = "11.5.10.5";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Идентификатор = Новый УникальныйИдентификатор("6065ea79-a0ab-453f-8ec8-5afbc6413d68");
	Обработчик.Многопоточный = Истина;
	Обработчик.ПроцедураЗаполненияДанныхОбновления = "Документы.РегистраторРасчетов.ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию";
	Обработчик.ПроцедураПроверки = "ОбновлениеИнформационнойБазы.ДанныеОбновленыНаНовуюВерсиюПрограммы";
	Обработчик.Комментарий = НСтр("ru = 'Перезаполняет реквизит ""Объект расчетов"".'");
	
	Читаемые = Новый Массив;
	Читаемые.Добавить(Метаданные.Документы.РегистраторРасчетов.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОплат.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПланОтгрузок.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСКлиентамиПоСрокам.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланОплат.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПланПоставок.ПолноеИмя());
	Читаемые.Добавить(Метаданные.РегистрыНакопления.РасчетыСПоставщикамиПоСрокам.ПолноеИмя());
	Читаемые.Добавить(Метаданные.Справочники.ОбъектыРасчетов.ПолноеИмя());
	Обработчик.ЧитаемыеОбъекты = СтрСоединить(Читаемые, ",");
	
	Изменяемые = Новый Массив;
	Изменяемые.Добавить(Метаданные.Документы.РегистраторРасчетов.ПолноеИмя());
	Обработчик.ИзменяемыеОбъекты = СтрСоединить(Изменяемые, ",");
	
	Блокируемые = Новый Массив;
	Блокируемые.Добавить(Метаданные.Документы.РегистраторРасчетов.ПолноеИмя());
	Обработчик.БлокируемыеОбъекты = СтрСоединить(Блокируемые, ",");
	
	Обработчик.ПриоритетыВыполнения = ОбновлениеИнформационнойБазы.ПриоритетыВыполненияОбработчика();

КонецПроцедуры

// Параметры:
// 	Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПараметрыВыборки = Параметры.ПараметрыВыборки;
	ПараметрыВыборки.ПолныеИменаОбъектов = СоздатьДокумент().Метаданные().ПолноеИмя();
	ПараметрыВыборки.ПоляУпорядочиванияПриРаботеПользователей.Добавить("Дата УБЫВ");
	ПараметрыВыборки.ПоляУпорядочиванияПриОбработкеДанных.Добавить("Дата УБЫВ");
	ПараметрыВыборки.СпособВыборки = ОбновлениеИнформационнойБазы.СпособВыборкиСсылки();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РегистраторРасчетов.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РегистраторРасчетов КАК РегистраторРасчетов
	|ГДЕ 
	|	НЕ РегистраторРасчетов.УдалитьОбъектРасчетов В (&ПустыеЗначенияОбъектовРасчетов)
	|	И ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрНакопления.РасчетыСКлиентамиПоСрокам КАК ДанныеРегистра
	|		ГДЕ
	|			ДанныеРегистра.Регистратор = РегистраторРасчетов.Ссылка
	|			И ДанныеРегистра.ОбъектРасчетов <> РегистраторРасчетов.ОбъектРасчетов
	|			И ДанныеРегистра.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)
	|			И РегистраторРасчетов.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РегистраторРасчетов.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РегистраторРасчетов КАК РегистраторРасчетов
	|ГДЕ
	|	НЕ РегистраторРасчетов.УдалитьОбъектРасчетов В (&ПустыеЗначенияОбъектовРасчетов)
	|	И ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрНакопления.РасчетыСПоставщикамиПоСрокам КАК ДанныеРегистра
	|		ГДЕ
	|			ДанныеРегистра.Регистратор = РегистраторРасчетов.Ссылка
	|			И ДанныеРегистра.ОбъектРасчетов <> РегистраторРасчетов.ОбъектРасчетов
	|			И ДанныеРегистра.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)
	|			И РегистраторРасчетов.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РегистраторРасчетов.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РегистраторРасчетов КАК РегистраторРасчетов
	|ГДЕ
	|	НЕ РегистраторРасчетов.УдалитьОбъектРасчетов В (&ПустыеЗначенияОбъектовРасчетов)
	|	И ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрНакопления.РасчетыСКлиентамиПланОплат КАК ДанныеРегистра
	|		ГДЕ
	|			ДанныеРегистра.Регистратор = РегистраторРасчетов.Ссылка
	|			И ДанныеРегистра.ОбъектРасчетов <> РегистраторРасчетов.ОбъектРасчетов
	|			И ДанныеРегистра.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)
	|			И РегистраторРасчетов.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РегистраторРасчетов.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РегистраторРасчетов КАК РегистраторРасчетов
	|ГДЕ
	|	НЕ РегистраторРасчетов.УдалитьОбъектРасчетов В (&ПустыеЗначенияОбъектовРасчетов)
	|	И ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрНакопления.РасчетыСПоставщикамиПланОплат КАК ДанныеРегистра
	|		ГДЕ
	|			ДанныеРегистра.Регистратор = РегистраторРасчетов.Ссылка
	|			И ДанныеРегистра.ОбъектРасчетов <> РегистраторРасчетов.ОбъектРасчетов
	|			И ДанныеРегистра.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)
	|			И РегистраторРасчетов.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РегистраторРасчетов.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РегистраторРасчетов КАК РегистраторРасчетов
	|ГДЕ
	|	НЕ РегистраторРасчетов.УдалитьОбъектРасчетов В (&ПустыеЗначенияОбъектовРасчетов)
	|	И ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрНакопления.РасчетыСКлиентамиПланОтгрузок КАК ДанныеРегистра
	|		ГДЕ
	|			ДанныеРегистра.Регистратор = РегистраторРасчетов.Ссылка
	|			И ДанныеРегистра.ОбъектРасчетов <> РегистраторРасчетов.ОбъектРасчетов
	|			И ДанныеРегистра.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)
	|			И РегистраторРасчетов.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	РегистраторРасчетов.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.РегистраторРасчетов КАК РегистраторРасчетов
	|ГДЕ
	|	НЕ РегистраторРасчетов.УдалитьОбъектРасчетов В (&ПустыеЗначенияОбъектовРасчетов)
	|	И ИСТИНА В
	|		(ВЫБРАТЬ ПЕРВЫЕ 1
	|			ИСТИНА
	|		ИЗ
	|			РегистрНакопления.РасчетыСПоставщикамиПланПоставок КАК ДанныеРегистра
	|		ГДЕ
	|			ДанныеРегистра.Регистратор = РегистраторРасчетов.Ссылка
	|			И ДанныеРегистра.ОбъектРасчетов <> РегистраторРасчетов.ОбъектРасчетов
	|			И ДанныеРегистра.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)
	|			И РегистраторРасчетов.ОбъектРасчетов <> ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка))
	|";
	
	Запрос.УстановитьПараметр("ПустыеЗначенияОбъектовРасчетов", ОбъектыРасчетовСервер.ПустыеЗначенияОбъектРасчетов());
	ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
КонецПроцедуры

Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПолноеИмяОбъекта = ПустаяСсылка().Метаданные().ПолноеИмя();
	ОбновляемыеДанные = ОбновлениеИнформационнойБазы.ДанныеДляОбновленияВМногопоточномОбработчике(Параметры);
	
	Если ОбновляемыеДанные.Количество() = 0 Тогда
		Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст ="ВЫБРАТЬ
		|	ОбрабатываемыеДанные.Ссылка КАК Ссылка
		|ПОМЕСТИТЬ ВТОбрабатываемыеДанные
		|ИЗ
		|	&ОбновляемыеДанные КАК ОбрабатываемыеДанные
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ДанныеДокумента.Ссылка КАК Ссылка,
		|	ДанныеДокумента.ВерсияДанных КАК ВерсияДанных,
		|	
		|	КлючиАналитикиУчетаПоПартнерам.Контрагент <> ОбъектыРасчетовТекущий.Контрагент
		|		ИЛИ КлючиАналитикиУчетаПоПартнерам.Договор <> ОбъектыРасчетовТекущий.Договор
		|
		|		ИЛИ (ВЫБОР
		|				КОГДА ТИПЗНАЧЕНИЯ(ДанныеДокумента.УдалитьОбъектРасчетов) = ТИП(Справочник.ДоговорыКонтрагентов)
		|						И ДоговорыКонтрагентов.РазрешенаРаботаСДочернимиПартнерами
		|					ТОГДА ДоговорыКонтрагентов.Партнер
		|				ИНАЧЕ КлючиАналитикиУчетаПоПартнерам.Партнер
		|			КОНЕЦ <> ОбъектыРасчетовТекущий.Партнер) 
		|
		|		ИЛИ ДанныеДокумента.Валюта <> ОбъектыРасчетовТекущий.ВалютаВзаиморасчетов 
		|		ИЛИ ОбъектыРасчетовТекущий.Ссылка ЕСТЬ NULL КАК ТребуетсяПерезаполнение,
		|	ЕСТЬNULL(ОбъектыРасчетов.Ссылка, ЗНАЧЕНИЕ(Справочник.ОбъектыРасчетов.ПустаяСсылка)) КАК ОбъектРасчетов
		|ИЗ
		|	Документ.РегистраторРасчетов КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаПоПартнерам КАК КлючиАналитикиУчетаПоПартнерам
		|			ПО ДанныеДокумента.АналитикаУчетаПоПартнерам = КлючиАналитикиУчетаПоПартнерам.Ссылка
		|	
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|			ПО КлючиАналитикиУчетаПоПартнерам.Договор = ДоговорыКонтрагентов.Ссылка
		|
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыРасчетов КАК ОбъектыРасчетов
		|			ПО ОбъектыРасчетов.Объект = ДанныеДокумента.УдалитьОбъектРасчетов
		|				И ОбъектыРасчетов.ТипРасчетов = ДанныеДокумента.ТипРасчетов
		|				И (ОбъектыРасчетов.Организация = ДанныеДокумента.Организация
		|					ИЛИ ОбъектыРасчетов.Организация = КлючиАналитикиУчетаПоПартнерам.Организация)
		|
		|				И (ВЫБОР
		|						КОГДА ТИПЗНАЧЕНИЯ(ДанныеДокумента.УдалитьОбъектРасчетов) = ТИП(Справочник.ДоговорыКонтрагентов)
		|								И ДоговорыКонтрагентов.РазрешенаРаботаСДочернимиПартнерами
		|							ТОГДА ДоговорыКонтрагентов.Партнер
		|						ИНАЧЕ КлючиАналитикиУчетаПоПартнерам.Партнер
		|					КОНЕЦ = ОбъектыРасчетов.Партнер)
		|
		|				И ОбъектыРасчетов.Контрагент = КлючиАналитикиУчетаПоПартнерам.Контрагент
		|				И ОбъектыРасчетов.Договор = КлючиАналитикиУчетаПоПартнерам.Договор
		|				И ОбъектыРасчетов.ВалютаВзаиморасчетов = ДанныеДокумента.Валюта
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОбъектыРасчетов КАК ОбъектыРасчетовТекущий
		|			ПО ДанныеДокумента.ОбъектРасчетов = ОбъектыРасчетовТекущий.Ссылка
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТОбрабатываемыеДанные КАК ОбрабатываемыеДанные
		|			ПО ДанныеДокумента.Ссылка = ОбрабатываемыеДанные.Ссылка
		|ГДЕ
		|	НЕ ДанныеДокумента.УдалитьОбъектРасчетов В (&ПустыеЗначенияОбъектовРасчетов)";
	
	Запрос.УстановитьПараметр("ПустыеЗначенияОбъектовРасчетов", ОбъектыРасчетовСервер.ПустыеЗначенияОбъектРасчетов());
	Запрос.УстановитьПараметр("ОбновляемыеДанные", ОбновляемыеДанные);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДокумент = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДокумент.Следующий() Цикл
		
		НачатьТранзакцию();
		
		Попытка
			Ссылка = ВыборкаДокумент.Ссылка;
			Блокировка = Новый БлокировкаДанных;
			ЭлементБлокировки = Блокировка.Добавить(ПолноеИмяОбъекта);
			ЭлементБлокировки.УстановитьЗначение("Ссылка", Ссылка);
			Блокировка.Заблокировать();
			
			ДокументОбъект = ОбновлениеИнформационнойБазыУТ.ПроверитьПолучитьОбъект(
				Ссылка,
				ВыборкаДокумент.ВерсияДанных,
				Параметры.Очередь);
				
			Если ДокументОбъект = Неопределено Тогда
				ЗафиксироватьТранзакцию();
				Продолжить;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(ВыборкаДокумент.ОбъектРасчетов) 
				И (НЕ ЗначениеЗаполнено(ДокументОбъект.ОбъектРасчетов)
						ИЛИ ВыборкаДокумент.ТребуетсяПерезаполнение) Тогда
				ДокументОбъект.ОбъектРасчетов = ВыборкаДокумент.ОбъектРасчетов;
			ИначеЕсли Не ЗначениеЗаполнено(ВыборкаДокумент.ОбъектРасчетов) 
				И (НЕ ЗначениеЗаполнено(ДокументОбъект.ОбъектРасчетов)
						ИЛИ ВыборкаДокумент.ТребуетсяПерезаполнение) Тогда
					//Заполняем объект расчетов из расчетных регистров
					ОРИзРасчетныхРегитсров = ОбъектыРасчетовИзРасчетныхРегитсров(ДокументОбъект);
					Если ОРИзРасчетныхРегитсров.Количество() > 1 Тогда
						ВызватьИсключение (СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не удалось заполнить поле ""Объект расчетов"" в документе: %1. 
									|Обнаружены расхождения в объектах расчетов в движениях этого документа.'"),
						Ссылка));
					ИначеЕсли ОРИзРасчетныхРегитсров.Количество() = 1 Тогда
						ОРИзРасчетныхРегитсров.Следующий();
						ОбъектРасчетов = Неопределено;
						Если ЗначениеЗаполнено(ОРИзРасчетныхРегитсров.ПоСрокамОР) Тогда 
							ОбъектРасчетов = ОРИзРасчетныхРегитсров.ПоСрокамОР
						КонецЕсли;
						
						Если ЗначениеЗаполнено(ОРИзРасчетныхРегитсров.ПланОплатОР)
							И ЗначениеЗаполнено(ОбъектРасчетов) 
							И ОРИзРасчетныхРегитсров.ПланОплатОР <> ОбъектРасчетов Тогда 
								ВызватьИсключение (СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru = 'Не удалось заполнить поле ""Объект расчетов"" в документе: %1. 
												|Обнаружены расхождения в объектах расчетов в движениях этого документа.'"),
									Ссылка));
						ИначеЕсли Не ЗначениеЗаполнено(ОбъектРасчетов)
									И ЗначениеЗаполнено(ОРИзРасчетныхРегитсров.ПланОплатОР) Тогда 
							ОбъектРасчетов = ОРИзРасчетныхРегитсров.ПланОплатОР;
						КонецЕсли;
						
						Если ЗначениеЗаполнено(ОРИзРасчетныхРегитсров.ОтугрзкиПоставкиОР)
							И ЗначениеЗаполнено(ОбъектРасчетов) 
							И ОРИзРасчетныхРегитсров.ОтугрзкиПоставкиОР <> ОбъектРасчетов Тогда 
								ВызватьИсключение (СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
									НСтр("ru = 'Не удалось заполнить поле ""Объект расчетов"" в документе: %1. 
												|Обнаружены расхождения в объектах расчетов в движениях этого документа.'"),
									Ссылка));
						ИначеЕсли ЗначениеЗаполнено(ОРИзРасчетныхРегитсров.ОтугрзкиПоставкиОР)
							И ЗначениеЗаполнено(ОбъектРасчетов) Тогда 
							ОбъектРасчетов = ОРИзРасчетныхРегитсров.ОтугрзкиПоставкиОР;
						КонецЕсли;
						
						Если ЗначениеЗаполнено(ОбъектРасчетов) Тогда
							ДокументОбъект.ОбъектРасчетов = ОбъектРасчетов;
						ИначеЕсли ЗначениеЗаполнено(ДокументОбъект.УдалитьОбъектРасчетов)
									И (ЗначениеЗаполнено(ОРИзРасчетныхРегитсров.ОтугрзкиПоставкиОР)
									Или ЗначениеЗаполнено(ОРИзРасчетныхРегитсров.ПланОплатОР)
									Или ЗначениеЗаполнено(ОРИзРасчетныхРегитсров.ПоСрокамОР)) Тогда
									ВызватьИсключение (СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										НСтр("ru = 'Не удалось заполнить поле ""Объект расчетов"" в документе: %1'"),
										Ссылка));
						КонецЕсли;
					Иначе
						ВызватьИсключение (СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Не удалось заполнить поле ""Объект расчетов"" в документе: %1'"),
						Ссылка));
					КонецЕсли;
			КонецЕсли;
			
			Если ДокументОбъект.Модифицированность() Тогда
				ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
			Иначе
				ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Ссылка);
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			ОбновлениеИнформационнойБазыУТ.СообщитьОНеудачнойОбработке(ИнформацияОбОшибке(), ВыборкаДокумент.Ссылка);
			
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, ПолноеИмяОбъекта);

КонецПроцедуры

Функция ОбъектыРасчетовИзРасчетныхРегитсров(РегистраторРасчетов)
	
	Запрос = Новый Запрос();
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 2 РАЗЛИЧНЫЕ
		|	РасчетыПоСрокам.ОбъектРасчетов КАК ПоСрокамОР,
		|	РасчетыПланОплат.ОбъектРасчетов КАК ПланОплатОР,
		|	РасчетыОтугрзкиПоставки.ОбъектРасчетов КАК ОтугрзкиПоставкиОР
		|ИЗ
		|	Документ.РегистраторРасчетов КАК ДанныеДокумента
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТабРасчетыПоСрокам КАК РасчетыПоСрокам
		|		ПО ДанныеДокумента.АналитикаУчетаПоПартнерам = РасчетыПоСрокам.АналитикаУчетаПоПартнерам
		|			И ДанныеДокумента.Ссылка = РасчетыПоСрокам.Регистратор
		|			И ДанныеДокумента.Валюта = РасчетыПоСрокам.Валюта
		|			И ДанныеДокумента.УдалитьОбъектРасчетов = РасчетыПоСрокам.УдалитьОбъектРасчетов
		|			И НЕ ДанныеДокумента.УдалитьОбъектРасчетов В (&ПустыеЗначенияОбъектовРасчетов)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТабРасчетыПланОплат КАК РасчетыПланОплат
		|		ПО ДанныеДокумента.АналитикаУчетаПоПартнерам = РасчетыПланОплат.АналитикаУчетаПоПартнерам
		|			И ДанныеДокумента.Ссылка = РасчетыПланОплат.Регистратор
		|			И ДанныеДокумента.Валюта = РасчетыПланОплат.Валюта
		|			И ДанныеДокумента.УдалитьОбъектРасчетов = РасчетыПланОплат.УдалитьОбъектРасчетов
		|			И НЕ ДанныеДокумента.УдалитьОбъектРасчетов В (&ПустыеЗначенияОбъектовРасчетов)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТабРасчетыОтугрзкиПоставки КАК РасчетыОтугрзкиПоставки
		|		ПО ДанныеДокумента.АналитикаУчетаПоПартнерам = РасчетыОтугрзкиПоставки.АналитикаУчетаПоПартнерам
		|			И ДанныеДокумента.Ссылка = РасчетыОтугрзкиПоставки.Регистратор
		|			И ДанныеДокумента.Валюта = РасчетыОтугрзкиПоставки.Валюта
		|			И ДанныеДокумента.УдалитьОбъектРасчетов = РасчетыОтугрзкиПоставки.УдалитьОбъектРасчетов
		|			И НЕ ДанныеДокумента.УдалитьОбъектРасчетов В (&ПустыеЗначенияОбъектовРасчетов)
		|ГДЕ
		|	ДанныеДокумента.Ссылка = &Ссылка";
	Если РегистраторРасчетов.ТипРасчетов = Перечисления.ТипыРасчетовСПартнерами.РасчетыСКлиентом Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ТабРасчетыПоСрокам", 			"РегистрНакопления.РасчетыСКлиентамиПоСрокам");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ТабРасчетыПланОплат", 		"РегистрНакопления.РасчетыСКлиентамиПланОплат");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ТабРасчетыОтугрзкиПоставки", 	"РегистрНакопления.РасчетыСКлиентамиПланОтгрузок");
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ТабРасчетыПоСрокам", 			"РегистрНакопления.РасчетыСПоставщикамиПоСрокам");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ТабРасчетыПланОплат", 		"РегистрНакопления.РасчетыСПоставщикамиПланОплат");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ТабРасчетыОтугрзкиПоставки", 	"РегистрНакопления.РасчетыСПоставщикамиПланПоставок");
	КонецЕсли;
	Запрос.УстановитьПараметр("Ссылка", РегистраторРасчетов.Ссылка);
	Запрос.УстановитьПараметр("ПустыеЗначенияОбъектовРасчетов", ОбъектыРасчетовСервер.ПустыеЗначенияОбъектРасчетов());
	Возврат Запрос.Выполнить().Выбрать();
	
КонецФункции

#КонецОбласти

#КонецОбласти


#КонецЕсли
