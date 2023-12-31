﻿
&НаКлиенте
Процедура OK(Команда)
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстанавливаемыеПараметры = Новый Структура("Организация, Период");
	ЗаполнитьЗначенияСвойств(УстанавливаемыеПараметры, Параметры);
	УстановитьПараметрыФункциональныхОпцийФормы(УстанавливаемыеПараметры);
	
	Параметры.Свойство("ФизическоеЛицо", ФизическоеЛицо);
	Параметры.Свойство("Период", Период);
	Параметры.Свойство("Организация", Организация);
	Параметры.Свойство("ИтогВзносы", ИтогВзносы);
	Для каждого ИмяПоля Из СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(УчетСтраховыхВзносовКлиентСервер.РассчитываемыеВзносы(Ложь,,Ложь)) Цикл
		Параметры.Свойство(ИмяПоля, ЭтаФорма[ИмяПоля]);
	КонецЦикла;
	
	УчетСтраховыхВзносов.УстановитьВидимостьКолонокТаблицыСтраховыхВзносов(ЭтотОбъект, Период,"");
	
КонецПроцедуры
