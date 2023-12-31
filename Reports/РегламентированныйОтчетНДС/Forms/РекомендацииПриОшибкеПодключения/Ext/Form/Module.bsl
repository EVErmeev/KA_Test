﻿
&НаКлиенте
Процедура ДекорацияРекомендацииПриОшибкеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("ОбщаяФорма.ПараметрыПроксиСервера", Новый Структура("НастройкаПроксиНаКлиенте", Истина), ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияОткрытьЖурналРегистрацииОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Новый Структура("Пользователь", ИмяПользователя()));
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНаписатьВТехПоддержкуОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
    АдресПолучателя = "webIts";
	Тема = НСтр("ru = 'Сервис проверки контрагентов ФНС'");
	Вложения = Неопределено;
	Сообщение = НСтр("ru = 'Не удалось подключиться к сервису проверки контрагентов ФНС.'");
		
	
	ДополнительныеПараметры = Новый Структура;
	//ДополнительныеПараметры.Вставить("Логин"                        , Логин);
	//ДополнительныеПараметры.Вставить("Пароль"                       , Пароль);
	ДополнительныеПараметры.Вставить("НастройкиСоединенияССерверами", НастройкиСоединения());
	//ДополнительныеПараметры.Вставить("ЭтоПолноправныйПользователь"  , ЭтоАдминистраторСистемы);
	
	ИнтернетПоддержкаПользователейКлиент.ОтправитьСообщениеВТехПоддержку(
		Тема,
		Сообщение,
		АдресПолучателя,
		Вложения,
		ДополнительныеПараметры);
	
КонецПроцедуры

&НаКлиенте
Функция НастройкиСоединения()
	//Если НастройкиСоединенияССерверами = Неопределено Тогда
		Возврат ИнтернетПоддержкаПользователейКлиент.НастройкиСоединенияССерверами();
	//Иначе
	//	Возврат НастройкиСоединенияССерверами;
	//КонецЕсли;
КонецФункции

