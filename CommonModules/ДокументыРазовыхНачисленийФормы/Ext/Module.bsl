﻿

#Область СлужебныйПрограммныйИнтерфейс

Процедура ПередПомещениемДанныхФормыВМенеджерРасчета(ДанныеОбъекта) Экспорт
	Регистратор = ДокументыРазовыхНачислений.РегистраторРазовогоНачисления(ДанныеОбъекта.Ссылка);
	
	ДокументыРазовыхНачислений.ЗаполнитьРегистраторРазовыхНачислений(ДанныеОбъекта, Регистратор); 		
КонецПроцедуры	

Процедура ОбновитьЗависимыеНачислениями(Объект, Сотрудники, ОписаниеДокумента, ОписаниеТаблицРазовыхНачислений) Экспорт	
	ПериодРегистрации = Объект[ОписаниеДокумента.МесяцНачисленияИмя];
	
	ЗависимыеНачисленияСотрудников = РасчетЗарплатыРасширенный.НайтиСтрокиОтборПоМассиву(Объект.ЗависимыеНачисления, "Сотрудник", Сотрудники);
	Для Каждого УдаляемаяСтрока Из ЗависимыеНачисленияСотрудников Цикл
		Объект.ЗависимыеНачисления.Удалить(УдаляемаяСтрока);
	КонецЦикла;
		
	МенеджерРасчета = РасчетЗарплатыРасширенный.СоздатьМенеджерРасчета(ПериодРегистрации, Объект.Организация);
	
	ТаблицаВедущихНачислений = МенеджерРасчета.НовыйВедущиеНачисленияСотрудников();
	
	СотрудникиОтбор = ОбщегоНазначенияБЗККлиентСервер.МассивВСоответствие(Сотрудники);
	
	Для Каждого ОписаниеТекущейТаблицы Из ОписаниеТаблицРазовыхНачислений Цикл
		Таблица = Объект[ОписаниеТекущейТаблицы.ИмяТаблицы];
	
		Для Каждого СтрокаПоСотруднику Из Таблица Цикл
			Если СотрудникиОтбор[СтрокаПоСотруднику.Сотрудник] <> Истина Тогда 
				Продолжить;
			КонецЕсли;
			
			СтрокаТаблицыВедущих = ТаблицаВедущихНачислений.Добавить();
			Если ОписаниеТекущейТаблицы.СодержитПолеСотрудник Тогда
				СтрокаТаблицыВедущих.Сотрудник = СтрокаПоСотруднику[ОписаниеТекущейТаблицы.ИмяРеквизитаСотрудник];
			Иначе
				СтрокаТаблицыВедущих.Сотрудник = Объект[ОписаниеТекущейТаблицы.ИмяРеквизитаСотрудник];
			КонецЕсли;
			
			Если ОписаниеТекущейТаблицы.СодержитПолеВидРасчета Тогда
				СтрокаТаблицыВедущих.Начисление = СтрокаПоСотруднику[ОписаниеТекущейТаблицы.ИмяРеквизитаВидРасчета];
			Иначе
				СтрокаТаблицыВедущих.Начисление = Объект[ОписаниеТекущейТаблицы.ИмяРеквизитаВидРасчета];
			КонецЕсли;
			
			СтрокаТаблицыВедущих.ДатаНачала = НачалоМесяца(СтрокаПоСотруднику.ПериодДействия);
			СтрокаТаблицыВедущих.ДатаОкончания = КонецМесяца(СтрокаПоСотруднику.ПериодДействия);
		КонецЦикла;
	КонецЦикла;	
	
	ЗависимыеНачисления = МенеджерРасчета.ЗависимыеНачисленияРассчитываемыеСРазовыми(ТаблицаВедущихНачислений);
	
	Если ЗависимыеНачисления.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаНачислений = МенеджерРасчета.ТаблицаИсходныеДанныеНачисленияЗарплатыПоНачислениям();
	
	Для Каждого СтрокаЗависимыхНачислений Из ЗависимыеНачисления Цикл
		СтрокаКРасчету = ТаблицаНачислений.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаКРасчету, СтрокаЗависимыхНачислений);
		СтрокаКРасчету.РассчитыватьПоРазовымНачислениямДокумента = Истина;
	КонецЦикла;

	МенеджерРасчета.ЗаполнитьНачисленияСотрудниковЗаПериод(ТаблицаНачислений.ВыгрузитьКолонку("Сотрудник"), ТаблицаНачислений);
	
	ТаблицыНачислений = РасчетЗарплатыРасширенныйФормы.ТаблицыНачисленийФормы();
	ТаблицыНачислений.Начисления = Объект.Начисления;
	ТаблицыНачислений.НачисленияПерерасчет = Объект.НачисленияПерерасчет;
	ТаблицыНачислений.ЗависимыеНачисления = Объект.ЗависимыеНачисления;
	
	РасчетЗарплатыРасширенныйФормы.РасчетЗарплатыНачисленияВДанныеФормы(
		ТаблицыНачислений, 
		МенеджерРасчета.Зарплата.Начисления, 
		Объект.Организация);
	
КонецПроцедуры

#КонецОбласти
