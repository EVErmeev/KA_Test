﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - см. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   ЭтаФорма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
Процедура ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = ЭтаФорма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды")
			И Параметры.Свойство("ОписаниеКоманды")
			И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда 
			
		СтруктураОтборов = Новый Структура("Регистратор", Параметры.ПараметрКоманды);
		ЭтаФорма.ФормаПараметры.Отбор = СтруктураОтборов;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗагрузкеВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;
	
	// Изменение настроек по функциональным опциям.
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);
	
	НовыеНастройкиКД = КомпоновщикНастроекФормы.Настройки;
	
КонецПроцедуры

Процедура ПередЗагрузкойНастроекВКомпоновщик(Контекст, КлючСхемы, КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД) Экспорт
	
	Если ТипЗнч(Контекст) = Тип("ФормаКлиентскогоПриложения") Тогда
		НастроитьПараметрыОтчетаПоВариантуОтчета(КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД);
		ОтчетыСервер.ПодключитьСхему(ЭтотОбъект, Контекст, СхемаКомпоновкиДанных, КлючСхемы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МенеджерВТ = Новый МенеджерВременныхТаблиц;
	
	ДоступныеПоляОтбора = Новый Массив;
	ДоступныеПоляУсловий = Новый Массив;
	
	СхемаРазузлования = Отчеты.ДеревоСебестоимостиПродукции.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	НастройкиРазузлования = СхемаРазузлования.НастройкиПоУмолчанию;
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	НаборДанныхРазузловки = СхемаРазузлования.НаборыДанных.Найти("ВыпущеннаяПродукция");
	Если НаборДанныхРазузловки = Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Изменилась схема разузлования продукции. Разузлование невозможно.'"));
		Возврат;
		
	КонецЕсли;	
	
	ПараметрПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Период"));
	Период = ПараметрПериод.Значение; // СтандартныйПериод
	НачалоПериода = ?(ПараметрПериод.Использование, Период.ДатаНачала, НачалоГода(ТекущаяДатаСеанса()));
	КонецПериода = ?(ПараметрПериод.Использование, Период.ДатаОкончания, ТекущаяДатаСеанса());
	
	ДанныеПоСебестоимости = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДанныеПоСебестоимости")).Значение;
	КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиРазузлования, "ДанныеПоСебестоимости", ДанныеПоСебестоимости);
	
	Если ПараметрПериод.Использование Тогда
		КомпоновкаДанныхКлиентСервер.УстановитьПараметр(НастройкиРазузлования, "Период", Период);
	КонецЕсли;
	
	Для Каждого ДоступноеПолеОтбора Из НастройкиОтчета.Отбор.ДоступныеПоляОтбора.Элементы Цикл
		ДоступныеПоляОтбора.Добавить(ДоступноеПолеОтбора.Поле);
	КонецЦикла;
	
	Для Каждого ПолеДанных Из НаборДанныхРазузловки.Поля Цикл
		
		Если ПолеДанных.ОграничениеИспользования.Условие Тогда
			Продолжить;
		КонецЕсли;
		
		ДоступныеПоляУсловий.Добавить(Новый ПолеКомпоновкиДанных(ПолеДанных.Поле));
		
	КонецЦикла;
	
	Накладные = Неопределено;
	Для Каждого ЭлементОтбора Из НастройкиОтчета.Отбор.Элементы Цикл
		
		Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Регистратор") Тогда
			Накладные = ЭлементОтбора.ПравоеЗначение;
		КонецЕсли;
		
		Если ДоступныеПоляОтбора.Найти(ЭлементОтбора.ЛевоеЗначение) = Неопределено Тогда
			НастройкиОтчета.Отбор.Элементы.Удалить(ЭлементОтбора);
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не Накладные = Неопределено Тогда
		
		ПараметрРегистратор = СхемаРазузлования.Параметры.Найти("Регистраторы");
		Если Не ПараметрРегистратор = Неопределено Тогда
			ПараметрРегистратор.Значение = Накладные;
		КонецЕсли;
				
	КонецЕсли;
		
	НастройкиРазузлования.Отбор.Элементы.Очистить();
	ЗаполнитьНастройкиОтчетаРекурсивно(НастройкиРазузлования.Отбор, НастройкиОтчета.Отбор, ДоступныеПоляУсловий);
	
	ПараметрыДереваСебестоимости = СтруктураСебестоимости.ПараметрыДереваСебестоимости();
	ПараметрыДереваСебестоимости.ДинамическоеСчитывание = Ложь;
	ПараметрыДереваСебестоимости.ТипРезультата = "МенеджерВременныхТаблиц";
	ПараметрыДереваСебестоимости.Результат = МенеджерВТ;
	
	ПараметрыУзлаДереваСебестоимости = СтруктураСебестоимости.ПараметрыУзлаДереваСебестоимости();
	ПараметрыУзлаДереваСебестоимости.ИнтерактивнаяНастройка = Истина;
	ПараметрыУзлаДереваСебестоимости.СхемаКД = СхемаРазузлования;
	ПараметрыУзлаДереваСебестоимости.НастройкиКД = НастройкиРазузлования;
	ПараметрыУзлаДереваСебестоимости.Отборы.ДанныеПоСебестоимости = ДанныеПоСебестоимости;
	ПараметрыУзлаДереваСебестоимости.Отборы.РазворачиватьДопРасходы = Ложь;
	ПараметрыУзлаДереваСебестоимости.Отборы.ДатаОкончания = КонецПериода;
	
	СтруктураСебестоимости.ПостроитьДеревоСебестоимости(ПараметрыДереваСебестоимости, ПараметрыУзлаДереваСебестоимости);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВТ;
	
	Запрос.УстановитьПараметр("Накладные", Накладные);
	Запрос.УстановитьПараметр("ДанныеПоСебестоимости", ДанныеПоСебестоимости);
	Запрос.УстановитьПараметр("ВалютаУправленческогоУчета", Константы.ВалютаУправленческогоУчета.Получить());
	Запрос.УстановитьПараметр("ДатаОкончания", КонецПериода);
	
#Область ТекстЗапроса
	Запрос.Текст =
		"ВЫБРАТЬ
		|	АналитикаУчетаНоменклатуры.Номенклатура КАК Продукция,
		|	АналитикаУчетаНоменклатуры.Характеристика КАК ХарактеристикаПродукции,
		|	АналитикаУчетаНоменклатуры.Назначение КАК Назначение,
		|	Результат.ПартияПродукции КАК ПартияПродукции,
		|	Результат.ПартияЗатрата КАК ПартияПолуфабриката,
		|	Результат.Номенклатура КАК Полуфабрикат,
		|	Результат.Характеристика КАК ХарактеристикаПолуфабриката,
		|	ВЫБОР
		|		КОГДА Результат.ВидСтроки = ЗНАЧЕНИЕ(Перечисление.ВидыСтрокДереваСебестоимости.ПартияПродукции)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЭтоПродукция,
		|	СУММА(Результат.Количество) КАК Количество,
		|	Результат.АналитикаУчетаПродукции КАК АналитикаУчетаПродукции,
		|	Результат.Организация КАК Организация,
		|	Результат.Организация.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
		|	АналитикаУчетаНоменклатуры.Серия КАК Серия,
		|	СУММА(ВЫБОР
		|			КОГДА Результат.ТребуетсяРазузлование
		|				ТОГДА 0
		|			ИНАЧЕ Результат.Сумма
		|		КОНЕЦ) КАК Сумма,
		|	СУММА(ВЫБОР
		|			КОГДА Результат.ТребуетсяРазузлование
		|				ТОГДА 0
		|			ИНАЧЕ Результат.Материальные + Результат.ДопРасходы
		|		КОНЕЦ) КАК Материальные,
		|	СУММА(ВЫБОР
		|			КОГДА Результат.ТребуетсяРазузлование
		|				ТОГДА 0
		|			ИНАЧЕ Результат.Трудозатраты
		|		КОНЕЦ) КАК Трудозатраты,
		|	СУММА(ВЫБОР
		|			КОГДА Результат.ТребуетсяРазузлование
		|				ТОГДА 0
		|			ИНАЧЕ Результат.ПостатейныеПостоянные
		|		КОНЕЦ) КАК ПостатейныеПостоянные,
		|	СУММА(ВЫБОР
		|			КОГДА Результат.ТребуетсяРазузлование
		|				ТОГДА 0
		|			ИНАЧЕ Результат.ПостатейныеПеременные
		|		КОНЕЦ) КАК ПостатейныеПеременные,
		|	СУММА(ВЫБОР
		|			КОГДА Результат.ТребуетсяРазузлование
		|				ТОГДА 0
		|			ИНАЧЕ Результат.СуммаЗабалансовая
		|		КОНЕЦ) КАК Забалансовая
		|ПОМЕСТИТЬ КоличествоВыпуска
		|ИЗ
		|	Результат КАК Результат
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК АналитикаУчетаНоменклатуры
		|		ПО Результат.АналитикаУчетаПродукции = АналитикаУчетаНоменклатуры.Ссылка
		|ГДЕ
		|	(Результат.ТребуетсяРазузлование
		|			ИЛИ Результат.ВидСтроки В (ЗНАЧЕНИЕ(Перечисление.ВидыСтрокДереваСебестоимости.ПартияПродукции), ЗНАЧЕНИЕ(Перечисление.ВидыСтрокДереваСебестоимости.ПартияПолуфабриката)))
		|
		|СГРУППИРОВАТЬ ПО
		|	Результат.Номенклатура,
		|	Результат.Характеристика,
		|	АналитикаУчетаНоменклатуры.Номенклатура,
		|	АналитикаУчетаНоменклатуры.Характеристика,
		|	ВЫБОР
		|		КОГДА Результат.ВидСтроки = ЗНАЧЕНИЕ(Перечисление.ВидыСтрокДереваСебестоимости.ПартияПродукции)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ,
		|	Результат.АналитикаУчетаПродукции,
		|	АналитикаУчетаНоменклатуры.Назначение,
		|	Результат.ПартияЗатрата,
		|	Результат.ПартияПродукции,
		|	Результат.Организация,
		|	Результат.Организация.ВалютаРегламентированногоУчета,
		|	АналитикаУчетаНоменклатуры.Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КоличествоВыпуска.Продукция КАК Продукция,
		|	КоличествоВыпуска.ХарактеристикаПродукции КАК ХарактеристикаПродукции,
		|	КоличествоВыпуска.Назначение КАК Назначение,
		|	КоличествоВыпуска.ПартияПродукции КАК ПартияПродукции,
		|	СУММА(КоличествоВыпуска.Количество) КАК Количество,
		|	КоличествоВыпуска.АналитикаУчетаПродукции КАК АналитикаУчетаПродукции,
		|	КоличествоВыпуска.Организация КАК Организация,
		|	КоличествоВыпуска.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
		|	КоличествоВыпуска.Серия КАК Серия,
		|	СУММА(КоличествоВыпуска.Сумма) КАК Сумма,
		|	СУММА(КоличествоВыпуска.Материальные) КАК Материальные,
		|	СУММА(КоличествоВыпуска.Трудозатраты) КАК Трудозатраты,
		|	СУММА(КоличествоВыпуска.ПостатейныеПостоянные) КАК ПостатейныеПостоянные,
		|	СУММА(КоличествоВыпуска.ПостатейныеПеременные) КАК ПостатейныеПеременные,
		|	СУММА(КоличествоВыпуска.Забалансовая) КАК Забалансовая
		|ПОМЕСТИТЬ ВТПродукция
		|ИЗ
		|	КоличествоВыпуска КАК КоличествоВыпуска
		|ГДЕ
		|	КоличествоВыпуска.ЭтоПродукция
		|
		|СГРУППИРОВАТЬ ПО
		|	КоличествоВыпуска.Продукция,
		|	КоличествоВыпуска.АналитикаУчетаПродукции,
		|	КоличествоВыпуска.Назначение,
		|	КоличествоВыпуска.ПартияПродукции,
		|	КоличествоВыпуска.ХарактеристикаПродукции,
		|	КоличествоВыпуска.Организация,
		|	КоличествоВыпуска.ВалютаРегламентированногоУчета,
		|	КоличествоВыпуска.Серия
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапрос.АналитикаУчетаВыходноеИзделие КАК АналитикаУчетаВыходноеИзделие,
		|	ВложенныйЗапрос.Количество КАК Количество,
		|	ВложенныйЗапрос.Сумма КАК Сумма,
		|	ВложенныйЗапрос.Материальные КАК Материальные,
		|	ВложенныйЗапрос.Трудозатраты КАК Трудозатраты,
		|	ВложенныйЗапрос.ПостатейныеПостоянные КАК ПостатейныеПостоянные,
		|	ВложенныйЗапрос.ПостатейныеПеременные КАК ПостатейныеПеременные,
		|	ВложенныйЗапрос.Забалансовая КАК Забалансовая,
		|	ВложенныйЗапрос.Затрата КАК Затрата,
		|	ВложенныйЗапрос.ХарактеристикаЗатраты КАК ХарактеристикаЗатраты,
		|	ВложенныйЗапрос.Полуфабрикат КАК Полуфабрикат,
		|	ВложенныйЗапрос.ХарактеристикаПолуфабриката КАК ХарактеристикаПолуфабриката,
		|	ВложенныйЗапрос.АналитикаУчетаПродукции КАК АналитикаУчетаПродукции,
		|	ВложенныйЗапрос.ВидСтроки КАК ВидСтроки,
		|	ВложенныйЗапрос.ПартияПолуфабриката КАК ПартияПолуфабриката,
		|	ВложенныйЗапрос.ПартияПродукции КАК ПартияПродукции,
		|	ВложенныйЗапрос.ЭтоПолуфабрикат КАК ЭтоПолуфабрикат,
		|	ВложенныйЗапрос.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ВложенныйЗапрос.Организация КАК Организация,
		|	ВложенныйЗапрос.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
		|	ВложенныйЗапрос.Подразделение КАК Подразделение,
		|	ВложенныйЗапрос.СтатьяКалькуляции КАК СтатьяКалькуляции,
		|	ВложенныйЗапрос.ПартияЗатрата КАК ПартияЗатрата
		|ПОМЕСТИТЬ Затраты
		|ИЗ
		|	(ВЫБРАТЬ
		|		Результат.АналитикаУчетаВыходноеИзделие КАК АналитикаУчетаВыходноеИзделие,
		|		СУММА(Результат.Количество) КАК Количество,
		|		СУММА(ВЫБОР
		|				КОГДА Результат.ТребуетсяРазузлование
		|					ТОГДА 0
		|				ИНАЧЕ Результат.Сумма
		|			КОНЕЦ) КАК Сумма,
		|		СУММА(ВЫБОР
		|				КОГДА Результат.ТребуетсяРазузлование
		|					ТОГДА 0
		|				ИНАЧЕ Результат.Материальные + Результат.ДопРасходы
		|			КОНЕЦ) КАК Материальные,
		|		СУММА(ВЫБОР
		|				КОГДА Результат.ТребуетсяРазузлование
		|					ТОГДА 0
		|				ИНАЧЕ Результат.Трудозатраты
		|			КОНЕЦ) КАК Трудозатраты,
		|		СУММА(ВЫБОР
		|				КОГДА Результат.ТребуетсяРазузлование
		|					ТОГДА 0
		|				ИНАЧЕ Результат.ПостатейныеПостоянные
		|			КОНЕЦ) КАК ПостатейныеПостоянные,
		|		СУММА(ВЫБОР
		|				КОГДА Результат.ТребуетсяРазузлование
		|					ТОГДА 0
		|				ИНАЧЕ Результат.ПостатейныеПеременные
		|			КОНЕЦ) КАК ПостатейныеПеременные,
		|		СУММА(ВЫБОР
		|				КОГДА Результат.ТребуетсяРазузлование
		|					ТОГДА 0
		|				ИНАЧЕ Результат.СуммаЗабалансовая
		|			КОНЕЦ) КАК Забалансовая,
		|		Результат.Номенклатура КАК Затрата,
		|		Результат.Характеристика КАК ХарактеристикаЗатраты,
		|		АналитикаУчетаПолуфабриката.Номенклатура КАК Полуфабрикат,
		|		АналитикаУчетаПолуфабриката.Характеристика КАК ХарактеристикаПолуфабриката,
		|		Результат.АналитикаУчетаПродукции КАК АналитикаУчетаПродукции,
		|		Результат.ВидСтроки КАК ВидСтроки,
		|		Результат.ПартияВыходноеИзделие КАК ПартияПолуфабриката,
		|		Результат.ПартияПродукции КАК ПартияПродукции,
		|		Результат.ТребуетсяРазузлование КАК ЭтоПолуфабрикат,
		|		ВЫБОР
		|			КОГДА ТИПЗНАЧЕНИЯ(Результат.Номенклатура) = ТИП(Справочник.Номенклатура)
		|				ТОГДА ВЫРАЗИТЬ(Результат.Номенклатура КАК Справочник.Номенклатура).ЕдиницаИзмерения
		|			КОГДА ТИПЗНАЧЕНИЯ(Результат.Номенклатура) = ТИП(Справочник.ВидыРаботСотрудников)
		|				ТОГДА ВЫРАЗИТЬ(Результат.Номенклатура КАК Справочник.ВидыРаботСотрудников).ЕдиницаИзмерения
		|			ИНАЧЕ ЗНАЧЕНИЕ(Справочник.УпаковкиЕдиницыИзмерения.ПустаяСсылка)
		|		КОНЕЦ КАК ЕдиницаИзмерения,
		|		Результат.Организация КАК Организация,
		|		Результат.Организация.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
		|		Результат.Подразделение КАК Подразделение,
		|		Результат.СтатьяКалькуляции КАК СтатьяКалькуляции,
		|		Результат.ПартияЗатрата КАК ПартияЗатрата
		|	ИЗ
		|		Результат КАК Результат
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлючиАналитикиУчетаНоменклатуры КАК АналитикаУчетаПолуфабриката
		|			ПО Результат.АналитикаУчетаВыходноеИзделие = АналитикаУчетаПолуфабриката.Ссылка
		|	
		|	СГРУППИРОВАТЬ ПО
		|		Результат.Характеристика,
		|		АналитикаУчетаПолуфабриката.Номенклатура,
		|		Результат.АналитикаУчетаПродукции,
		|		АналитикаУчетаПолуфабриката.Характеристика,
		|		Результат.Подразделение,
		|		Результат.Организация,
		|		Результат.Организация.ВалютаРегламентированногоУчета,
		|		Результат.ПартияВыходноеИзделие,
		|		Результат.СтатьяКалькуляции,
		|		Результат.Номенклатура,
		|		Результат.АналитикаУчетаВыходноеИзделие,
		|		Результат.ТребуетсяРазузлование,
		|		Результат.ПартияПродукции,
		|		Результат.ВидСтроки,
		|		Результат.ПартияЗатрата) КАК ВложенныйЗапрос
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТПродукция.Продукция КАК Продукция,
		|	ВТПродукция.ХарактеристикаПродукции КАК ХарактеристикаПродукции,
		|	ВТПродукция.Назначение КАК Назначение,
		|	ВТПродукция.ПартияПродукции КАК ПартияПродукции,
		|	ВТПродукция.Количество КАК КоличествоВыпуск,
		|	ВТПродукция.Продукция КАК Полуфабрикат,
		|	ВТПродукция.ХарактеристикаПродукции КАК ХарактеристикаПолуфабриката,
		|	Затраты.Затрата КАК Затрата,
		|	Затраты.ХарактеристикаЗатраты КАК ХарактеристикаЗатраты,
		|	Затраты.Сумма КАК Стоимость,
		|	Затраты.Материальные КАК Материальные,
		|	Затраты.Трудозатраты КАК Трудозатраты,
		|	Затраты.ПостатейныеПостоянные КАК ПостатейныеПостоянные,
		|	Затраты.ПостатейныеПеременные КАК ПостатейныеПеременные,
		|	Затраты.Забалансовая КАК Забалансовая,
		|	Затраты.Количество КАК Количество,
		|	Затраты.ЭтоПолуфабрикат КАК ЭтоПолуфабрикат,
		|	Затраты.ЕдиницаИзмерения КАК ЕдиницаИзмеренияЗатраты,
		|	Затраты.Организация КАК Организация,
		|	Затраты.ВалютаРегламентированногоУчета КАК ВалютаРегламентированногоУчета,
		|	Затраты.Подразделение КАК Подразделение,
		|	Затраты.СтатьяКалькуляции КАК СтатьяКалькуляции,
		|	ВТПродукция.Серия КАК Серия,
		|	ВТПродукция.Сумма КАК СуммаВыпуск,
		|	ВТПродукция.Материальные КАК МатериальныеВыпуск,
		|	ВТПродукция.Трудозатраты КАК ТрудозатратыВыпуск,
		|	ВТПродукция.ПостатейныеПостоянные КАК ПостатейныеПостоянныеВыпуск,
		|	ВТПродукция.ПостатейныеПеременные КАК ПостатейныеПеременныеВыпуск,
		|	ВТПродукция.Забалансовая КАК ЗабалансоваяВыпуск,
		|	Затраты.ПартияЗатрата КАК ПартияЗатрата
		|ПОМЕСТИТЬ ЗатратыВРазрезе
		|ИЗ
		|	ВТПродукция КАК ВТПродукция
		|		ЛЕВОЕ СОЕДИНЕНИЕ Затраты КАК Затраты
		|		ПО ВТПродукция.АналитикаУчетаПродукции = Затраты.АналитикаУчетаВыходноеИзделие
		|			И (НЕ Затраты.ВидСтроки = ЗНАЧЕНИЕ(Перечисление.ВидыСтрокДереваСебестоимости.ПартияПродукции))
		|			И ВТПродукция.ПартияПродукции = Затраты.ПартияПродукции
		|			И ВТПродукция.ПартияПродукции = Затраты.ПартияПолуфабриката
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	КоличествоВыпуска.Продукция,
		|	КоличествоВыпуска.ХарактеристикаПродукции,
		|	КоличествоВыпуска.Назначение,
		|	КоличествоВыпуска.ПартияПродукции,
		|	КоличествоВыпуска.Количество,
		|	КоличествоВыпуска.Полуфабрикат,
		|	КоличествоВыпуска.ХарактеристикаПолуфабриката,
		|	Затраты.Затрата,
		|	Затраты.ХарактеристикаЗатраты,
		|	СУММА(Затраты.Сумма),
		|	СУММА(Затраты.Материальные),
		|	СУММА(Затраты.Трудозатраты),
		|	СУММА(Затраты.ПостатейныеПостоянные),
		|	СУММА(Затраты.ПостатейныеПеременные),
		|	СУММА(Затраты.Забалансовая),
		|	СУММА(Затраты.Количество),
		|	Затраты.ЭтоПолуфабрикат,
		|	Затраты.ЕдиницаИзмерения,
		|	Затраты.Организация,
		|	Затраты.ВалютаРегламентированногоУчета,
		|	Затраты.Подразделение,
		|	Затраты.СтатьяКалькуляции,
		|	КоличествоВыпуска.Серия,
		|	0,
		|	0,
		|	0,
		|	0,
		|	0,
		|	0,
		|	Затраты.ПартияЗатрата
		|ИЗ
		|	КоличествоВыпуска КАК КоличествоВыпуска
		|		ЛЕВОЕ СОЕДИНЕНИЕ Затраты КАК Затраты
		|		ПО КоличествоВыпуска.АналитикаУчетаПродукции = Затраты.АналитикаУчетаПродукции
		|			И КоличествоВыпуска.Полуфабрикат = Затраты.Полуфабрикат
		|			И КоличествоВыпуска.ХарактеристикаПолуфабриката = Затраты.ХарактеристикаПолуфабриката
		|			И КоличествоВыпуска.ПартияПолуфабриката = Затраты.ПартияПолуфабриката
		|			И КоличествоВыпуска.ПартияПродукции = Затраты.ПартияПродукции
		|			И Затраты.ПартияПродукции <> Затраты.ПартияПолуфабриката
		|ГДЕ
		|	НЕ КоличествоВыпуска.ЭтоПродукция
		|
		|СГРУППИРОВАТЬ ПО
		|	КоличествоВыпуска.Продукция,
		|	КоличествоВыпуска.ХарактеристикаПродукции,
		|	КоличествоВыпуска.Назначение,
		|	КоличествоВыпуска.Серия,
		|	КоличествоВыпуска.ПартияПродукции,
		|	КоличествоВыпуска.Количество,
		|	КоличествоВыпуска.Полуфабрикат,
		|	КоличествоВыпуска.ХарактеристикаПолуфабриката,
		|	Затраты.Затрата,
		|	Затраты.ХарактеристикаЗатраты,
		|	Затраты.ЭтоПолуфабрикат,
		|	Затраты.ЕдиницаИзмерения,
		|	Затраты.Организация,
		|	Затраты.ВалютаРегламентированногоУчета,
		|	Затраты.Подразделение,
		|	Затраты.СтатьяКалькуляции,
		|	Затраты.ПартияЗатрата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Номенклатура КАК Номенклатура,
		|	СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Характеристика КАК Характеристика,
		|	СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Серия КАК Серия,
		|	СебестоимостьТоваров.Партия КАК Партия,
		|	СебестоимостьТоваров.Организация КАК Организация,
		|	СУММА(СебестоимостьТоваров.Количество) КАК Количество,
		|	СУММА(ВЫБОР
		|			КОГДА &ДанныеПоСебестоимости = 1
		|				ТОГДА СебестоимостьТоваров.Стоимость
		|				+ СебестоимостьТоваров.Трудозатраты
		|				+ СебестоимостьТоваров.ПостатейныеПостоянныеСНДС
		|				+ СебестоимостьТоваров.ПостатейныеПеременныеСНДС
		|				+ СебестоимостьТоваров.ДопРасходы
		|			КОГДА &ДанныеПоСебестоимости = 2
		|				ТОГДА СебестоимостьТоваров.СтоимостьБезНДС
		|				+ СебестоимостьТоваров.Трудозатраты
		|				+ СебестоимостьТоваров.ПостатейныеПостоянныеБезНДС
		|				+ СебестоимостьТоваров.ПостатейныеПеременныеБезНДС
		|				+ СебестоимостьТоваров.ДопРасходыБезНДС
		|			КОГДА &ДанныеПоСебестоимости = 3
		|				ТОГДА СебестоимостьТоваров.СтоимостьУпр
		|				+ СебестоимостьТоваров.ТрудозатратыУпр
		|				+ СебестоимостьТоваров.ПостатейныеПостоянныеУпр
		|				+ СебестоимостьТоваров.ПостатейныеПеременныеУпр
		|				+ СебестоимостьТоваров.ДопРасходыУпр
		|			КОГДА &ДанныеПоСебестоимости = 4
		|				ТОГДА СебестоимостьТоваров.СтоимостьРегл
		|				+ СебестоимостьТоваров.ТрудозатратыРегл
		|				+ СебестоимостьТоваров.ПостатейныеПостоянныеРегл
		|				+ СебестоимостьТоваров.ПостатейныеПеременныеРегл
		|				+ СебестоимостьТоваров.ДопРасходыРегл
		|		КОНЕЦ)												КАК Стоимость,
		|	СУММА(ВЫБОР
		|			КОГДА &ДанныеПоСебестоимости = 1
		|				ТОГДА СебестоимостьТоваров.Стоимость + СебестоимостьТоваров.ДопРасходы
		|			КОГДА &ДанныеПоСебестоимости = 2
		|				ТОГДА СебестоимостьТоваров.СтоимостьБезНДС + СебестоимостьТоваров.ДопРасходыБезНДС
		|			КОГДА &ДанныеПоСебестоимости = 3
		|				ТОГДА СебестоимостьТоваров.СтоимостьУпр + СебестоимостьТоваров.ДопРасходыУпр
		|			КОГДА &ДанныеПоСебестоимости = 4
		|				ТОГДА СебестоимостьТоваров.СтоимостьРегл + СебестоимостьТоваров.ДопРасходыРегл
		|		КОНЕЦ)												КАК Материальные,
		|	СУММА(ВЫБОР
		|			КОГДА &ДанныеПоСебестоимости = 1
		|				ТОГДА СебестоимостьТоваров.Трудозатраты
		|			КОГДА &ДанныеПоСебестоимости = 2
		|				ТОГДА СебестоимостьТоваров.Трудозатраты
		|			КОГДА &ДанныеПоСебестоимости = 3
		|				ТОГДА СебестоимостьТоваров.ТрудозатратыУпр
		|			КОГДА &ДанныеПоСебестоимости = 4
		|				ТОГДА СебестоимостьТоваров.ТрудозатратыРегл
		|		КОНЕЦ)												КАК Трудозатраты,
		|	СУММА(ВЫБОР
		|			КОГДА &ДанныеПоСебестоимости = 1
		|				ТОГДА СебестоимостьТоваров.ПостатейныеПостоянныеСНДС
		|			КОГДА &ДанныеПоСебестоимости = 2
		|				ТОГДА СебестоимостьТоваров.ПостатейныеПостоянныеБезНДС
		|			КОГДА &ДанныеПоСебестоимости = 3
		|				ТОГДА СебестоимостьТоваров.ПостатейныеПостоянныеУпр
		|			КОГДА &ДанныеПоСебестоимости = 4
		|				ТОГДА СебестоимостьТоваров.ПостатейныеПостоянныеРегл
		|		КОНЕЦ)												КАК ПостатейныеПостоянные,
		|	СУММА(ВЫБОР
		|			КОГДА &ДанныеПоСебестоимости = 1
		|				ТОГДА СебестоимостьТоваров.ПостатейныеПеременныеСНДС
		|			КОГДА &ДанныеПоСебестоимости = 2
		|				ТОГДА СебестоимостьТоваров.ПостатейныеПеременныеБезНДС
		|			КОГДА &ДанныеПоСебестоимости = 3
		|				ТОГДА СебестоимостьТоваров.ПостатейныеПеременныеУпр
		|			КОГДА &ДанныеПоСебестоимости = 4
		|				ТОГДА СебестоимостьТоваров.ПостатейныеПеременныеРегл
		|		КОНЕЦ)												КАК ПостатейныеПеременные,
		|	СУММА(ВЫБОР
		|			КОГДА &ДанныеПоСебестоимости = 1
		|				ТОГДА СебестоимостьТоваров.СтоимостьЗабалансовая
		|			КОГДА &ДанныеПоСебестоимости = 2
		|				ТОГДА СебестоимостьТоваров.СтоимостьЗабалансовая
		|			КОГДА &ДанныеПоСебестоимости = 3
		|				ТОГДА СебестоимостьТоваров.СтоимостьЗабалансовая
		|			КОГДА &ДанныеПоСебестоимости = 4
		|				ТОГДА СебестоимостьТоваров.СтоимостьЗабалансоваяРегл
		|		КОНЕЦ)												КАК Забалансовая
		|ПОМЕСТИТЬ МатериалыПродукция
		|ИЗ
		|	РегистрНакопления.СебестоимостьТоваров КАК СебестоимостьТоваров
		|ГДЕ
		|	СебестоимостьТоваров.Регистратор В(&Накладные)
		|	И СебестоимостьТоваров.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)
		|	И (СебестоимостьТоваров.Период <= &ДатаОкончания ИЛИ &ДатаОкончания = ДАТАВРЕМЯ(1,1,1))
		|
		|СГРУППИРОВАТЬ ПО
		|	СебестоимостьТоваров.Партия,
		|	СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Серия,
		|	СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Характеристика,
		|	СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Номенклатура,
		|	СебестоимостьТоваров.Организация
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ФактическиеДанные.Продукция КАК Продукция,
		|	ФактическиеДанные.ХарактеристикаПродукции КАК ХарактеристикаПродукции,
		|	ФактическиеДанные.Назначение КАК НазначениеПродукции,
		|	ФактическиеДанные.ПартияПродукции КАК ПартияПродукции,
		|	ФактическиеДанные.Полуфабрикат КАК Полуфабрикат,
		|	ФактическиеДанные.ХарактеристикаПолуфабриката КАК ХарактеристикаПолуфабриката,
		|	ФактическиеДанные.Затрата КАК Затрата,
		|	ФактическиеДанные.ХарактеристикаЗатраты КАК ХарактеристикаЗатраты,
		|	ВЫБОР
		|		КОГДА ФактическиеДанные.СуммаВыпуск > 0
		|			ТОГДА ФактическиеДанные.СуммаВыпуск
		|		ИНАЧЕ ФактическиеДанные.Стоимость
		|	КОНЕЦ КАК Стоимость,
		|	ВЫБОР
		|		КОГДА ФактическиеДанные.МатериальныеВыпуск > 0
		|			ТОГДА ФактическиеДанные.МатериальныеВыпуск
		|		ИНАЧЕ ФактическиеДанные.Материальные
		|	КОНЕЦ КАК Материальные,
		|	ВЫБОР
		|		КОГДА ФактическиеДанные.ТрудозатратыВыпуск > 0
		|			ТОГДА ФактическиеДанные.ТрудозатратыВыпуск
		|		ИНАЧЕ ФактическиеДанные.Трудозатраты
		|	КОНЕЦ КАК Трудозатраты,
		|	ВЫБОР
		|		КОГДА ФактическиеДанные.ПостатейныеПостоянныеВыпуск > 0
		|			ТОГДА ФактическиеДанные.ПостатейныеПостоянныеВыпуск
		|		ИНАЧЕ ФактическиеДанные.ПостатейныеПостоянные
		|	КОНЕЦ КАК ПостатейныеПостоянные,
		|	ВЫБОР
		|		КОГДА ФактическиеДанные.ПостатейныеПеременныеВыпуск > 0
		|			ТОГДА ФактическиеДанные.ПостатейныеПеременныеВыпуск
		|		ИНАЧЕ ФактическиеДанные.ПостатейныеПеременные
		|	КОНЕЦ КАК ПостатейныеПеременные,
		|	ВЫБОР
		|		КОГДА ФактическиеДанные.ЗабалансоваяВыпуск > 0
		|			ТОГДА ФактическиеДанные.ЗабалансоваяВыпуск
		|		ИНАЧЕ ФактическиеДанные.Забалансовая
		|	КОНЕЦ КАК Забалансовые,
		|	ФактическиеДанные.Количество КАК Количество,
		|	ФактическиеДанные.Продукция.ЕдиницаИзмерения КАК ЕдиницаИзмеренияПродукции,
		|	ФактическиеДанные.Полуфабрикат.ЕдиницаИзмерения КАК ЕдиницаИзмеренияПолуфабриката,
		|	ФактическиеДанные.ЕдиницаИзмеренияЗатраты КАК ЕдиницаИзмеренияЗатраты,
		|	ФактическиеДанные.Организация КАК Организация,
		|	ФактическиеДанные.СтатьяКалькуляции КАК СтатьяКалькуляции,
		|	ФактическиеДанные.Подразделение КАК Подразделение,
		|	""Продукция"" КАК ТипДанных,
		|	ФактическиеДанные.Серия КАК Серия,
		|	ФактическиеДанные.ПартияЗатрата КАК ПартияЗатраты,
		|	0 КАК Уровень,
		|	ВЫБОР
		|		КОГДА &ДанныеПоСебестоимости = 3
		|			ТОГДА ФактическиеДанные.ВалютаРегламентированногоУчета
		|		ИНАЧЕ
		|			&ВалютаУправленческогоУчета
		|	КОНЕЦ КАК Валюта
		|ИЗ
		|	ЗатратыВРазрезе КАК ФактическиеДанные
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	NULL,
		|	МатериалыПродукция.Номенклатура,
		|	МатериалыПродукция.Характеристика,
		|	СУММА(МатериалыПродукция.Стоимость),
		|	СУММА(МатериалыПродукция.Материальные),
		|	СУММА(МатериалыПродукция.Трудозатраты),
		|	СУММА(МатериалыПродукция.ПостатейныеПостоянные),
		|	СУММА(МатериалыПродукция.ПостатейныеПеременные),
		|	СУММА(МатериалыПродукция.Забалансовая),
		|	СУММА(МатериалыПродукция.Количество),
		|	NULL,
		|	NULL,
		|	МатериалыПродукция.Номенклатура.ЕдиницаИзмерения,
		|	МатериалыПродукция.Организация,
		|	NULL,
		|	NULL,
		|	""Материалы"",
		|	МатериалыПродукция.Серия,
		|	МатериалыПродукция.Партия,
		|	0,
		|	ВЫБОР
		|		КОГДА &ДанныеПоСебестоимости = 3
		|			ТОГДА МатериалыПродукция.Организация.ВалютаРегламентированногоУчета
		|		ИНАЧЕ
		|			&ВалютаУправленческогоУчета
		|	КОНЕЦ
		|ИЗ
		|	МатериалыПродукция КАК МатериалыПродукция
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СебестоимостьТоваров КАК СебестоимостьТоваров
		|		ПО (СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Номенклатура = МатериалыПродукция.Номенклатура)
		|			И (СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Характеристика = МатериалыПродукция.Характеристика)
		|			И (СебестоимостьТоваров.АналитикаУчетаНоменклатуры.Серия = МатериалыПродукция.Серия)
		|			И (СебестоимостьТоваров.РазделУчета В (ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ПроизводственныеЗатраты), ЗНАЧЕНИЕ(Перечисление.РазделыУчетаСебестоимостиТоваров.ТоварыПринятыеНаОтветхранение)))
		|			И (СебестоимостьТоваров.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход))
		|			И (СебестоимостьТоваров.ХозяйственнаяОперация В (ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыпускПродукции), ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыпускПродукцииНаСклад), ЗНАЧЕНИЕ(Перечисление.ХозяйственныеОперации.ВыпускПродукцииВПодразделение)))
		|			И (НЕ СебестоимостьТоваров.Партия = НЕОПРЕДЕЛЕНО)
		|ГДЕ
		|	СебестоимостьТоваров.Регистратор ЕСТЬ NULL
		|
		|СГРУППИРОВАТЬ ПО
		|	МатериалыПродукция.Номенклатура,
		|	МатериалыПродукция.Характеристика,
		|	МатериалыПродукция.Организация,
		|	МатериалыПродукция.Серия,
		|	МатериалыПродукция.Номенклатура.ЕдиницаИзмерения,
		|	МатериалыПродукция.Партия,
		|	ВЫБОР
		|		КОГДА &ДанныеПоСебестоимости = 3
		|			ТОГДА МатериалыПродукция.Организация.ВалютаРегламентированногоУчета
		|		ИНАЧЕ
		|			&ВалютаУправленческогоУчета
		|	КОНЕЦ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ФактическиеДанные.Продукция КАК Продукция,
		|	ФактическиеДанные.ХарактеристикаПродукции КАК ХарактеристикаПродукции,
		|	ФактическиеДанные.Назначение КАК НазначениеПродукции,
		|	ФактическиеДанные.ПартияПродукции КАК ПартияПродукции,
		|	ФактическиеДанные.Полуфабрикат КАК Полуфабрикат,
		|	ФактическиеДанные.ХарактеристикаПолуфабриката КАК ХарактеристикаПолуфабриката,
		|	СУММА(ФактическиеДанные.Количество) КАК КоличествоВыпуск,
		|	ФактическиеДанные.Организация КАК Организация,
		|	ВЫБОР
		|		КОГДА &ДанныеПоСебестоимости = 3
		|			ТОГДА ФактическиеДанные.ВалютаРегламентированногоУчета
		|		ИНАЧЕ
		|			&ВалютаУправленческогоУчета
		|	КОНЕЦ КАК Валюта
		|ИЗ
		|	КоличествоВыпуска КАК ФактическиеДанные
		|ГДЕ
		|	ФактическиеДанные.ЭтоПродукция
		|
		|СГРУППИРОВАТЬ ПО
		|	ФактическиеДанные.Продукция,
		|	ФактическиеДанные.Полуфабрикат,
		|	ФактическиеДанные.ХарактеристикаПолуфабриката,
		|	ФактическиеДанные.ПартияПродукции,
		|	ФактическиеДанные.ХарактеристикаПродукции,
		|	ФактическиеДанные.Назначение,
		|	ФактическиеДанные.Организация,
		|	ВЫБОР
		|		КОГДА &ДанныеПоСебестоимости = 3
		|			ТОГДА ФактическиеДанные.ВалютаРегламентированногоУчета
		|		ИНАЧЕ
		|			&ВалютаУправленческогоУчета
		|	КОНЕЦ";
	
#КонецОбласти

	МассивРезультатов = Запрос.ВыполнитьПакет();
	ВнешниеНаборыДанных = Новый Структура();
	ВнешниеНаборыДанных.Вставить("Факт", МассивРезультатов[МассивРезультатов.Количество() - 2].Выгрузить());
	ВнешниеНаборыДанных.Вставить("Выпуски", МассивРезультатов[МассивРезультатов.Количество() - 1].Выгрузить());
	
	ЭлементыКУдалению = Новый Массив;
	Для Каждого ЭлементОтбора Из НастройкиОтчета.Отбор.Элементы Цикл
		
		Если ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Регистратор") Тогда
			ЭлементыКУдалению.Добавить(ЭлементОтбора);
		КонецЕсли;
		
		
	КонецЦикла;
	
	Для Каждого УдаляемыйЭлемент Из ЭлементыКУдалению Цикл
		НастройкиОтчета.Отбор.Элементы.Удалить(УдаляемыйЭлемент);
	КонецЦикла;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки);
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	ВывестиТекстПредупрежденияОбОграниченияхИспользованияОтчета(НачалоПериода,
		КонецПериода,
		ДокументРезультат);
		
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
		КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(
			СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Настраивает параметры отчета по варианту отчета
//
// Параметры:
//	КлючВарианта						- Строка									- имя предопределенного или уникальный идентификатор пользовательского
//																						варианта отчета.
//										- Неопределено 								- вызов для варианта расшифровки или без контекста.
//	НовыеНастройкиКД					- НастройкиКомпоновкиДанных					- настройки варианта отчета, которые будут загружены
//																						в компоновщик настроек после его инициализации.
//										- Неопределено 								- настройки варианта не надо загружать (уже загружены ранее).
//	НовыеПользовательскиеНастройкиКД	- ПользовательскиеНастройкиКомпоновкиДанных - пользовательские настройки, которые будут загружены в компоновщик
//																						настроек после его инициализации.
//										- Неопределено 								- пользовательские настройки не надо загружать (уже загружены ранее).
//
Процедура НастроитьПараметрыОтчетаПоВариантуОтчета(КлючВарианта, НовыеНастройкиКД, НовыеПользовательскиеНастройкиКД)
	
	ПараметрДанныеПоСебестоимости = СхемаКомпоновкиДанных.Параметры.Найти("ДанныеПоСебестоимости");
	
	СписокВыбора = Новый СписокЗначений;
	
	Если КлючВарианта = "ФактическаяСебестоимостьПродукцииПредприятия" Тогда
		
		СписокВыбора.Добавить(1, НСтр("ru = 'В валюте упр. учета с НДС'"));
		СписокВыбора.Добавить(2, НСтр("ru = 'В валюте упр. учета без НДС'"));
		
	ИначеЕсли КлючВарианта = "ФактическаяСебестоимостьПродукцииОрганизации" Тогда	
		
		Если РасчетСебестоимостиПовтИсп.УправленческийУчетОрганизаций() Тогда
			СписокВыбора.Добавить(3, НСтр("ru = 'В валюте упр. учета'"));
		КонецЕсли;
		СписокВыбора.Добавить(4, НСтр("ru = 'В валюте регл. учета'"));
		
	Иначе
		
		СписокВыбора.Добавить(1, НСтр("ru = 'В валюте упр. учета с НДС'"));
		СписокВыбора.Добавить(2, НСтр("ru = 'В валюте упр. учета без НДС'"));
		СписокВыбора.Добавить(4, НСтр("ru = 'В валюте регл. учета'"));
		
	КонецЕсли;
	
	ПараметрДанныеПоСебестоимости.УстановитьДоступныеЗначения(СписокВыбора);
	
	Если НовыеНастройкиКД = Неопределено
		Или НовыеПользовательскиеНастройкиКД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначениеПараметраДанныеПоСебестоимости = НовыеНастройкиКД.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ДанныеПоСебестоимости"));
	НастройкаДанныеПоСебестоимости = НовыеПользовательскиеНастройкиКД.Элементы.Найти(ЗначениеПараметраДанныеПоСебестоимости.ИдентификаторПользовательскойНастройки);
	Если Не НастройкаДанныеПоСебестоимости = Неопределено
		И СписокВыбора.НайтиПоЗначению(НастройкаДанныеПоСебестоимости.Значение) = Неопределено Тогда
		НастройкаДанныеПоСебестоимости.Значение = СписокВыбора[0].Значение;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет отбор в СКД получателе возможными отборами.
// 
// Параметры:
//	ПриемникНастроек - ОтборКомпоновкиДанных
//	ИсточникНастроек - ОтборКомпоновкиДанных
//	ВозможныеПоляУсловия - Массив - полей компоновки данных, на которые возможно наложить отбор в приемнике настроек.
//
Процедура ЗаполнитьНастройкиОтчетаРекурсивно(ПриемникНастроек, ИсточникНастроек, ВозможныеПоляУсловия)
	
	Для Каждого ЭлементОтбора Из ИсточникНастроек.Элементы Цикл
		
		Если Не ЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(ЭлементОтбора) = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			
			НовыйЭлемент = ПриемникНастроек.Элементы.Добавить(ТипЗнч(ЭлементОтбора));
			ЗаполнитьЗначенияСвойств(НовыйЭлемент, ЭлементОтбора);
			ЗаполнитьНастройкиОтчетаРекурсивно(НовыйЭлемент, ЭлементОтбора, ВозможныеПоляУсловия);
			
		Иначе
			
			Если ВозможныеПоляУсловия.Найти(ЭлементОтбора.ЛевоеЗначение) = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ЗаполнитьЗначенияСвойств(ПриемникНастроек.Элементы.Добавить(ТипЗнч(ЭлементОтбора)), ЭлементОтбора);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	
	Параметры = Новый Массив;
	Параметры.Добавить("ТолькоМатериалыДавальца");
	
	Возврат Параметры;
	
КонецФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		КомпоновкаДанныхСервер.УдалитьЭлементОтбораИзВсехНастроекОтчета(КомпоновщикНастроекФормы, "ХарактеристикаПродукции");
	КонецЕсли;
	
	КомпоновкаДанныхСервер.ОчиститьСтруктуруПоФункциональнымОпциям(КомпоновщикНастроекФормы.Настройки.Структура, УдаляемыеПоляПоФО());
	
КонецПроцедуры

Функция УдаляемыеПоляПоФО()
	
	УдаляемыеПоля = Новый Массив;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьХарактеристикиНоменклатуры") Тогда
		
		УдаляемыеПоля.Добавить(Новый ПолеКомпоновкиДанных("ХарактеристикаПродукции"));
		УдаляемыеПоля.Добавить(Новый ПолеКомпоновкиДанных("ХарактеристикаПолуфабриката"));
		УдаляемыеПоля.Добавить(Новый ПолеКомпоновкиДанных("ХарактеристикаЗатраты"));
		
	КонецЕсли;
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьСерииНоменклатуры") Тогда
		УдаляемыеПоля.Добавить(Новый ПолеКомпоновкиДанных("Серия"));
	КонецЕсли;
	
	Возврат УдаляемыеПоля;
	
КонецФункции

Процедура ВывестиТекстПредупрежденияОбОграниченияхИспользованияОтчета(НачалоПериода, КонецПериода, ДокументРезультат)
	
	ТекстПредупреждения = РасчетСебестоимостиПрикладныеАлгоритмы.ТекстПредупрежденияНеподдерживаемыеОрганизации(НачалоПериода, КонецПериода, КомпоновщикНастроек);
	
	Если Не ПустаяСтрока(ТекстПредупреждения) Тогда
		
		ТаблицаПредупреждение = Новый ТабличныйДокумент;
		ОбластьПредупреждение = ТаблицаПредупреждение.Область(1,1,1,1);
		
		ОбластьПредупреждение.Текст 	 = СокрЛП(ТекстПредупреждения);
		ОбластьПредупреждение.ЦветТекста = ЦветаСтиля.ЦветОтрицательногоЧисла;
		
		ДокументРезультат.ВставитьОбласть(
		ОбластьПредупреждение,
		ДокументРезультат.Область(1,1,1,1),
		ТипСмещенияТабличногоДокумента.ПоВертикали);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
