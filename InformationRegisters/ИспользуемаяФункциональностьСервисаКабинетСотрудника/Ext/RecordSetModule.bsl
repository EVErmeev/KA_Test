﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Настройки = РегистрыСведений.ИспользуемаяФункциональностьСервисаКабинетСотрудника.СоздатьМенеджерЗаписи();
	Настройки.Прочитать();
	
	СтруктураНастроек = ОбщегоНазначения.СтруктураПоМенеджеруЗаписи(
							Настройки, Метаданные.РегистрыСведений.ИспользуемаяФункциональностьСервисаКабинетСотрудника);
							
	ЭтотОбъект.ДополнительныеСвойства.Вставить("ПрежниеНастройки", СтруктураНастроек);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ПрежниеНастройки = Неопределено;
	ДополнительныеСвойства.Свойство("ПрежниеНастройки", ПрежниеНастройки);
	Если ЗначениеЗаполнено(ПрежниеНастройки) И Количество() > 0 И Не ПрежниеНастройки.ЗаявленияНаДСВ И ЭтотОбъект[0].ЗаявленияНаДСВ Тогда
		ИмяОбработчика = КабинетСотрудника.ИмяОбработчикаЗарегистрироватьИзмененияПлановыхУдержаний();
		НаборЗаписей = РегистрыСведений.ОбработчикиОбменаКабинетСотрудника.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Обработчик.Установить(ИмяОбработчика);
		ЗаписьНабора = НаборЗаписей.Добавить();
		ЗаписьНабора.Обработчик = ИмяОбработчика; 
		ЗаписьНабора.Выполнено = Ложь;
		НаборЗаписей.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли