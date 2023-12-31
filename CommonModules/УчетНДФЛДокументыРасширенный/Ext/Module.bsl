﻿#Область СлужебныеПроцедурыИФункции

Процедура ОтменитьПрименениеВычетов(Регистратор, Сотрудник) Экспорт
	
	Если ТипЗнч(Регистратор) = Тип("ДокументСсылка.УвольнениеСписком") Тогда
		
		Заявление = Регистратор.ПолучитьОбъект();
		СтрокаСотрудника = Заявление.Сотрудники.Найти(Сотрудник, "Сотрудник");
		Если СтрокаСотрудника <> Неопределено Тогда
			
			СтрокаСотрудника.ПрименятьВычетыПослеУвольнения = Истина;
			Заявление.Записать(РежимЗаписиДокумента.Проведение);
			
		КонецЕсли;
		
	Иначе
		УчетНДФЛДокументыБазовый.ОтменитьПрименениеВычетов(Регистратор, Сотрудник);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти