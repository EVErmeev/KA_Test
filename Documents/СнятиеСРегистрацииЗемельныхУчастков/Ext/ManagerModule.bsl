﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Команды

// Добавляет команду создания документа "Отмена регистрации земельных участков".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.СнятиеСРегистрацииЗемельныхУчастков) Тогда
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.СнятиеСРегистрацииЗемельныхУчастков.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.СнятиеСРегистрацииЗемельныхУчастков);
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		Возврат КомандаСоздатьНаОсновании;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("ИмущественныеНалоги");
	МеханизмыДокумента.Добавить("ОсновныеСредства");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура - коллекция элементов:
//     * Таблица<ИмяРегистра> - ТаблицаЗначений - таблица данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		
		ЗаполнитьПараметрыИнициализации(Запрос, Документ);
		
		ТекстЗапросаТаблицаПараметрыНачисленияЗемельногоНалога(ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДокументыПоОС(Запрос, ТекстыЗапроса, Регистры);
		
	КонецЕсли;
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

// Формирует таблицы движений при отложенном проведении.
//
// Параметры:
//  ДокументСсылка			 - ДокументСсылка.СнятиеСРегистрацииЗемельныхУчастков - Документ, для которого формируются движения
//  МенеджерВременныхТаблиц	 - МенеджерВременныхТаблиц - Содержит вспомогательные временные таблицы, которые могут использоваться для формирования движений.
//
// Возвращаемое значение:
//  см. ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения
Функция ТаблицыОтложенногоФормированияДвижений(ДокументСсылка, МенеджерВременныхТаблиц) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаПараметрыНачисленияЗемельногоНалога(ТекстыЗапроса, Неопределено);
	
	ТаблицыДляДвижений = ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(
		Запрос, ТекстыЗапроса, Неопределено);
	
	Возврат ТаблицыДляДвижений;
	
КонецФункции

#КонецОбласти

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Проведение

Функция ДополнительныеИсточникиДанныхДляДвижений(ИмяРегистра) Экспорт
	
	ИсточникиДанных = Новый Соответствие;
	Возврат ИсточникиДанных;
	
КонецФункции

Функция АдаптированныйТекстЗапросаДвиженийПоРегистру(ИмяРегистра) Экспорт

	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	ПолноеИмяДокумента = "Документ.СнятиеСРегистрацииЗемельныхУчастков";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	ПереопределениеРасчетаПараметров.Вставить("НомерНаПечать", """""");
	
	ВЗапросеЕстьИсточник = Истина;
	
	Если ИмяРегистра = "РеестрДокументов" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "";
		ВЗапросеЕстьИсточник = Ложь;
		
	ИначеЕсли ИмяРегистра = "ДокументыПоОС" Тогда
		
		ТекстЗапроса = ТекстЗапросаТаблицаДокументыПоОС(Запрос, ТекстыЗапроса, ИмяРегистра);
		СинонимТаблицыДокумента = "ДанныеДокумента";
		
	Иначе
		ТекстИсключения = НСтр("ru = 'В документе %ПолноеИмяДокумента% не реализована адаптация текста запроса формирования движений по регистру %ИмяРегистра%.'");
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ПолноеИмяДокумента%", ПолноеИмяДокумента);
		ТекстИсключения = СтрЗаменить(ТекстИсключения, "%ИмяРегистра%", ИмяРегистра);
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Если ИмяРегистра = "РеестрДокументов"
		ИЛИ ИмяРегистра = "ДокументыПоОС" Тогда
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросПроведенияПоНезависимомуРегистру(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ВЗапросеЕстьИсточник,
										ПереопределениеРасчетаПараметров);
	Иначе	
		
		ТекстЗапроса = ОбновлениеИнформационнойБазыУТ.АдаптироватьЗапросМеханизмаПроведения(
										ТекстЗапроса,
										ПолноеИмяДокумента,
										СинонимТаблицыДокумента,
										ПереопределениеРасчетаПараметров);
	КонецЕсли; 

	Результат = ОбновлениеИнформационнойБазыУТ.РезультатАдаптацииЗапроса();
	Результат.ЗначенияПараметров = ЗначенияПараметров;
	Результат.ТекстЗапроса = ТекстЗапроса;
	
	Возврат Результат;
	
КонецФункции

Процедура ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка)
	
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Организация КАК Организация,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.ПометкаУдаления КАК ПометкаУдаления,
	|	ДанныеДокумента.Проведен КАК Проведен,
	|	ДанныеДокумента.Комментарий КАК Комментарий,
	|	ДанныеДокумента.Ответственный КАК Ответственный,
	|	ДанныеДокумента.СнятиеСРегистрацииСПрошлойДаты КАК СнятиеСРегистрацииСПрошлойДаты,
	|	КОНЕЦПЕРИОДА(ДанныеДокумента.ДатаСнятияСРегистрации, ДЕНЬ) КАК ДатаСнятияСРегистрации
	|ИЗ
	|	Документ.СнятиеСРегистрацииЗемельныхУчастков КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла; 
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.СнятиеСРегистрацииЗемельныхУчастков"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.СнятиеСРегистрацииЗемельныхУчастков);

	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Процедура ТекстЗапросаТаблицаПараметрыНачисленияЗемельногоНалога(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ПараметрыНачисленияЗемельногоНалога";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаТаблицаВтСписокОС(
		ТекстыЗапроса, "Документ.СнятиеСРегистрацииЗемельныхУчастков");

	ВнеоборотныеАктивыЛокализация.ТекстЗапросаТаблицаВтПараметрыНачисленияЗемельногоНалога(
		ТекстыЗапроса, "Документ.СнятиеСРегистрацииЗемельныхУчастков");
	
	Текст = 
	"ВЫБРАТЬ
	|	НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) КАК Период,
	|	ДАТАВРЕМЯ(1,1,1) КАК ДатаИсправления,
	|
	|	&Организация КАК Организация,
	|	ТабличнаяЧастьДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	ЛОЖЬ КАК ВключатьВНалоговуюБазу,
	|
	|	ПараметрыНачисленияЗемельногоНалога.КодКатегорииЗемель КАК КодКатегорииЗемель,
	|	ПараметрыНачисленияЗемельногоНалога.КадастровыйНомер КАК КадастровыйНомер,
	|	ПараметрыНачисленияЗемельногоНалога.КадастроваяСтоимость КАК КадастроваяСтоимость,
	|	ПараметрыНачисленияЗемельногоНалога.ОбщаяСобственность КАК ОбщаяСобственность,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляВПравеОбщейСобственностиЧислитель КАК ДоляВПравеОбщейСобственностиЧислитель,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляВПравеОбщейСобственностиЗнаменатель КАК ДоляВПравеОбщейСобственностиЗнаменатель,
	|	ПараметрыНачисленияЗемельногоНалога.ЖилищноеСтроительство КАК ЖилищноеСтроительство,
	|	ПараметрыНачисленияЗемельногоНалога.ДатаНачалаПроектирования КАК ДатаНачалаПроектирования,
	|	ПараметрыНачисленияЗемельногоНалога.ДатаРегистрацииПравНаОбъектНедвижимости КАК ДатаРегистрацииПравНаОбъектНедвижимости,
	|	ПараметрыНачисленияЗемельногоНалога.ПостановкаНаУчетВНалоговомОргане КАК ПостановкаНаУчетВНалоговомОргане,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговыйОрган КАК НалоговыйОрган,
	|	ПараметрыНачисленияЗемельногоНалога.КодПоОКТМО КАК КодПоОКТМО,
	|	ПараметрыНачисленияЗемельногоНалога.КодПоОКАТО КАК КодПоОКАТО,
	|	ПараметрыНачисленияЗемельногоНалога.КБК КАК КБК,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговаяСтавка КАК НалоговаяСтавка,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговаяЛьготаПоНалоговойБазе КАК НалоговаяЛьготаПоНалоговойБазе,
	|	ПараметрыНачисленияЗемельногоНалога.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395 КАК КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395,
	|	ПараметрыНачисленияЗемельногоНалога.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391 КАК КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391,
	|	ПараметрыНачисленияЗемельногоНалога.УменьшениеНалоговойБазыПоСтатье391 КАК УменьшениеНалоговойБазыПоСтатье391,
	|	ПараметрыНачисленияЗемельногоНалога.УменьшениеНалоговойБазыНаСумму КАК УменьшениеНалоговойБазыНаСумму,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляНеОблагаемойНалогомПлощадиЧислитель КАК ДоляНеОблагаемойНалогомПлощадиЧислитель,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляНеОблагаемойНалогомПлощадиЗнаменатель КАК ДоляНеОблагаемойНалогомПлощадиЗнаменатель,
	|	ПараметрыНачисленияЗемельногоНалога.НеОблагаемаяНалогомСумма КАК НеОблагаемаяНалогомСумма,
	|	ПараметрыНачисленияЗемельногоНалога.СниженнаяНалоговаяСтавка КАК СниженнаяНалоговаяСтавка,
	|	ПараметрыНачисленияЗемельногоНалога.ПроцентУменьшенияСуммыНалога КАК ПроцентУменьшенияСуммыНалога,
	|	ПараметрыНачисленияЗемельногоНалога.СуммаУменьшенияСуммыНалога КАК СуммаУменьшенияСуммыНалога,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидЗаписиОРегистрации.СнятиеСРегистрационногоУчета) КАК ВидЗаписи
	|ИЗ
	|	Документ.СнятиеСРегистрацииЗемельныхУчастков.ОС КАК ТабличнаяЧастьДокумента
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ втПараметрыНачисленияЗемельногоНалога КАК ПараметрыНачисленияЗемельногоНалога
	|		ПО ПараметрыНачисленияЗемельногоНалога.ОсновноеСредство = ТабличнаяЧастьДокумента.ОсновноеСредство
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПараметрыНачисленияЗемельногоНалога.СрезПоследних(
	|			&Период, 
	|			Регистратор <> &Ссылка
	|				И Организация = &Организация
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						СписокОС.ОсновноеСредство
	|					ИЗ
	|						втСписокОС КАК СписокОС)) КАК ДанныеРегистраПоследнее
	|		ПО ДанныеРегистраПоследнее.ОсновноеСредство = ТабличнаяЧастьДокумента.ОсновноеСредство
	|ГДЕ
	|	ТабличнаяЧастьДокумента.Ссылка = &Ссылка
	|	И (НЕ &СнятиеСРегистрацииСПрошлойДаты
	|		ИЛИ ЕСТЬNULL(ДанныеРегистраПоследнее.Период, ДАТАВРЕМЯ(1,1,1)) < &Период)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	&ДатаСнятияСРегистрации КАК Период,
	|	&Период КАК ДатаИсправления,
	|
	|	&Организация КАК Организация,
	|	ТабличнаяЧастьДокумента.ОсновноеСредство КАК ОсновноеСредство,
	|	
	|	ЛОЖЬ КАК ВключатьВНалоговуюБазу,
	|
	|	ПараметрыНачисленияЗемельногоНалога.КодКатегорииЗемель КАК КодКатегорииЗемель,
	|	ПараметрыНачисленияЗемельногоНалога.КадастровыйНомер КАК КадастровыйНомер,
	|	ПараметрыНачисленияЗемельногоНалога.КадастроваяСтоимость КАК КадастроваяСтоимость,
	|	ПараметрыНачисленияЗемельногоНалога.ОбщаяСобственность КАК ОбщаяСобственность,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляВПравеОбщейСобственностиЧислитель КАК ДоляВПравеОбщейСобственностиЧислитель,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляВПравеОбщейСобственностиЗнаменатель КАК ДоляВПравеОбщейСобственностиЗнаменатель,
	|	ПараметрыНачисленияЗемельногоНалога.ЖилищноеСтроительство КАК ЖилищноеСтроительство,
	|	ПараметрыНачисленияЗемельногоНалога.ДатаНачалаПроектирования КАК ДатаНачалаПроектирования,
	|	ПараметрыНачисленияЗемельногоНалога.ДатаРегистрацииПравНаОбъектНедвижимости КАК ДатаРегистрацииПравНаОбъектНедвижимости,
	|	ПараметрыНачисленияЗемельногоНалога.ПостановкаНаУчетВНалоговомОргане КАК ПостановкаНаУчетВНалоговомОргане,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговыйОрган КАК НалоговыйОрган,
	|	ПараметрыНачисленияЗемельногоНалога.КодПоОКТМО КАК КодПоОКТМО,
	|	ПараметрыНачисленияЗемельногоНалога.КодПоОКАТО КАК КодПоОКАТО,
	|	ПараметрыНачисленияЗемельногоНалога.КБК КАК КБК,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговаяСтавка КАК НалоговаяСтавка,
	|	ПараметрыНачисленияЗемельногоНалога.НалоговаяЛьготаПоНалоговойБазе КАК НалоговаяЛьготаПоНалоговойБазе,
	|	ПараметрыНачисленияЗемельногоНалога.КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395 КАК КодНалоговойЛьготыОсвобождениеОтНалогообложенияПоСтатье395,
	|	ПараметрыНачисленияЗемельногоНалога.КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391 КАК КодНалоговойЛьготыУменьшениеНалоговойБазыПоСтатье391,
	|	ПараметрыНачисленияЗемельногоНалога.УменьшениеНалоговойБазыПоСтатье391 КАК УменьшениеНалоговойБазыПоСтатье391,
	|	ПараметрыНачисленияЗемельногоНалога.УменьшениеНалоговойБазыНаСумму КАК УменьшениеНалоговойБазыНаСумму,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляНеОблагаемойНалогомПлощадиЧислитель КАК ДоляНеОблагаемойНалогомПлощадиЧислитель,
	|	ПараметрыНачисленияЗемельногоНалога.ДоляНеОблагаемойНалогомПлощадиЗнаменатель КАК ДоляНеОблагаемойНалогомПлощадиЗнаменатель,
	|	ПараметрыНачисленияЗемельногоНалога.НеОблагаемаяНалогомСумма КАК НеОблагаемаяНалогомСумма,
	|	ПараметрыНачисленияЗемельногоНалога.СниженнаяНалоговаяСтавка КАК СниженнаяНалоговаяСтавка,
	|	ПараметрыНачисленияЗемельногоНалога.ПроцентУменьшенияСуммыНалога КАК ПроцентУменьшенияСуммыНалога,
	|	ПараметрыНачисленияЗемельногоНалога.СуммаУменьшенияСуммыНалога КАК СуммаУменьшенияСуммыНалога,
	|	
	|	ЗНАЧЕНИЕ(Перечисление.ВидЗаписиОРегистрации.СнятиеСРегистрационногоУчета) КАК ВидЗаписи
	|ИЗ
	|	Документ.СнятиеСРегистрацииЗемельныхУчастков.ОС КАК ТабличнаяЧастьДокумента
	|
	|		ЛЕВОЕ СОЕДИНЕНИЕ втПараметрыНачисленияЗемельногоНалога КАК ПараметрыНачисленияЗемельногоНалога
	|		ПО ПараметрыНачисленияЗемельногоНалога.ОсновноеСредство = ТабличнаяЧастьДокумента.ОсновноеСредство
	|ГДЕ
	|	ТабличнаяЧастьДокумента.Ссылка = &Ссылка
	|	И &СнятиеСРегистрацииСПрошлойДаты";
	
	ТекстыЗапроса.Добавить(Текст, ИмяРегистра);
	
КонецПроцедуры

Функция ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "РеестрДокументов";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	&Ссылка                                 КАК Ссылка,
	|	&Период                                 КАК ДатаДокументаИБ,
	|	&Номер                                  КАК НомерДокументаИБ,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	&Организация                            КАК Организация,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&Ответственный                          КАК Ответственный,
	|	&Комментарий                            КАК Комментарий,
	|	&Проведен                               КАК Проведен,
	|	&ПометкаУдаления                        КАК ПометкаУдаления,
	|	ЛОЖЬ                                    КАК ДополнительнаяЗапись,
	|	&Период                                 КАК ДатаПервичногоДокумента,
	|	&НомерНаПечать                          КАК НомерПервичногоДокумента,
	|	ЛОЖЬ                                    КАК СторноИсправление,
	|	НЕОПРЕДЕЛЕНО                            КАК СторнируемыйДокумент,
	|	НЕОПРЕДЕЛЕНО                            КАК ИсправляемыйДокумент,
	|	&Период                                 КАК ДатаОтраженияВУчете,
	|	НЕОПРЕДЕЛЕНО                            КАК Приоритет";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ТекстЗапросаТаблицаДокументыПоОС(Запрос, ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "ДокументыПоОС";
	
	Если НЕ ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат "";
	КонецЕсли;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаОС.НомерСтроки-1, 0)    КАК НомерЗаписи,
	|	&Ссылка                                 КАК Ссылка,
	|	&Период                                 КАК Дата,
	|	&Организация                            КАК Организация,
	|	&Проведен                               КАК Проведен,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	&ИдентификаторМетаданных                КАК ТипСсылки,
	|	ИСТИНА                                  КАК ОтражатьВРеглУчете,
	|	ЛОЖЬ                                    КАК ОтражатьВУпрУчете,
	|	ТаблицаОС.ОсновноеСредство              КАК ОсновноеСредство,
	|	&СнятиеСРегистрацииСПрошлойДаты         КАК ЭтоИсправление,
	|
	|	ВЫБОР
	|		КОГДА &СнятиеСРегистрацииСПрошлойДаты
	|			ТОГДА &ДатаСнятияСРегистрации
	|		ИНАЧЕ ДАТАВРЕМЯ(1,1,1)
	|	КОНЕЦ                             КАК НачалоПериодаИсправления,
	|
	|	ВЫБОР
	|		КОГДА &СнятиеСРегистрацииСПрошлойДаты
	|			ТОГДА КОНЕЦПЕРИОДА(&Период, МЕСЯЦ)
	|		ИНАЧЕ ДАТАВРЕМЯ(1,1,1)
	|	КОНЕЦ                             КАК КонецПериодаИсправления
	|ИЗ
	|	Документ.СнятиеСРегистрацииЗемельныхУчастков КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.СнятиеСРегистрацииЗемельныхУчастков.ОС КАК ТаблицаОС
	|		ПО ТаблицаОС.Ссылка = ДанныеДокумента.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область Печать

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#Область БлокировкаПриОбновленииИБ

Процедура ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ПредставлениеОперации) Экспорт
	
	ВходящиеДанные = Новый Соответствие;
	
	ЗакрытиеМесяцаСервер.ПроверитьБлокировкуВходящихДанныхПриОбновленииИБ(ВходящиеДанные, ПредставлениеОперации);
	
КонецПроцедуры

#КонецОбласти

#Область СтандартныеПодсистемы

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	Возврат; //В дальнейшем будет добавлен код команд
	
КонецПроцедуры

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
