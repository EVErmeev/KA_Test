﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает виды расходов, считающиеся товарами
// Возвращаемое значение:
//	Массив - Массив из ПеречислениеСсылка.ВидыРасходовУСН.
//
Функция ВидыРасходовТовары() Экспорт
	
	ВидыРасходовТовары = Новый Массив;
	ВидыРасходовТовары.Добавить(Перечисления.ВидыРасходовУСН.Номенклатура);
	ВидыРасходовТовары.Добавить(Перечисления.ВидыРасходовУСН.ДопРасходыТовары);
	ВидыРасходовТовары.Добавить(Перечисления.ВидыРасходовУСН.ТаможенныеПлатежиТовары);
	
	Возврат ВидыРасходовТовары;
	
КонецФункции

// Возвращает виды расходов, считающиеся материалами
// Возвращаемое значение:
//	Массив - Массив из ПеречислениеСсылка.ВидыРасходовУСН.
//
Функция ВидыРасходовМатериалы() Экспорт
	
	ВидыРасходовМатериалы = Новый Массив;
	ВидыРасходовМатериалы.Добавить(Перечисления.ВидыРасходовУСН.Материалы);
	ВидыРасходовМатериалы.Добавить(Перечисления.ВидыРасходовУСН.ДопРасходыМатериалы);
	ВидыРасходовМатериалы.Добавить(Перечисления.ВидыРасходовУСН.ТаможенныеПлатежиМатериалы);
	
	Возврат ВидыРасходовМатериалы;
	
КонецФункции

// Возвращает виды расходов, считающиеся нематериальными активами
// Возвращаемое значение:
//	Массив - Массив из ПеречислениеСсылка.ВидыРасходовУСН.
//
Функция ВидыРасходовОСНМА() Экспорт
	
	ВидыРасходовОСНМА = Новый Массив;
	ВидыРасходовОСНМА.Добавить(Перечисления.ВидыРасходовУСН.ОС);
	ВидыРасходовОСНМА.Добавить(Перечисления.ВидыРасходовУСН.НМА);
	
	Возврат ВидыРасходовОСНМА;
	
КонецФункции

// Возвращает виды расходов, считающиеся прочими (услуги, зарплата и т.д.)
// Возвращаемое значение:
//	Массив - Массив из ПеречислениеСсылка.ВидыРасходовУСН.
//
Функция ВидыРасходовПрочие() Экспорт
	
	ВидыРасходовПрочие = Новый Массив;
	ВидыРасходовПрочие.Добавить(Перечисления.ВидыРасходовУСН.Услуги);
	ВидыРасходовПрочие.Добавить(Перечисления.ВидыРасходовУСН.РБП);
	ВидыРасходовПрочие.Добавить(Перечисления.ВидыРасходовУСН.ТаможенныеПлатежи);
	ВидыРасходовПрочие.Добавить(Перечисления.ВидыРасходовУСН.Зарплата);
	ВидыРасходовПрочие.Добавить(Перечисления.ВидыРасходовУСН.Налоги);
	ВидыРасходовПрочие.Добавить(Перечисления.ВидыРасходовУСН.Лизинг);
	ВидыРасходовПрочие.Добавить(Перечисления.ВидыРасходовУСН.Кредиты);
	
	Возврат ВидыРасходовПрочие;
	
КонецФункции

// Возвращает виды расходов, для которых достаточно соблюдения двух условий для признания:
//	- оплата;
//	- факт возникновения расхода.
// Возвращаемое значение:
//	Массив - Массив из ПеречислениеСсылка.ВидыРасходовУСН.
//
Функция ВидыРасходовПризнаваемыеПоОплате() Экспорт
	
	ВидыРасходовПризнаваемыеПоОплате = Новый Массив;
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВидыРасходовПризнаваемыеПоОплате, ВидыРасходовМатериалы());
	ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ВидыРасходовПризнаваемыеПоОплате, ВидыРасходовПрочие());
	
	Возврат ВидыРасходовПризнаваемыеПоОплате;
	
КонецФункции

// Возвращает признак определения расходов, для которых необходимо соблюдение трех условий для признания:
//	- поступление товара (возникновение расхода);
//	- оплата товара;
//	- реализация товара.
//	
// Параметры:
//	ВидРасходов - ПеречислениеСсылка.ВидыРасходовУСН - вид расходов, для которого необходимо получить
//		признак признания как товара.
//	
// Возвращаемое значение:
//	Булево - Истина, если для переданного вида расходов необходимо соблюдение всех трех условий.
//
Функция ПризнаетсяКакТовар(ВидРасходов) Экспорт
	Возврат ВидыРасходовТовары().Найти(ВидРасходов) <> Неопределено;
КонецФункции

// Возвращает признак определения расходов ОС/НМА, для которых необходимо особое поведение признания:
//	- факт возникновения расхода;
//	- оплата расхода;
//	- принятие к учету ОС или НМА;
//	- признание равными долями в течении отчетного периода с момента выполнения предыдущих трех условий
//	
// Параметры:
//	ВидРасходов - ПеречислениеСсылка.ВидыРасходовУСН - вид расходов, для которого необходимо получить
//		признак признания как ОС/НМА.
//	
// Возвращаемое значение:
//	Булево - Истина, если для переданного вида расходов необходимо соблюдение особого поведения признания.
//
Функция ПризнаетсяКакОСНМА(ВидРасходов) Экспорт
	Возврат ВидыРасходовОСНМА().Найти(ВидРасходов) <> Неопределено;
КонецФункции

// Возвращает признак определения расходов, для которых необходимо соблюдение двух условий для признания:
//	- факт возникновения расхода;
//	- оплата расхода.
//	
// Параметры:
//	ВидРасходов - ПеречислениеСсылка.ВидыРасходовУСН - вид расходов, для которого необходимо получить
//		признак признания по соблюдению двух условий.
//	
// Возвращаемое значение:
//	Булево - Истина, если для переданного вида расходов необходимо соблюдение двух условий.
//
Функция ПризнаетсяПоОплате(ВидРасходов) Экспорт
	Возврат ВидыРасходовТовары().Найти(ВидРасходов) = Неопределено
		И ВидыРасходовОСНМА().Найти(ВидРасходов) = Неопределено;
КонецФункции

#КонецОбласти

#КонецЕсли