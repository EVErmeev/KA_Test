﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий
	
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	// Проверим изменения в в наборе записей проводов и если изменения есть - зарегистрируем операции к закрытию месяца.
	// Текущее состояние набора помещается во временную таблицу,
	// чтобы при записи получить изменение нового набора относительно текущего.
	
	ТекстыЗапросовДляПолученияТаблицыИзменений = 
		ЗакрытиеМесяцаСервер.ТекстыЗапросовДляПолученияТаблицыИзмененийРегистра(ЭтотОбъект.Метаданные(), ЭтотОбъект.Отбор);
		
	СтруктураПроверкиИзмененияРегистра = Новый Структура();
	СтруктураПроверкиИзмененияРегистра.Вставить("ТекстВыборкиТаблицыИзменений", ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиТаблицыИзменений);
	СтруктураПроверкиИзмененияРегистра.Вставить("МенеджерВременныхТаблиц", Новый МенеджерВременныхТаблиц);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураПроверкиИзмененияРегистра.МенеджерВременныхТаблиц;
	Запрос.Текст = ТекстыЗапросовДляПолученияТаблицыИзменений.ТекстВыборкиНачальныхДанных;
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	
	Запрос.Выполнить();
	
	ДополнительныеСвойства.Вставить("СтруктураПроверкиИзмененияРегистра", СтруктураПроверкиИзмененияРегистра);

	Если ДополнительныеСвойства.Свойство("НеВыполнятьДопОбработкуПроводок")
		И ДополнительныеСвойства.НеВыполнятьДопОбработкуПроводок Тогда
		Возврат;
	КонецЕсли;
	
	РегистрыБухгалтерии.Хозрасчетный.ВыполнитьДопОбработкуПроводок(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПроверкиИзмененияРегистра = Неопределено;
	Если Не Отказ И ДополнительныеСвойства.Свойство("СтруктураПроверкиИзмененияРегистра", СтруктураПроверкиИзмененияРегистра) Тогда
		
		ИмяРегистра = "Хозрасчетный";
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = СтруктураПроверкиИзмененияРегистра.МенеджерВременныхТаблиц;
		
		Если НЕ ПланыОбмена.ГлавныйУзел() = Неопределено Тогда // В РИБ данный регистр обрабатывается только в главном узле.
			
			// Уничтожаем таблицу начальных записей регистра:
			Запрос.Текст = "УНИЧТОЖИТЬ НачальныеЗаписи" + ИмяРегистра;
			Запрос.Выполнить();
			Возврат;
			
		КонецЕсли;
		
		// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
		// и если отличия найдены регистрация задание на формирование финансового результата.	
		Запрос.Текст = СтруктураПроверкиИзмененияРегистра.ТекстВыборкиТаблицыИзменений;
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("ВыполнятьПроверку",
			ТипЗнч(Отбор.Регистратор.Значение)<>Тип("ДокументСсылка.РегламентнаяОперация"));
		
		ТекстАктуализацииЗакрытияМесяца =
		"ВЫБРАТЬ
		|	ТаблицаИзменений.Организация КАК Организация,
		|	ТаблицаИзменений.Регистратор КАК Документ,
		|	ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.РеклассификацияДолгосрочныхАктивовОбязательств) КАК Операция,
		|	МИНИМУМ(НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, Месяц)) КАК Месяц
		|ИЗ
		|	ТаблицаИзмененийХозрасчетный КАК ТаблицаИзменений
		|ГДЕ
		|	&ВыполнятьПроверку = ИСТИНА
		|	И (ТаблицаИзменений.СчетДт.Долгосрочный
		|	ИЛИ ТаблицаИзменений.СчетКт.Долгосрочный)
		|СГРУППИРОВАТЬ ПО
		|	ТаблицаИзменений.Организация,
		|	ТаблицаИзменений.Регистратор";
		
		ПроверкаИзмененияРегистра = Ложь;
		Если ДополнительныеСвойства.Свойство("ПроверкаИзмененияРегистра", ПроверкаИзмененияРегистра) И ПроверкаИзмененияРегистра = Истина Тогда
			//Задание к формированию финансового результата
			ТекстАктуализацииЗакрытияМесяца = ТекстАктуализацииЗакрытияМесяца +
			"
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	ТаблицаИзменений.Организация КАК Организация,
			|	ТаблицаИзменений.Регистратор КАК Документ,
			|	ЗНАЧЕНИЕ(Перечисление.ОперацииЗакрытияМесяца.ФормированиеФинансовогоРезультата) КАК Операция,
			|	МИНИМУМ(НАЧАЛОПЕРИОДА(ТаблицаИзменений.Период, Месяц)) КАК Месяц
			|ИЗ
			|	ТаблицаИзмененийХозрасчетный КАК ТаблицаИзменений
			|СГРУППИРОВАТЬ ПО
			|	ТаблицаИзменений.Организация,
			|	ТаблицаИзменений.Регистратор";
		
		КонецЕсли;
		
		Запрос.Текст = Запрос.Текст + ОбщегоНазначения.РазделительПакетаЗапросов() + ТекстАктуализацииЗакрытияМесяца;
			
		// Уничтожаем таблицу изменений регистра:
		Запрос.Текст = Запрос.Текст + ОбщегоНазначения.РазделительПакетаЗапросов() + "УНИЧТОЖИТЬ ТаблицаИзмененийХозрасчетный";
		
		Выборка = Запрос.Выполнить().Выбрать();
		РегистрыСведений.ЗаданияКЗакрытиюМесяца.СоздатьЗаписиРегистраПоДаннымВыборки(Выборка);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли