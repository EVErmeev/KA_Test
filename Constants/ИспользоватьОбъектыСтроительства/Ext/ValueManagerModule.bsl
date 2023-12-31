﻿
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	ПараметрыНабора = УправлениеСвойствами.СтруктураПараметровНабораСвойств();
	ПараметрыНабора.Используется = Константы.ИспользоватьОбъектыСтроительства.Получить();
	
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Справочник_ОбъектыСтроительства", ПараметрыНабора);

КонецПроцедуры

#КонецОбласти

#КонецЕсли
