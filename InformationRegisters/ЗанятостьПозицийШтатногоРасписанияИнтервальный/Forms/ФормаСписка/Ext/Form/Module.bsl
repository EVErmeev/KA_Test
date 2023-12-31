﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// БлокировкаИзмененияОбъектов
	БлокировкаИзмененияОбъектов.ПриСозданииНаСервереЗаблокированнойФормыСписка(ЭтотОбъект, Элементы.ФормаКоманднаяПанель);
	// Конец БлокировкаИзмененияОбъектов
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

// БлокировкаИзмененияОбъектов

&НаКлиенте
Процедура Подключаемый_РазблокироватьОбъекты(Команда)
	
	БлокировкаИзмененияОбъектовКлиент.РазблокироватьФормуСписка(ЭтотОбъект);
	
КонецПроцедуры

// Конец БлокировкаИзмененияОбъектов

&НаКлиенте
Процедура ПерезаполнитьРегистр(Команда)
	
	ПерезаполнитьРегистрНаСервере();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПерезаполнитьРегистрНаСервере()
	
	НаборЗаписей = РегистрыСведений.ЗанятостьПозицийШтатногоРасписанияИнтервальный.СоздатьНаборЗаписей();
	НаборЗаписей.ОбменДанными.Загрузка = Истина;
	
	НаборЗаписей.Записать();
	
	РегистрыСведений.ЗанятостьПозицийШтатногоРасписания.ЗаполнитьИнтервальныйРегистр();
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
