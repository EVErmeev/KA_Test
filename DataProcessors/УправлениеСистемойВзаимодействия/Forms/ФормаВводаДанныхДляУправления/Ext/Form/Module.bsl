﻿#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сохранить(Команда)
	Закрыть(ДанныеДляУправления);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура Инициализировать(Данные = "") Экспорт
	
	ДанныеДляУправления = Данные;
	
КонецПроцедуры

#КонецОбласти
