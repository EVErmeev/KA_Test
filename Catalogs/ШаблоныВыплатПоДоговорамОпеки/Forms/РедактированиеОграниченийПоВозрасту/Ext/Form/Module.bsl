﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("ВозрастОт", ВозрастОт);
	Параметры.Свойство("ВозрастДо", ВозрастДо);
	
	Элементы.ИсключаяДатуОт.Доступность = ВозрастОт>0;
	Элементы.ВключаяДатуДо.Доступность = ВозрастДо>0;
	
	ВозрастОтЛет = Цел(ВозрастОт / 12);
	ВозрастОтМесяцев = ВозрастОт % 12;
	ВозрастДоЛет = Цел(ВозрастДо / 12);
	ВозрастДоМесяцев = ВозрастДо % 12;
	
	Параметры.Свойство("ИсключаяДатуОт", ИсключаяДатуОт);
	Параметры.Свойство("ВключаяДатуДо", ВключаяДатуДо);
	
	ВозвращаемоеЗначениеУстановлено = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ВозвращаемоеЗначениеУстановлено Тогда 
		Результат = Новый Структура("ВозрастОт,ВозрастДо,ИсключаяДатуОт,ВключаяДатуДо");
		Результат.ВозрастОт = ВозрастОтЛет * 12 + ВозрастОтМесяцев;
		Результат.ВозрастДо =  ВозрастДоЛет * 12 + ВозрастДоМесяцев;
		Результат.ИсключаяДатуОт = ИсключаяДатуОт;
		Результат.ВключаяДатуДо = ВключаяДатуДо;
		ОповеститьОВыборе(Результат);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Отмена(Команда)
	ВозвращаемоеЗначениеУстановлено = Ложь;
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура Ок(Команда)
	ВозвращаемоеЗначениеУстановлено = Истина;
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ВозрастОтЛетПриИзменении(Элемент)
	УстановитьСостояниеИДоступностьФлагов();
КонецПроцедуры

&НаКлиенте
Процедура ВозрастОтМесяцевПриИзменении(Элемент)
	УстановитьСостояниеИДоступностьФлагов();
КонецПроцедуры

&НаКлиенте
Процедура ВозрастДоЛетПриИзменении(Элемент)
	УстановитьСостояниеИДоступностьФлагов();
КонецПроцедуры

&НаКлиенте
Процедура ВозрастДоМесяцевПриИзменении(Элемент)
	УстановитьСостояниеИДоступностьФлагов();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьСостояниеИДоступностьФлагов()
	Элементы.ИсключаяДатуОт.Доступность = ВозрастОтЛет>0 Или ВозрастОтМесяцев>0;
	Если Не Элементы.ИсключаяДатуОт.Доступность Тогда 
		ИсключаяДатуОт = Ложь;
	КонецЕсли;
	Элементы.ВключаяДатуДо.Доступность = ВозрастДоЛет>0 Или ВозрастДоМесяцев>0;
	Если Не Элементы.ВключаяДатуДо.Доступность Тогда 
		ВключаяДатуДо = Ложь;
	КонецЕсли;
КонецПроцедуры
		
#КонецОбласти
