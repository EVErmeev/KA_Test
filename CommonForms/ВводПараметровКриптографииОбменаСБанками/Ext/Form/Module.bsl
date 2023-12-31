﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	МодельСервиса = ОбщегоНазначения.РазделениеВключено();
	
	Если НЕ Параметры.Свойство("ОтпечатокСертификата") Тогда
		Организация			= Параметры.Организация;
		Сервис				= Параметры.Сервис;
		Если ЗначениеЗаполнено(Сервис) Тогда
			СертификатАбонента 	= УниверсальныйОбменСБанкамиВызовСервера.
				СертификатОрганизации(Сервис, Организация);
			ЗапомнитьСертификат = УниверсальныйОбменСБанкамиВызовСервера.
				ПризнакЗапомнитьСертификатОрганизации(Сервис, Организация);
		КонецЕсли;
		Если Параметры.Свойство("ПараметрыОтбора") Тогда
			ПараметрыОтбора = Параметры.ПараметрыОтбора;
		Иначе
			ПараметрыОтбора = УниверсальныйОбменСБанкамиКлиентСервер.
				ПараметрыОтбораСертификата(Сервис, Организация);
		КонецЕсли;
	Иначе
		СертификатАбонента 	= Параметры.ОтпечатокСертификата;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СертификатАбонента) Тогда
		ЭтоОблачныйСертификат = УниверсальныйОбменСБанкамиВызовСервера.ЭтоОблачныйСертификатПользователя(СертификатАбонента);
	КонецЕсли;
	
	Если Параметры.Свойство("ВозможностьВыбораСертификата", ВозможностьВыбораСертификата) Тогда
		Элементы.СертификатАбонентаПредставление.ТолькоПросмотр = НЕ Параметры.ВозможностьВыбораСертификата;
	КонецЕсли;
	
	Если Параметры.Свойство("НазваниеКнопки") Тогда
		Если НЕ ПустаяСтрока(Параметры.НазваниеКнопки) Тогда
			Элементы.ФормаОК.Заголовок = Параметры.НазваниеКнопки;
		КонецЕсли;
	КонецЕсли;
	
	ОтображатьПолеВводаПароля = Истина;
	Если Параметры.Свойство("ОтображатьПолеВводаПароля") Тогда
		ОтображатьПолеВводаПароля = Параметры.ОтображатьПолеВводаПароля;
		Если ОтображатьПолеВводаПароля Тогда
			ВызватьИсключение(НСтр("ru='Пароль к секретному ключу вводится средствами ОС.'"));
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("ТекстПодсказкиПоСертификату") Тогда
		ТекстПодсказкиПоСертификату = Параметры.ТекстПодсказкиПоСертификату;
	КонецЕсли;
	
	Если Параметры.Свойство("Заголовок") И НЕ ПустаяСтрока(Параметры.Заголовок) Тогда
		ЭтотОбъект.Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	ОтображатьФлагЗапомнитьВыборСертификата = Ложь;
	Если Параметры.Свойство("ОтображатьФлагЗапомнитьВыборСертификата") Тогда
		ОтображатьФлагЗапомнитьВыборСертификата = Параметры.ОтображатьФлагЗапомнитьВыборСертификата;
	КонецЕсли;
	
	Если ОтображатьФлагЗапомнитьВыборСертификата И ЗначениеЗаполнено(Сервис) И НЕ ОтображатьПолеВводаПароля Тогда
		Элементы.ЗапомнитьВыборСертификата.Видимость = Истина;
		Шаблон = НСтр("ru='Запомнить сертификат для сервиса ""%1""'");
		Элементы.ЗапомнитьВыборСертификата.Заголовок = СтрШаблон(Шаблон, Сервис);
	Иначе
		Элементы.ЗапомнитьВыборСертификата.Видимость = Ложь;
	КонецЕсли;

	СогласованоОтсутствиеМеткиВремени = Истина;
	ДоступнаУсовершенствованнаяПодпись = УниверсальныйОбменСБанкамиВызовСервера.ДоступнаУсовершенствованнаяПодпись();
	Если Параметры.Свойство("ДобавитьМеткуДоверенногоВремени") Тогда
		ДобавитьМеткуДоверенногоВремени = Параметры.ДобавитьМеткуДоверенногоВремени;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(СертификатАбонента) Тогда
		// Запускаем проверку подставленного по умолчанию сертификата.
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьСертификат", 0.2, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВвод(Команда)
	
	Если НЕ ЗначениеЗаполнено(СертификатАбонента) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Сертификат криптографии не выбран, его необходимо указать для продолжения формирования сообщения.'"),
			,"СертификатАбонентаПредставление");
		Возврат;
	КонецЕсли;
	
	Если СертификатНеНайденВХранилище Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru='Выбран сертификат криптографии, который не найден в хранилище сертификатов.
				|Выберите сертификат из хранилища.'"),
			,"СертификатАбонентаПредставление");
		Возврат;
	КонецЕсли;
	
	Если ЭтоОблачныйСертификат Тогда
		Оповещение = Новый ОписаниеОповещения("ПроверитьПослеИнициализацииОблачнойКриптографии", ЭтотОбъект);
		УниверсальныйОбменСБанкамиКлиент.ИнициализироватьСервисКриптографии(СертификатАбонента, Оповещение);
	Иначе
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбработатьВводЗавершение", ЭтотОбъект);
		УниверсальныйОбменСБанкамиКлиент.ПроверитьСертификат(ОповещениеОЗавершении, СертификатАбонента, , Ложь);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьВводЗавершение(РезультатПроверки, ДополнительныеПараметры) Экспорт

	ТекстОшибки = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатПроверки, "ОписаниеОшибки", "");
	Валиден     = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатПроверки, "Валиден", Ложь);

	Если Валиден <> Истина Тогда
		Если НЕ ЗначениеЗаполнено(ТекстОшибки) Тогда
			ТекстОшибки = НСтр("ru = 'Возникла неизвестная ошибка при проверке сертификата. Попробуйте выбрать другой сертификат.'");
		КонецЕсли;
		ПоказатьПредупреждение(, ТекстОшибки);
		
		Возврат;
	КонецЕсли;
	
	СохранитьСертификатИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПослеИнициализацииОблачнойКриптографии(Результат, ДополнительныеПараметры) Экспорт

	Если Результат.Выполнено Тогда
		РезультатПроверки = ПроверитьВСервисе(СертификатАбонента);
		Если РезультатПроверки = Ложь Тогда
			ПоказатьПредупреждение(, НСтр("ru = 'Сертификат не действителен. Попробуйте выбрать другой сертификат.'"));
			Возврат;
		КонецЕсли;
	Иначе
		ПоказатьПредупреждение(, Результат.ОписаниеОшибки);
		Возврат;
	КонецЕсли;
	
	СохранитьСертификатИЗакрыть();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СогласованоОтсутствиеМеткиВремениПриИзменении(Элемент)
	УправлениеДоступностью();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьСертификат()

	Если ЭтоОблачныйСертификат Тогда
		ОтобразитьПредставлениеСертификата();
	Иначе

		ОповещениеОЗавершении = Новый ОписаниеОповещения("ПроверитьСертификатЗавершение", ЭтотОбъект);

		УниверсальныйОбменСБанкамиКлиент.ПроверитьСертификат(ОповещениеОЗавершении, СертификатАбонента, , Ложь);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСертификатЗавершение(РезультатПроверки, ДополнительныеПараметры) Экспорт
	
	Валиден = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(РезультатПроверки, "Валиден", Ложь);
	Если Валиден = Истина Тогда
		ОтобразитьПредставлениеСертификата();
	Иначе
		// Очистим подставленный по умолчанию сертификат, т.к. он не прошел проверку.
		СертификатАбонента = "";
		СертификатАбонентаПредставление = "";
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	Оповещение = Новый ОписаниеОповещения(
		"СертификатАбонентаПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура("Элемент", Элемент));

	УниверсальныйОбменСБанкамиКлиент.ВыбратьСертификат(
		Оповещение, СертификатАбонента, ПараметрыОтбора);

КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Элемент = ДополнительныеПараметры.Элемент;
	
	Если Результат.Выполнено Тогда
		СертификатАбонента = Результат.ВыбранноеЗначение.Отпечаток;
		
		ОтобразитьПредставлениеСертификата();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДанныеСертификата(Отпечаток)
	
	ОблачныйСертификат = УниверсальныйОбменСБанками.НайтиОблачныйСертификатВХранилище(Отпечаток);
	Если ОблачныйСертификат <> Неопределено Тогда
		Сертификат = УниверсальныйОбменСБанкамиКлиентСервер.СертификатКриптографииВСтуктуру(
			Новый СертификатКриптографии(ОблачныйСертификат.Сертификат));
		Возврат Сертификат;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура СертификатАбонентаПредставлениеОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ПустаяСтрока(СертификатАбонента) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭтоОблачныйСертификат Тогда
		ДанныеСертификата = ДанныеСертификата(СертификатАбонента);
		Если ДанныеСертификата <> Неопределено Тогда
			ПараметрыФормы = Новый Структура("Сертификат", ДанныеСертификата);
			ОткрытьФорму(
				"ОбщаяФорма.ПросмотрСертификатаОбменаСБанками", ПараметрыФормы,
				ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
	Иначе
		УниверсальныйОбменСБанкамиКлиент.ПоказатьСертификат(
			Новый Структура("Отпечаток, ЭтоЭлектроннаяПодписьВМоделиСервиса",
			СертификатАбонента, ЭтоОблачныйСертификат));
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СертификатАбонентаПредставлениеОчистка(Элемент, СтандартнаяОбработка)
	
	СертификатАбонента = "";
	ОтобразитьПредставлениеСертификата();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьПредставлениеСертификата()
	
	ЭтоОблачныйСертификат = УниверсальныйОбменСБанкамиКлиент.ЭтоОблачныйСертификатПользователя(СертификатАбонента);
		
	ПараметрыОтображенияСертификата = УниверсальныйОбменСБанкамиКлиент.ПараметрыОтобразитьПредставленияСертификатов();
	ПараметрыОтображенияСертификата.ПолеВвода								= Элементы.СертификатАбонентаПредставление;
	ПараметрыОтображенияСертификата.Сертификат								= СертификатАбонента;
	ПараметрыОтображенияСертификата.ИмяРеквизитаПредставлениеСертификата	= "СертификатАбонентаПредставление";
	ПараметрыОтображенияСертификата.Форма 									= ЭтотОбъект;
	ПараметрыОтображенияСертификата.ЭтоОблачныйСертификат					= ЭтоОблачныйСертификат;
	ПараметрыОтображенияСертификата.ТекстПодсказкиПоСертификату 			= ТекстПодсказкиПоСертификату;
	
	Оповещение = Новый ОписаниеОповещения("ОтобразитьПредставлениеСертификатаЗавершение", ЭтотОбъект);
	УниверсальныйОбменСБанкамиКлиент.
		ОтобразитьПредставлениеСертификата(Оповещение,ПараметрыОтображенияСертификата);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьПредставлениеСертификатаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	СвойстваСертификата = Результат.СвойстваСертификата;
	Если Результат.Выполнено Тогда
		СертификатНеНайденВХранилище = Результат.СертификатНеНайденВХранилище;
		Если НЕ СертификатНеНайденВХранилище Тогда
			Если СвойстваСертификата <> Неопределено Тогда
				РезультатПроверки = УниверсальныйОбменСБанкамиКлиентСервер.СертификатСоответствуетОтбору(СвойстваСертификата, ПараметрыОтбора);
				Если НЕ РезультатПроверки.ПризнакСоответствия Тогда
					// Если сертификат не подходит по критериям очищаем его.
					СертификатАбонента = "";
					ОтобразитьПредставлениеСертификата();
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	Иначе
		СертификатНеНайденВХранилище = Истина;
	КонецЕсли;

	ВывестиПредупреждениеНаФорму();
	
КонецПроцедуры 

&НаКлиенте
Процедура ВывестиПредупреждениеНаФорму()
	
	ВыводитьПредупреждениеНаФорму = ДобавитьМеткуДоверенногоВремени 
		И Не ДоступнаУсовершенствованнаяПодпись
		И Не ЭтоОблачныйСертификат
		И Не МодельСервиса;
		
	Если ВыводитьПредупреждениеНаФорму Тогда

		Элементы.НедоступностьМеткиДоверенногоВремени.Заголовок = 
		НСтр("ru='Банку требуется отчетность с электронной подписью, содержащей метки доверенного времени.
			|Их поддержка реализована в платформе 1С:Предприятие, начиная с версии 8.3.20.1838.
			|Для подписания отчетности обновите версию платформы.'");
			
		Элементы.ГруппаМеткиДоверенногоВремени.Видимость = Истина;
		СогласованоОтсутствиеМеткиВремени = Ложь;
	Иначе
		СогласованоОтсутствиеМеткиВремени = Истина;
		Элементы.ГруппаМеткиДоверенногоВремени.Видимость = Ложь;
	КонецЕсли;
	
	УправлениеДоступностью();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьСертификатИЗакрыть()

	// Обновляем настройки обмена с банками.
	Если ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(Сервис) Тогда
		УниверсальныйОбменСБанкамиВызовСервера.
			СохранитьСертификатОрганизации(Сервис, Организация, СертификатАбонента, ЗапомнитьСертификат);
	КонецЕсли;
	
	Результат = Новый Структура();
	
	Результат.Вставить("Пароль",                          "");
	Результат.Вставить("Сертификат",                      СертификатАбонента);
	Результат.Вставить("ЭтоОблачныйСертификат",           ЭтоОблачныйСертификат);
	Результат.Вставить("ДобавитьМеткуДоверенногоВремени", ДобавитьМеткуДоверенногоВремени
														  И ДоступнаУсовершенствованнаяПодпись
														  И Не ЭтоОблачныйСертификат);

	Закрыть(Результат);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПроверитьВСервисе(СертификатАбонента)
	
	ОблачныйСертификат = УниверсальныйОбменСБанками.НайтиОблачныйСертификатВХранилище(СертификатАбонента);
	Если ОблачныйСертификат <> Неопределено Тогда
		РезультатПроверки = СервисКриптографии.ПроверитьСертификат(ОблачныйСертификат.Сертификат);
		Возврат РезультатПроверки;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура УправлениеДоступностью()
	Элементы.ФормаОК.Доступность = СогласованоОтсутствиеМеткиВремени;
КонецПроцедуры

#КонецОбласти
