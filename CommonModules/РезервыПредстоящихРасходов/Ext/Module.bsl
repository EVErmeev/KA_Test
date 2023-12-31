﻿#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиЭтаповЗакрытияМесяца

//++ НЕ УТ

#Область НачислениеСписаниеРезервовПредстоящихРасходов

// Добавляет этап в таблицу этапов закрытия месяца.
// Элементы данной таблицы являются элементами второго уровня в дереве этапов в форме закрытия месяца.
// 
// Параметры:
// 	ТаблицаЭтапов - (См. Обработки.ОперацииЗакрытияМесяца.ЗаполнитьОписаниеЭтаповЗакрытияМесяца)
// 	ТекущийРодитель - Строка - идентификатор группы.
Процедура ДобавитьЭтап_НачислениеСписаниеРезервовПредстоящихРасходов(ТаблицаЭтапов,ТекущийРодитель) Экспорт
	НоваяСтрока = ЗакрытиеМесяцаСервер.ДобавитьЭтапВТаблицу(ТаблицаЭтапов, ТекущийРодитель,
		Перечисления.ОперацииЗакрытияМесяца.НачислениеСписаниеРезервовПредстоящихРасходов,
		Ложь, Истина, Ложь);
	НоваяСтрока.ВыполняетсяВручную = Истина;
	НоваяСтрока.ТекстВыполнить = НСтр("ru='Отразить'");
	НоваяСтрока.ДействиеИспользование = ЗакрытиеМесяцаСервер.ОписаниеДействия_СервернаяПроцедура(
		"РезервыПредстоящихРасходов.Использование_НачислениеСписаниеРезервовПредстоящихРасходов");
	НоваяСтрока.ДействиеВыполнить  = ЗакрытиеМесяцаСервер.ОписаниеДействия_ОткрытьФорму(
		Метаданные.Документы.НачислениеСписаниеРезервовПредстоящихРасходов.Формы.ФормаРабочееМесто.ПолноеИмя());
	НоваяСтрока.ДействиеВыполнить.ПараметрыФормы.Вставить("ВсеОрганизации");

КонецПроцедуры

Процедура Использование_НачислениеСписаниеРезервовПредстоящихРасходов(ПараметрыОбработчика) Экспорт
	
	ЗакрытиеМесяцаСервер.УвеличитьКоличествоОбработанныхДанныхДляЗамера(ПараметрыОбработчика, 1);
	
	Запрос = Новый Запрос;
	ЗакрытиеМесяцаСервер.ИнициализироватьЗапрос(Запрос, ПараметрыОбработчика);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбъектыУчетаРезервов.Организация КАК Организация,
	|	ОбъектыУчетаРезервов.ВидРезервов КАК ВидРезервов,
	|	ОбъектыУчетаРезервов.Ссылка КАК ОбъектУчетаРезервов
	|ПОМЕСТИТЬ ВТРезервы
	|ИЗ
	|	Справочник.ОбъектыУчетаРезервовПредстоящихРасходов КАК ОбъектыУчетаРезервов
	|ГДЕ
	|	ОбъектыУчетаРезервов.НачалоПериода <= &КонецПериода
	|	И ОбъектыУчетаРезервов.КонецПериода = ДАТАВРЕМЯ(1,1,1)
	|	И ОбъектыУчетаРезервов.Организация В (&МассивОрганизаций)
	|	И НЕ ОбъектыУчетаРезервов.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	ОбъектыУчетаРезервов.Организация КАК Организация,
	|	ОбъектыУчетаРезервов.ВидРезервов КАК ВидРезервов,
	|	ОбъектыУчетаРезервов.Ссылка КАК ОбъектУчетаРезервов
	|ИЗ
	|	Справочник.ОбъектыУчетаРезервовПредстоящихРасходов КАК ОбъектыУчетаРезервов
	|ГДЕ
	|	ОбъектыУчетаРезервов.НачалоПериода <= &КонецПериода
	|	И ОбъектыУчетаРезервов.КонецПериода >= &КонецПериода
	|	И ОбъектыУчетаРезервов.Организация В (&МассивОрганизаций)
	|	И НЕ ОбъектыУчетаРезервов.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|	
	|ВЫБРАТЬ
	|	РезервыПредстоящихРасходов.Организация КАК Организация,
	|	РезервыПредстоящихРасходов.ВидРезервов КАК ВидРезервов,
	|	РезервыПредстоящихРасходов.ОбъектУчетаРезервов КАК ОбъектУчетаРезервов
	|ИЗ
	|	РегистрНакопления.РезервыПредстоящихРасходов.Остатки(&КонецПериода, Организация В (&МассивОрганизаций)) КАК РезервыПредстоящихРасходов
	|ГДЕ
	|	РезервыПредстоящихРасходов.СуммаУпрОстаток <> 0
	|	ИЛИ РезервыПредстоящихРасходов.СуммаРеглОстаток <> 0
	|	ИЛИ РезервыПредстоящихРасходов.СуммаНУОстаток <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	ВидРезервов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВидыРезервов.Организация КАК Организация,
	|	ВидыРезервов.ВидРезервов КАК ВидРезервов
	|ПОМЕСТИТЬ ВТРезервыКОтражению
	|ИЗ
	|	ВТРезервы КАК ВидыРезервов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НачислениеСписаниеРезервовПредстоящихРасходов КАК ОтражениеРезервов
	|		ПО (ОтражениеРезервов.Дата = &КонецПериода)
	|			И ВидыРезервов.Организация = ОтражениеРезервов.Организация
	|			И (ВидыРезервов.ВидРезервов = ОтражениеРезервов.ВидРезервов)
	|			И (ОтражениеРезервов.Проведен)
	|ГДЕ
	|	ОтражениеРезервов.Ссылка ЕСТЬ NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ОбъектыРезервов.Организация КАК Организация,
	|	ОбъектыРезервов.ВидРезервов КАК ВидРезервов,
	|	ОбъектыРезервов.ОбъектУчетаРезервов КАК ОбъектУчетаРезервов,
	|	ОтражениеРезервов.Ссылка КАК Документ
	|ПОМЕСТИТЬ ВТОбъектыУчетаРезервовКОтражению
	|ИЗ
	|	ВТРезервы КАК ОбъектыРезервов
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.НачислениеСписаниеРезервовПредстоящихРасходов КАК ОтражениеРезервов
	|		ПО (ОтражениеРезервов.Дата = &КонецПериода)
	|			И ОбъектыРезервов.Организация = ОтражениеРезервов.Организация
	|			И (ОбъектыРезервов.ВидРезервов = ОтражениеРезервов.ВидРезервов)
	|			И (ОтражениеРезервов.Проведен)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.НачислениеСписаниеРезервовПредстоящихРасходов.Резервы КАК РезервыОтраженияРезервов
	|		ПО ОтражениеРезервов.Ссылка = РезервыОтраженияРезервов.Ссылка
	|			И (ОбъектыРезервов.ОбъектУчетаРезервов = РезервыОтраженияРезервов.ОбъектУчетаРезервов)
	|ГДЕ
	|	РезервыОтраженияРезервов.ОбъектУчетаРезервов ЕСТЬ NULL";
	Запрос.Выполнить();
	
	РазмерыВременныхТаблиц = ЗакрытиеМесяцаСервер.РазмерыВременныхТаблиц(Запрос, ПараметрыОбработчика);
	
	Если РазмерыВременныхТаблиц.ВТРезервы = 0 Тогда
		
		ЗакрытиеМесяцаСервер.УстановитьСостояниеНеТребуется(
			ПараметрыОбработчика,
			НСтр("ru='Нет объектов учета резервов, требующих отражения начисления или списание резервов'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
	ИначеЕсли РазмерыВременныхТаблиц.ВТОбъектыУчетаРезервовКОтражению <> 0 Тогда
		
		ЗакрытиеМесяцаСервер.УстановитьСостояниеВыполненСОшибками(
			ПараметрыОбработчика,
			НСтр("ru='Отражение резервов предстоящих расходов выполнено'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
	ИначеЕсли РазмерыВременныхТаблиц.ВТРезервыКОтражению = 0 Тогда
		
		ЗакрытиеМесяцаСервер.УстановитьСостояниеНеТребуется(
			ПараметрыОбработчика,
			НСтр("ru='Отражение резервов предстоящих расходов выполнено'", ОбщегоНазначения.КодОсновногоЯзыка()));
		
	КонецЕсли;	
	
КонецПроцедуры

// Проверки состояния системы, относящиеся к этапу.

Процедура ОписаниеПроверок_НачислениеСписаниеРезервовПредстоящихРасходов(ТаблицаПроверок) Экспорт
	
	// Отражение резервов.
	ОписаниеПроверки = ЗакрытиеМесяцаСервер.ДобавитьОписаниеНовойПроверки(ТаблицаПроверок,
		"ПроверкаНеобходимостиНачислениеСписаниеРезервовПредстоящихРасходов",
		Перечисления.ОперацииЗакрытияМесяца.НачислениеСписаниеРезервовПредстоящихРасходов,
		Перечисления.МоментЗапускаПроверкиОперацииЗакрытияМесяца.ДоИПослеРасчета,
		"РезервыПредстоящихРасходов.ПроверкаНеобходимостиНачислениеСписаниеРезервовПредстоящихРасходов");
	
	ЗакрытиеМесяцаСервер.ЗаполнитьПредставлениеНовойПроверки(ОписаниеПроверки,
		НСтр("ru='Не отражена операция начисления/списания резервов предстоящих расходов'", ОбщегоНазначения.КодОсновногоЯзыка()),
		НСтр("ru='По всем видам резервов должны быть созданы документы ""Начисления и списания резервов предстоящих расходов"".'", ОбщегоНазначения.КодОсновногоЯзыка()));
	
КонецПроцедуры

// Обработчик проверки необходимости выполнения этапа 
//
//  Параметры:
//	ПараметрыПроверки - см. АудитСостоянияСистемы.ИнициализироватьПараметрыПроверки
//
Процедура ПроверкаНеобходимостиНачислениеСписаниеРезервовПредстоящихРасходов(ПараметрыПроверки) Экспорт
	
	СписокПолей = Новый СписокЗначений;
	СписокПолей.Добавить("Организация", НСтр("ru='Организация'", ОбщегоНазначения.КодОсновногоЯзыка()));
	СписокПолей.Добавить("ВидРезервов", НСтр("ru='Вид резервов'", ОбщегоНазначения.КодОсновногоЯзыка()));
	
	ПараметрыРегистрации = ЗакрытиеМесяцаСервер.ИнициализироватьПараметрыРегистрацииПроблемПроверки(
		"ВТРезервыКОтражению",
		НСтр("ru='Не созданы документы ""Начисления и списания резервов предстоящих расходов"" по организации ""%1"" за период %2'", ОбщегоНазначения.КодОсновногоЯзыка()),
		СписокПолей);
		
	Если ЗначениеЗаполнено(ПараметрыПроверки.ДополнительныеПараметры) Тогда
		КоличествоДанных = РасчетСебестоимостиПрикладныеАлгоритмы.РазмерВременнойТаблицы(
			ПараметрыПроверки.ДополнительныеПараметры.МенеджерВременныхТаблиц,
			"ВТРезервыКОтражению");
		ЗакрытиеМесяцаСервер.УвеличитьКоличествоОбработанныхДанныхДляЗамера(
			ПараметрыПроверки.ДополнительныеПараметры,
			КоличествоДанных);
	КонецЕсли;
		
	ШаблонТекстаОшибки = НСтр("ru = 'Для документов ""Начисления и списания резервов предстоящих расходов"" по организации ""%1"" за период %2 указаны не все объекты учета резервов'", ОбщегоНазначения.КодОсновногоЯзыка());
	РасширенныйСписокПолей = СписокПолей.Скопировать();
	РасширенныйСписокПолей.Добавить("ОбъектУчетаРезервов", НСтр("ru = 'Объект учета резервов'", ОбщегоНазначения.КодОсновногоЯзыка()));
	РасширенныйСписокПолей.Добавить("Документ", НСтр("ru = 'Документ начисления и списания резервов'", ОбщегоНазначения.КодОсновногоЯзыка()));
	ЗакрытиеМесяцаСервер.ДополнитьПараметрыРегистрацииПроблемПроверки(ПараметрыРегистрации, "ВТОбъектыУчетаРезервовКОтражению", ШаблонТекстаОшибки, РасширенныйСписокПолей, "Документ");
	
	ЗакрытиеМесяцаСервер.ЗарегистрироватьПроблемыВыполненияПроверки(
	 	ПараметрыПроверки,
		ПараметрыРегистрации);
	
КонецПроцедуры

#КонецОбласти
//-- НЕ УТ

#КонецОбласти

//++ НЕ УТ

Процедура РезервыОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Если НЕ Параметры.Свойство("Отбор") ИЛИ ТипЗнч(Параметры.Отбор) <> Тип("Структура") Тогда
		Параметры.Вставить("Отбор", Новый Структура);
	КонецЕсли;
	
	КлючНазначенияИспользования =
		ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "КлючНазначенияИспользования", "РезервыПредстоящихРасходов");
	ТипыРезервов = Перечисления.ТипыРезервовПредстоящихРасходов.ТипыРезервовПоНазначению(КлючНазначенияИспользования);
	ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Параметры.Отбор, Новый Структура("ТипРезерва", ТипыРезервов), Ложь);
	
КонецПроцедуры

//-- НЕ УТ

#КонецОбласти