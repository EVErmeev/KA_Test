﻿
#Область ПрограммныйИнтерфейс

Функция ПолучитьПараметрыПрорисовкиПанелиОтправки(Форма, КонтролирующийОрган = "ФНС") Экспорт
	
	Отчет = ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиентСервер.СсылкаНаОтчетПоФорме(Форма);
	Если Отчет = Неопределено ИЛИ ТипЗнч(Отчет) = Тип("Массив") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	// получаем параметры
	ЦветТекста = Новый Цвет;
	ПоказыватьКнопкуПротокола = Ложь;
	ДатаОтправки = '00010101';
	ТекстСостояния = СдачаОтчетностиЧерезСервисСпецоператораВызовСервера.ПолучитьСтрокуСостоянияОтправкиОтчетаИДополнительныеСвойства(
		Отчет, 
		КонтролирующийОрган, 
		ЦветТекста, 
		ПоказыватьКнопкуПротокола, 
		ДатаОтправки);
	
	// инициализируем результат
	Результат = Новый Структура("ВидимостьПанели, ВидимостьКнопкиПротокола, ТекстНадписи, ЦветТекстаНадписи, ДатаОтправки");
	Результат.ВидимостьПанели = ЗначениеЗаполнено(ТекстСостояния);
	Результат.ВидимостьКнопкиПротокола = ПоказыватьКнопкуПротокола;
	Результат.ТекстНадписи = ТекстСостояния;
	Результат.ЦветТекстаНадписи = ЦветТекста;
	Результат.ДатаОтправки = ДатаОтправки;
	
	Возврат Результат;
	
КонецФункции

Процедура ПриИнициализацииФормыРегламентированногоОтчета(Форма, КонтролирующийОрган = "ФНС", ПараметрыПрорисовкиПанели = Неопределено) Экспорт
	
	РазделениеВключено = ЭлектронныйДокументооборотСКонтролирующимиОрганамиВызовСервера.РазделениеВключено();
	
	// регулируем видимость кнопки отправки через представителя для абонентов сервиса
	УстановитьВидимостьКнопкиОтправкиЧерезПредставителя(Форма);
	
	// инициализируем параметры прорисовки панели
	Если РазделениеВключено Тогда
		ПараметрыПрорисовкиПанели = ПолучитьПараметрыПрорисовкиПанелиОтправки(Форма, КонтролирующийОрган);
	Иначе
		ПараметрыПрорисовкиПанели = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьВидимостьКнопкиОтправкиЧерезПредставителя(Форма) Экспорт
	
	ГруппаОтправкаЧерезПредставителя = Форма.Элементы.Найти("ГруппаОтправкаЧерезПредставителя");
	Если ГруппаОтправкаЧерезПредставителя <> Неопределено Тогда
		ГруппаОтправкаЧерезПредставителя.Видимость = Ложь; 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
