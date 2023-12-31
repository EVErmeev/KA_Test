﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Параметры.ИмяСобытияОбмена) Или ПустаяСтрока(Параметры.ИмяФайла) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	
	Если Параметры.ИмяСобытияОбмена = "Обмен" Тогда
		ИмяМетода = "КабинетСотрудника.ВыполнитьОбменССервисомФоновоеЗадание";
		КлючФоновогоЗадания = КабинетСотрудника.КлючФоновогоЗаданияПубликации();
	ИначеЕсли Параметры.ИмяСобытияОбмена = "ОбновлениеПубликации" Тогда
		ИмяМетода = "КабинетСотрудника.ОбновлениеПубликацииФоновоеЗадание";
		КлючФоновогоЗадания = КабинетСотрудника.КлючФоновогоЗаданияПубликации();
	ИначеЕсли Параметры.ИмяСобытияОбмена = "ПубликацияРасчетныхЛистков" Тогда
		ИмяМетода = "КабинетСотрудника.ОпубликоватьРасчетныеЛистыВФоне";
		ПараметрыПроцедуры = Параметры.ПараметрыПубликацииРЛ;
	Иначе
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ИнтервалОжидания = ?(ОбщегоНазначения.ИнформационнаяБазаФайловая(),1,10); 
	
	ПараметрыПроцедуры.Вставить("ПодготовитьДанныеДляТехПоддержки", Истина);
	ЗапуститьФоновоеЗадание(Параметры.ИмяСобытияОбмена, ИмяМетода, ПараметрыПроцедуры);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПриНачалеЗадания();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если АктивноеЗадание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОтменитьВыполнениеЗадания(АктивноеЗадание.ДлительнаяОперация.ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если АктивноеЗадание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	ОтменитьВыполнениеЗадания(АктивноеЗадание.ДлительнаяОперация.ИдентификаторЗадания);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтменитьВыполнениеЗадания(ИдентификаторЗадания)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаКлиенте
Функция РезультатВыполнения()
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяСобытияОбмена", Параметры.ИмяСобытияОбмена);
	Результат.Вставить("РезультатВыполненияОбмена", РезультатВыполненияОбмена);
	Результат.Вставить("ПолноеИмяФайла", ПолноеИмяФайла);
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗапуститьФоновоеЗадание(ИмяЗадания, ИмяМетода, ПараметрыПроцедуры)
	
	ПараметрыВыполненияВФоне = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполненияВФоне.ЗапуститьВФоне = Истина;
	ПараметрыВыполненияВФоне.ОжидатьЗавершение = 0;
	Если ЗначениеЗаполнено(КлючФоновогоЗадания) Тогда
		ПараметрыВыполненияВФоне.КлючФоновогоЗадания = КлючФоновогоЗадания;
	КонецЕсли;
	
	ДлительнаяОперация = ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыПроцедуры, ПараметрыВыполненияВФоне);
	
	НовоеЗадание = Новый Структура("Имя,ДлительнаяОперация");
	НовоеЗадание.Имя = ИмяЗадания;
	НовоеЗадание.ДлительнаяОперация = ДлительнаяОперация;
	
	АктивноеЗадание = Новый ФиксированнаяСтруктура(НовоеЗадание);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриНачалеЗадания()
	
	Если ЗначениеЗаполнено(АктивноеЗадание) Тогда
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ДлительныеОперацииКлиент.ОжидатьЗавершение(
			АктивноеЗадание.ДлительнаяОперация,
			Новый ОписаниеОповещения("ПриЗавершенииЗадания", ЭтотОбъект, АктивноеЗадание.Имя),
			ПараметрыОжидания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииЗадания(ФоновоеЗадание, ИмяЗадания) Экспорт
	
	АктивноеЗадание = Неопределено;
	
	Если ФоновоеЗадание = Неопределено Тогда
		Закрыть(РезультатВыполнения());
	ИначеЕсли ФоновоеЗадание.Статус = "Ошибка" Тогда
		ТекстСообщения = НСтр("ru = 'При выполнении фонового задания возникла ошибка:'") + Символы.ПС + ФоновоеЗадание.КраткоеПредставлениеОшибки;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
		Закрыть(РезультатВыполнения());
	ИначеЕсли ФоновоеЗадание.Статус = "Выполнено" Тогда
		
		Если ИмяЗадания = "ВыгрузкаЖурналаРегистрации" Тогда
			ВыгрузкаЖурналаРегистрацииЗавершение(ФоновоеЗадание);
		Иначе
			РезультатВыполнения = ПолучитьИзВременногоХранилища(ФоновоеЗадание.АдресРезультата);
			РезультатВыполненияОбмена = Новый ФиксированнаяСтруктура(РезультатВыполнения);
			Если ИмяЗадания = "Обмен" Тогда
				ОтборПоДатам = Неопределено;
			Иначе
				ОтборПоДатам = РезультатВыполненияОбмена;
			КонецЕсли;
			ПодключитьОбработчикОжидания("ВыгрузкаЖурналаРегистрации", ИнтервалОжидания, Истина);
		КонецЕсли;
		
	Иначе
		Закрыть(РезультатВыполнения());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузкаЖурналаРегистрации()

	ПараметрыПроцедуры = ПараметрыОтбораЖР();
	ИмяМетода = "КабинетСотрудника.ВыгрузкаЖурналаРегистрацииФоновоеЗадание";
	ЗапуститьФоновоеЗадание("ВыгрузкаЖурналаРегистрации", ИмяМетода, ПараметрыПроцедуры);
	
	ПриНачалеЗадания();
	
КонецПроцедуры

&НаСервере
Функция ПараметрыОтбораЖР()

	ИменаСобытий = КабинетСотрудника.СобытияЖРОбмен();
	ОтборЖурналаРегистрации = КабинетСотрудника.ОтборЖурналаРегистрацииДляВыгрузки(ИменаСобытий, ОтборПоДатам);
	ПараметрыПроцедуры = Новый Структура("ОтборЖурналаРегистрации", ОтборЖурналаРегистрации);
	
	Возврат ПараметрыПроцедуры;

КонецФункции

&НаКлиенте
Процедура ВыгрузкаЖурналаРегистрацииЗавершение(ФоновоеЗадание)
	
	ОбработчикЗавершения = Новый ОписаниеОповещения("ВыполнитьОбменСохранитьЖурналЗавершение", ЭтотОбъект);
	
	ПараметрыСохраненияФайла = ФайловаяСистемаКлиент.ПараметрыСохраненияФайла();
	ПараметрыСохраненияФайла.Диалог.Фильтр = НСтр("ru = 'Данные журнала регистрации'") + "(*.zip)|*.zip";
	ИмяФайла = СтрШаблон("%1.%2", Параметры.ИмяФайла, "zip");
	ФайловаяСистемаКлиент.СохранитьФайл(ОбработчикЗавершения, ФоновоеЗадание.АдресРезультата, ИмяФайла, ПараметрыСохраненияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбменСохранитьЖурналЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат <> Неопределено Тогда
		ПолноеИмяФайла = Результат[0].ПолноеИмя;
	КонецЕсли;
	
	Закрыть(РезультатВыполнения());

КонецПроцедуры

#КонецОбласти






