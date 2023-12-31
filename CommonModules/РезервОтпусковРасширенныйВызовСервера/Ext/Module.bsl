﻿
#Область СлужебныйПрограммныйИнтерфейс

Функция ПараметрыРедактированияСреднегоЗаработка(ОписаниеОбъекта) Экспорт
	
	Возврат РезервОтпусковРасширенный.ПараметрыРедактированияСреднегоЗаработка(ОписаниеОбъекта);
	
КонецФункции

Функция ПараметрыРедактированияСохраняемогоДенежногоСодержания(Сотрудник, ДатаРасчета, Ссылка, Организация) Экспорт
	
	СтруктураОбъекта = Новый Структура();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("ЗарплатаКадрыПриложения.ГосударственнаяСлужба.РасчетДенежногоСодержания") Тогда
		Модуль = ОбщегоНазначения.ОбщийМодуль("РасчетДенежногоСодержания");
		СтруктураОбъекта = Модуль.ПодготовитьСтруктуруОбъектаДляРасчетаРезервовОтпусков(Сотрудник, Организация, ДатаРасчета);
		СтруктураОбъекта.Вставить("Ссылка", 	 Ссылка);
		СтруктураОбъекта.Вставить("РасчетРезерваОтпусков", 	Истина);
		СтруктураОбъекта.Вставить("ДенежноеСодержание", Неопределено);
		СтруктураОбъекта.Вставить("ДенежноеСодержаниеФактическиеНачисления", Неопределено);
		СтруктураОбъекта.Вставить("КоэффициентыРаспределения", Неопределено);
		СтруктураОбъекта.Вставить("КоэффициентыРаспределенияДенежногоСодержания", Неопределено);
	КонецЕсли;

	Возврат СтруктураОбъекта;
	
КонецФункции

#КонецОбласти
