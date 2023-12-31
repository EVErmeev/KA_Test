﻿#Область СлужебныеПроцедурыИФункции

Функция ПараметрыБлокировкиИзмененияОбъекта(СсылкаНаОбъект, УправляемаяФорма) Экспорт
	
	КоллекцияБлокировок = БлокировкаИзмененияОбъектовБазовый.ПараметрыБлокировкиИзмененияОбъекта(СсылкаНаОбъект, УправляемаяФорма);
	
	МетаданныеОбъекта = СсылкаНаОбъект.Метаданные();
	Если ПравоДоступа("Изменение", МетаданныеОбъекта) Тогда
		
		Если УправляемаяФорма <> Неопределено Тогда
			ЗарплатаКадрыРасширенный.ДобавитьБлокировкуИзмененияОбъектаФормы(КоллекцияБлокировок, УправляемаяФорма);
		КонецЕсли;
		
		ИсправлениеДокументовЗарплатаКадры.ДобавитьБлокировкуИзмененияОбъектаФормы(КоллекцияБлокировок, СсылкаНаОбъект);
		
	КонецЕсли;
	
	Возврат КоллекцияБлокировок;
	
КонецФункции

#КонецОбласти

