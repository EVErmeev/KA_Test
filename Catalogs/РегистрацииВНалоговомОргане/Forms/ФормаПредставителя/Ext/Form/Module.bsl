﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ВыполняетсяЗакрытие;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("ЗначенияЗаполнения") Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.ЗначенияЗаполнения);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Представитель)
		И ТипЗнч(Представитель) = Тип("СправочникСсылка.Контрагенты") Тогда
		
		ПредставительЮридическоеЛицо = 1;
		ЮридическоеЛицо	= Представитель;
		
	Иначе
		
		ПредставительЮридическоеЛицо = 0;
		ФизическоеЛицо	= Представитель;
		
	КонецЕсли;
	
	ЗакрыватьПриВыборе	= Ложь;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВыполняетсяЗакрытие = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не ВыполняетсяЗакрытие И Модифицированность Тогда
		
		Отказ = Истина;
		
		Если ЗавершениеРаботы Тогда
		
			ТекстПредупреждения = НСтр("ru='Данные были изменены.
											|Перед завершением работы рекомендуется сохранить изменения,
											|иначе измененные данные будут утеряны.'");
			
			Возврат;
		
		Иначе
			
			ТекстВопроса = НСтр("ru='Данные были изменены. Сохранить изменения?'");
			Оповещение = Новый ОписаниеОповещения("ВопросСохранитьИзмененияЗавершение", ЭтотОбъект);
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНетОтмена);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов	= Новый Массив;
	
	Если ПредставительЮридическоеЛицо = 1 Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ФизическоеЛицо");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ЮридическоеЛицо");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставительЮридическоеЛицоПриИзменении(Элемент)
	
	Если ПредставительЮридическоеЛицо = 1 Тогда
		Представитель = ЮридическоеЛицо;
	Иначе
		Представитель = ФизическоеЛицо;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЮридическоеЛицоПриИзменении(Элемент)
	
	Если ПредставительЮридическоеЛицо = 1 Тогда
		Представитель = ЮридическоеЛицо;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФизическоеЛицоПриИзменении(Элемент)
	
	Если ПредставительЮридическоеЛицо = 0 Тогда
		Представитель = ФизическоеЛицо;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьПриИзменении(Элемент)
	
	//++ НЕ УТ
	
	Если ТипЗнч(Доверенность) = Тип("СправочникСсылка.МашиночитаемыеДоверенностиФНС")
		ИЛИ ТипЗнч(Доверенность) = Тип("СправочникСсылка.МашиночитаемыеДоверенностиРаспределенныйРеестр") Тогда
		
		МассивКодовНалоговыхОрганов = ДокументооборотСКОВызовСервера.КодыНалоговыхОргановМЧДФНС(
			Доверенность);
		
		Если ЗначениеЗаполнено(Код) И МассивКодовНалоговыхОрганов.Количество() <> 0
			И МассивКодовНалоговыхОрганов.Найти(Код) = Неопределено Тогда
			
			ТекстВопроса = СтрШаблон(
				НСтр("ru = 'Машиночитаемая доверенность не действует для налогового органа %1.
						   |
						   |Все равно выбрать доверенность?'"),
				Код);
			ДополнительныеПараметры = Новый Структура("Доверенность", Доверенность);
			Доверенность = Неопределено;
			Оповещение = Новый ОписаниеОповещения("ДоверенностьПриИзмененииПослеПодтверждения", ЭтотОбъект, ДополнительныеПараметры);
			ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
		КонецЕсли;
	КонецЕсли;
	
	//-- НЕ УТ
	
	Возврат;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ЗаписатьДанные();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Если ПроверитьЗаполнение() Тогда
		ЗаписатьДанные();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Элементы = Форма.Элементы;
	
	ПредставительЮрЛицо	= Форма.ПредставительЮридическоеЛицо = 1;
	
	Элементы.ФизическоеЛицо.Доступность = НЕ ПредставительЮрЛицо;
	Элементы.ЮридическоеЛицо.Доступность = ПредставительЮрЛицо;
	Элементы.УполномоченноеЛицоПредставителя.Доступность = ПредставительЮрЛицо;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДанные()
	
	ЗначениеВыбора	= Новый Структура("Представитель,УполномоченноеЛицоПредставителя,ДокументПредставителя,Доверенность");
	ЗаполнитьЗначенияСвойств(ЗначениеВыбора, ЭтотОбъект);
	
	Модифицированность = Ложь;
	
	ОповеститьОВыборе(ЗначениеВыбора);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросСохранитьИзмененияЗавершение(Результат, ДополнительныеПараметры) Экспорт

	Если Результат = КодВозвратаДиалога.Да Тогда
		Если ПроверитьЗаполнение() Тогда
			ЗаписатьДанные();
			Закрыть();
		КонецЕсли;
	ИначеЕсли Результат = КодВозвратаДиалога.Нет Тогда
		ВыполняетсяЗакрытие = Истина;
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДоверенностьПриИзмененииПослеПодтверждения(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Доверенность = ДополнительныеПараметры.Доверенность;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти