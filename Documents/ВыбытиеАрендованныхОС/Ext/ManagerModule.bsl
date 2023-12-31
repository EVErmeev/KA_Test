﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Проведение

// Описывает учетные механизмы используемые в документе для регистрации в механизме проведения.
//
// Параметры:
//  МеханизмыДокумента - Массив - список имен учетных механизмов, для которых будет выполнена
//              регистрация в механизме проведения.
//
Процедура ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента) Экспорт
	
	МеханизмыДокумента.Добавить("ОсновныеСредства");
	МеханизмыДокумента.Добавить("РеестрДокументов");
	
	ВыбытиеАрендованныхОСЛокализация.ЗарегистрироватьУчетныеМеханизмы(МеханизмыДокумента);
	
КонецПроцедуры

// Возвращает таблицы для движений, необходимые для проведения документа по регистрам учетных механизмов.
//
// Параметры:
//  Документ - ДокументСсылка - ссылка на документ, по которому необходимо получить данные
//  Регистры - Структура - список имен регистров, для которых необходимо получить таблицы
//  ДопПараметры - Структура - дополнительные параметры для получения данных, определяющие контекст проведения.
//
// Возвращаемое значение:
//  Структура:
//     * Ключ - Строка - Имя таблицы.
//     * Значение - ТаблицаЗначений - таблица данных для отражения в регистр.
//
Функция ДанныеДокументаДляПроведения(Документ, Регистры, ДопПараметры = Неопределено) Экспорт
	
	Если ДопПараметры = Неопределено Тогда
		ДопПараметры = ПроведениеДокументов.ДопПараметрыИнициализироватьДанныеДокументаДляПроведения();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстыЗапроса = Новый СписокЗначений;
	
	Если Не ДопПараметры.ПолучитьТекстыЗапроса Тогда
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		ЗаполнитьПараметрыИнициализации(Запрос, Документ);
		
		ТекстЗапросаТаблицаПервоначальныеСведенияОС(ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаАрендованныеОС(ТекстыЗапроса, Регистры);
				
		ТекстЗапросаТаблицаРеестрДокументов(Запрос, ТекстыЗапроса, Регистры);
		ТекстЗапросаТаблицаДокументыПоОС(Запрос, ТекстыЗапроса, Регистры);
		
		ВыбытиеАрендованныхОСЛокализация.ДополнитьТекстыЗапросовПроведения(Запрос, ТекстыЗапроса, Регистры);
	КонецЕсли;
	
	Возврат ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, ДопПараметры);
	
КонецФункции

// Формирует таблицы движений при отложенном проведении.
//
// Параметры:
//  ДокументСсылка			 - ДокументСсылка.ВыбытиеАрендованныхОС - Документ, для которого формируются движения
//  МенеджерВременныхТаблиц	 - МенеджерВременныхТаблиц - Содержит вспомогательные временные таблицы, которые могут использоваться для формирования движений.
//  
// Возвращаемое значение:
//  см. ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения
//
Функция ТаблицыОтложенногоФормированияДвижений(ДокументСсылка, МенеджерВременныхТаблиц) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	ЗаполнитьПараметрыИнициализации(Запрос, ДокументСсылка);
	
	ТекстыЗапроса = Новый СписокЗначений;
	ТекстЗапросаТаблицаСтоимостьОС(ТекстыЗапроса);
	
	ТаблицыДляДвижений = ПроведениеДокументов.ИнициализироватьДанныеДокументаДляПроведения(Запрос, ТекстыЗапроса, Неопределено);
	
	Возврат ТаблицыДляДвижений;
	
КонецФункции

#КонецОбласти

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	
	
КонецПроцедуры

// Добавляет команду создания документа "Выбытие арендованных ОС".
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//	СтрокаТаблицыЗначений - добавленная команда.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Если ПравоДоступа("Добавление", Метаданные.Документы.ВыбытиеАрендованныхОС) Тогда
		
		КомандаСоздатьНаОсновании = КомандыСозданияНаОсновании.Добавить();
		КомандаСоздатьНаОсновании.Менеджер = Метаданные.Документы.ВыбытиеАрендованныхОС.ПолноеИмя();
		КомандаСоздатьНаОсновании.Представление = ОбщегоНазначенияУТ.ПредставлениеОбъекта(Метаданные.Документы.ВыбытиеАрендованныхОС);
		КомандаСоздатьНаОсновании.ФункциональныеОпции = "ИспользоватьВнеоборотныеАктивы2_2,ИспользоватьВнеоборотныеАктивы2_4";
		КомандаСоздатьНаОсновании.РежимЗаписи = "Проводить";
		
		Возврат КомандаСоздатьНаОсновании;
		
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//   Параметры - См. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

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
	
	ПолноеИмяДокумента = "Документ.ВыбытиеАрендованныхОС";
	
	ЗначенияПараметров = ЗначенияПараметровПроведения();
	ПереопределениеРасчетаПараметров = Новый Структура;
	
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
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК Ссылка,
	|	ДанныеДокумента.Дата КАК Период,
	|	ДанныеДокумента.Номер КАК Номер,
	|	ДанныеДокумента.ПометкаУдаления,
	|	ДанныеДокумента.Проведен,
	|	ДанныеДокумента.Комментарий,
	|	ДанныеДокумента.Ответственный,
	|	ДанныеДокумента.Организация,
	|	ДанныеДокумента.Контрагент,
	|	ДанныеДокумента.Договор
	|ИЗ
	|	Документ.ВыбытиеАрендованныхОС КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	Результат = Запрос.Выполнить();
	Реквизиты = Результат.Выбрать();
	Реквизиты.Следующий();
	
	Для Каждого Колонка Из Результат.Колонки Цикл
		Запрос.УстановитьПараметр(Колонка.Имя, Реквизиты[Колонка.Имя]);
	КонецЦикла;
	
	Запрос.УстановитьПараметр("КонецДня", Новый Граница(КонецДня(Реквизиты.Период),ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Граница", Новый Граница(НачалоМесяца(Реквизиты.Период), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("ИспользуетсяУправлениеВНА_2_4", ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4(Реквизиты.Период));
	
	ЗначенияПараметровПроведения = ЗначенияПараметровПроведения(Реквизиты);
	Для каждого КлючИЗначение Из ЗначенияПараметровПроведения Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла; 
	
КонецПроцедуры

Функция ЗначенияПараметровПроведения(Реквизиты = Неопределено)

	ЗначенияПараметровПроведения = Новый Структура;
	ЗначенияПараметровПроведения.Вставить("ИдентификаторМетаданных", ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Документ.ВыбытиеАрендованныхОС"));
	ЗначенияПараметровПроведения.Вставить("ХозяйственнаяОперация", Перечисления.ХозяйственныеОперации.ВыбытиеАрендованныхОС);
	ЗначенияПараметровПроведения.Вставить("НазваниеДокумента", НСтр("ru = 'Выбытие арендованных ОС'"));
	ЗначенияПараметровПроведения.Вставить("НастройкаХозяйственнойОперации", Справочники.НастройкиХозяйственныхОпераций.ВыбытиеАрендованныхОС);

	Если Реквизиты <> Неопределено Тогда
		ЗначенияПараметровПроведения.Вставить("НомерНаПечать", ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Реквизиты.Номер));
	КонецЕсли; 
	
	Возврат ЗначенияПараметровПроведения;
	
КонецФункции

Процедура ТекстЗапросаТаблицаПервоначальныеСведенияОС(ТекстыЗапроса, Регистры)

	ИмяРегистра = "ПервоначальныеСведенияОС";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаТаблицаВтПервоначальныеСведенияОС(ТекстыЗапроса, "Документ.ВыбытиеАрендованныхОС");
	
	ТекстЗапроса = ВыбытиеАрендованныхОСЛокализация.ТекстЗапросаТаблицаПервоначальныеСведенияОС();
	
	Если ТекстЗапроса = Неопределено Тогда
		ТекстЗапроса =
		"ВЫБРАТЬ
		|	&Период                    КАК Период,
		|	&Организация               КАК Организация,
		|	ТаблицаОС.ОсновноеСредство КАК ОсновноеСредство,
		|
		|	ПервоначальныеСведенияОС.ПорядокУчетаУУ КАК ПорядокУчетаУУ,
		|	ПервоначальныеСведенияОС.ДатаВводаВЭксплуатациюБУ КАК ДатаВводаВЭксплуатациюБУ,
		|	ПервоначальныеСведенияОС.ДатаВводаВЭксплуатациюУУ КАК ДатаВводаВЭксплуатациюУУ,
		|	ПервоначальныеСведенияОС.ДокументВводаВЭксплуатациюУУ КАК ДокументВводаВЭксплуатациюУУ,
		|	&Ссылка КАК ДокументСнятияСУчетаУУ
		|ИЗ
		|	втСписокОС КАК ТаблицаОС
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ втПервоначальныеСведенияОС КАК ПервоначальныеСведенияОС
		|		ПО ТаблицаОС.ОсновноеСредство = ПервоначальныеСведенияОС.ОсновноеСредство";
	КонецЕсли;
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
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
	|	ТаблицаОС.ОсновноеСредство              КАК ОсновноеСредство
	|ИЗ
	|	Документ.ВыбытиеАрендованныхОС КАК ДанныеДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ВыбытиеАрендованныхОС.ОС КАК ТаблицаОС
	|		ПО ТаблицаОС.Ссылка = ДанныеДокумента.Ссылка
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ТекстЗапросаТаблицаАрендованныеОС(ТекстыЗапроса, Регистры)
	
	ИмяРегистра = "АрендованныеОС";
	
	Если Не ПроведениеДокументов.ТребуетсяТаблицаДляДвижений(ИмяРегистра, Регистры) Тогда
		Возврат;
	КонецЕсли;
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	&Ссылка                       КАК Регистратор,
	|	&Период                       КАК Период,
	|	ТаблицаОС.ОсновноеСредство    КАК ОсновноеСредство,
	|	&Организация                  КАК Организация,
	|	&Контрагент                   КАК Контрагент,
	|	&Договор                      КАК Договор,
	|	ЗНАЧЕНИЕ(Перечисление.СостоянияОС.СнятоСУчета) КАК Состояние
	|ИЗ
	|	Документ.ВыбытиеАрендованныхОС.ОС КАК ТаблицаОС
	|ГДЕ
	|	ТаблицаОС.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

Процедура ТекстЗапросаТаблицаСтоимостьОС(ТекстыЗапроса)

	ИмяРегистра = "СтоимостьОС";
	
	ВнеоборотныеАктивыСлужебный.ТекстЗапросаТаблицаВтТаблицаОС(ТекстыЗапроса, "Документ.ВыбытиеАрендованныхОС");
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход)  КАК ВидДвижения,
	|	&Ссылка                                 КАК Регистратор,
	|	&Период                                 КАК Период,
	|	&Организация                            КАК Организация,
	|	ТаблицаОС.ОсновноеСредство              КАК ОсновноеСредство,
	|	ТаблицаОС.Местонахождение               КАК Подразделение,
	|	ТаблицаОС.ГруппаФинансовогоУчета        КАК ГруппаФинансовогоУчета,
	|	ТаблицаОС.НаправлениеДеятельности       КАК НаправлениеДеятельности,
	|	&Контрагент                             КАК Контрагент,
	|	СтоимостьОС.ЗалоговаяСтоимость          КАК ЗалоговаяСтоимость,
	|	&ХозяйственнаяОперация                  КАК ХозяйственнаяОперация,
	|	
	|	ТаблицаОС.ИдентификаторСтроки КАК ИдентификаторФинЗаписи,
	|	&НастройкаХозяйственнойОперации КАК НастройкаХозяйственнойОперации
	|	
	|ИЗ
	|	втТаблицаОС КАК ТаблицаОС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_СтоимостьВНА КАК СтоимостьОС
	|		ПО СтоимостьОС.ОбъектУчета = ТаблицаОС.ОсновноеСредство
	|			И СтоимостьОС.Ссылка = &Ссылка";
	
	ТекстыЗапроса.Добавить(ТекстЗапроса, ИмяРегистра);
	
КонецПроцедуры

#КонецОбласти

#Область ПроведениеПоРеглУчету

Функция ТекстОтраженияВРеглУчете() Экспорт
	
	Возврат ВыбытиеАрендованныхОСЛокализация.ТекстОтраженияВРеглУчете();
	
КонецФункции

// Функция возвращает текст запроса дополнительных временных таблиц, необходимых для отражения в регламентированном учете.
//
// Возвращаемое значение:
// 	Строка - 
//
Функция ТекстЗапросаВТОтраженияВРеглУчете() Экспорт
	
	Возврат ВыбытиеАрендованныхОСЛокализация.ТекстЗапросаВТОтраженияВРеглУчете();
	
КонецФункции

#КонецОбласти

#Область Печать

Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

// Заполняет документ по контрагенту
// 
// Параметры:
// 	Объект - ДокументОбъект.ВыбытиеАрендованныхОС - 
// Возвращаемое значение:
// 	Строка, Неопределено - 
Функция ЗаполнитьПолученнымиВАрендуОтКонтрагента(Объект) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Объект.ОС.Очистить();
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	АрендованныеОС.ОсновноеСредство КАК ОсновноеСредство,
	|	АрендованныеОС.Контрагент КАК Контрагент,
	|	АрендованныеОС.Договор КАК Договор
	|ПОМЕСТИТЬ втАрендованныеОС
	|ИЗ
	|	РегистрСведений.АрендованныеОС.СрезПоследних(&Дата, Регистратор <> &Ссылка) КАК АрендованныеОС
	|ГДЕ
	|	АрендованныеОС.Состояние = ЗНАЧЕНИЕ(Перечисление.СостоянияОС.ПринятоКЗабалансовомуУчету)
	|	И АрендованныеОС.Контрагент = &Контрагент
	|	И (АрендованныеОС.Договор = &Договор
	|		ИЛИ &Договор = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка))
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ОсновноеСредство
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	АрендованныеОС.ОсновноеСредство,
	|	МестонахождениеОС.Организация,
	|	АрендованныеОС.Контрагент,
	|	АрендованныеОС.Договор
	|ИЗ
	|	втАрендованныеОС КАК АрендованныеОС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.МестонахождениеОС.СрезПоследних(
	|			&Дата, 
	|			Регистратор <> &Ссылка
	|				И ДатаИсправления = ДАТАВРЕМЯ(1,1,1)
	|				И ОсновноеСредство В
	|					(ВЫБРАТЬ
	|						АрендованныеОС.ОсновноеСредство
	|					ИЗ
	|						втАрендованныеОС КАК АрендованныеОС)) КАК МестонахождениеОС
	|		ПО МестонахождениеОС.ОсновноеСредство = АрендованныеОС.ОсновноеСредство
	|ГДЕ
	|	(МестонахождениеОС.Организация = &Организация
	|		ИЛИ &Организация = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка))
	|
	|УПОРЯДОЧИТЬ ПО
	|	АрендованныеОС.ОсновноеСредство.Представление,
	|	АрендованныеОС.ОсновноеСредство.ИнвентарныйНомер";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	Запрос.УстановитьПараметр("Организация", Объект.Организация);
	Запрос.УстановитьПараметр("Контрагент", Объект.Контрагент);
	Запрос.УстановитьПараметр("Договор", Объект.Договор);
	Запрос.УстановитьПараметр("Дата", ?(ЗначениеЗаполнено(Объект.Дата), Объект.Дата, ТекущаяДатаСеанса()));
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ЗначениеЗаполнено(Объект.Организация) Тогда
			Объект.Организация = Выборка.Организация;
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.Договор) Тогда
			Объект.Договор = Выборка.Договор;
		КонецЕсли;
		
		Если Объект.Организация <> Выборка.Организация
			ИЛИ Объект.Договор <> Выборка.Договор Тогда
			Продолжить;
		КонецЕсли;
		
		ДанныеСтроки = Объект.ОС.Добавить();
		ДанныеСтроки.ОсновноеСредство = Выборка.ОсновноеСредство;

	КонецЦикла;
	
	Если Объект.ОС.Количество() = 0 Тогда
		ТекстСообщения = НСтр("ru = 'От арендодателя ""%1"" не поступали основные средства'");
		ТекстСообщения = СтрШаблон(ТекстСообщения, Строка(Объект.Договор));
		Возврат ТекстСообщения;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
