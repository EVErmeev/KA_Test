﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

#Область ОбработчикиПравилРегистрации

// См. ЗарплатаКадрыРасширенныйСинхронизацияДанных.ШаблонОбработчика
Процедура ПриЗаполненииНастроекОбработчиковПравилРегистрации(Настройки) Экспорт
	ЗарплатаКадрыРасширенныйСинхронизацияДанных.ДляРегламентированныхДанных(Настройки);
КонецПроцедуры

#КонецОбласти

// Начальное заполнение и обновление информационной базы.
Процедура НачальноеЗаполнение() Экспорт
	Обновить(ПолучитьМакет("ПредопределенныеЗначения").ПолучитьТекст());
КонецПроцедуры

// Заполняет ставки рефинансирования Центрального Банка Российской Федерации.
Процедура Обновить(ТекстXML) Экспорт
	ЗарплатаКадры.ОбновитьКлассификатор(ТекстXML);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область УстаревшиеПроцедурыИФункции

// Устарела. Следует использовать процедуру НачальноеЗаполнение.
Процедура ЗаполнитьЗначенияСтавкиРефинансированияЦБ() Экспорт
	НачальноеЗаполнение();
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли