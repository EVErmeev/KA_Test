﻿#Область ОбработчикиСобытийФормы

// В обработчике события ПриСозданииНаСервере формы выполняется:
// - заполнение списка выбора кодов определения цены сделки (на основании макета, где хранятся коды и их расшифровка);
// - заполнение списка выбора кодов метода ценообразования (на основании макета, где хранятся коды и их расшифровка).
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	СписокКодов = КонтролируемыеСделкиПовтИсп.ПолучитьКодыОпределенияЦеныСделки();
	Элементы.КодОпределенияЦеныСделки.СписокВыбора.Очистить();
	Для Каждого Код Из СписокКодов Цикл
		НовыйКод = Элементы.КодОпределенияЦеныСделки.СписокВыбора.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйКод, Код);
	КонецЦикла;

	СписокКодов = КонтролируемыеСделкиПовтИсп.ПолучитьКодыМетодовЦенообразования();
	Элементы.КодМетодаЦенообразования.СписокВыбора.Очистить();
	Для Каждого Код Из СписокКодов Цикл
		НовыйКод = Элементы.КодМетодаЦенообразования.СписокВыбора.Добавить();
		ЗаполнитьЗначенияСвойств(НовыйКод, Код);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти