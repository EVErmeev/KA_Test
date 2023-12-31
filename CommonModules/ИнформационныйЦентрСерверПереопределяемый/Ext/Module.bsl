﻿
#Область ПрограммныйИнтерфейс

// Определяет ссылку поиска информации.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//	СсылкаПоискаИнформации - Строка - адрес.
//	
// Пример:
//	Если к адресу ссылки добавить строку поиска, и перейти по данному адресу, то
//	в результате мы должны перейти форму результатов поиска.
//	
Процедура ОпределитьСсылкуПоискаИнформации(СсылкаПоискаИнформации) Экспорт
КонецПроцедуры

// Определяет общие макеты с информационными ссылками.
// @skip-warning ПустойМетод - переопределяемый метод.
// 
// Параметры:
//  МассивМакетов - Массив Из ТабличныйДокумент - массив общих макетов.
//
Процедура ОбщиеМакетыСИнформационнымиСсылками(МассивМакетов) Экспорт
КонецПроцедуры

// Определяет массив полных путей к формам, в которых используются информационные ссылки.
// @skip-warning ПустойМетод - переопределяемый метод.
//
// Параметры:
//  МассивФорм - Массив Из Строка - массив полных путей к формам.
//
Процедура ФормыСИнформационнымиСсылками(МассивФорм) Экспорт
КонецПроцедуры

#КонецОбласти