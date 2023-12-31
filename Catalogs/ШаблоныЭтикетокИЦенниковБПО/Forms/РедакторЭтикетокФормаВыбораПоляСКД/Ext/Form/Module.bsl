﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
    Если Параметры.Свойство("АвтоТест") Тогда
        Возврат;
    КонецЕсли;
	
	Если Параметры.Свойство("АдресХранилищаСКД") Тогда
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(Параметры.АдресХранилищаСКД));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДоступныеПоля

&НаКлиенте
Процедура ДоступныеПоляВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ВыбратьПолеСКД(ВыбраннаяСтрока);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьПоле(Команда)
	
	ТекущаяСтрока = Элементы.ДоступныеПоля.ТекущаяСтрока;
	
	Если ТекущаяСтрока <> Неопределено Тогда
		ВыбратьПолеСКД(ТекущаяСтрока);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьПолеСКД(ВыбраннаяСтрока)
	
	ПолеСКД = Строка(КомпоновщикНастроек.Настройки.ДоступныеПоляПорядка.ПолучитьОбъектПоИдентификатору(ВыбраннаяСтрока).Поле);
	ЭтотОбъект.Закрыть(ПолеСКД);
	
КонецПроцедуры

#КонецОбласти