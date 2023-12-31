﻿////////////////////////////////////////////////////////////////////////////////
// Места выплаты зарплаты.
// Расширенные серверные процедуры и функции форм документов.
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Настраивает поля формы с местами выплаты зарплаты.
//
// Параметры:
//   ОписателиПолейМестВыплаты - Соответствие: 
//     * Ключ     - ПолеФормы - поле формы с местом выплаты
//     * Значение - ПеречислениеСсылка.ВидыМестВыплатыЗарплаты.
//
Процедура НастроитьПоляМестВыплатыЗарплаты(ОписателиПолейМестВыплаты) Экспорт

	Для Каждого ОписательПоля Из ОписателиПолейМестВыплаты Цикл
		ОписательПоля.Ключ.ОграничениеТипа = ВзаиморасчетыССотрудникамиРасширенный.ОписаниеТипаМестаВыплатыПоВиду(ОписательПоля.Значение);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
