﻿
#Область ОбработчикиСобытийФормы 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	АдресВременногоХранилища = Параметры.АдресВременногоХранилища;
	РежимРедактирования      = Параметры.РежимРедактирования;
	Организация              = Параметры.Организация;
	
	ДокументыЭкспорт.Загрузить(ПолучитьИзВременногоХранилища(АдресВременногоХранилища));
	СуммаВыручкиИтог = ДокументыЭкспорт.Итог("СуммаВыручки");
	КорректировкаВыручкиИтог = ДокументыЭкспорт.Итог("КорректировкаВыручки");
	
	Элементы.ФормаПеренестиВДокумент.Видимость = РежимРедактирования;
	Элементы.ФормаЗакрыть.КнопкаПоУмолчанию = НЕ РежимРедактирования;
	Элементы.ДокументыЭкспорт.ТолькоПросмотр = НЕ РежимРедактирования;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если ЗавершениеРаботы И Модифицированность Тогда
		Отказ = Истина;
		ТекстПредупреждения = НСтр("ru = 'Данные не были перенесены в документ. После закрытия, сделанные Вами изменения сохранены не будут.'");
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработчикОповещенияВопросПередЗакрытием", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные не перенесены в документ. Перенести?'");
		ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыЭкспортВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ДокументыЭкспорт.ТекущиеДанные;
	Если Поле = Элементы.ДокументыЭкспортДокумент Тогда
		
		Если ЗначениеЗаполнено(ТекущаяСтрока.Документ) И НЕ РежимРедактирования Тогда
			ПоказатьЗначение(Неопределено, ТекущаяСтрока.Документ);
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПеренестиВДокумент(Команда)
	
	Отказ = Ложь;
	
	ОчиститьСообщения();
	ПроверитьЗаполнениеТабличнойЧасти(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Модифицированность = Ложь;
	Закрыть(ПоместитьДокументыЭкспортВоВременноеХранилище());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПроверитьЗаполнениеТабличнойЧасти(Отказ)
	
	Для ТекИндекс = 0 По ДокументыЭкспорт.Количество()-1 Цикл
		
		Если НЕ ЗначениеЗаполнено(ДокументыЭкспорт[ТекИндекс].Документ) Тогда
			ТекстОшибки = НСтр("ru='Не заполнен документ в строке %НомерСтроки%'");
			ТекстОшибки = СтрЗаменить(ТекстОшибки,"%НомерСтроки%",ТекИндекс+1);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки,
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДокументыЭкспорт", ТекИндекс + 1, "Документ"),
				,
				Отказ);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДокументыЭкспорт[ТекИндекс].СуммаВыручки) 
			 И НЕ ЗначениеЗаполнено(ДокументыЭкспорт[ТекИндекс].КорректировкаВыручки) Тогда
			ТекстОшибки = НСтр("ru='Не заполнена сумма в строке %НомерСтроки%'");
			ТекстОшибки = СтрЗаменить( ТекстОшибки,"%НомерСтроки%",ТекИндекс+1);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				ТекстОшибки ,
				,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ДокументыЭкспорт", ТекИндекс + 1, "Сумма"),
				,
				Отказ);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПоместитьДокументыЭкспортВоВременноеХранилище()
	
	Возврат ПоместитьВоВременноеХранилище(ДокументыЭкспорт.Выгрузить(), АдресВременногоХранилища);
	
КонецФункции

&НаКлиенте
Процедура ОбработчикОповещенияВопросПередЗакрытием(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОчиститьСообщения();
		Отказ = Ложь;
		ПроверитьЗаполнениеТабличнойЧасти(Отказ);
		Если НЕ Отказ Тогда
			Модифицированность = Ложь;
			Закрыть(ПоместитьДокументыЭкспортВоВременноеХранилище());
		КонецЕсли;
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокументыЭкспортПриИзменении(Элемент)
	
	СуммаВыручкиИтог = ДокументыЭкспорт.Итог("СуммаВыручки");
	КорректировкаВыручкиИтог = ДокументыЭкспорт.Итог("КорректировкаВыручки");
	
КонецПроцедуры


#КонецОбласти