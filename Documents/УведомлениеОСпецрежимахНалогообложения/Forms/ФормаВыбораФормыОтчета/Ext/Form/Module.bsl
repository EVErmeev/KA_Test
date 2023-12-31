﻿#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Данные = Неопределено;
	Параметры.Свойство("Данные", Данные);
	АдресДанные = ПоместитьВоВременноеХранилище(Данные, УникальныйИдентификатор);

	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("ЗначениеКопирования", ЗначениеКопирования);
	Параметры.Свойство("ИмяОтчета", ИмяОтчета);
	Параметры.Свойство("ВидУведомления", ВидУведомления);
	ТФ = Отчеты[ИмяОтчета].ПолучитьТаблицуФорм();
	ЗначениеВРеквизитФормы(ТФ, "ТаблицаФорм");
	
	СписокВыбора = Элементы.ПолеРедакцияФормы.СписокВыбора;
	СписокВыбора.Очистить();
	ТДС = ТекущаяДатаСеанса();
	Для Каждого Стр Из ТФ Цикл 
		Если ЗначениеЗаполнено(ВидУведомления) 
			И ЗначениеЗаполнено(Стр.ВидУведомления)
			И ВидУведомления <> Стр.ВидУведомления Тогда 
			
			Продолжить;
		КонецЕсли;
		СписокВыбора.Добавить(Стр.ИмяФормы, Стр.ОписаниеФормы);
		Если (ЗначениеЗаполнено(Стр.ДатаНачала) И НачалоДня(Стр.ДатаНачала) > ТДС)
			Или (ЗначениеЗаполнено(Стр.ДатаКонца) И КонецДня(Стр.ДатаКонца) < ТДС) Тогда 
			
			Продолжить;
		КонецЕсли;
		ПолеРедакцияФормы = Стр.ИмяФормы;
	КонецЦикла;
	
	Элементы.Создать.Доступность = ЗначениеЗаполнено(Организация) И ЗначениеЗаполнено(ПолеРедакцияФормы);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	Элементы.Создать.Доступность = ЗначениеЗаполнено(Организация);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы
&НаКлиенте
Процедура Создать(Команда)
	Данные = ПолучитьИзВременногоХранилища(АдресДанные);
	ПараметрыОткрытия = Новый Структура("Организация, ЗначениеКопирования, Данные, ВидУведомления",
											Организация, ЗначениеКопирования, Данные, ВидУведомления);
	ОткрытьФорму("Отчет."+ИмяОтчета+".Форма."+ПолеРедакцияФормы, ПараметрыОткрытия, ВладелецФормы, Истина);
	Закрыть();
КонецПроцедуры

#КонецОбласти