﻿
#Область СлужебныеПроцедурыИФункции

Процедура УстановитьУчетнуюПолитикуНДФЛОбособленногоПодразделения(Источник, Отказ) Экспорт
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(Источник) Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Источник.ОбособленноеПодразделение Тогда 
		УстановитьЗначенияУчетнойПолитикиНДФЛПоУмолчанию(Источник);
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", Источник.Ссылка);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Организации.Ссылка КАК Организация,
	               |	УчетнаяПолитикаПоНДФЛРасширенный.*
	               |ИЗ
	               |	Справочник.Организации КАК Организации
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.УчетнаяПолитикаПоНДФЛРасширенный КАК УчетнаяПолитикаПоНДФЛРасширенный
	               |		ПО Организации.ГоловнаяОрганизация = УчетнаяПолитикаПоНДФЛРасширенный.Организация
	               |			И (Организации.Ссылка = &Организация)";
	
	УстановитьПривилегированныйРежим(Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		НаборЗаписей = РегистрыСведений.УчетнаяПолитикаПоНДФЛРасширенный.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Организация.Установить(Выборка.Организация);
		НоваяЗапись = НаборЗаписей.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяЗапись, Выборка);
		НаборЗаписей.Записать();
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьЗначенияУчетнойПолитикиНДФЛПоУмолчанию(Источник)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", Источник.Ссылка);
	
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	УчетнаяПолитикаПоНДФЛРасширенный.Организация КАК Организация
	|ИЗ
	|	РегистрСведений.УчетнаяПолитикаПоНДФЛРасширенный КАК УчетнаяПолитикаПоНДФЛРасширенный
	|ГДЕ
	|	УчетнаяПолитикаПоНДФЛРасширенный.Организация = &Организация";
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	
	Если Не РезультатЗапроса.Пустой() Тогда 
		Возврат;
	КонецЕсли;
	
	НаборЗаписей = РегистрыСведений.УчетнаяПолитикаПоНДФЛРасширенный.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Организация.Установить(Источник.Ссылка);
	НоваяЗапись = НаборЗаписей.Добавить();
	НоваяЗапись.Организация = Источник.Ссылка;
	НоваяЗапись.УдержаниеНДФЛПриВыплатеМежрасчетныхНачисленийСАвансом = Перечисления.УдержаниеНДФЛПриВыплатеМежрасчетныхНачисленийСАвансом.УдерживатьНалог;
	НоваяЗапись.УдержаниеНДФЛПриВыплатеАванса = Перечисления.УдержаниеНДФЛПриВыплатеАванса.НеУдерживатьНалог;
	НоваяЗапись.ИсчислениеНДФЛВАвансе = Перечисления.ИсчислениеНДФЛВАвансе.ИсчислятьНалог;
	НоваяЗапись.ИсчислениеНДФЛПриМежрасчетныхНачислениях = Перечисления.ИсчислениеНДФЛПриМежрасчетныхНачислениях.ИсчислятьНалог;
	НаборЗаписей.Записать();
	
КонецПроцедуры

#КонецОбласти
