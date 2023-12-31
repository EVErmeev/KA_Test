﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(
		Истина, "ОбщаяКоманда.ДокументыПоОсновномуСредству");
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОбъектЭксплуатации", ПараметрКоманды);
	
	// Чтобы можно было открыть несколько форм нужно определить уникальность.
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник) = Тип("ФормаКлиентскогоПриложения")
		И ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Справочник.ОбъектыЭксплуатации.Форма.ФормаЭлемента" Тогда
		УникальностьФормы = ПараметрыВыполненияКоманды.Источник;
	Иначе
		УникальностьФормы = ПараметрКоманды;
	КонецЕсли; 
	
	ИмяФормы = ВнеоборотныеАктивыКлиентЛокализация.ИмяФормыДокументыПоОсновномуСредству();
	Если ИмяФормы = Неопределено Тогда
		ИмяФормы = "Обработка.ЖурналДокументовОС2_4.Форма";
	КонецЕсли; 
	
	ОткрытьФорму(ИмяФормы, 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		УникальностьФормы,
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти
