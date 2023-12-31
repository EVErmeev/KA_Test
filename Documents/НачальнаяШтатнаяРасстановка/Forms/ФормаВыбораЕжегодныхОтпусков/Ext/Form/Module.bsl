﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры, "Сотрудник,ДатаОстатков");
	Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Информация по отпускам для сотрудника %1'"),
		Сотрудник);
	
	Если ТолькоПросмотр Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ФормаOK",
			"Доступность",
			Ложь);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ФормаОтмена",
			"КнопкаПоУмолчанию",
			Истина);
		
	КонецЕсли;
	
	ЗаполнитьЕжегодныеОтпуска(Параметры);	
	
	ПараметрыСтажевыхЭлементов = ОстаткиОтпусков.ПараметрыДляДополнитьТабличнуюЧастьСтажевымиЭлементами();
	ПараметрыСтажевыхЭлементов.Форма = ЭтаФорма;
	ПараметрыСтажевыхЭлементов.ИмяТаблицы = "ЕжегодныеОтпуска";
	ПараметрыСтажевыхЭлементов.ТабличнаяЧастьВОбъекте = Ложь;
	ПараметрыСтажевыхЭлементов.ЗаполнятьРеквизитыПоСотруднику = Истина;
	ПараметрыСтажевыхЭлементов.Сотрудник = Сотрудник;
	ПараметрыСтажевыхЭлементов.ДатаСреза = ДатаОстатков;
	ОстаткиОтпусков.ДополнитьТабличнуюЧастьСтажевымиЭлементами(ПараметрыСтажевыхЭлементов);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзмененыОтсутствияСдвигающиеРабочийГод" И Источник = ЭтаФорма Тогда 
		ОбработатьИзменениеСведенийОбОтсутствиях(Параметр);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЕжегодныеОтпуска

&НаКлиенте
Процедура ЕжегодныеОтпускаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ОстаткиОтпусковКлиент.ПриНачалеРедактированияЕжегодногоОтпуска(ЭтаФорма, Элементы.ЕжегодныеОтпуска.ТекущиеДанные, НоваяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ЕжегодныеОтпускаПередУдалением(Элемент, Отказ)
	
	ОстаткиОтпусковКлиент.ПередУдалениемЕжегодногоОтпуска(ЭтаФорма, Отказ, "ВведеныОстатки", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЕжегодныеОтпускаВидЕжегодногоОтпускаПриИзменении(Элемент)
	
	ВнестиСводныйОстатокВТаблицуПрав(ЭтаФорма);
	
	ТекущиеДанные = Элементы.ЕжегодныеОтпуска.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КоличествоДнейВГод = КоличествоДнейЕжегодногоОтпускаПоУмолчанию(ТекущиеДанные.ВидЕжегодногоОтпуска);
	Если КоличествоДнейВГод <> Неопределено Тогда
		ТекущиеДанные.КоличествоДнейВГод = КоличествоДнейВГод;
	КонецЕсли;
	
	ОстаткиОтпусковКлиентСервер.УстановитьКомментарииДействийСЕжегоднымОтпуском(ТекущиеДанные);
	ЗаполнитьЗначенияСтажевыхРеквизитовВСтроке(Сотрудник, ТекущиеДанные.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаКлиенте
Процедура ЕжегодныеОтпускаВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ЕжегодныеОтпуска.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Поле.Имя = "ЕжегодныеОтпускаОписаниеСтажевыхПоказателей" Тогда
		
		ОстаткиОтпусковКлиент.ОткрытьФормуРедактированияСтажаОтпускаСотрудника(
			ЭтаФорма, Сотрудник, ДатаОстатков, ТекущиеДанные.ВидЕжегодногоОтпуска);
			
	ИначеЕсли Поле.Имя = "ЕжегодныеОтпускаДнейОтсутствия" Тогда
		
		Если ТекущиеДанные.ВидЕжегодногоОтпуска <> ОбщегоНазначенияКлиент.ПредопределенныйЭлемент("Справочник.ВидыОтпусков.ОтпускЗаВредность") Тогда 
			ОстаткиОтпусковКлиент.ОткрытьФормуВводаОтсутствийСдвигающихРабочийГод(
				ЭтаФорма, ТекущиеДанные.ВидЕжегодногоОтпуска, АдресСведенийОбОтсутствиях());
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОстаткиОтпусковПоРабочимГодам

&НаКлиенте
Процедура ОстаткиОтпусковПоРабочимГодамПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ВнестиСводныйОстатокВТаблицуПрав(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиОтпусковПоРабочимГодамПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Если ОстаткиОтпусковПоРабочимГодам.Количество() = 1 Тогда
			Элемент.ТекущиеДанные.ВидЕжегодногоОтпуска = ПредопределенноеЗначение("Справочник.ВидыОтпусков.Основной");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиОтпусковПоРабочимГодамОстатокПриИзменении(Элемент)
	ВнестиСводныйОстатокВТаблицуПрав(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиОтпусковПоРабочимГодамВидЕжегодногоОтпускаПриИзменении(Элемент)
	ВнестиСводныйОстатокВТаблицуПрав(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиОтпусковПоРабочимГодамРабочийГодНачалоПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОстаткиОтпусковПоРабочимГодам.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		Отбор = Новый Структура("ВидЕжегодногоОтпуска", ТекущиеДанные.ВидЕжегодногоОтпуска);
		СведенияОбОтсутствиях = ОтсутствияСдвигающиеРабочийГод.НайтиСтроки(Отбор);
		ОстаткиОтпусковКлиентСервер.ЗаполнитьДатуОкончанияРабочегоГодаВСтроке(ТекущиеДанные, СведенияОбОтсутствиях, ДатаОстатков);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ОстаткиОтпусковПоРабочимГодамПослеУдаления(Элемент)
	ВнестиСводныйОстатокВТаблицуПрав(ЭтаФорма);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура OK(Команда)
	
	ОчиститьСообщения();
	
	Если Модифицированность Тогда
		
		Если НЕ ПроверитьЗаполнениеОтпусков() Тогда
			Возврат;
		КонецЕсли; 
		
		СтруктураПараметраОповещения = Новый Структура;
		СтруктураПараметраОповещения.Вставить("Сотрудник", Сотрудник);
		СтруктураПараметраОповещения.Вставить("ДатаОстатков", ДатаОстатков);
		СтруктураПараметраОповещения.Вставить("ЕжегодныеОтпуска", ЕжегодныеОтпуска);
		СтруктураПараметраОповещения.Вставить("ОстаткиОтпусковПоРабочимГодам", ОстаткиОтпусковПоРабочимГодам);
		СтруктураПараметраОповещения.Вставить("ОтсутствияСдвигающиеРабочийГод", ОтсутствияСдвигающиеРабочийГод);
		
		Оповестить("ИзмененыЕжегодныеОтпуска", СтруктураПараметраОповещения, ВладелецФормы);
		
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПроверитьЗаполнениеОтпусков()
	Возврат ОстаткиОтпусков.ДокументВводаОстатковОтпусковЗаполненКорректно(ЭтаФорма);
КонецФункции

&НаСервере
Процедура ЗаполнитьЗначенияСтажевыхРеквизитовВСтроке(Сотрудник, ИдентификаторСтроки)
	ТекущиеДанные = ЕжегодныеОтпуска.НайтиПоИдентификатору(ИдентификаторСтроки);
	ОстаткиОтпусков.ЗаполнитьЗначенияСтажевыхРеквизитовВСтроке(ТекущиеДанные, Сотрудник, ДатаОстатков);
КонецПроцедуры

&НаСервереБезКонтекста
Функция КоличествоДнейЕжегодногоОтпускаПоУмолчанию(ВидЕжегодногоОтпуска)
	Возврат ОстаткиОтпусков.КоличествоДнейОтпускаВГодПоУмолчанию(ВидЕжегодногоОтпуска);
КонецФункции

&НаКлиенте
Процедура ЕжегодныеОтпускаКоличествоДнейВГодПриИзменении(Элемент)
	ОстаткиОтпусковКлиент.ПриИзмененииЕжегодныеОтпускаКоличество(ЭтаФорма, Элементы.ЕжегодныеОтпуска.ТекущиеДанные, "ВведеныОстатки");
КонецПроцедуры

&НаКлиенте
Процедура ЕжегодныеОтпускаПриАктивизацииСтроки(Элемент)
	ОстаткиОтпусковКлиент.ПриАктивизацииСтрокиЕжегодногоОтпуска(ЭтаФорма, "ВведеныОстатки");
КонецПроцедуры

&НаКлиенте
Процедура ЕжегодныеОтпускаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ОстаткиОтпусковКлиент.ПриОкончанииРедактированияЕжегодногоОтпуска(Элемент.ТекущиеДанные, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнестиСводныйОстатокВТаблицуПрав(Форма)

	ОстаткиОтпусковКлиентСервер.ВнестиСводныйОстатокВТаблицуПрав(Форма, "КоличествоДней", "ВведеныОстатки");	
	ОстаткиОтпусковКлиент.ПриАктивизацииСтрокиЕжегодногоОтпуска(Форма, "ВведеныОстатки");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьЕжегодныеОтпуска(Параметры)

	// Заполнение Действия и Комментария
	Для Каждого СтрокаЕжегодныеОтпуска Из Параметры.ЕжегодныеОтпуска Цикл
		НоваяСтрока = ЕжегодныеОтпуска.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаЕжегодныеОтпуска);
		Если СтрокаЕжегодныеОтпуска.НеИспользовать Тогда
			НоваяСтрока.Действие = ПредопределенноеЗначение("Перечисление.ДействияСЕжегоднымиОтпусками.Отменить");
		Иначе
			НоваяСтрока.Действие = ПредопределенноеЗначение("Перечисление.ДействияСЕжегоднымиОтпусками.ПустаяСсылка");
		КонецЕсли;
		ОстаткиОтпусковКлиентСервер.УстановитьКомментарииДействийСЕжегоднымОтпуском(НоваяСтрока);
	КонецЦикла;
	Для Каждого СтрокаОстаткиОтпусковПоРабочимГодам Из Параметры.ОстаткиОтпусковПоРабочимГодам Цикл
		ЗаполнитьЗначенияСвойств(ОстаткиОтпусковПоРабочимГодам.Добавить(), СтрокаОстаткиОтпусковПоРабочимГодам);
	КонецЦикла;
	
	// ВведеныОстатки
	СводныеОстаткиОтпусков = ОстаткиОтпусковПоРабочимГодам.Выгрузить();
	СводныеОстаткиОтпусков.Свернуть("ВидЕжегодногоОтпуска", "Остаток");
	Для Каждого ОстатокОтпуска Из СводныеОстаткиОтпусков Цикл
		НайденныеСтроки = ЕжегодныеОтпуска.НайтиСтроки(Новый Структура("ВидЕжегодногоОтпуска", ОстатокОтпуска.ВидЕжегодногоОтпуска));
		Если НайденныеСтроки.Количество() > 0 Тогда
			НайденныеСтроки[0].ВведеныОстатки = Истина;
		КонецЕсли;
	КонецЦикла; 
	
	// Отсутствия, сдвигающие рабочий год
	ОтсутствияПоВидуОтпуска = Новый Соответствие;
	Для Каждого СведенияОбОтсутствии Из Параметры.ОтсутствияСдвигающиеРабочийГод Цикл 
		НоваяСтрока = ОтсутствияСдвигающиеРабочийГод.Добавить();
	    ЗаполнитьЗначенияСвойств(НоваяСтрока, СведенияОбОтсутствии);
		КоличествоДней = ОтсутствияПоВидуОтпуска[НоваяСтрока.ВидЕжегодногоОтпуска];
		КоличествоДней = ?(КоличествоДней = Неопределено, 0, КоличествоДней) + НоваяСтрока.КоличествоДней;
		ОтсутствияПоВидуОтпуска.Вставить(НоваяСтрока.ВидЕжегодногоОтпуска, КоличествоДней);
	КонецЦикла;
	
	Для Каждого КлючИЗначение Из ОтсутствияПоВидуОтпуска Цикл
		Отбор = Новый Структура("ВидЕжегодногоОтпуска", КлючИЗначение.Ключ);
		НайденныеСтроки = ЕжегодныеОтпуска.НайтиСтроки(Отбор);
		Если НайденныеСтроки.Количество() > 0 Тогда 
			НайденныеСтроки[0].ДнейОтсутствия = КлючИЗначение.Значение;
		КонецЕсли;
	КонецЦикла;
	
	ОстаткиОтпусков.УстановитьУсловноеОформлениеЕжегодныхОтпусков(ЭтаФорма);

КонецПроцедуры

&НаСервере
Функция АдресСведенийОбОтсутствиях()
	
	ТекущаяСтрока = Элементы.ЕжегодныеОтпуска.ТекущаяСтрока;
	ВидЕжегодногоОтпуска = ЕжегодныеОтпуска.НайтиПоИдентификатору(ТекущаяСтрока).ВидЕжегодногоОтпуска;
	Отбор = Новый Структура("ВидЕжегодногоОтпуска", ВидЕжегодногоОтпуска);
	
	Возврат ПоместитьВоВременноеХранилище(ОтсутствияСдвигающиеРабочийГод.Выгрузить(Отбор), УникальныйИдентификатор);
	
КонецФункции

&НаСервере
Процедура ОбработатьИзменениеСведенийОбОтсутствиях(ПараметрыОповещения)
	
	ВидЕжегодногоОтпуска = ПараметрыОповещения.ВидЕжегодногоОтпуска;
	СведенияОбОтсутствиях = ПараметрыОповещения.ОтсутствияСдвигающиеРабочийГод;
	
	Отбор = Новый Структура("ВидЕжегодногоОтпуска", ВидЕжегодногоОтпуска);
	НайденныеСтроки = ОтсутствияСдвигающиеРабочийГод.НайтиСтроки(Отбор);
	Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл 
		ОтсутствияСдвигающиеРабочийГод.Удалить(НайденнаяСтрока);
	КонецЦикла;
	
	ДнейОтсутствия = 0;
	Для Каждого СтрокаСведений Из СведенияОбОтсутствиях Цикл 
		НоваяСтрока = ОтсутствияСдвигающиеРабочийГод.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаСведений);
		НоваяСтрока.ВидЕжегодногоОтпуска = ВидЕжегодногоОтпуска;
		ДнейОтсутствия = ДнейОтсутствия + НоваяСтрока.КоличествоДней;
	КонецЦикла;
	
	СтрокиПоВидуОтпуска = ЕжегодныеОтпуска.НайтиСтроки(Отбор);
	Для Каждого СтрокаВидаОтпуска Из СтрокиПоВидуОтпуска Цикл 
		СтрокаВидаОтпуска.ДнейОтсутствия = ДнейОтсутствия;
	КонецЦикла;
	
	ОстаткиПоВидуОтпуска = ОстаткиОтпусковПоРабочимГодам.НайтиСтроки(Отбор);
	ПоследнийРабочийГод = Неопределено;
	Для Каждого СтрокаОстатков Из ОстаткиПоВидуОтпуска Цикл
		Если ПоследнийРабочийГод = Неопределено Или СтрокаОстатков.РабочийГодНачало > ПоследнийРабочийГод.РабочийГодНачало Тогда 
			ПоследнийРабочийГод = СтрокаОстатков;
		КонецЕсли;
	КонецЦикла;
	
	Если ПоследнийРабочийГод <> Неопределено Тогда 
		ОстаткиОтпусковКлиентСервер.ЗаполнитьДатуОкончанияРабочегоГодаВСтроке(ПоследнийРабочийГод, СведенияОбОтсутствиях, ДатаОстатков);
	КонецЕсли;
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти

