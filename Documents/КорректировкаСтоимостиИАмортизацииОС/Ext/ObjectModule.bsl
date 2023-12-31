﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнициализироватьДокументПередЗаполнением();
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	
	Если ТипДанныхЗаполнения = Тип("Структура") Тогда
		
		ЗаполнитьДокументПоОтбору(ДанныеЗаполнения, СтандартнаяОбработка);
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("СправочникСсылка.ОбъектыЭксплуатации") 
		ИЛИ ТипДанныхЗаполнения = Тип("Массив")
			И ДанныеЗаполнения.Количество() <> 0
			И ТипЗнч(ДанныеЗаполнения[0]) = Тип("СправочникСсылка.ОбъектыЭксплуатации") Тогда
			
		ЗаполнитьНаОснованииОбъектовЭксплуатации(ДанныеЗаполнения, Неопределено, СтандартнаяОбработка);
		
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ПринятиеКУчетуОС2_4") Тогда
		ЗаполнитьДокументНаОснованииПринятияКУчетуОС(ДанныеЗаполнения, СтандартнаяОбработка);
	ИначеЕсли ТипДанныхЗаполнения = Тип("ДокументСсылка.ИзменениеПараметровОС2_4") Тогда
		ЗаполнитьДокументНаОснованииИзменениеПараметровОС(ДанныеЗаполнения, СтандартнаяОбработка);
	КонецЕсли;
	
	КорректировкаСтоимостиИАмортизацииОСЛокализация.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	ПараметрыВыбораСтатейИАналитик = Документы.КорректировкаСтоимостиИАмортизацииОС.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаЗаполнения(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	Комментарий = "";
	
	ОбщегоНазначенияУТ.ОчиститьИдентификаторыДокумента(ЭтотОбъект, "ОС");
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ВнеоборотныеАктивы.ПроверитьСоответствиеДатыВерсииУчета(ЭтотОбъект, Истина, Отказ);
	ВнеоборотныеАктивы.ПроверитьОтсутствиеДублейВТабличнойЧасти(ЭтотОбъект, "ОС", "ОсновноеСредство", Отказ);
	
	ПараметрыРеквизитовОбъекта = 
		ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_КорректировкаСтоимостиИАмортизацииОС(ЭтотОбъект, ВспомогательныеРеквизиты());
	ОбщегоНазначенияУТ.ОтключитьПроверкуЗаполненияРеквизитовОбъекта(ПараметрыРеквизитовОбъекта, МассивНепроверяемыхРеквизитов);
	
	ПроверитьТабличнуюЧасть(МассивНепроверяемыхРеквизитов, Отказ);
	ПроверитьПериодКорректировки(Отказ);
	
	ПараметрыВыбораСтатейИАналитик = Документы.КорректировкаСтоимостиИАмортизацииОС.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, ПараметрыВыбораСтатейИАналитик);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	Если Не Отказ И РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		
		ЗаблокироватьДанные();
		
		Если ВидИмущества = Перечисления.ВидыИмущества.Арендованное Тогда
			ВнеоборотныеАктивыСлужебный.ПроверитьЧтоОСПолученыВАрендуЗаБалансом(ЭтотОбъект, Отказ);
		Иначе
			ВнеоборотныеАктивыСлужебный.ПроверитьЧтоОСПринятыКУчету(ЭтотОбъект, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьРеквизитыПередЗаписью();
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "ОС");
	
	ПараметрыВыбораСтатейИАналитик = Документы.КорректировкаСтоимостиИАмортизацииОС.ПараметрыВыбораСтатейИАналитик();
	ДоходыИРасходыСервер.ПередЗаписью(ЭтотОбъект, ПараметрыВыбораСтатейИАналитик);
	
	//Настройка счетов учета
	НастройкаСчетовУчетаСервер.ПередЗаписью(ЭтотОбъект,
		Документы.КорректировкаСтоимостиИАмортизацииОС.ПараметрыНастройкиСчетовУчета());
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Заполнение

Процедура ИнициализироватьДокументПередЗаполнением()
	
	Ответственный = Пользователи.ТекущийПользователь();
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	
	ОтражатьВУпрУчете = Истина;
	ОтражатьВРеглУчете = Истина;
	
КонецПроцедуры

Процедура ЗаполнитьДокументПоОтбору(Основание, СтандартнаяОбработка)

	Если Основание.Свойство("ОсновноеСредство") Тогда
		ЗаполнитьНаОснованииОбъектовЭксплуатации(Основание.ОсновноеСредство, Основание, СтандартнаяОбработка);
	КонецЕсли; 
	
	Если Основание.Свойство("ПараметрыДействуютСПрошлойДаты") Тогда
		
		КорректировкаСПрошлойДаты = Истина;
		
		Если Основание.Свойство("ПериодИсправления") Тогда
			ПериодИсправления = Основание.ПериодИсправления; // СтандартныйПериод
			Если ПериодИсправления.ДатаНачала < НачалоМесяца(ТекущаяДатаСеанса()) Тогда

				НачалоПериода = ПериодИсправления.ДатаНачала;
				
				Документы.КорректировкаСтоимостиИАмортизацииОС.ЗаполнитьПараметрыПоУмолчанию(ЭтотОбъект);
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьНаОснованииОбъектовЭксплуатации(Основание, ЗначенияОтбора, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Основание) Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ИсходныеОС = ?(ТипЗнч(Основание) = Тип("Массив"), Основание, ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Основание));
	
	СостояниеПринят = Новый Массив;
	СостояниеПринят.Добавить(Перечисления.СостоянияОС.ПринятоКУчету);
	СостояниеПринят.Добавить(Перечисления.СостоянияОС.ПринятоКЗабалансовомуУчету);
	СписокОС = ВнеоборотныеАктивы.ВернутьПринятыеКУчетуОС(ИсходныеОС, Дата, СостояниеПринят);
	
	Если СписокОС.Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Основные средства должны быть приняты к учету'");
		ВызватьИсключение ТекстСообщения;
		
	КонецЕсли;
	
	ПервоначальныеСведения = Справочники.ОбъектыЭксплуатации.ПервоначальныеСведения(СписокОС[0], Дата);
	Организация = ПервоначальныеСведения.Организация;
	Подразделение = ПервоначальныеСведения.Местонахождение;
	
	ОтражатьВУпрУчете = ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюУУ);
	ОтражатьВРеглУчете = 
		ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюБУ)
		ИЛИ ЗначениеЗаполнено(ПервоначальныеСведения.ДокументВводаВЭксплуатациюНУ);
	
	ВидИмущества =
		?(ПервоначальныеСведения.СостояниеБУ = Перечисления.СостоянияОС.ПринятоКЗабалансовомуУчету,
			Перечисления.ВидыИмущества.Арендованное,
			Перечисления.ВидыИмущества.Собственное);
	
	Для каждого ОсновноеСредствоОснование Из СписокОС Цикл
		НоваяСтрока = ОС.Добавить();
		НоваяСтрока.ОсновноеСредство = ОсновноеСредствоОснование;
	КонецЦикла;
	
	Документы.КорректировкаСтоимостиИАмортизацииОС.ЗаполнитьПоДаннымУчета(ЭтотОбъект);
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииПринятияКУчетуОС(Основание, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ВидИмущества = Перечисления.ВидыИмущества.Собственное;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК ДокументОснование,
	|	ДанныеДокумента.ОтражатьВРеглУчете КАК ОтражатьВРеглУчете,
	|	ДанныеДокумента.ОтражатьВУпрУчете КАК ОтражатьВУпрУчете
	|ИЗ
	|	Документ.ПринятиеКУчетуОС2_4 КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Основание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабличнаяЧасть.ОсновноеСредство КАК ОсновноеСредство
	|ИЗ
	|	Документ.ПринятиеКУчетуОС2_4.ОС КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Основание
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТабличнаяЧасть.НомерСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Основание", Основание);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ЗаполнитьПоДокументу(РезультатЗапроса)
	
КонецПроцедуры

Процедура ЗаполнитьДокументНаОснованииИзменениеПараметровОС(Основание, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ВидИмущества = Перечисления.ВидыИмущества.Собственное;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ДанныеДокумента.Ссылка КАК ДокументОснование,
	|	ДанныеДокумента.ОтражатьВРеглУчете КАК ОтражатьВРеглУчете,
	|	ДанныеДокумента.ОтражатьВУпрУчете КАК ОтражатьВУпрУчете,
	|	ДанныеДокумента.Дата КАК Дата,
	|	ДанныеДокумента.СобытиеОС КАК СобытиеОС,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.ПараметрыДействуютСПрошлойДаты
	|				И НАЧАЛОПЕРИОДА(ДанныеДокумента.НачалоДействия, МЕСЯЦ) < НАЧАЛОПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК КорректировкаСПрошлойДаты,
	|	ВЫБОР
	|		КОГДА ДанныеДокумента.ПараметрыДействуютСПрошлойДаты
	|				И НАЧАЛОПЕРИОДА(ДанныеДокумента.НачалоДействия, МЕСЯЦ) < НАЧАЛОПЕРИОДА(ДанныеДокумента.Дата, МЕСЯЦ)
	|			ТОГДА НАЧАЛОПЕРИОДА(ДанныеДокумента.НачалоДействия, МЕСЯЦ)
	|		ИНАЧЕ ДАТАВРЕМЯ(1,1,1)
	|	КОНЕЦ КАК НачалоПериода
	|ИЗ
	|	Документ.ИзменениеПараметровОС2_4 КАК ДанныеДокумента
	|ГДЕ
	|	ДанныеДокумента.Ссылка = &Основание
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТабличнаяЧасть.ОсновноеСредство КАК ОсновноеСредство
	|ИЗ
	|	Документ.ИзменениеПараметровОС2_4.ОС КАК ТабличнаяЧасть
	|ГДЕ
	|	ТабличнаяЧасть.Ссылка = &Основание
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТабличнаяЧасть.НомерСтроки";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Основание", Основание);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ЗаполнитьПоДокументу(РезультатЗапроса)
	
КонецПроцедуры

Процедура ЗаполнитьПоДокументу(РезультатЗапроса)

	Если Не РезультатЗапроса[0].Пустой() Тогда
		Выборка = РезультатЗапроса[0].Выбрать();
		Выборка.Следующий();
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Выборка);
	КонецЕсли;
	
	Если РезультатЗапроса[1].Пустой() Тогда
		Возврат
	КонецЕсли; 
		
	ОС.Загрузить(РезультатЗапроса[1].Выгрузить());
	
	ПервоначальныеСведения = Справочники.ОбъектыЭксплуатации.ПервоначальныеСведения(ОС[0].ОсновноеСредство);
	Организация = ПервоначальныеСведения.Организация;
	Подразделение = ПервоначальныеСведения.Местонахождение;
	
	Документы.КорректировкаСтоимостиИАмортизацииОС.ЗаполнитьПоДаннымУчета(ЭтотОбъект);
	Документы.КорректировкаСтоимостиИАмортизацииОС.ЗаполнитьПараметрыПоУмолчанию(ЭтотОбъект);
	
	Документы.КорректировкаСтоимостиИАмортизацииОС.НачатьРасчетАмортизацииПоЗаданнымПараметрам(ЭтотОбъект);
	
КонецПроцедуры
 
#КонецОбласти

#Область ПроверкаЗаполнения

Процедура ПроверитьТабличнуюЧасть(МассивНепроверяемыхРеквизитов, Отказ)

	Если ВидИмущества = Перечисления.ВидыИмущества.Арендованное Тогда
		Возврат;
	КонецЕсли;
	
	ВедетсяРегламентированныйУчетВНА = ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА();
	
	Если НЕ ВедетсяРегламентированныйУчетВНА Тогда
		Возврат;
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("ОС.СтоимостьБУ");
	ШаблонСообщенияСтоимостьРегл = НСтр("ru = 'Для основного средства ""%1"" необходимо указать стоимость в регламентированном учете'");
	
	Для каждого ДанныеСтроки Из ОС Цикл
		
		Если ДанныеСтроки.СтоимостьБУ = 0
			И ДанныеСтроки.СтоимостьНУ = 0
			И ДанныеСтроки.СтоимостьЦФ = 0
			И ОтражатьВРеглУчете
			И ВедетсяРегламентированныйУчетВНА Тогда
			
			ТекстСообщения = СтрШаблон(ШаблонСообщенияСтоимостьРегл, Строка(ДанныеСтроки.ОсновноеСредство));
			Поле = ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ОС", ДанныеСтроки.НомерСтроки, "ОсновноеСредство");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, Поле, "", Отказ);
			
		КонецЕсли;
		
	КонецЦикла; 
	
КонецПроцедуры

Процедура ПроверитьПериодКорректировки(Отказ)
	
	Если НЕ КорректировкаСПрошлойДаты
		ИЛИ НЕ ЗначениеЗаполнено(НачалоПериода) Тогда
		Возврат
	КонецЕсли;
	
	Если НачалоПериода >= НачалоМесяца(Дата)
		И ЗначениеЗаполнено(Дата) Тогда
		ТекстСообщения = НСтр("ru = 'Начало корректировки должно быть раньше начала месяца, в котором оформлен документ'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "НачалоПериода",, Отказ);
	ИначеЕсли НЕ ВнеоборотныеАктивы.ИспользуетсяУправлениеВНА_2_4(НачалоПериода) Тогда
		ТекстСообщения = НСтр("ru = 'Начало корректировки должно быть не раньше начала учета внеоборотных активов версии 2.4'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "НачалоПериода",, Отказ);
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область Прочее

Процедура ЗаблокироватьДанные()

	Блокировка = Новый БлокировкаДанных;
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ПервоначальныеСведенияОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	ЭлементБлокировки.УстановитьЗначение("Организация", Организация);
	
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.МестонахождениеОС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ОС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ОсновноеСредство", "ОсновноеСредство");
	
	Блокировка.Заблокировать(); 
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПередЗаписью()

	ОчиститьНеиспользуемыеРеквизиты();
	
	Если НЕ НастройкиНалоговУчетныхПолитикПовтИсп.РеглУчетВНАВедетсяНезависимо(Организация, КонецМесяца(?(Дата <> '000101010000', Дата, ТекущаяДатаСеанса())))
		И Константы.ВалютаУправленческогоУчета.Получить() = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация) Тогда
		
		Для каждого ДанныеСтроки Из ОС Цикл
			ДанныеСтроки.СтоимостьУУ = ДанныеСтроки.СтоимостьБУ;
			ДанныеСтроки.АмортизацияУУ = ДанныеСтроки.АмортизацияБУ;
			ДанныеСтроки.ПервоначальнаяСтоимостьУУ = ДанныеСтроки.ПервоначальнаяСтоимостьБУ;
		КонецЦикла; 
		
	КонецЕсли; 
	
	Если ОтражатьВУпрУчете И НЕ ОтражатьВРеглУчете И НЕ ЗначениеЗаполнено(ВидИмущества) Тогда
		ВидИмущества = Перечисления.ВидыИмущества.Собственное;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьНеиспользуемыеРеквизиты()
	
	ПараметрыРеквизитовОбъекта = ВнеоборотныеАктивыКлиентСервер.ЗначенияСвойствЗависимыхРеквизитов_КорректировкаСтоимостиИАмортизацииОС(
		ЭтотОбъект, ВспомогательныеРеквизиты());
	
	ОбщегоНазначенияУТКлиентСервер.ОчиститьНеиспользуемыеРеквизиты(
		ЭтотОбъект, ПараметрыРеквизитовОбъекта, "ОС,ПараметрыЗаПериод,ПараметрыЗаПериодБУ,ПараметрыЗаПериодНУ");

КонецПроцедуры

Функция ВспомогательныеРеквизиты()
	
	ДатаПараметров = КонецМесяца(?(Дата <> '000101010000', Дата, ТекущаяДатаСеанса()));
	
	ВспомогательныеРеквизиты = Новый Структура;
	ВспомогательныеРеквизиты.Вставить("ВедетсяРегламентированныйУчетВНА", ВнеоборотныеАктивыСлужебный.ВедетсяРегламентированныйУчетВНА());
	ВспомогательныеРеквизиты.Вставить("ПорядокУчетаВНА", НастройкиНалоговУчетныхПолитикПовтИсп.ПорядокУчетаВНА(Организация, ДатаПараметров));
	ВспомогательныеРеквизиты.Вставить("ПрименяетсяФСБУ6", НастройкиНалоговУчетныхПолитикПовтИсп.ПрименяетсяФСБУ6(Организация, ДатаПараметров));
	ВспомогательныеРеквизиты.Вставить("ПлательщикНалогаНаПрибыль", Ложь);
	ВспомогательныеРеквизиты.Вставить("ПоддержкаПБУ18", Ложь);
	ВспомогательныеРеквизиты.Вставить("ВедетсяУчетПостоянныхИВременныхРазниц", Ложь);

	ВалютаУпр = Константы.ВалютаУправленческогоУчета.Получить();
	ВалютаРегл = ЗначениеНастроекПовтИсп.ВалютаРегламентированногоУчетаОрганизации(Организация);
	ВспомогательныеРеквизиты.Вставить("ВалютыСовпадают", ВалютаУпр = ВалютаРегл);
	
	ВспомогательныеРеквизиты.Вставить("ИспользоватьУчетВнеоборотныхАктивовПоНаправлениямДеятельности", 
		ПолучитьФункциональнуюОпцию("ИспользоватьУчетВнеоборотныхАктивовПоНаправлениямДеятельности"));
	
	ВспомогательныеРеквизиты.Вставить(
		"РеглУчетВНАВедетсяНезависимо",
		НастройкиНалоговУчетныхПолитикПовтИсп.РеглУчетВНАВедетсяНезависимо(Организация, ДатаПараметров));
	
	Документы.КорректировкаСтоимостиИАмортизацииОС.ПолучитьПараметрыУчетныхПолитикЗаПериод(ЭтотОбъект, ВспомогательныеРеквизиты);
		
	КорректировкаСтоимостиИАмортизацииОСЛокализация.ДополнитьВспомогательныеРеквизиты(ЭтотОбъект, ВспомогательныеРеквизиты);
	
	Возврат ВспомогательныеРеквизиты;

КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
