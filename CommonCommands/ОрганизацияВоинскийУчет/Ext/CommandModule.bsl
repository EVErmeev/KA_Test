﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ВладелецФормы = ПараметрыВыполненияКоманды.Источник;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ОрганизацияСсылка", ПараметрКоманды);
	
	ОткрытьФорму("ОбщаяФорма.ОрганизацияВоинскийУчет", 
		ПараметрыОткрытия, 
		ВладелецФормы, 
		, 
		ВладелецФормы.Окно);
		
КонецПроцедуры
