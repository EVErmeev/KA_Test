﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	ФизическоеЛицо = СЭДОФССРасширенный.ФизическоеЛицоСотрудника(Сотрудник);
	СогласиеИОтзыв = РегистрыСведений.СогласияНаУведомленияОбЭЛН.ПолучитьПаруСогласиеИОтзывНаДату(
		Страхователь,
		ФизическоеЛицо,
		Дата);
	Если СогласиеИОтзыв = Неопределено Или Не ЗначениеЗаполнено(СогласиеИОтзыв.Согласие) Тогда
		ТекстОшибки = НСтр("ru = 'На %1 нет согласий, которые можно отозвать'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, Формат(Дата, "ДЛФ=D"));
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, ТекстОшибки, "Дата");
	ИначеЕсли ЗначениеЗаполнено(СогласиеИОтзыв.Отзыв) И СогласиеИОтзыв.Отзыв <> Ссылка Тогда
		ТекстОшибки = НСтр("ru = 'Согласие от %1 уже отозвано %2'");
		ТекстОшибки = СтрШаблон(ТекстОшибки, Формат(СогласиеИОтзыв.ДатаСогласия, "ДЛФ=D"), СогласиеИОтзыв.Отзыв);
		СообщенияБЗК.СообщитьОбОшибкеВОбъекте(Отказ, ЭтотОбъект, ТекстОшибки, "Дата");
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ДатаСоздания) Тогда
		ДатаСоздания = ТекущаяДата(); // АПК:143 Для фильтрации событий в журнале регистрации требуется дата сервера.
	КонецЕсли;
	
	Реквизиты = Реквизиты();
	ЗначенияРеквизитовДоЗаписи = ЗначенияРеквизитовДоЗаписи(Реквизиты);
	
	Если ЗначенияРеквизитовДоЗаписи = Неопределено
		Или ЗначенияРеквизитовДоЗаписи.Сотрудник <> Сотрудник Тогда
		ФизическоеЛицо = СЭДОФССРасширенный.ФизическоеЛицоСотрудника(Сотрудник);
	КонецЕсли;
	
	ПредставлениеИзменений = ПредставлениеИзменений(РежимЗаписи, Реквизиты, ЗначенияРеквизитовДоЗаписи);
	
	ДополнительныеСвойства.Вставить("ЗначенияРеквизитовДоЗаписи", ЗначенияРеквизитовДоЗаписи);
	ДополнительныеСвойства.Вставить("ПредставлениеИзменений", ПредставлениеИзменений);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		ЗаписьЖурналаРегистрации(
			СЭДОФССРасширенный.ИмяСобытияЖурнала(),
			УровеньЖурналаРегистрации.Примечание,
			Сотрудник.Метаданные(),
			Сотрудник,
			НСтр("ru = 'Состав изменений не вычислен, поскольку документ был записан в режиме отключения бизнес логики. Вероятно, он был изменен в другой информационной базе.'"),
			РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
		Возврат;
	КонецЕсли;
	
	РегистрыСведений.СогласияНаУведомленияОбЭЛН.Обновить(Страхователь, Сотрудник);
	
	ДоЗаписи = ДополнительныеСвойства.ЗначенияРеквизитовДоЗаписи;
	Если ДоЗаписи <> Неопределено
		И (ДоЗаписи.Сотрудник <> Сотрудник Или ДоЗаписи.Страхователь <> Страхователь) Тогда
		РегистрыСведений.СогласияНаУведомленияОбЭЛН.Обновить(ДоЗаписи.Страхователь, ДоЗаписи.Сотрудник);
	КонецЕсли;
	
	ПредставлениеИзменений = ДополнительныеСвойства.ПредставлениеИзменений;
	Если ПредставлениеИзменений <> "" Тогда
		ЗаписьЖурналаРегистрации(
			СЭДОФССРасширенный.ИмяСобытияЖурнала(),
			УровеньЖурналаРегистрации.Информация,
			Сотрудник.Метаданные(),
			Сотрудник,
			ПредставлениеИзменений,
			РежимТранзакцииЗаписиЖурналаРегистрации.Транзакционная);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция Реквизиты()
	Если ЭтоНовый() Тогда
		Возврат Неопределено;
	КонецЕсли;
	МетаданныеРеквизитов = Метаданные().Реквизиты;
	ИменаРеквизитов = Новый Массив;
	Для Каждого РеквизитМетаданных Из МетаданныеРеквизитов Цикл
		ИменаРеквизитов.Добавить(РеквизитМетаданных.Имя);
	КонецЦикла;
	Возврат Новый Структура("Имена, Метаданные", ИменаРеквизитов, МетаданныеРеквизитов);
КонецФункции

Функция ЗначенияРеквизитовДоЗаписи(Реквизиты)
	Если ЭтоНовый() Тогда
		Возврат Неопределено;
	КонецЕсли;
	ИменаРеквизитовСтрокой = СтрСоединить(Реквизиты.Имена, ",") + ",Дата,Проведен,ПометкаУдаления";
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, ИменаРеквизитовСтрокой);
КонецФункции

Функция ПредставлениеИзменений(РежимЗаписи, Реквизиты, ЗначенияРеквизитовДоЗаписи)
	Если ЭтоНовый() Тогда
		Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
			Возврат НСтр("ru = 'Документ создан и проведен.'");
		Иначе
			Возврат НСтр("ru = 'Документ создан, но не проведен.'");
		КонецЕсли;
	КонецЕсли;
	
	ПредставлениеИзменений = "";
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		БудетПроведен = Истина;
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		БудетПроведен = Ложь;
	Иначе
		БудетПроведен = Проведен;
	КонецЕсли;
	Если БудетПроведен <> ЗначенияРеквизитовДоЗаписи.Проведен Тогда
		Если БудетПроведен Тогда
			ДобавитьТекст(ПредставлениеИзменений, НСтр("ru = 'Документ проведен'"));
		Иначе
			ДобавитьТекст(ПредставлениеИзменений, НСтр("ru = 'Отменено проведение документа'"));
		КонецЕсли;
	КонецЕсли;
	
	Если ПометкаУдаления <> ЗначенияРеквизитовДоЗаписи.ПометкаУдаления Тогда
		Если ПометкаУдаления Тогда
			ДобавитьТекст(ПредставлениеИзменений, НСтр("ru = 'Установлена пометка удаления'"));
		Иначе
			ДобавитьТекст(ПредставлениеИзменений, НСтр("ru = 'Снята пометка удаления'"));
		КонецЕсли;
	КонецЕсли;
	
	ИзмененныеРеквизитыПодробно = Новый Массив;
	Для Каждого ИмяРеквизита Из Реквизиты.Имена Цикл
		Если ЭтотОбъект[ИмяРеквизита] <> ЗначенияРеквизитовДоЗаписи[ИмяРеквизита] Тогда
			ИзмененныеРеквизитыПодробно.Добавить(СтрШаблон(
				НСтр("ru = '%1 (было %2, стало %3)'"),
				Реквизиты.Метаданные[ИмяРеквизита].Представление(),
				ПредставлениеЗначения(ЗначенияРеквизитовДоЗаписи[ИмяРеквизита]),
				ПредставлениеЗначения(ЭтотОбъект[ИмяРеквизита])));
		КонецЕсли;
	КонецЦикла;
	
	Если ИзмененныеРеквизитыПодробно.Количество() > 0 Тогда
		Если ПредставлениеИзменений = "" Тогда
			ПредставлениеИзменений = НСтр("ru = 'Изменены реквизиты:'");
		Иначе
			ПредставлениеИзменений = ПредставлениеИзменений + ", " + НСтр("ru = 'а также изменены реквизиты:'");
		КонецЕсли;
		Разделитель = Символы.ПС + "  • ";
		ПредставлениеИзменений = ПредставлениеИзменений + Разделитель + СтрСоединить(ИзмененныеРеквизитыПодробно, ";" + Разделитель) + ".";
	ИначеЕсли ПредставлениеИзменений <> "" Тогда
		ПредставлениеИзменений = ПредставлениеИзменений + ".";
	КонецЕсли;
	
	Возврат ПредставлениеИзменений;
КонецФункции

Процедура ДобавитьТекст(Текст, ДобавляемыйТекст, Разделитель = ", ")
	Если Текст = "" Тогда
		Текст = ДобавляемыйТекст;
	Иначе
		Текст = Текст + Разделитель + ДобавляемыйТекст;
	КонецЕсли;
КонецПроцедуры

Функция ПредставлениеЗначения(Значение)
	Возврат ?(ЗначениеЗаполнено(Значение), """" + Значение + """", НСтр("ru = 'не заполнено'"));
КонецФункции

#КонецОбласти


#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли