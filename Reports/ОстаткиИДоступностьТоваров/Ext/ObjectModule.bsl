﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользовательскиеНастройкиМодифицированы = Ложь;
	
	ЗначениеПоиска = Новый ПараметрКомпоновкиДанных("СтрокаСейчас");
	ЭлементПараметрыДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ЗначениеПоиска);
	ЭлементПараметрыДанных.Значение = НСтр("ru = 'Сейчас'");
	
	ЗначениеПоиска = Новый ПараметрКомпоновкиДанных("СтрокаОжидается");
	ЭлементПараметрыДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ЗначениеПоиска);
	ЭлементПараметрыДанных.Значение = НСтр("ru = 'Ожидается'");
	
	ЗначениеПоиска = Новый ПараметрКомпоновкиДанных("СтрокаВсего");
	ЭлементПараметрыДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(ЗначениеПоиска);
	ЭлементПараметрыДанных.Значение = НСтр("ru = 'Всего'");
	
	УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы);
	
	// Вызов из самообслуживания.
	Если ОбщегоНазначенияУТКлиентСервер.АвторизованВнешнийПользователь() Тогда
		ПараметрВыводитьОтбор = КомпоновщикНастроек.Настройки.ПараметрыВывода.Элементы.Найти("ВыводитьОтбор");
		Если ПараметрВыводитьОтбор <> Неопределено Тогда
			ПараметрВыводитьОтбор.Использование = Истина;
			ПараметрВыводитьОтбор.Значение = ТипВыводаТекстаКомпоновкиДанных.НеВыводить;
		КонецЕсли;
	КонецЕсли;

	// Стандартная компоновка отчета.
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	
	ПодставитьТекстыЗапросаОстатков(СхемаКомпоновкиДанных);
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.Основной.Запрос;
	
	
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаВесНоменклатуры", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаВесУпаковки("Таблица.Номенклатура.ЕдиницаИзмерения", "Таблица.Номенклатура"));
		
	ТекстЗапроса = СтрЗаменить(
		ТекстЗапроса, 
		"&ТекстЗапросаОбъемНоменклатуры", 
		Справочники.УпаковкиЕдиницыИзмерения.ТекстЗапросаОбъемУпаковки("Таблица.Номенклатура.ЕдиницаИзмерения", "Таблица.Номенклатура"));

	СхемаКомпоновкиДанных.НаборыДанных.Основной.Запрос = ТекстЗапроса;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	КомпоновкаДанныхСервер.УстановитьЗаголовкиМакетаКомпоновки(ПараметризуемыеЗаголовкиПолей(), МакетКомпоновки);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	КомпоновкаДанныхСервер.СкрытьВспомогательныеПараметрыОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек, ДокументРезультат, ВспомогательныеПараметрыОтчета());
	
	// Сообщим форме отчета, что настройки модифицированы
	Если ПользовательскиеНастройкиМодифицированы Тогда
		КомпоновщикНастроек.ПользовательскиеНастройки.ДополнительныеСвойства.Вставить("ПользовательскиеНастройкиМодифицированы", Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Настройки общей формы отчета подсистемы "Варианты отчетов".
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   КлючВарианта - Строка - Имя предопределенного варианта отчета или уникальный идентификатор пользовательского.
//   Настройки - См. ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт
	
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПередЗагрузкойВариантаНаСервере = Истина;
	Настройки.События.ПередЗаполнениемПанелиБыстрыхНастроек	= Истина;
	
КонецПроцедуры

// Вызывается до перезаполнения панели настроек формы отчета.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - форма отчета.
//   ПараметрыЗаполнения - Структура - параметры, которые будут загружены в отчет.
//
Процедура ПередЗаполнениемПанелиБыстрыхНастроек(Форма, ПараметрыЗаполнения) Экспорт
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьОбособленноеОбеспечениеЗаказов") Тогда
		ПараметрыДанных = КомпоновщикНастроек.Настройки.ПараметрыДанных;
		ПараметрДанных = ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметркомпоновкиДанных("ПоказатьОбособленныеТовары"));
		ПараметрДанных.ИдентификаторПользовательскойНастройки = "";
	КонецЕсли;
КонецПроцедуры

// Вызывается в одноименном обработчике формы отчета после выполнения кода формы.
//
// Подробнее - см. ОтчетыПереопределяемый.ПередЗагрузкойВариантаНаСервере
//
Процедура ПередЗагрузкойВариантаНаСервере(ЭтаФорма, НовыеНастройкиКД) Экспорт
	
	Отчет = ЭтаФорма.Отчет;
	КомпоновщикНастроекФормы = Отчет.КомпоновщикНастроек;

	// Изменение настроек по функциональным опциям
	НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы);

КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Булево - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Булево - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Параметры = Форма.Параметры;
	
	Если Параметры.Свойство("ПараметрКоманды") Тогда
		
		Если Параметры.Свойство("ОписаниеКоманды")
			И Параметры.ОписаниеКоманды.Свойство("ДополнительныеПараметры") Тогда
			
			// Структура с полями из ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов.
			ОписаниеКоманды = Параметры.ОписаниеКоманды; // Структура -
			ДополнительныеПараметрыКоманды = ОписаниеКоманды.ДополнительныеПараметры; // Структура -
			Если ДополнительныеПараметрыКоманды.ИмяКоманды = "ОстаткиИДоступность" Тогда
				Форма.ФормаПараметры.Отбор.Вставить("Номенклатура", Параметры.ПараметрКоманды);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьОбязательныеНастройки(ПользовательскиеНастройкиМодифицированы)
	
	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);
	
КонецПроцедуры

Функция ВспомогательныеПараметрыОтчета()
	
	ВспомогательныеПараметры = Новый Массив;
	
	ВспомогательныеПараметры.Добавить("КоличественныеИтогиПоЕдИзм");
	
	КомпоновкаДанныхСервер.ДобавитьВспомогательныеПараметрыОтчетаПоФункциональнымОпциям(ВспомогательныеПараметры);
	
	Возврат ВспомогательныеПараметры;

КонецФункции

Функция ПараметризуемыеЗаголовкиПолей()
	
	Возврат КомпоновкаДанныхСервер.СоответствиеЗаголовковПолейЕдиницИзмерений(КомпоновщикНастроек);
	
КонецФункции

Процедура НастроитьПараметрыОтборыПоФункциональнымОпциям(КомпоновщикНастроекФормы)
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьЕдиницыИзмеренияДляОтчетов") Тогда
		КомпоновкаДанныхСервер.УдалитьПараметрИзПользовательскихНастроекОтчета(КомпоновщикНастроекФормы, "ЕдиницыКоличества");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодставитьТекстыЗапросаОстатков(Макет)
	
	ТекстЗапроса = Макет.НаборыДанных[0].Запрос;
	
	СтрокаДляПоиска = "ПОМЕСТИТЬ ЗапасыИПотребности"; //@Query-part
	НачальнаяПозиция = СтрНайти(ТекстЗапроса, СтрокаДляПоиска);
	
	СтрокаДляПоиска = "ИНДЕКСИРОВАТЬ ПО"; //@Query-part
	НачальнаяПозиция = СтрНайти(ТекстЗапроса, СтрокаДляПоиска, , НачальнаяПозиция);
	
	Тексты = Новый Массив();
	Тексты.Добавить(Лев(ТекстЗапроса, НачальнаяПозиция - 1));
	
	Если ОбеспечениеВДокументахСервер.ЭтоПроизводительныйРежим() Тогда
		
		Текст =
			"ВЫБРАТЬ
			|	ИнформацияОДоступности.Номенклатура КАК Номенклатура,
			|	ИнформацияОДоступности.Характеристика КАК Характеристика,
			|	ИнформацияОДоступности.Склад КАК Склад,
			|	ИнформацияОДоступности.Назначение КАК Назначение,
			|	ИнформацияОДоступности.Заказ КАК Заказ,
			|	ИнформацияОДоступности.ДатаСобытия КАК ДатаСобытия,
			|	ИнформацияОДоступности.ВНаличииОстаток КАК ВНаличииОстаток,
			|	ИнформацияОДоступности.ПоступитОстаток КАК ПоступитОстаток
			|ИЗ
			|	РегистрНакопления.ЗапасыИПотребности.Остатки(,
			|		Склад ССЫЛКА Справочник.Склады
			|			И ВЫБОР
			|				КОГДА &ПоказатьОбособленныеТовары
			|					ТОГДА
			|						ИСТИНА
			|				ИНАЧЕ Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
			|			КОНЕЦ
			|			{(Номенклатура, Характеристика) В(
			|				ВЫБРАТЬ
			|					ТаблицаОтбора.Номенклатура КАК Номенклатура,
			|					ТаблицаОтбора.Характеристика КАК Характеристика
			|				ИЗ
			|					ОтборПоСегментуНоменклатуры КАК ТаблицаОтбора
			|				ГДЕ
			|					ТаблицаОтбора.ИспользуетсяОтборПоСегментуНоменклатуры = &ИспользуетсяОтборПоСегментуНоменклатуры)}
			|			{Номенклатура.* КАК Номенклатура,
			|			Характеристика.* КАК Характеристика,
			|			Склад.* КАК Склад}) КАК ИнформацияОДоступности
			|";
		
	Иначе
		
		Текст =
			"ВЫБРАТЬ
			|	ИнформацияОДоступности.Номенклатура КАК Номенклатура,
			|	ИнформацияОДоступности.Характеристика КАК Характеристика,
			|	ИнформацияОДоступности.Склад КАК Склад,
			|	ИнформацияОДоступности.Назначение КАК Назначение,
			|	ИнформацияОДоступности.ЗаказНаПоступление КАК Заказ,
			|	ИнформацияОДоступности.ДатаПоступления КАК ДатаСобытия,
			|	ВЫБОР
			|		КОГДА ИнформацияОДоступности.Состояние = ЗНАЧЕНИЕ(Перечисление.РаспределениеЗапасовСостояния.ОстатокНаСкладе)
			|			ТОГДА ИнформацияОДоступности.Запас
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК ВНаличииОстаток,
			|	ВЫБОР
			|		КОГДА ИнформацияОДоступности.Состояние = ЗНАЧЕНИЕ(Перечисление.РаспределениеЗапасовСостояния.ОжидаемоеПоступление)
			|			ТОГДА ИнформацияОДоступности.Запас
			|		ИНАЧЕ 0
			|	КОНЕЦ КАК ПоступитОстаток
			|ИЗ
			|	РегистрСведений.РаспределениеЗапасов КАК ИнформацияОДоступности
			|		{ВНУТРЕННЕЕ СОЕДИНЕНИЕ ОтборПоСегментуНоменклатуры КАК ТаблицаОтбора
			|		ПО ТаблицаОтбора.Номенклатура = ИнформацияОДоступности.Номенклатура
			|			И ТаблицаОтбора.Характеристика = ИнформацияОДоступности.Характеристика}
			|ГДЕ
			|	ИнформацияОДоступности.Состояние В (
			|		ЗНАЧЕНИЕ(Перечисление.РаспределениеЗапасовСостояния.ОстатокНаСкладе),
			|		ЗНАЧЕНИЕ(Перечисление.РаспределениеЗапасовСостояния.ОжидаемоеПоступление))
			|	И ИнформацияОДоступности.Запас <> 0
			|	И ИнформацияОДоступности.Склад ССЫЛКА Справочник.Склады
			|	И ВЫБОР
			|			КОГДА &ПоказатьОбособленныеТовары ТОГДА
			|				ИСТИНА
			|			ИНАЧЕ
			|				ИнформацияОДоступности.Назначение = ЗНАЧЕНИЕ(Справочник.Назначения.ПустаяСсылка)
			|		КОНЕЦ
			|{ГДЕ
			|	ТаблицаОтбора.ИспользуетсяОтборПоСегментуНоменклатуры = &ИспользуетсяОтборПоСегментуНоменклатуры
			|}
			|{ГДЕ
			|	ИнформацияОДоступности.Склад.* КАК Склад,
			|	ИнформацияОДоступности.Номенклатура.* КАК Номенклатура,
			|	ИнформацияОДоступности.Характеристика.* КАК Характеристика}
			|";
		
	КонецЕсли;
	Тексты.Добавить(ОбщегоНазначенияУТ.РазделительЗапросовВОбъединении());
	Тексты.Добавить(Текст);
	Тексты.Добавить(Сред(ТекстЗапроса, НачальнаяПозиция));
	ТекстЗапроса = СтрСоединить(Тексты);
	Макет.НаборыДанных[0].Запрос = ТекстЗапроса;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли