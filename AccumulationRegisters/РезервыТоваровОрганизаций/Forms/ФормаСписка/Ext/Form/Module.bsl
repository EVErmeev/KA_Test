﻿
#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Значение = Элемент.ТекущиеДанные[Поле.Имя];
	ПоказатьЗначение(Неопределено, Значение);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти
