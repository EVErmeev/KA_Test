﻿////////////////////////////////////////////////////////////////////////////////
// Отражение зарплаты в финансовом учете.
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Процедура предназначена для формирования движений по финансовому учету.
//
// Параметры:
//  Движения			 - КоллекцияДвижений - коллекция движений документа,
//  Отказ				 - Булево			 - признак отказа от проведения документа,
//  ПериодРегистрации	 - Дата				 - месяц, зарплата которого отражается в учете,
//  ДанныеДляОтражения	 - Структура		 - Таблицы значений с данными, которые
//  		могут использоваться для формирования движений по финансовому учету.
//  		При вызове процедуры ДанныеДляОтражения может содержать
//  		одно или несколько полей с приведенными ниже именами, т.е.
//  		Необходимо проверять наличие того или иного элемента структуры.
//  		Организация
//  Организация			 - 					 - СправочникСсылка.Организации.
//
Процедура ЗарегистрироватьЗарплатуВФинансовомУчете(Движения, Отказ, ПериодРегистрации, ДанныеДляОтражения, Организация) Экспорт
	
КонецПроцедуры

// Определяет возможность выполнения операции отражения зарплаты в финансовом учете,
//  осуществляемой документом «Отражение зарплаты в финансовом учете»,
//  одним экземпляром документа по всем организациям.
//
// Параметры:
//  Доступность	 - Булево	 - Истина, если операция одним документом по всем организациям доступна, Ложь - в противном случае.
//
Процедура ЗаполнитьДоступностьОтраженияЗарплатыВФинансовомУчетеОднимДокументомПоВсемОрганизациям(Доступность) Экспорт
	
КонецПроцедуры

#КонецОбласти
