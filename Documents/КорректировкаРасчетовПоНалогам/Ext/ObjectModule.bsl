﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Организация = ЗначениеНастроекПовтИсп.ПолучитьОрганизациюПоУмолчанию(Организация);
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ОписаниеЗамера = ОценкаПроизводительности.НачатьЗамерДлительнойОперации("ПроведениеКорректировкаРасчетовПоНалогам");
	ДополнительныеСвойства.Вставить("ОписаниеЗамера", ОписаниеЗамера);
	
	ПроведениеДокументов.ПередЗаписьюДокумента(ЭтотОбъект, РежимЗаписи, РежимПроведения);
	
	СуммаДокумента = РасшифровкаНалогов.Итог("Сумма");
	
	ОбщегоНазначенияУТ.ЗаполнитьИдентификаторыДокумента(ЭтотОбъект, "РасшифровкаНалогов");
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроведениеДокументов.ПриЗаписиДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПроведениеДокументов.ОбработкаПроведенияДокумента(ЭтотОбъект, Отказ);
	
	ОписаниеЗамера = Неопределено;
	Если ДополнительныеСвойства.Свойство("ОписаниеЗамера", ОписаниеЗамера) Тогда
		ОценкаПроизводительности.ЗакончитьЗамерДлительнойОперации(ОписаниеЗамера, 1);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	ПроведениеДокументов.ОбработкаУдаленияПроведенияДокумента(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.КорректировкаСчета Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ТипНалога");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.КодБК");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.СрокУплаты");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ВидПлатежа");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеПенейШтрафов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ТипНалога");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.КодБК");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.СрокУплаты");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ПлатежныйДокумент");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ВидДвижения");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.ПогашениеПенейШтрафов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ТипНалога");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.КодБК");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.СрокУплаты");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ВидДвижения");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.СчетУчета");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.НачислениеНалогов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ВидПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ВидДвижения");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ПлатежныйДокумент");
	ИначеЕсли ВидОперации = Перечисления.ВидыОперацийПоЕдиномуНалоговомуСчету.УплатаНалогов Тогда
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ВидПлатежа");
		МассивНепроверяемыхРеквизитов.Добавить("РасшифровкаНалогов.ВидДвижения");
	КонецЕсли;

	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если Не Отказ И ОбщегоНазначенияУТ.ПроверитьЗаполнениеРеквизитовОбъекта(ЭтотОбъект, ПроверяемыеРеквизиты) Тогда
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли