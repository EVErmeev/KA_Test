﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
  	Если Параметры.Свойство("АвтоТест") Тогда
   		Возврат;
  	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "Организация, ОтчетныйГод");
	
	УстановитьПараметрыИОтборДляДинамическогоСписка(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьНастроекНалоговУчетныхПолитик"
		ИЛИ ИмяСобытия = "УчастникКонтролируемойСделкиЗаписан"
		ИЛИ ИмяСобытия = "Запись_Организации"
		ИЛИ ИмяСобытия = "ВзаимозависимыеЛица_Записан" Тогда
		
		Элементы.ВзаимозависимыеЛица.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ВзаимозависимыеЛицаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Контрагент = Элемент.ТекущиеДанные.Контрагент;
	АктуальнаяДата = Элемент.ТекущиеДанные.АктуальнаяДатаВзаимозависимогоЛица;
	ПараметрыОткрытия = ПараметрыОткрытияФормыВзаимозависимогоЛица(Организация, Контрагент, АктуальнаяДата);
	ПараметрыОткрытия.Вставить("ПериодДанныхКонтрагента", Элементы.ВзаимозависимыеЛица.ТекущиеДанные.НачалоПериода);
	ОткрытьФорму("РегистрСведений.ВзаимозависимыеЛица.ФормаЗаписи", ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетныйГодПриИзменении(Элемент)
	УстановитьПараметрыИОтборДляДинамическогоСписка(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	УстановитьПараметрыИОтборДляДинамическогоСписка(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьПоОрганизации(Команда)
	
	ПараметрыДляПередачи = Новый Структура("Организация", Организация);
	ОткрытьФорму("РегистрСведений.ВзаимозависимыеЛица.Форма.ФормаЗаполнения", ПараметрыДляПередачи, ЭтаФорма, Ложь, 
					, , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВзаимозависимоеЛицо(Команда)
	
	СтруктураЗаполнения = Новый Структура("Организация, Период", Организация, Дата(ОтчетныйГод, 1, 1));
	ПараметрыОткрытия = Новый Структура("ЗначенияЗаполнения, ДоступностьКлючевыхЗаписей", СтруктураЗаполнения, Истина);
	ОткрытьФорму("РегистрСведений.ВзаимозависимыеЛица.ФормаЗаписи", ПараметрыОткрытия, Элементы.ВзаимозависимыеЛица);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВзаимозависимоеЛицоКопированием(Команда)
	
	Если Элементы.ВзаимозависимыеЛица.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураЗаполнения = Новый Структура("Организация, Период", Организация, Дата(ОтчетныйГод, 1, 1));
	СтруктураЗаполнения.Вставить("Контрагент", Элементы.ВзаимозависимыеЛица.ТекущиеДанные.Контрагент);
	СтруктураЗаполнения.Вставить("ТипВзаимозависимости", Элементы.ВзаимозависимыеЛица.ТекущиеДанные.ТипВзаимозависимости);
	ПараметрыОткрытия = Новый Структура("ЗначенияЗаполнения, ДоступностьКлючевыхЗаписей", СтруктураЗаполнения, Истина);
	ОткрытьФорму("РегистрСведений.ВзаимозависимыеЛица.ФормаЗаписи", ПараметрыОткрытия, Элементы.ВзаимозависимыеЛица);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВзаимозависимоеЛицо(Команда)
	
	Если Элементы.ВзаимозависимыеЛица.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контрагент = Элементы.ВзаимозависимыеЛица.ТекущиеДанные.Контрагент;
	АктуальнаяДата = Элементы.ВзаимозависимыеЛица.ТекущиеДанные.АктуальнаяДатаВзаимозависимогоЛица;
	ПараметрыОткрытия = ПараметрыОткрытияФормыВзаимозависимогоЛица(Организация, Контрагент, АктуальнаяДата);
															
	ПараметрыОткрытия.Вставить("ПериодДанныхКонтрагента", Элементы.ВзаимозависимыеЛица.ТекущиеДанные.НачалоПериода);
	ОткрытьФорму("РегистрСведений.ВзаимозависимыеЛица.ФормаЗаписи", ПараметрыОткрытия, Элементы.ВзаимозависимыеЛица);
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВзаимозависимоеЛицо(Команда)
	
	Если Элементы.ВзаимозависимыеЛица.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Контрагент = Элементы.ВзаимозависимыеЛица.ТекущиеДанные.Контрагент;
	АктуальнаяДата = Элементы.ВзаимозависимыеЛица.ТекущиеДанные.АктуальнаяДатаВзаимозависимогоЛица;
	УдалитьЗаписьРегистра(Организация, Контрагент, АктуальнаяДата);
	Элементы.ВзаимозависимыеЛица.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыИОтборДляДинамическогоСписка(Форма)
	
	Форма.ВзаимозависимыеЛица.Параметры.УстановитьЗначениеПараметра("НачалоГода", Дата(Форма.ОтчетныйГод, 1, 1));
	Форма.ВзаимозависимыеЛица.Параметры.УстановитьЗначениеПараметра("КонецГода", Дата(Форма.ОтчетныйГод+1, 1, 1)-1);
	Форма.ВзаимозависимыеЛица.Параметры.УстановитьЗначениеПараметра("Организация", Форма.Организация);
	Форма.Элементы.ВзаимозависимыеЛица.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПараметрыОткрытияФормыВзаимозависимогоЛица(Организация, Контрагент, Период)
	Возврат РегистрыСведений.ВзаимозависимыеЛица.ПолучитьПараметрыОткрытияФормыЗаписиВзаимозависимогоЛица(Организация, Контрагент, Период);
КонецФункции

&НаСервереБезКонтекста
Процедура УдалитьЗаписьРегистра(Организация, Контрагент, Период)
	НаборРегистра = РегистрыСведений.ВзаимозависимыеЛица.СоздатьНаборЗаписей();
	НаборРегистра.Отбор.Организация.Значение = Организация;
	НаборРегистра.Отбор.Организация.Использование = Истина;
	НаборРегистра.Отбор.Контрагент.Значение = Контрагент;
	НаборРегистра.Отбор.Контрагент.Использование = Истина;
	НаборРегистра.Отбор.Период.Значение = Период;
	НаборРегистра.Отбор.Период.Использование = Истина;
	НаборРегистра.Записать();
КонецПроцедуры

#КонецОбласти
