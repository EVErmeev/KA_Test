﻿#Область СлужебныеПроцедурыИФункции

// Отключает режим записи логов.
// 
Процедура ОтключитьЛогированиеЗапросов() Экспорт
	
	ПараметрыЛогирования                 = ПараметрыЛогированияЗапросов();
	ПараметрыЛогирования.Включено        = Ложь;
	
	УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования);
	
КонецПроцедуры

// Возвращает текствое описание текущего окружения и параметров.
// 
// Возвращаемое значение:
// 	Строка - Текстовое описание текущего окружения.
Функция ИнформацияОбОкружении() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеОкружения = Новый Массив();
	
	ЛогированиеЗапросовИС.ДополнитьИнформациюОбОкруженииШапка(ДанныеОкружения);
	
	ДанныеОкружения.Добавить(
		СтрШаблон(
			"%1: %2",
			Метаданные.Константы.РежимРаботыСТестовымКонтуромВЕТИС.Синоним,
			ИнтеграцияВЕТИСКлиентСервер.РежимРаботыСТестовымКонтуромВЕТИС()));
	
	ПараметрыОптимизации = ИнтеграцияВЕТИС.ПараметрыОптимизации();
	
	СинонимыПараметровОптимизации = ИнтеграцияВЕТИСПовтИсп.ПредставленияНастроекОптимизации();
	
	Для Каждого КлючИЗначение Из ПараметрыОптимизации Цикл
		
		ПредставлениеПараметра = СинонимыПараметровОптимизации.Получить(КлючИЗначение.Ключ);
		Если ПредставлениеПараметра = Неопределено Тогда
			ПредставлениеПараметра = ИнтеграцияИСКлиентСервер.ПредставлениеВстроенногоИмени(КлючИЗначение.Ключ);
		КонецЕсли;
		
		ДанныеОкружения.Добавить(
			СтрШаблон(
				"%1: %2%3",
				ПредставлениеПараметра,
				Формат(КлючИЗначение.Значение, "ДФ=dd.MM.yyyy; БЛ=Нет; БИ=Да;")));
		
	КонецЦикла;
	
	ЛогированиеЗапросовИС.ДополнитьИнформациюОбОкруженииПодвал(ДанныеОкружения);
	
	Возврат СтрСоединить(ДанныеОкружения, Символы.ПС);
	
КонецФункции

// Получает текущие параметры логирования.
// 
// Возвращаемое значение:
// 	см. ЛогированиеЗапросовИС.ПараметрыЛогированияЗапросов
Функция ПараметрыЛогированияЗапросов() Экспорт
	
	Возврат ЛогированиеЗапросовИС.ПараметрыЛогированияЗапросов("ПараметрыЛогированияЗапросовВЕТИС");
	
КонецФункции

// Сохраняет параметры логирования в параметр сеанса.
// 
// Параметры:
// 	ПараметрыЛогирования - см. ЛогированиеЗапросовИС.ПараметрыЛогированияЗапросов.
Процедура УстановитьПараметрыЛогированияЗапросов(ПараметрыЛогирования) Экспорт
	
	ПараметрыСеанса.ПараметрыЛогированияЗапросовВЕТИС = ОбщегоНазначения.ФиксированныеДанные(ПараметрыЛогирования);
	
КонецПроцедуры

// Дописывает полученные данные лога запросов в текущий уровень логирования.
// 
// Параметры:
// 	ДанныеДокумента - Структура:
// 	* ДанныеЛогаЗапросов - Строка - Данные для записи в лог запросов
Процедура ДописатьВТекущийЛогДанныеИзФоновогоЗадания(ДанныеДокумента) Экспорт
	
	ЛогированиеЗапросовИС.ДописатьВТекущийЛогДанныеИзФоновогоЗадания(ДанныеДокумента, ПараметрыЛогированияЗапросов());
	
КонецПроцедуры

#КонецОбласти
