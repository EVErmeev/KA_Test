﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура УточнитьИмяРолиПросмотраЗаконодательныхЗначений(ПараметрыОбновления = Неопределено) Экспорт
	
	ЗаменяемыеРоли = Новый Соответствие;
	ЗаменяемыеРоли.Вставить(
		"? ПросмотрЗаконодательныхЗначений",
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве("ИспользованиеОбработкиРедактированиеЗаконодательныхЗначений"));
	УправлениеДоступом.ЗаменитьРолиВПрофилях(ЗаменяемыеРоли);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли