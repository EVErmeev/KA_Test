﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Возврат при получении формы для анализа.
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РеквизитыФормы		= ПолучитьРеквизиты();
	ТипНомераГТДОбъекта	= ?(Параметры.Свойство("ТипНомераГТД"),
							Параметры.ТипНомераГТД,
							Перечисления.ТипыНомеровГТД.НомерГТД);
	ВестиУчетРНПТ		= ?(Параметры.Свойство("ВестиУчетРНПТ"),
							Параметры.ВестиУчетРНПТ,
							Ложь);
	
	Для Каждого Реквизит Из РеквизитыФормы Цикл
		Если Элементы.Найти(Реквизит.Имя) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		РеквизитИспользуется = Истина;
		
		Если Реквизит.Имя = "Код"
			И (ТипНомераГТДОбъекта = Перечисления.ТипыНомеровГТД.НомерРНПТ
				Или ТипНомераГТДОбъекта = Перечисления.ТипыНомеровГТД.НомерРНПТКомплекта) Тогда
			
			Элементы[Реквизит.Имя].Заголовок = НСтр("ru = 'Разрешить редактирование номера РНПТ'");
			
		ИначеЕсли Не ВестиУчетРНПТ
			И (Реквизит.Имя = "ТипНомераГТД"
				Или Реквизит.Имя = "ПрослеживаемыеКомплектующие") Тогда
			
			РеквизитИспользуется = Ложь;
			
		КонецЕсли;
		
		ЭтотОбъект[Реквизит.Имя]			= РеквизитИспользуется;
		Элементы[Реквизит.Имя].Видимость	= РеквизитИспользуется;
		
		ИменаРеквизитовФормы.Добавить(Реквизит.Имя);
	КонецЦикла;
	
	СобытияФорм.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	// Для всех включенных флажков сформируем массив соответствующих им реквизитов справочника.
	Результат = Новый Массив;
	
	Для Каждого Реквизит Из ИменаРеквизитовФормы Цикл
		Если ЭтотОбъект[Реквизит.Значение] Тогда
			Результат.Добавить(Реквизит.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры

#КонецОбласти