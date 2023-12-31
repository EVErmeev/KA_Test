﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен текущей (используемой вызывающим кодом) версии интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//   Строка - пространство имен.
//
Функция Пакет() Экспорт
КонецФункции

// Возвращает текущую (используемую вызывающим кодом) версию интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//   Строка - версия интерфейса.
//
Функция Версия() Экспорт
КонецФункции

// Возвращает название программного интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Возвращаемое значение:
//   Строка - название интерфейса.
//
Функция ПрограммныйИнтерфейс() Экспорт
КонецФункции

// Выполняет регистрацию обработчиков сообщений в качестве обработчиков каналов обмена сообщениями.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  МассивОбработчиков - Массив - массив обработчиков.
//
Процедура ОбработчикиКаналовСообщений(Знач МассивОбработчиков) Экспорт
КонецПроцедуры

// Выполняет регистрацию обработчиков трансляции сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  МассивОбработчиков - Массив - массив обработчиков.
//
Процедура ОбработчикиТрансляцииСообщений(Знач МассивОбработчиков) Экспорт
КонецПроцедуры

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ControlZonesBackup/a.b.c.d}ZoneBackupSuccessfull.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - тип сообщения.
//
Функция СообщениеРезервнаяКопияОбластиСоздана(Знач ИспользуемыйПакет = Неопределено) Экспорт
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ControlZonesBackup/a.b.c.d}ZoneBackupFailed.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - тип сообщения.
//
Функция СообщениеОшибкаАрхивацииОбласти(Знач ИспользуемыйПакет = Неопределено) Экспорт
КонецФункции

// Возвращает тип сообщения {http://www.1c.ru/SaaS/ControlZonesBackup/a.b.c.d}ZoneBackupSkipped.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ИспользуемыйПакет - Строка - пространство имен версии интерфейса сообщений, для которой получается тип сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - тип сообщения.
//
Функция СообщениеАрхивацияОбластиПропущена(Знач ИспользуемыйПакет = Неопределено) Экспорт
КонецФункции

#КонецОбласти
