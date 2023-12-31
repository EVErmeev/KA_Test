﻿
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ИнвентарныйУчет") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(Перечисления.СпособыПогашенияСтоимостиТМЦ.ПриПередаче);
		ДанныеВыбора.Добавить(Перечисления.СпособыПогашенияСтоимостиТМЦ.ПоСроку);
		Если Параметры.ИнвентарныйУчет Тогда
			ДанныеВыбора.Добавить(Перечисления.СпособыПогашенияСтоимостиТМЦ.ПоНаработке);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.Свойство("СпособПогашенияСтоимостиБУ") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.Добавить(Перечисления.СпособыПогашенияСтоимостиТМЦ.ПриПередаче);
		ДанныеВыбора.Добавить(Параметры.СпособПогашенияСтоимостиБУ);
		
	КонецЕсли;
	
КонецПроцедуры
