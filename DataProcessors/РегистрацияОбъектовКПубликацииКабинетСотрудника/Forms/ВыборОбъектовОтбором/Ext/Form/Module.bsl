﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИмяТаблицыДанных = Параметры.ИмяТаблицы;
	ЗаголовокТаблицы  = "";
	
	Описание = ХарактеристикиПоМетаданным(ИмяТаблицыДанных);
	ОписаниеМетаданные = Описание.Метаданные;
	Заголовок = ОписаниеМетаданные.Представление();
	
	Если Описание.ЭтоСсылка Тогда
		
		ЗаголовокТаблицы = ОписаниеМетаданные.ПредставлениеОбъекта;
		Если ПустаяСтрока(ЗаголовокТаблицы) Тогда
			ЗаголовокТаблицы = Заголовок;
		КонецЕсли;
		
		СписокДанных.ПроизвольныйЗапрос = Ложь;
		СписокДанных.ДинамическоеСчитываниеДанных = Истина;
		СписокДанных.ОсновнаяТаблица = ИмяТаблицыДанных;
								
		Поле = СписокДанных.Отбор.ДоступныеПоляОтбора.Элементы.Найти(Новый ПолеКомпоновкиДанных("Ссылка"));
		ТаблицаКолонок = Новый ТаблицаЗначений;
		Колонки = ТаблицаКолонок.Колонки;
		Колонки.Добавить("Ссылка", Поле.ТипЗначения, ЗаголовокТаблицы);
		КлючФормыДанных = "Ссылка";
		
	Иначе
		Возврат;
	КонецЕсли;
	
	ДобавитьКолонкиВСписокДанных("Порядок, Отбор, Группировка, СтандартнаяКартинка, Параметры, УсловноеОформление",
								 Колонки);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборПриИзменении(Элемент)
	Элементы.СписокДанных.Обновить();	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокДанных

&НаКлиенте
Процедура СписокДанныхВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуТекущегоОбъекта();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьТекущийОбъект(Команда)
	ОткрытьФормуТекущегоОбъекта();
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОтобранныеЗначения(Команда)
	ПроизвестиВыбор(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьТекущуюСтроку(Команда)
	ПроизвестиВыбор(Ложь);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Метаданные

&НаСервереБезКонтекста
Функция ХарактеристикиПоМетаданным(ИмяТаблицыМетаданных)
	
	Характеристики = НовыйХарактеристикиПоМетаданным();
	ТаблицаМетаданных = МетаданныеПоПолномуИмени(ИмяТаблицыМетаданных);
	
	Характеристики.Метаданные = ТаблицаМетаданных;
	Характеристики.ИмяТаблицы = ИмяТаблицыМетаданных;
	
	Если Метаданные.Справочники.Содержит(ТаблицаМетаданных) Тогда
		Характеристики.ЭтоСсылка 	= Истина;
		Характеристики.Менеджер  	= Справочники[ТаблицаМетаданных.Имя];
	ИначеЕсли Метаданные.БизнесПроцессы.Содержит(ТаблицаМетаданных) Тогда
		Характеристики.ЭтоСсылка 	= Истина;
		Характеристики.Менеджер 	= БизнесПроцессы[ТаблицаМетаданных.Имя];
	КонецЕсли;
	
	Возврат Характеристики;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция НовыйХарактеристикиПоМетаданным() 
	
	Характеристики = Новый Структура;
	Характеристики.Вставить("ИмяТаблицы", "");
	Характеристики.Вставить("Метаданные", Неопределено);
	Характеристики.Вставить("Менеджер", Неопределено);
	Характеристики.Вставить("ЭтоСсылка", Ложь);
	
	Возврат Характеристики;
	
КонецФункции

&НаСервереБезКонтекста
Функция МетаданныеПоПолномуИмени(ИмяМетаданных) 
	
	Если ПустаяСтрока(ИмяМетаданных) Тогда
		Возврат Метаданные;
	КонецЕсли;
		
	Значение = Метаданные.НайтиПоПолномуИмени(ИмяМетаданных);
	Если Значение = Неопределено Тогда
		Значение = Метаданные[ИмяМетаданных];
	КонецЕсли;
	
	Возврат Значение;
	
КонецФункции

#КонецОбласти

&НаКлиенте
Процедура ОткрытьФормуТекущегоОбъекта()
	ТекПараметры = ПараметрыФормыТекущегоОбъекта(Элементы.СписокДанных.ТекущиеДанные);
	Если ТекПараметры <> Неопределено Тогда
		ОткрытьФорму(ТекПараметры.ИмяФормы, ТекПараметры.Ключ);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроизвестиВыбор(ВесьРезультатОтбора = Истина)	
	Если ВесьРезультатОтбора Тогда
		Данные = ВсеВыбранныеЭлементы();
	Иначе
		Данные = Новый Массив;
		Для Каждого ТекСтрока Из Элементы.СписокДанных.ВыделенныеСтроки Цикл
			Данные.Добавить(Элементы.СписокДанных.ДанныеСтроки(ТекСтрока).Ссылка);
		КонецЦикла;
	КонецЕсли;
	Закрыть(Данные);
КонецПроцедуры

&НаСервере
Функция ПараметрыФормыТекущегоОбъекта(Знач Данные)
	
	Если Данные = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(КлючФормыДанных) = Тип("Строка") Тогда
		КлючОбъекта = Данные[КлючФормыДанных];
		ИмяФормыОбъекта = ПолучитьИмяФормы(КлючОбъекта) + ".ФормаОбъекта";
	Иначе
		Если Данные.Свойство("Регистратор") Тогда
			КлючОбъекта = Данные.Регистратор;
			ИмяФормыОбъекта = ПолучитьИмяФормы(КлючОбъекта) + ".ФормаОбъекта";
		Иначе
			ЗаполнитьЗначенияСвойств(КлючФормыДанных, Данные);
			ТекПараметры = Новый Массив;
			ТекПараметры.Добавить(КлючФормыДанных);
			ИмяКлючаЗаписи = СтрЗаменить(Параметры.ИмяТаблицы, ".", "КлючЗаписи.");
			КлючОбъекта = Новый(ИмяКлючаЗаписи, ТекПараметры);
			ИмяФормыОбъекта = Параметры.ИмяТаблицы + ".ФормаЗаписи";
		КонецЕсли;
		
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяФормы", ИмяФормыОбъекта);
	Результат.Вставить("Ключ", Новый Структура("Ключ", КлючОбъекта));
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ВсеВыбранныеЭлементы()
	Возврат ТекущиеДанныеДинамическогоСписка(СписокДанных).ВыгрузитьКолонку("Ссылка");	
КонецФункции	

&НаСервере
Процедура ДобавитьКолонкиВСписокДанных(СохранятьИмена, Добавлять)
	
	ЭлементСписокДанных = Элементы.СписокДанных;
	ИмяРеквизитаТаблицы = ЭлементСписокДанных.ПутьКДанным;
	
	Сохраняемые = Новый Структура(СохранятьИмена);
	СохраняемыеПутиДанных = Новый Соответствие;
	Для Каждого Элемент Из Сохраняемые Цикл
		СохраняемыеПутиДанных.Вставить(ИмяРеквизитаТаблицы + "." + Элемент.Ключ, Истина);
	КонецЦикла;
	
	Удалять = Новый Массив;
	Для Каждого Элемент Из ЭлементСписокДанных.ПодчиненныеЭлементы Цикл
		Удалять.Добавить(Элемент);
	КонецЦикла;
	Для Каждого Элемент Из Удалять Цикл
		Если ТипЗнч(Элемент) <> Тип("ГруппаФормы") И СохраняемыеПутиДанных[Элемент.ПутьКДанным] = Неопределено Тогда
			Элементы.Удалить(Элемент);
		КонецЕсли;
	КонецЦикла;
	
	Префикс = ЭлементСписокДанных.Имя;
	Для Каждого Колонка Из Добавлять Цикл
		ИмяКолонки = Колонка.Имя;
		ЭлементФормы = Элементы.Вставить(Префикс + ИмяКолонки, Тип("ПолеФормы"), ЭлементСписокДанных);
		ЭлементФормы.Вид = ВидПоляФормы.ПолеВвода;
		ЭлементФормы.ПутьКДанным = ИмяРеквизитаТаблицы + "." + ИмяКолонки;
		ЭлементФормы.Заголовок = Колонка.Заголовок;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьИмяФормы(ТекущийОбъект)
	
	Тип = ТипЗнч(ТекущийОбъект);
	Если Тип = Тип("ДинамическийСписок") Тогда
		Возврат ТекущийОбъект.ОсновнаяТаблица + ".";
	ИначеЕсли Тип = Тип("Строка") Тогда
		Возврат ТекущийОбъект + ".";
	КонецЕсли;
	
	ТаблицаМетаданных = ТекущийОбъект.Метаданные();
	Возврат ТаблицаМетаданных.ПолноеИмя() + ".";
	
КонецФункции

&НаСервере
Функция ТекущиеДанныеДинамическогоСписка(ИсточникДанных)
	СхемаКомпоновки = Новый СхемаКомпоновкиДанных;
	
	Источник = СхемаКомпоновки.ИсточникиДанных.Добавить();
	Источник.Имя = "Источник";
	Источник.ТипИсточникаДанных = "local";
	
	Набор = СхемаКомпоновки.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	Набор.Запрос = ИсточникДанных.ТекстЗапроса;
	Набор.АвтоЗаполнениеДоступныхПолей = Истина;
	Набор.ИсточникДанных = Источник.Имя;
	Набор.Имя = Источник.Имя;
	
	ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновки);
	Компоновщик = Новый КомпоновщикНастроекКомпоновкиДанных;
	Компоновщик.Инициализировать(ИсточникНастроек);
	
	ТекНастройки = Компоновщик.Настройки;
	
	Для Каждого Элемент Из ТекНастройки.Выбор.ДоступныеПоляВыбора.Элементы Цикл
		Если Не Элемент.Папка Тогда
			Поле = ТекНастройки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			Поле.Использование = Истина;
			Поле.Поле = Элемент.Поле;
		КонецЕсли;
	КонецЦикла;
	Группа = ТекНастройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	Группа.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));

	СкопироватьОтборКомпоновкиДанных(ТекНастройки.Отбор, ИсточникДанных.Отбор);
	СкопироватьОтборКомпоновкиДанных(ТекНастройки.Отбор, ИсточникДанных.КомпоновщикНастроек.ПолучитьНастройки().Отбор);

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(СхемаКомпоновки, ТекНастройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	Процессор = Новый ПроцессорКомпоновкиДанных;
	Процессор.Инициализировать(Макет);
	Вывод  = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	Результат = Новый ТаблицаЗначений;
	Вывод.УстановитьОбъект(Результат); 
	Вывод.Вывести(Процессор);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура СкопироватьОтборКомпоновкиДанных(ГруппаПриемник, ГруппаИсточник) 
	
	КоллекцияИсточник = ГруппаИсточник.Элементы;
	КоллекцияПриемник = ГруппаПриемник.Элементы;
	Для Каждого Элемент Из КоллекцияИсточник Цикл
		
		ТипЭлемента  = ТипЗнч(Элемент);
		НовыйЭлемент = КоллекцияПриемник.Добавить(ТипЭлемента);
		
		ЗаполнитьЗначенияСвойств(НовыйЭлемент, Элемент);
		Если ТипЭлемента = Тип("ГруппаЭлементовОтбораКомпоновкиДанных") Тогда
			СкопироватьОтборКомпоновкиДанных(НовыйЭлемент, Элемент) 
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
