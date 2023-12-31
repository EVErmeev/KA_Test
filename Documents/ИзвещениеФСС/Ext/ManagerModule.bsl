﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//  КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр).
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной
//                                                            параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной
//                                            параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ДляВсехСтрок( ЗначениеРазрешено(ФизическиеЛица.ФизическоеЛицо, NULL КАК ИСТИНА)
	|	) И ЗначениеРазрешено(Организация)";
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ТекущиеДела

// См. ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел.
Процедура ПриЗаполненииСпискаТекущихДел(ТекущиеДела) Экспорт
	
	Если Не СЭДОФСС.ДоступенОбменЧерезСЭДО()
		Или Не ПравоДоступа("Изменение", Метаданные.Документы.ИзвещениеФСС) Тогда
		Возврат; // Нет прав.
	КонецЕсли;
	
	МодульТекущиеДелаСервер = ОбщегоНазначения.ОбщийМодуль("ТекущиеДелаСервер");
	Разделы = МодульТекущиеДелаСервер.РазделыДляОбъекта(Метаданные.Документы.ИзвещениеФСС.ПолноеИмя());
	Если Разделы.Количество() = 0 Тогда
		Возврат; // Некорректное внедрение.
	КонецЕсли;
	
	Требования = ТребованияПоОтправке();
	ФильтрСегодня = Новый Структура("Сегодня", Истина);
	НеобходимоОтправитьРеестровВсего   = Требования.Реестры.Количество();
	НеобходимоОтправитьРеестровСегодня = Требования.Реестры.НайтиСтроки(ФильтрСегодня).Количество();
	НеобходимоПодтвердитьВсего         = Требования.Подтверждения.Количество();
	
	Для Каждого Раздел Из Разделы Цикл
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = "КритичныеТребованияПоОтправкеИзвещений" + СтрЗаменить(Раздел.ПолноеИмя(), ".", "_");
		Дело.ЕстьДела       = (НеобходимоОтправитьРеестровСегодня > 0);
		Дело.Важное         = Истина;
		Дело.Владелец       = Раздел;
		Дело.Представление  = НСтр("ru = 'Сегодня отправить реестры по извещениям ФСС'");
		Дело.Количество     = НеобходимоОтправитьРеестровСегодня;
		Дело.Подсказка      = НСтр("ru = 'После подтверждения получения извещений ФСС необходимо отправить реестр с недостающими сведениями в течении 5 рабочих дней.'");
		Дело.ПараметрыФормы = Новый Структура("ТолькоТребующиеОтправкиСегодня", Истина);
		Дело.Форма          = "Документ.ИзвещениеФСС.ФормаСписка";
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = "ОбычныеТребованияПоОтправкеИзвещений" + СтрЗаменить(Раздел.ПолноеИмя(), ".", "_");
		Дело.ЕстьДела       = (НеобходимоОтправитьРеестровВсего > 0);
		Дело.Важное         = Ложь;
		Дело.Владелец       = Раздел;
		Дело.Представление  = НСтр("ru = 'Отправить реестры по извещениям ФСС'");
		Дело.Количество     = НеобходимоОтправитьРеестровВсего;
		Дело.Подсказка      = НСтр("ru = 'После подтверждения получения извещений ФСС необходимо отправить реестр с недостающими сведениями в течении 5 рабочих дней.'");
		Дело.ПараметрыФормы = Новый Структура("ТолькоТребующиеОтправки", Истина);
		Дело.Форма          = "Документ.ИзвещениеФСС.ФормаСписка";
		
		Дело = ТекущиеДела.Добавить();
		Дело.Идентификатор  = "ОбычныеТребованияПоПодтверждениюИзвещений" + СтрЗаменить(Раздел.ПолноеИмя(), ".", "_");
		Дело.ЕстьДела       = (НеобходимоПодтвердитьВсего > 0);
		Дело.Важное         = Ложь;
		Дело.Владелец       = Раздел;
		Дело.Представление  = НСтр("ru = 'Подтвердить получение извещений ФСС'");
		Дело.Количество     = НеобходимоПодтвердитьВсего;
		Дело.Подсказка      = НСтр("ru = 'Необходимо подтвердить получение извещений ФСС в течении 1 рабочего дня.'");
		Дело.ПараметрыФормы = Новый Структура("ТолькоТребующиеПодтверждения", Истина);
		Дело.Форма          = "Документ.ИзвещениеФСС.ФормаСписка";
		
	КонецЦикла;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ТекущиеДела

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

#Область ОбновлениеИнформационнойБазы

// Заполняет виды извещений ФСС.
//
// Параметры:
//   ПараметрыОбновления - Структура - Параметры отложенного обновления.
//
Процедура ЗаполнитьВидИзвещений(ПараметрыОбновления = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИзвещениеФСС.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ИзвещениеФСС КАК ИзвещениеФСС
	|ГДЕ
	|	ИзвещениеФСС.ВидИзвещенияФСС = ЗНАЧЕНИЕ(Перечисление.ВидыИзвещенийФСС.ПустаяСсылка)
	|	И ИзвещениеФСС.ВходящийФайл <> ЗНАЧЕНИЕ(Справочник.ИзвещениеФССПрисоединенныеФайлы.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ДокументОбъект.ВидИзвещенияФСС = Перечисления.ВидыИзвещенийФСС.ИзвещениеОПредставленииНедостающихСведений;
		СЭДОФСС.ЗаписатьДокумент(ДокументОбъект);
	КонецЦикла;
	
	Если ПараметрыОбновления <> Неопределено Тогда
		ПараметрыОбновления.ОбработкаЗавершена = Истина;
	КонецЕсли;
КонецПроцедуры

// Заполняет таблицу ФизическиеЛица.
//
// Параметры:
//   ПараметрыОбновления - Структура - Параметры отложенного обновления.
//
Процедура ЗаполнитьТаблицуФизическихЛицИзвещений(ПараметрыОбновления = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИзвещениеФСС.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ИзвещениеФСС КАК ИзвещениеФСС
	|ГДЕ
	|	ИзвещениеФСС.ФизическоеЛицо <> ЗНАЧЕНИЕ(Справочник.ФизическиеЛица.ПустаяСсылка)";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		ДокументОбъект.ЗаполнитьТаблицуФизическихЛиц();
		СЭДОФСС.ЗаписатьДокумент(ДокументОбъект);
	КонецЦикла;
	
	Если ПараметрыОбновления <> Неопределено Тогда
		ПараметрыОбновления.ОбработкаЗавершена = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СоставДокументов

// Возвращает описание состава документа
//
// Возвращаемое значение:
//  Структура - см. ЗарплатаКадрыСоставДокументов.НовоеОписаниеСоставаОбъекта.
//
Функция ОписаниеСоставаОбъекта() Экспорт
	Возврат ЗарплатаКадрыСоставДокументов.ОписаниеСоставаОбъектаФизическоеЛицоВШапке("ФизическоеЛицо", "Сотрудник");
КонецФункции

#КонецОбласти

#Область ФиксацияВторичныхДанныхВДокументах

Функция ПараметрыФиксацииВторичныхДанных() Экспорт
	ФиксируемыеРеквизиты = ФиксируемыеРеквизиты();
	Возврат ФиксацияВторичныхДанныхВДокументах.ПараметрыФиксации(ФиксируемыеРеквизиты);
КонецФункции

#КонецОбласти

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#Область ФиксацияВторичныхДанныхВДокументах

Функция ФиксируемыеРеквизиты()
	ФиксируемыеРеквизиты = Новый Соответствие;
	
	// При помощи механизмов фиксации описываются только механизмы обновления вторичных данных.
	// Механизмы заполнения первичных данных при этом могут существенно отличаться.
	
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "ПодтверждениеПолучения";
	Шаблон.ОснованиеЗаполнения = "ИдентификаторСообщения";
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ТребуетсяПодтверждение");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ДатаОтправкиПодтверждения");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ПодтверждениеПолученоФСС");
	
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "МаксимальнаяДатаПодтверждения";
	Шаблон.ОснованиеЗаполнения = "ВходящаяДата";
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "МаксимальнаяДатаПодтверждения");
	
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы           = "МаксимальнаяДатаОтправкиРеестра";
	Шаблон.ОснованиеЗаполнения = "ДатаОтправкиПодтверждения";
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "МаксимальнаяДатаОтправкиРеестра");
	
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы                = "ВходящийРеестр";
	Шаблон.ОснованиеЗаполнения      = "ВходящийРеестр";
	Шаблон.ОтображатьПредупреждение = Ложь;
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Организация");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Сотрудник");
	
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы                = "ВходящееЗаявлениеПервичныйДокумент";
	Шаблон.ОснованиеЗаполнения      = "ВходящийРеестр";
	Шаблон.ФиксацияГруппы           = Истина;
	Шаблон.ОтображатьПредупреждение = Ложь;
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ВходящееЗаявление");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ВходящийПервичныйДокумент");
	
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы                = "ВходящийПервичныйДокумент";
	Шаблон.ОснованиеЗаполнения      = "ВходящийПервичныйДокумент";
	Шаблон.ОтображатьПредупреждение = Ложь;
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ИсходящийПервичныйДокумент");
	
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы                = "ИсходящийПервичныйДокумент";
	Шаблон.ОснованиеЗаполнения      = "ИсходящийПервичныйДокумент";
	Шаблон.ОтображатьПредупреждение = Ложь;
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ИсходящееЗаявление");
	
	Шаблон = ФиксацияВторичныхДанныхВДокументах.ОписаниеФиксируемогоРеквизита();
	Шаблон.ИмяГруппы                = "ИсходящееЗаявление";
	Шаблон.ОснованиеЗаполнения      = "ИсходящееЗаявление";
	Шаблон.ОтображатьПредупреждение = Ложь;
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "ИсходящийРеестр");
	ФиксацияВторичныхДанныхВДокументах.ДобавитьФиксируемыйРеквизит(ФиксируемыеРеквизиты, Шаблон, "Обработано");
	
	Возврат Новый ФиксированноеСоответствие(ФиксируемыеРеквизиты);
КонецФункции

#КонецОбласти

#Область СЭДО

Процедура ЗагрузитьУведомлениеОНаличииСообщения10(Страхователь, ИдентификаторСообщения, ТребуетсяПодтверждение) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	Попытка
		// Поиск документа по идентификатору сообщения.
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИзвещениеФСС.Ссылка КАК Ссылка,
		|	ИзвещениеФСС.Дата КАК Дата,
		|	ИзвещениеФСС.ПометкаУдаления КАК ПометкаУдаления,
		|	ИзвещениеФСС.Организация КАК Организация,
		|	ИзвещениеФСС.Страхователь КАК Страхователь,
		|	ИзвещениеФСС.ТребуетсяПодтверждение КАК ТребуетсяПодтверждение
		|ИЗ
		|	Документ.ИзвещениеФСС КАК ИзвещениеФСС
		|ГДЕ
		|	ИзвещениеФСС.ИдентификаторСообщения = &ИдентификаторСообщения
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПометкаУдаления,
		|	Дата УБЫВ";
		Запрос.УстановитьПараметр("ИдентификаторСообщения", ИдентификаторСообщения);
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Если Выборка.Страхователь = Страхователь
				И Не Выборка.ПометкаУдаления
				И ТребуетсяПодтверждение = Выборка.ТребуетсяПодтверждение Тогда
				ОтменитьТранзакцию();
				Возврат;
			КонецЕсли;
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Иначе
			ДокументОбъект = Документы.ИзвещениеФСС.СоздатьДокумент();
		КонецЕсли;
		
		Если ДокументОбъект.ПометкаУдаления Тогда
			ДокументОбъект.УстановитьПометкуУдаления(Ложь);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ДокументОбъект.Организация) Тогда
			ДокументОбъект.Организация = Страхователь;
		КонецЕсли;
		ДокументОбъект.Страхователь           = Страхователь;
		ДокументОбъект.ИдентификаторСообщения = ИдентификаторСообщения;
		ДокументОбъект.ТребуетсяПодтверждение = ТребуетсяПодтверждение;
		ДокументОбъект.ЗаполнитьДату();
		ЗаписатьДокумент(ДокументОбъект, РежимЗаписиДокумента.Запись);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'При загрузке уведомления об извещении ФСС %1 возникла ошибка: %2'"),
			ИдентификаторСообщения,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		СообщенияБЗК.СообщитьОПроблеме(ТекстОшибки);
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗагрузитьСообщение10(Страхователь, ИдентификаторСообщения, ТекстXML, Результат) Экспорт
	УстановитьПривилегированныйРежим(Истина);
	
	// Пример:
	// <ns3:notice xmlns:ns2="http://www.fss.ru/integration/types/commonUq/v01" xmlns:ns3="http://www.fss.ru/integration/types/pvso/notice/v01">
	//    <tofCode>9000</tofCode>
	//    <regNum>9999502919</regNum>
	//    <date>2020-06-18+03:00</date>
	//    <number>3</number>
	//    <batchNum>E_2707411305_2018_08_03_04</batchNum>
	//    <registrRowNums>
	//        <rowNumber>1</rowNumber>
	//        <rowNumber>3</rowNumber>
	//        <rowNumber>2</rowNumber>
	//    </registrRowNums>
	//    <ns2:attachment>
	//        <content>UEsDBBQ...</content>
	//        <ext>docx</ext>
	//        <size>9318</size>
	//    </ns2:attachment>
	// </ns3:notice>
	
	// Поиск нужного узла.
	СтруктураDOM = СериализацияБЗК.СтруктураDOM(ТекстXML);
	ЭлементDOM = СериализацияБЗК.НайтиУзелDOM(СтруктураDOM, "//*[local-name() = 'notice']/..");
	Если ЭлементDOM = Неопределено Тогда
		ТекстОшибки = СтрШаблон(НСтр("ru = 'В xml-содержимом сообщения не удалось найти узел ""notice"". Текст XML: %1'"), ТекстXML);
		СЭДОФСС.ОшибкаОбработки(Результат, ИдентификаторСообщения, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	// Чтение реквизитов узла.
	ФрагментXML = СериализацияБЗК.ОбъектDOMВСтрокуXML(ЭлементDOM);
	ОбъектXDTO = СериализацияБЗК.ОбъектXDTOИзСтрокиXML(ФрагментXML);
	РеквизитыИзвещения = ОбщегоНазначенияБЗК.ЗначенияСвойств(ОбъектXDTO, "tofCode, regNum, date, number, batchNum, attachment");
	РеквизитыВложения = ОбщегоНазначенияБЗК.ЗначенияСвойств(РеквизитыИзвещения.attachment, "content, ext, size");
	Если РеквизитыВложения.content = Неопределено Тогда
		ТекстОшибки = СтрШаблон(НСтр("ru = 'В xml-содержимом сообщения не заполнен узел ""notice.attachment.content"". Текст XML: %1'"), ТекстXML);
		СЭДОФСС.ОшибкаОбработки(Результат, ИдентификаторСообщения, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	НовыеНомераСтрок = Новый Массив;
	RowNumbers = СериализацияБЗК.СписокXDTO(ОбъектXDTO, "registrRowNums.rowNumber");
	Для Каждого RowNumber Из RowNumbers Цикл
		НомерСтрокиРеестра = СериализацияБЗК.ЗначениеXML(RowNumber, Тип("Число"));
		Если ТипЗнч(НомерСтрокиРеестра) = Тип("Число") Тогда
			НовыеНомераСтрок.Добавить(НомерСтрокиРеестра);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из РеквизитыИзвещения Цикл
		Если ТипЗнч(КлючИЗначение.Значение) = Тип("Строка") Тогда
			РеквизитыИзвещения.Вставить(КлючИЗначение.Ключ, СокрЛП(КлючИЗначение.Значение));
		КонецЕсли;
	КонецЦикла;
	Для Каждого КлючИЗначение Из РеквизитыВложения Цикл
		Если ТипЗнч(КлючИЗначение.Значение) = Тип("Строка") Тогда
			РеквизитыВложения.Вставить(КлючИЗначение.Ключ, СокрЛП(КлючИЗначение.Значение));
		КонецЕсли;
	КонецЦикла;
	
	// Новые значения реквизитов документа.
	ИменаПолей = "Загружено,Страхователь,ИдентификаторСообщения,ВходящийИдентификаторРеестра,ВходящийНомер,ВходящаяДата";
	НовыеЗначения = Новый Структура(ИменаПолей);
	НовыеЗначения.Загружено                    = Истина;
	НовыеЗначения.Страхователь                 = Страхователь;
	НовыеЗначения.ИдентификаторСообщения       = ИдентификаторСообщения;
	НовыеЗначения.ВходящийИдентификаторРеестра = РеквизитыИзвещения.batchNum;
	НовыеЗначения.ВходящийНомер = СериализацияБЗК.ЗначениеXML(РеквизитыИзвещения.number, Тип("Число"));
	НовыеЗначения.ВходящаяДата  = СериализацияБЗК.ЗначениеXML(РеквизитыИзвещения.date,   Тип("Дата"));
	
	// Новые значения реквизитов присоединенного файла.
	ДвоичныеДанныеФайла = СериализацияБЗК.ЗначениеXML(РеквизитыВложения.content, Тип("ДвоичныеДанные"));
	
	ПараметрыФайла = РаботаСФайлами.ПараметрыДобавленияФайла("Идентификатор, Кодировка");
	ПараметрыФайла.РасширениеБезТочки = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(РеквизитыВложения.ext);
	ПараметрыФайла.Служебный          = Истина;
	ПараметрыФайла.Идентификатор      = ИдентификаторСообщения;
	
	// Поиск документа по идентификатору сообщения.
	НачатьТранзакцию(РежимУправленияБлокировкойДанных.Управляемый);
	Попытка
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИзвещениеФСС.Ссылка КАК Ссылка,
		|	ИзвещениеФСС.Дата КАК Дата,
		|	ИзвещениеФСС.ПометкаУдаления КАК ПометкаУдаления
		|ИЗ
		|	Документ.ИзвещениеФСС КАК ИзвещениеФСС
		|ГДЕ
		|	ИзвещениеФСС.ИдентификаторСообщения = &ИдентификаторСообщения
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПометкаУдаления,
		|	Дата УБЫВ";
		Запрос.УстановитьПараметр("ИдентификаторСообщения", ИдентификаторСообщения);
		
		ЕстьИзменения = Ложь;
		
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
		Иначе
			ДокументОбъект = Документы.ИзвещениеФСС.СоздатьДокумент();
		КонецЕсли;
		
		// Обновление реквизитов документа.
		Если Не ЗначениеЗаполнено(ДокументОбъект.Организация) Тогда
			ЕстьИзменения = Истина;
			ДокументОбъект.Организация = Страхователь;
		КонецЕсли;
		
		СтарыеЗначения = Новый Структура(ИменаПолей);
		ЗаполнитьЗначенияСвойств(СтарыеЗначения, ДокументОбъект, ИменаПолей);
		Если Не ОбщегоНазначенияБЗК.ЗначенияСовпадают(СтарыеЗначения, НовыеЗначения) Тогда
			ЕстьИзменения = Истина;
			ЗаполнитьЗначенияСвойств(ДокументОбъект, НовыеЗначения, ИменаПолей);
			ДокументОбъект.ЗаполнитьДату();
		КонецЕсли;
		
		ДокументОбъект.ЗаполнитьВходящийРеестр(ЕстьИзменения);
		ДокументОбъект.ОбновитьНомераСтрок(НовыеНомераСтрок, ЕстьИзменения);
		ДокументОбъект.ЗаполнитьСтрокиРеестров(ЕстьИзменения);
		
		Если ЕстьИзменения Тогда
			ЗаписатьДокумент(ДокументОбъект, РежимЗаписиДокумента.Запись);
		КонецЕсли;
		
		// Обновление присоединенного файла.
		ПараметрыФайла.ВладелецФайлов   = ДокументОбъект.Ссылка;
		ПараметрыФайла.ИмяБезРасширения = ПредставлениеДокумента(ДокументОбъект);
		ВходящийФайл = ОбновитьФайл(ДвоичныеДанныеФайла, ПараметрыФайла);
		
		// Запись ссылки на файл в реквизиты документа.
		ДокументОбъект.Прочитать();
		Если ДокументОбъект.ВходящийФайл <> ВходящийФайл Тогда
			Если Не ЗначениеЗаполнено(ДокументОбъект.ВидИзвещенияФСС) Тогда
				ДокументОбъект.ВидИзвещенияФСС = Перечисления.ВидыИзвещенийФСС.ИзвещениеОПредставленииНедостающихСведений;
			КонецЕсли;
			ДокументОбъект.ВходящийФайл = ВходящийФайл;
			ДокументОбъект.ОбновитьВторичныеДанные();
			ЗаписатьДокумент(ДокументОбъект, РежимЗаписиДокумента.Запись);
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'При загрузке XML-содержимого Извещения ФСС %1 возникла ошибка: %2'"),
			ИдентификаторСообщения,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		СЭДОФСС.ОшибкаОбработки(Результат, ИдентификаторСообщения, ТекстОшибки);
		Возврат;
	КонецПопытки;
	
	Результат.Обработано = Истина;
КонецПроцедуры

Функция ОбновитьФайл(ДвоичныеДанныеФайла, ПараметрыФайла)
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПрисоединенныеФайлы.Ссылка КАК Ссылка
	|ИЗ
	|	&ИсточникДанных КАК ПрисоединенныеФайлы
	|ГДЕ
	|	ПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
	|	И ПрисоединенныеФайлы.Идентификатор = &Идентификатор";
	Запрос.УстановитьПараметр("ВладелецФайла", ПараметрыФайла.ВладелецФайлов);
	Запрос.УстановитьПараметр("Идентификатор", ПараметрыФайла.Идентификатор);
	
	ИмяОбъекта = ПараметрыФайла.ВладелецФайлов.Метаданные().Имя;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ИсточникДанных", "Справочник." + ИмяОбъекта + "ПрисоединенныеФайлы"); 
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	АдресДвоичныхДанных = ПоместитьВоВременноеХранилище(ДвоичныеДанныеФайла);
	
	Если Выборка.Следующий() Тогда 
		СсылкаФайла = Выборка.Ссылка;
		ПараметрыФайла.Вставить("АдресФайлаВоВременномХранилище", АдресДвоичныхДанных);
		ПараметрыФайла.Вставить("АдресВременногоХранилищаТекста", "");
		РаботаСФайлами.ОбновитьФайл(СсылкаФайла, ПараметрыФайла);
	Иначе
		СсылкаФайла = РаботаСФайлами.ДобавитьФайл(ПараметрыФайла, АдресДвоичныхДанных);
	КонецЕсли;
	
	Возврат СсылкаФайла;
КонецФункции

Функция ПредставлениеДокумента(РеквизитыДокумента)
	Если ЗначениеЗаполнено(РеквизитыДокумента.ВходящийНомер)
		И ЗначениеЗаполнено(РеквизитыДокумента.ВходящаяДата) Тогда
		Номер = РеквизитыДокумента.ВходящийНомер;
		Дата  = РеквизитыДокумента.ВходящаяДата;
	Иначе
		Номер = РеквизитыДокумента.Номер;
		Дата  = РеквизитыДокумента.Дата;
	КонецЕсли;
	
	ФИО = Строка(РеквизитыДокумента.ФизическоеЛицо);
	Если ЗначениеЗаполнено(ФИО) Тогда
		Шаблон = НСтр("ru = 'Извещение ФСС %1 от %2 (%3)'");
	Иначе
		Шаблон = НСтр("ru = 'Извещение ФСС %1 от %2'");
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Номер, Формат(Дата, "ДЛФ=D"), ФИО);
КонецФункции

#КонецОбласти

#Область Регламенты

Функция МаксимальнаяДатаПодтвержденияПолучения(Объект) Экспорт
	Возврат СЭДОФСС.БлижайшийРабочийДень(Объект.ВходящаяДата, РабочихДнейНаПодтверждениеПолучения());
КонецФункции

Функция МаксимальнаяДатаОтправкиРеестра(Объект) Экспорт
	Если ЗначениеЗаполнено(Объект.ДатаОтправкиПодтверждения)
		И Объект.ДатаОтправкиПодтверждения < Объект.МаксимальнаяДатаПодтверждения Тогда
		ДатаОтсчета = Объект.ДатаОтправкиПодтверждения;
	Иначе
		ДатаОтсчета = Объект.МаксимальнаяДатаПодтверждения;
	КонецЕсли;
	Возврат СЭДОФСС.БлижайшийРабочийДень(ДатаОтсчета, РабочихДнейНаОтправкуРеестра());
КонецФункции

// См. п.7 Положения № 1 утвержденного Постановлением Правительства РФ от 21.04.2011 N 294.
Функция РабочихДнейНаПодтверждениеПолучения()
	Возврат 1;
КонецФункции

// См. п.7 Положения № 1 утвержденного Постановлением Правительства РФ от 21.04.2011 N 294.
Функция РабочихДнейНаОтправкуРеестра()
	Возврат 5;
КонецФункции

#КонецОбласти

#Область ТекущиеДела

Функция ТребованияПоОтправке()
	НачалоТекущегоДня = НачалоДня(ТекущаяДатаСеанса());
	НачалоРабочегоДня = НачалоДня(СЭДОФСС.БлижайшийРабочийДень(НачалоТекущегоДня));
	// Бумагу отправляют через 2-3 дня, а на подтверждение получения дается 1 день.
	НачалоТекущегоДняМинусДваДня = НачалоТекущегоДня - 86400 * 2;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИзвещениеФСС.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ИзвещениеФСС.МаксимальнаяДатаОтправкиРеестра <= &НачалоРабочегоДня
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Сегодня
	|ИЗ
	|	Документ.ИзвещениеФСС КАК ИзвещениеФСС
	|ГДЕ
	|	НЕ ИзвещениеФСС.Обработано
	|	И ИзвещениеФСС.МаксимальнаяДатаОтправкиРеестра >= &НачалоТекущегоДня
	|	И НЕ ИзвещениеФСС.ПометкаУдаления
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИзвещениеФСС.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ИзвещениеФСС.МаксимальнаяДатаПодтверждения <= &НачалоРабочегоДня
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Сегодня
	|ИЗ
	|	Документ.ИзвещениеФСС КАК ИзвещениеФСС
	|ГДЕ
	|	НЕ ИзвещениеФСС.Обработано
	|	И НЕ ИзвещениеФСС.ПодтверждениеПолученоФСС
	|	И ИзвещениеФСС.ДатаОтправкиПодтверждения = &ПустаяДата
	|	И ИзвещениеФСС.МаксимальнаяДатаПодтверждения >= &НачалоТекущегоДняМинусДваДня
	|	И НЕ ИзвещениеФСС.ПометкаУдаления";
	Запрос.УстановитьПараметр("НачалоТекущегоДня", НачалоТекущегоДня);
	Запрос.УстановитьПараметр("НачалоРабочегоДня", НачалоРабочегоДня);
	Запрос.УстановитьПараметр("НачалоТекущегоДняМинусДваДня", НачалоТекущегоДняМинусДваДня);
	Запрос.УстановитьПараметр("ПустаяДата", '00010101');
	
	Массив = Запрос.ВыполнитьПакет();
	
	Результат = Новый Структура("Реестры, Подтверждения");
	Результат.Реестры       = Массив[0].Выгрузить();
	Результат.Подтверждения = Массив[1].Выгрузить();
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#Область Заполнение

Процедура ПриЗаписиПервичногоДокумента(ПервичныйДокументОбъект, Отказ) Экспорт
	// Обновление вторичных данных в привилегированном режиме.
	УстановитьПривилегированныйРежим(Истина);
	
	// АПК:96-выкл Ключевое слово ОБЪЕДИНИТЬ использовано по назначению.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИзвещениеФСС.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ИзвещениеФСС КАК ИзвещениеФСС
	|ГДЕ
	|	ИзвещениеФСС.ИсходящийПервичныйДокумент В (&Ссылка, &ИсправленныйДокумент)
	|	И ИзвещениеФСС.ОпределятьАвтоматически
	|	И НЕ ИзвещениеФСС.Обработано
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ИзвещениеФСС.Ссылка
	|ИЗ
	|	Документ.ИзвещениеФСС КАК ИзвещениеФСС
	|ГДЕ
	|	ИзвещениеФСС.ВходящийПервичныйДокумент В (&Ссылка, &ИсправленныйДокумент)
	|	И ИзвещениеФСС.ОпределятьАвтоматически
	|	И НЕ ИзвещениеФСС.Обработано";
	// АПК:96-вкл
	ИсправленныйДокумент = ОбщегоНазначенияБЗК.ЗначениеСвойства(ПервичныйДокументОбъект, "ИсправленныйДокумент");
	Запрос.УстановитьПараметр("ИсправленныйДокумент", ИсправленныйДокумент);
	Запрос.УстановитьПараметр("Ссылка",               ПервичныйДокументОбъект.Ссылка);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Попытка
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДокументОбъект.Заблокировать();
			ДокументОбъект.ОбновитьВторичныеДанные();
			ЗаписатьДокумент(ДокументОбъект, РежимЗаписиДокумента.Запись);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Не удалось обновить извещение ""%1"": %2'"),
				Выборка.Ссылка,
				Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			ВызватьИсключение ТекстОшибки;
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписиЗаявленияНаВыплатуПособия(ЗаявлениеОбъект, Отказ) Экспорт
	
	// АПК:96-выкл Ключевое слово ОБЪЕДИНИТЬ использовано по назначению.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ИзвещениеФСС.Ссылка КАК Ссылка
	|ИЗ
	|	Документ.ИзвещениеФСС КАК ИзвещениеФСС
	|ГДЕ
	|	ИзвещениеФСС.ИсходящийПервичныйДокумент = &ПервичныйДокумент
	|	И ИзвещениеФСС.ОпределятьАвтоматически
	|	И НЕ ИзвещениеФСС.Обработано
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	ИзвещениеФСС.Ссылка
	|ИЗ
	|	Документ.ИзвещениеФСС КАК ИзвещениеФСС
	|ГДЕ
	|	ИзвещениеФСС.ВходящийПервичныйДокумент = &ПервичныйДокумент
	|	И ИзвещениеФСС.ОпределятьАвтоматически
	|	И НЕ ИзвещениеФСС.Обработано";
	Запрос.УстановитьПараметр("ПервичныйДокумент", ЗаявлениеОбъект.ДокументОснование);
	// АПК:96-вкл
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Попытка
			ДокументОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ДокументОбъект.Заблокировать();
			ДокументОбъект.ОбновитьВторичныеДанные();
			ЗаписатьДокумент(ДокументОбъект, РежимЗаписиДокумента.Запись);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Не удалось обновить извещение ""%1"": %2'"),
				Выборка.Ссылка,
				Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			ВызватьИсключение ТекстОшибки;
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

Функция СписокВыбораЗаявлений(ФизическоеЛицо, ПервичныйДокумент, ИсключаемоеЗаявление, Количество) Экспорт
	Результат = Новый СписокЗначений;
	Если Не ЗначениеЗаполнено(ФизическоеЛицо) Тогда
		Возврат Результат;
	КонецЕсли;
	// Если первичный документ заполнен - получить последнее заявление по документу.
	Отбор = Новый Структура;
	Если ЗначениеЗаполнено(ПервичныйДокумент) Тогда
		Отбор.Вставить("ДокументОснование", ПервичныйДокумент);
	Иначе
		Отбор.Вставить("ФизическоеЛицо", ФизическоеЛицо);
	КонецЕсли;
	Поля = "Ссылка, Дата";
	Сортировки = "Дата Убыв, Ссылка Убыв";
	Запрос = Документы.ЗаявлениеСотрудникаНаВыплатуПособия.ЗапросПоДокументу(Отбор, Поля, Количество, Сортировки);
	Таблица = Запрос.Выполнить().Выгрузить();
	Результат.ЗагрузитьЗначения(Таблица.ВыгрузитьКолонку("Ссылка"));
	Если ЗначениеЗаполнено(ИсключаемоеЗаявление) Тогда
		ЭлементСписка = Результат.НайтиПоЗначению(ИсключаемоеЗаявление);
		Если ЭлементСписка <> Неопределено Тогда
			Результат.Удалить(ЭлементСписка);
		КонецЕсли;
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция РеестрыПоЗаявлению(Заявление, ПервичныйДокумент, ИсключаемоеЗаявление, Количество) Экспорт
	Если Не ЗначениеЗаполнено(Заявление) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 1
	|	Реестр.Ссылка КАК Ссылка,
	|	Реестр.СтатусДокумента КАК СтатусДокумента,
	|	Реестр.Номер КАК Номер,
	|	Реестр.Дата КАК Дата,
	|	ВЫБОР
	|		КОГДА Реестр.СтатусДокумента = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявленийИРеестровНаВыплатуПособий.ПринятФСС)
	|			ТОГДА 6
	|		КОГДА Реестр.СтатусДокумента = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявленийИРеестровНаВыплатуПособий.ПереданВФСС)
	|			ТОГДА 5
	|		КОГДА Реестр.СтатусДокумента = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявленийИРеестровНаВыплатуПособий.Подготовлен)
	|			ТОГДА 4
	|		КОГДА Реестр.СтатусДокумента = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявленийИРеестровНаВыплатуПособий.НеПринятФСС)
	|			ТОГДА 3
	|		КОГДА Реестр.СтатусДокумента = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаявленийИРеестровНаВыплатуПособий.Аннулирован)
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ВесСостояния,
	|	Реестр.ПометкаУдаления КАК ПометкаУдаления,
	|	Реестр.Проведен КАК Проведен
	|ИЗ
	|	Документ.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий.СведенияНеобходимыеДляНазначенияПособий КАК ТаблицаСведений
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий КАК Реестр
	|		ПО ТаблицаСведений.Ссылка = Реестр.Ссылка
	|ГДЕ
	|	&Условия
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПометкаУдаления,
	|	Проведен УБЫВ,
	|	ВесСостояния УБЫВ,
	|	Дата УБЫВ";
	
	Если Количество = 0 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1", "");
	ИначеЕсли Количество > 1 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПЕРВЫЕ 1", "ПЕРВЫЕ " + Формат(Количество, "ЧГ="));
	КонецЕсли;
	
	Условия = Новый Массив;
	Условия.Добавить("ТаблицаСведений.Заявление = &Заявление");
	Запрос.УстановитьПараметр("Заявление", Заявление);
	Если ЗначениеЗаполнено(ПервичныйДокумент) Тогда
		Условия.Добавить("ТаблицаСведений.ПервичныйДокумент = &ПервичныйДокумент");
		Запрос.УстановитьПараметр("ПервичныйДокумент", ПервичныйДокумент);
	КонецЕсли;
	Если ЗначениеЗаполнено(ИсключаемоеЗаявление) Тогда
		Условия.Добавить("ТаблицаСведений.Заявление <> &ИсключаемоеЗаявление");
		Запрос.УстановитьПараметр("ИсключаемоеЗаявление", ИсключаемоеЗаявление);
	КонецЕсли;
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&Условия", СтрСоединить(Условия, " И "));
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

#КонецОбласти

Процедура ЗаписатьДокумент(ДокументОбъект, РежимЗаписи) Экспорт
	ДокументОбъект.ДействияПередЗаписью();
	СЭДОФСС.ЗаписатьДокумент(ДокументОбъект, Истина, Ложь, РежимЗаписи);
КонецПроцедуры

#КонецОбласти

#КонецЕсли