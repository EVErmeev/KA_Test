﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Команда = Метаданные.Обработки.ОбщиеФормыСЭДОФСС.Команды.ПолучитьСообщенияСЭДОФССЗаПериод;
	НавигационнаяСсылка = "e1cib/command/" + Команда.ПолноеИмя();
	
	Страхователи.ЗагрузитьЗначения(ЭлектронныйДокументооборотСФСС.ОрганизацииИспользующиеОбменФСС());
	
	ДатаОкончания = ТекущаяДатаСеанса();
	ДатаНачала = ДатаОкончания - 86400;
	
	ОтборыПоОрганизациям = СЭДОФССКлиентСервер.ОтборыПоОрганизациямФормы(Параметры);
	Если ОтборыПоОрганизациям <> Неопределено Тогда
		Отмеченные = СЭДОФССВызовСервера.СтрахователиИзОтборовПоОрганизациямФормы(ОтборыПоОрганизациям);
		Для Каждого Страхователь Из Отмеченные Цикл
			ЭлементСписка = Страхователи.НайтиПоЗначению(Страхователь);
			Если ЭлементСписка <> Неопределено Тогда
				ЭлементСписка.Пометка = Истина;
				АвтоматическоеСохранениеДанныхВНастройках = АвтоматическоеСохранениеДанныхФормыВНастройках.НеИспользовать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	Выбранные = ВыбранныеСтрахователи.ВыгрузитьЗначения();
	Для Каждого Страхователь Из Выбранные Цикл
		ЭлементСписка = Страхователи.НайтиПоЗначению(Страхователь);
		Если ЭлементСписка <> Неопределено Тогда
			ЭлементСписка.Пометка = Истина;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПолучитьСообщения(Команда)
	Состояние(НСтр("ru = 'Получение списка сообщений...'"), , , БиблиотекаКартинок.ДлительнаяОперация24БЗК);
	Ошибки = Новый Массив;
	ИдентификаторыСообщений = ИдентификаторыСообщенийСтрахователей(Ошибки);
	Если Ошибки.Количество() > 0 Тогда
		ИнформированиеПользователяКлиент.ПоказатьПодробности(
			СтрСоединить(Ошибки, Символы.ПС + Символы.ПС + "----------" + Символы.ПС + Символы.ПС),
			НСтр("ru = 'Ошибки при получении списка сообщений'"));
	КонецЕсли;
	Если ИдентификаторыСообщений <> Неопределено Тогда
		Закрыть();
		СЭДОФССКлиент.ПовторноПолучитьСообщенияИзФСС(ИдентификаторыСообщений);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ИдентификаторыСообщенийСтрахователей(Ошибки)
	МассивСтрахователей = Новый Массив;
	Для Каждого ЭлементСписка Из Страхователи Цикл
		Если ЭлементСписка.Пометка И ЗначениеЗаполнено(ЭлементСписка.Значение) Тогда
			ОбщегоНазначенияБЗК.ДобавитьЗначениеВМассив(МассивСтрахователей, ЭлементСписка.Значение);
		КонецЕсли;
	КонецЦикла;
	Если МассивСтрахователей.Количество() = 0 Тогда
		ТекстОшибки = НСтр("ru = 'Необходимо выбрать организацию'");
		СообщенияБЗККлиентСервер.СообщитьВФорме(ТекстОшибки, "Страхователи");
		Возврат Неопределено;
	КонецЕсли;
	Если Не ПроверкиБЗККлиентСервер.ПериодСоответствуетТребованиям(
			ЭтотОбъект,
			"",
			"ДатаНачала",
			"ДатаОкончания",
			НСтр("ru = 'получения сообщений'")) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВыбранныеСтрахователи.ЗагрузитьЗначения(МассивСтрахователей);
	ВыбранныеСтрахователи.ЗаполнитьПометки(Ложь);
	
	ИдентификаторыСообщенийСтрахователей = Новый Соответствие;
	Ошибки = Новый Массив;
	МассивДат = ОбщегоНазначенияБЗК.МассивДатИзПериода(ДатаНачала, ДатаОкончания);
	Для Каждого Страхователь Из МассивСтрахователей Цикл
		Идентификаторы = Новый Массив;
		ОшибкиСтрахователя = Новый Массив;
		Для Каждого Дата Из МассивДат Цикл
			Результат = ЭлектронныйДокументооборотСФСС.МетаданныеВходящихСообщенийСЭДОФСС(Страхователь, Дата);
			Если ЗначениеЗаполнено(Результат.ОписаниеОшибки) Тогда
				ОшибкиСтрахователя.Добавить(Формат(Дата, "ДЛФ=D") + ": " + Результат.ОписаниеОшибки);
			КонецЕсли;
			Если ТипЗнч(Результат.ДанныеСообщений) = Тип("Массив") Тогда
				Для Каждого ДанныеСообщения Из Результат.ДанныеСообщений Цикл
					ОбщегоНазначенияБЗК.ДобавитьЗначениеВМассив(Идентификаторы, ДанныеСообщения.Идентификатор);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		Если ОшибкиСтрахователя.Количество() > 0 Тогда
			Ошибки.Добавить(Строка(Страхователь) + ":" + Символы.ПС + СтрСоединить(ОшибкиСтрахователя, Символы.ПС));
		КонецЕсли;
		ИдентификаторыСообщенийСтрахователей.Вставить(Страхователь, Идентификаторы);
	КонецЦикла;
	
	Возврат ИдентификаторыСообщенийСтрахователей;
КонецФункции

#КонецОбласти
