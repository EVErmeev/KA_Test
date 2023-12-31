﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры = Неопределено Тогда
		Отказ = Истина;
	Иначе
		Подразделение = Параметры.Подразделение;
		Показатель = Параметры.Показатель;
		ЗначениеПоказателя = Параметры.ЗначениеПоказателя;
		Период = Параметры.ДействуетС;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	МесяцСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(Период);;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДействуетСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("МесяцСтрокаНачалоВыбораЗавершение", ЭтотОбъект);
	ОбщегоНазначенияУТКлиент.НачалоВыбораПредставленияПериодаРегистрации(Элемент, СтандартнаяОбработка, Период, ЭтаФорма, Оповещение);
	
КонецПроцедуры

// Продолжение процедуры ДействуетСНачалоВыбора, см. выше
//
&НаКлиенте
Процедура МесяцСтрокаНачалоВыбораЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранныйПериод <> Неопределено Тогда
		Период = ВыбранныйПериод;
		МесяцСтрока = ОбщегоНазначенияУТКлиент.ПолучитьПредставлениеПериодаРегистрации(Период);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДействуетСРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	ОбщегоНазначенияУТКлиент.РегулированиеПредставленияПериодаРегистрации(Направление, СтандартнаяОбработка, Период, МесяцСтрока);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	
	Если ЗаписатьНастройкуЗначенийПоказателей() Тогда
		
		Оповестить("Установка_НастройкаЗначенийПоказателейДляРаспределенияРасходов");
		
		ЗначенияПоказалей = Новый Структура();
		ЗначенияПоказалей.Вставить("Подразделение",      Подразделение);
		ЗначенияПоказалей.Вставить("Показатель",         Показатель);
		ЗначенияПоказалей.Вставить("ЗначениеПоказателя", ЗначениеПоказателя);
		ЗначенияПоказалей.Вставить("Период",             Период);
		
		Закрыть(ЗначенияПоказалей);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ЗаписатьНастройкуЗначенийПоказателей()
	
	Попытка
		МенеджерЗаписи = РегистрыСведений.ЗначенияПоказателейДляРаспределенияРасходов.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Период = Период;
		МенеджерЗаписи.Подразделение = Подразделение;
		МенеджерЗаписи.Показатель = Показатель;
		МенеджерЗаписи.ЗначениеПоказателя = ЗначениеПоказателя;
		МенеджерЗаписи.Записать();
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти






