﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает пространство имен версии интерфейса сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//  Строка - наименование пакета.
//
Функция Пакет() Экспорт
КонецФункции

// Возвращает версию интерфейса сообщений, обслуживаемую обработчиком.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//  Строка -версия пакета.
//
Функция Версия() Экспорт
КонецФункции

// Возвращает базовый тип для сообщений версии.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - базовый тип тел сообщений в модели сервиса.
//
Функция БазовыйТип() Экспорт
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  Сообщение - ОбъектXDTO - входящее сообщение,
//  Отправитель - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, соответствующий отправителю сообщения.
//  СообщениеОбработано - Булево - флаг успешной обработки сообщения. Значение данного параметра необходимо
//    установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике.
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
КонецПроцедуры

#КонецОбласти
