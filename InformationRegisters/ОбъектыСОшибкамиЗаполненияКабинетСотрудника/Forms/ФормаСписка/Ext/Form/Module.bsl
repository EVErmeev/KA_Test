﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗарплатаКадры.ПриСозданииНаСервереФормыСДинамическимСписком(ЭтотОбъект, "Список");
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОбновитьСписокОшибокЗаполненияКабинетСотрудника" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПроверитьЗаполнениеОбъектов(Команда)
	НачатьПроверкуЗаполнения();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НачатьПроверкуЗаполнения()

	ДлительнаяОперация = ДлительнаяОперацияПроверкаЗаполнения();
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Истина;
	ПараметрыОжидания.ОповещениеПользователя.Показать = Истина;
	ПараметрыОжидания.ОповещениеПользователя.Текст = НСтр("ru = 'Проверка заполнения публикуемых объектов выполнена.'");
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ПроверкаЗаполненияЗавершение", ЭтотОбъект);
	ДлительныеОперацииКлиент.ОжидатьЗавершение(ДлительнаяОперация, ОповещениеОЗавершении, ПараметрыОжидания);

КонецПроцедуры

&НаСервере
Функция ДлительнаяОперацияПроверкаЗаполнения()

	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.Вставить("НаименованиеФоновогоЗадания", НСтр("ru = 'Проверка заполнения публикуемых объектов'"));
	ПараметрыВыполненияВФоне.ОжидатьЗавершение = 0;
	Возврат ДлительныеОперации.ВыполнитьВФоне(
		"КабинетСотрудника.ПроверитьЗаполнениеПубликуемыхОбъектовФоновоеЗадание",
		Неопределено,
		ПараметрыВыполненияВФоне);

КонецФункции

&НаКлиенте
Процедура ПроверкаЗаполненияЗавершение(ДлительнаяОперация, ДополнительныеПараметры = Неопределено) Экспорт
	
	Элементы.Список.Обновить();
	
	Если ДлительнаяОперация = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ДлительнаяОперация.Статус = "Ошибка" Тогда
		ПоказатьПредупреждение(, ДлительнаяОперация.КраткоеПредставлениеОшибки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти



