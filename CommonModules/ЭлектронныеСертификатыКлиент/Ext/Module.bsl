﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает массив доверенных сертификатов
//
// Возвращаемое значение:
//   Массив из Структура:
//    * Сертификат - Строка - сертификат в виде Base64
//    * Хранилище - Строка
//
Функция СписокДоверенныхСертификатов() Экспорт
	Сертификаты = Новый Массив();

	// Сертификат в хранилище ROOT
	МассивСтрок = Новый Массив();
	МассивСтрок.Добавить("MIIFwjCCA6qgAwIBAgICEAAwDQYJKoZIhvcNAQELBQAwcDELMAkGA1UEBhMCUlUx");
	МассивСтрок.Добавить("PzA9BgNVBAoMNlRoZSBNaW5pc3RyeSBvZiBEaWdpdGFsIERldmVsb3BtZW50IGFu");
	МассивСтрок.Добавить("ZCBDb21tdW5pY2F0aW9uczEgMB4GA1UEAwwXUnVzc2lhbiBUcnVzdGVkIFJvb3Qg");
	МассивСтрок.Добавить("Q0EwHhcNMjIwMzAxMjEwNDE1WhcNMzIwMjI3MjEwNDE1WjBwMQswCQYDVQQGEwJS");
	МассивСтрок.Добавить("VTE/MD0GA1UECgw2VGhlIE1pbmlzdHJ5IG9mIERpZ2l0YWwgRGV2ZWxvcG1lbnQg");
	МассивСтрок.Добавить("YW5kIENvbW11bmljYXRpb25zMSAwHgYDVQQDDBdSdXNzaWFuIFRydXN0ZWQgUm9v");
	МассивСтрок.Добавить("dCBDQTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAMfFOZ8pUAL3+r2n");
	МассивСтрок.Добавить("qqE0Zp52selXsKGFYoG0GM5bwz1bSFtCt+AZQMhkWQheI3poZAToYJu69pHLKS6Q");
	МассивСтрок.Добавить("XBiwBC1cvzYmUYKMYZC7jE5YhEU2bSL0mX7NaMxMDmH2/NwuOVRj8OImVa5s1F4U");
	МассивСтрок.Добавить("zn4Kv3PFlDBjjSjXKVY9kmjUBsXQrIHeaqmUIsPIlNWUnimXS0I0abExqkbdrXbX");
	МассивСтрок.Добавить("YwCOXhOO2pDUx3ckmJlCMUGacUTnylyQW2VsJIyIGA8V0xzdaeUXg0VZ6ZmNUr5Y");
	МассивСтрок.Добавить("Ber/EAOLPb8NYpsAhJe2mXjMB/J9HNsoFMBFJ0lLOT/+dQvjbdRZoOT8eqJpWnVD");
	МассивСтрок.Добавить("U+QL/qEZnz57N88OWM3rabJkRNdU/Z7x5SFIM9FrqtN8xewsiBWBI0K6XFuOBOTD");
	МассивСтрок.Добавить("4V08o4TzJ8+Ccq5XlCUW2L48pZNCYuBDfBh7FxkB7qDgGDiaftEkZZfApRg2E+M9");
	МассивСтрок.Добавить("G8wkNKTPLDc4wH0FDTijhgxR3Y4PiS1HL2Zhw7bD3CbslmEGgfnnZojNkJtcLeBH");
	МассивСтрок.Добавить("BLa52/dSwNU4WWLubaYSiAmA9IUMX1/RpfpxOxd4Ykmhz97oFbUaDJFipIggx5sX");
	МассивСтрок.Добавить("ePAlkTdWnv+RWBxlJwMQ25oEHmRguNYf4Zr/Rxr9cS93Y+mdXIZaBEE0KS2iLRqa");
	МассивСтрок.Добавить("OiWBki9IMQU4phqPOBAaG7A+eP8PAgMBAAGjZjBkMB0GA1UdDgQWBBTh0YHlzlpf");
	МассивСтрок.Добавить("BKrS6badZrHF+qwshzAfBgNVHSMEGDAWgBTh0YHlzlpfBKrS6badZrHF+qwshzAS");
	МассивСтрок.Добавить("BgNVHRMBAf8ECDAGAQH/AgEEMA4GA1UdDwEB/wQEAwIBhjANBgkqhkiG9w0BAQsF");
	МассивСтрок.Добавить("AAOCAgEAALIY1wkilt/urfEVM5vKzr6utOeDWCUczmWX/RX4ljpRdgF+5fAIS4vH");
	МассивСтрок.Добавить("tmXkqpSCOVeWUrJV9QvZn6L227ZwuE15cWi8DCDal3Ue90WgAJJZMfTshN4OI8cq");
	МассивСтрок.Добавить("W9E4EG9wglbEtMnObHlms8F3CHmrw3k6KmUkWGoa+/ENmcVl68u/cMRl1JbW2bM+");
	МассивСтрок.Добавить("/3A+SAg2c6iPDlehczKx2oa95QW0SkPPWGuNA/CE8CpyANIhu9XFrj3RQ3EqeRcS");
	МассивСтрок.Добавить("AQQod1RNuHpfETLU/A2gMmvn/w/sx7TB3W5BPs6rprOA37tutPq9u6FTZOcG1Oqj");
	МассивСтрок.Добавить("C/B7yTqgI7rbyvox7DEXoX7rIiEqyNNUguTk/u3SZ4VXE2kmxdmSh3TQvybfbnXV");
	МассивСтрок.Добавить("4JbCZVaqiZraqc7oZMnRoWrXRG3ztbnbes/9qhRGI7PqXqeKJBztxRTEVj8ONs1d");
	МассивСтрок.Добавить("WN5szTwaPIvhkhO3CO5ErU2rVdUr89wKpNXbBODFKRtgxUT70YpmJ46VVaqdAhOZ");
	МассивСтрок.Добавить("D9EUUn4YaeLaS8AjSF/h7UkjOibNc4qVDiPP+rkehFWM66PVnP1Msh93tc+taIfC");
	МассивСтрок.Добавить("EYVMxjh8zNbFuoc7fzvvrFILLe7ifvEIUqSVIC/AzplM/Jxw7buXFeGP1qVCBEHq");
	МассивСтрок.Добавить("391d/9RAfaZ12zkwFsl+IKwE/OZxW8AHa9i1p4GO0YSNuczzEm4=");
	
	Элемент = НовыйДоверенныйСертификат();
	Элемент.Наименование   = НСтр("ru = 'Корневой сертификат'");
	Элемент.Хранилище      = "ROOT";
	Элемент.ДействителенДо = '20320228';
	Элемент.Сертификат     = СтрСоединить(МассивСтрок, "");
	Сертификаты.Добавить(Элемент);

	// Сертификат в хранилище CA
	МассивСтрок = Новый Массив();
	МассивСтрок.Добавить("MIIHQjCCBSqgAwIBAgICEAIwDQYJKoZIhvcNAQELBQAwcDELMAkGA1UEBhMCUlUx");
	МассивСтрок.Добавить("PzA9BgNVBAoMNlRoZSBNaW5pc3RyeSBvZiBEaWdpdGFsIERldmVsb3BtZW50IGFu");
	МассивСтрок.Добавить("ZCBDb21tdW5pY2F0aW9uczEgMB4GA1UEAwwXUnVzc2lhbiBUcnVzdGVkIFJvb3Qg");
	МассивСтрок.Добавить("Q0EwHhcNMjIwMzAyMTEyNTE5WhcNMjcwMzA2MTEyNTE5WjBvMQswCQYDVQQGEwJS");
	МассивСтрок.Добавить("VTE/MD0GA1UECgw2VGhlIE1pbmlzdHJ5IG9mIERpZ2l0YWwgRGV2ZWxvcG1lbnQg");
	МассивСтрок.Добавить("YW5kIENvbW11bmljYXRpb25zMR8wHQYDVQQDDBZSdXNzaWFuIFRydXN0ZWQgU3Vi");
	МассивСтрок.Добавить("IENBMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA9YPqBKOk19NFymrE");
	МассивСтрок.Добавить("wehzrhBEgT2atLezpduB24mQ7CiOa/HVpFCDRZzdxqlh8drku408/tTmWzlNH/br");
	МассивСтрок.Добавить("HuQhZ/miWKOf35lpKzjyBd6TPM23uAfJvEOQ2/dnKGGJbsUo1/udKSvxQwVHpVv3");
	МассивСтрок.Добавить("S80OlluKfhWPDEXQpgyFqIzPoxIQTLZ0deirZwMVHarZ5u8HqHetRuAtmO2ZDGQn");
	МассивСтрок.Добавить("vVOJYAjls+Hiueq7Lj7Oce7CQsTwVZeP+XQx28PAaEZ3y6sQEt6rL06ddpSdoTMp");
	МассивСтрок.Добавить("BnCqTbxW+eWMyjkIn6t9GBtUV45yB1EkHNnj2Ex4GwCiN9T84QQjKSr+8f0psGrZ");
	МассивСтрок.Добавить("vPbCbQAwNFJjisLixnjlGPLKa5vOmNwIh/LAyUW5DjpkCx004LPDuqPpFsKXNKpa");
	МассивСтрок.Добавить("L2Dm6uc0x4Jo5m+gUTVORB6hOSzWnWDj2GWfomLzzyjG81DRGFBpco/O93zecsIN");
	МассивСтрок.Добавить("3SL2Ysjpq1zdoS01CMYxie//9zWvYwzI25/OZigtnpCIrcd2j1Y6dMUFQAzAtHE+");
	МассивСтрок.Добавить("qsXflSL8HIS+IJEFIQobLlYhHkoE3avgNx5jlu+OLYe0dF0Ykx1PGNjbwqvTX37R");
	МассивСтрок.Добавить("Cn32NMjlotW2QcGEZhDKj+3urZizp5xdTPZitA+aEjZM/Ni71VOdiOP0igbw6asZ");
	МассивСтрок.Добавить("2fxdozZ1TnSSYNYvNATwthNmZysCAwEAAaOCAeUwggHhMBIGA1UdEwEB/wQIMAYB");
	МассивСтрок.Добавить("Af8CAQAwDgYDVR0PAQH/BAQDAgGGMB0GA1UdDgQWBBTR4XENCy2BTm6KSo9MI7NM");
	МассивСтрок.Добавить("XqtpCzAfBgNVHSMEGDAWgBTh0YHlzlpfBKrS6badZrHF+qwshzCBxwYIKwYBBQUH");
	МассивСтрок.Добавить("AQEEgbowgbcwOwYIKwYBBQUHMAKGL2h0dHA6Ly9yb3N0ZWxlY29tLnJ1L2NkcC9y");
	МассивСтрок.Добавить("b290Y2Ffc3NsX3JzYTIwMjIuY3J0MDsGCCsGAQUFBzAChi9odHRwOi8vY29tcGFu");
	МассивСтрок.Добавить("eS5ydC5ydS9jZHAvcm9vdGNhX3NzbF9yc2EyMDIyLmNydDA7BggrBgEFBQcwAoYv");
	МассивСтрок.Добавить("aHR0cDovL3JlZXN0ci1wa2kucnUvY2RwL3Jvb3RjYV9zc2xfcnNhMjAyMi5jcnQw");
	МассивСтрок.Добавить("gbAGA1UdHwSBqDCBpTA1oDOgMYYvaHR0cDovL3Jvc3RlbGVjb20ucnUvY2RwL3Jv");
	МассивСтрок.Добавить("b3RjYV9zc2xfcnNhMjAyMi5jcmwwNaAzoDGGL2h0dHA6Ly9jb21wYW55LnJ0LnJ1");
	МассивСтрок.Добавить("L2NkcC9yb290Y2Ffc3NsX3JzYTIwMjIuY3JsMDWgM6Axhi9odHRwOi8vcmVlc3Ry");
	МассивСтрок.Добавить("LXBraS5ydS9jZHAvcm9vdGNhX3NzbF9yc2EyMDIyLmNybDANBgkqhkiG9w0BAQsF");
	МассивСтрок.Добавить("AAOCAgEARBVzZls79AdiSCpar15dA5Hr/rrT4WbrOfzlpI+xrLeRPrUG6eUWIW4v");
	МассивСтрок.Добавить("Sui1yx3iqGLCjPcKb+HOTwoRMbI6ytP/ndp3TlYua2advYBEhSvjs+4vDZNwXr/D");
	МассивСтрок.Добавить("anbwIWdurZmViQRBDFebpkvnIvru/RpWud/5r624Wp8voZMRtj/cm6aI9LtvBfT9");
	МассивСтрок.Добавить("cfzhOaexI/99c14dyiuk1+6QhdwKaCRTc1mdfNQmnfWNRbfWhWBlK3h4GGE9JK33");
	МассивСтрок.Добавить("Gk8ZS8DMrkdAh0xby4xAQ/mSWAfWrBmfzlOqGyoB1U47WTOeqNbWkkoAP2ys94+s");
	МассивСтрок.Добавить("Jg4NTkiDVtXRF6nr6fYi0bSOvOFg0IQrMXO2Y8gyg9ARdPJwKtvWX8VPADCYMiWH");
	МассивСтрок.Добавить("h4n8bZokIrImVKLDQKHY4jCsND2HHdJfnrdL2YJw1qFskNO4cSNmZydw0Wkgjv9k");
	МассивСтрок.Добавить("F+KxqrDKlB8MZu2Hclph6v/CZ0fQ9YuE8/lsHZ0Qc2HyiSMnvjgK5fDc3TD4fa8F");
	МассивСтрок.Добавить("E8gMNurM+kV8PT8LNIM+4Zs+LKEV8nqRWBaxkIVJGekkVKO8xDBOG/aN62AZKHOe");
	МассивСтрок.Добавить("GcyIdu7yNMMRihGVZCYr8rYiJoKiOzDqOkPkLOPdhtVlgnhowzHDxMHND/E2WA5p");
	МассивСтрок.Добавить("ZHuNM/m0TXt2wTTPL7JH2YC0gPz/BvvSzjksgzU5rLbRyUKQkgU=");
	
	Элемент = НовыйДоверенныйСертификат();
	Элемент.Наименование   = НСтр("ru = 'Выпускающий сертификат'");
	Элемент.Хранилище      = "CA";
	Элемент.ДействителенДо = '20270306';
	Элемент.Сертификат     = СтрСоединить(МассивСтрок, "");
	Сертификаты.Добавить(Элемент);
	
	Возврат Сертификаты;
	
КонецФункции

// Начинает установку доверенных сертификатов, сертификаты будут установлены если они отсутствую в хранилище.
//
// Параметры:
//  ОповещениеЗавершения - ОписаниеОповещения - описание оповещения при завершении установки, описание результата
//                                              см. РезультатОперации.
//
Процедура НачатьУстановкуДоверенныхСертификатов(ОповещениеЗавершения) Экспорт
	
	Сертификаты = СписокДоверенныхСертификатов();
	
	ЭтоWindowsКлиент   = ОбщегоНазначенияКлиент.ЭтоWindowsКлиент();
	ВерсияБСПДопустима = ВерсияБСПДопустимаДляУстановкиКорневыхСертификатов();
	
	Если ВерсияБСПДопустима И ЭтоWindowsКлиент Тогда
		Контекст = Новый Структура();
		Контекст.Вставить("Сертификаты", Сертификаты);
		Контекст.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
		
		Оповещение = Новый ОписаниеОповещения("НачатьУстановкуДоверенныхСертификатовЗавершение", ЭтотОбъект, Контекст);
		НачатьПодключениеКомпонентыExtraCryptoAPI(Оповещение);
	Иначе
		РезультатОперации = РезультатОперации();
		РезультатОперации.Результат = Ложь;
		Если Не ЭтоWindowsКлиент Тогда
			РезультатОперации.ОписаниеОшибки = НСтр("ru = 'Установка сертификатов поддерживается только в Windows.'");
		Иначе
			РезультатОперации.ОписаниеОшибки = НСтр("ru = 'Установка сертификатов не поддерживается в этой версии БСП.'");
		КонецЕсли;
		Если ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, РезультатОперации);
		КонецЕсли;
	КонецЕсли;
		
	
КонецПроцедуры

// Начинает получение списка установленных доверенных сертификатов
//
// Параметры:
//  ОповещениеЗавершения - Описание оповещения, возвращает
//    Результат - см. РезультатОперации
//
Процедура НачатьПроверкуДоверенныхСертификатов(ОповещениеЗавершения) Экспорт
	
	Сертификаты        = СписокДоверенныхСертификатов();
	ЭтоWindowsКлиент   = ОбщегоНазначенияКлиент.ЭтоWindowsКлиент();
	ВерсияБСПДопустима = ВерсияБСПДопустимаДляУстановкиКорневыхСертификатов();
	
	Если ВерсияБСПДопустима И ЭтоWindowsКлиент Тогда
		Контекст = Новый Структура();
		Контекст.Вставить("Сертификаты", Сертификаты);
		Контекст.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
		
		Оповещение = Новый ОписаниеОповещения("НачатьПроверкуДоверенныхСертификатовЗавершение", ЭтотОбъект, Контекст);
		НачатьПодключениеКомпонентыExtraCryptoAPI(Оповещение);
	Иначе
		РезультатОперации = РезультатОперации();
		РезультатОперации.Результат = Ложь;
		Если Не ЭтоWindowsКлиент Тогда
			РезультатОперации.ОписаниеОшибки = НСтр("ru = 'Проверка сертификатов поддерживается только в Windows.'");
		Иначе
			РезультатОперации.ОписаниеОшибки = НСтр("ru = 'Проверка сертификатов не поддерживается в этой версии БСП.'");
		КонецЕсли;
		Если ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, РезультатОперации);
		КонецЕсли;
	КонецЕсли;
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает Истина если интегрирована минимально требуемая версия БСП
//
// Возвращаемое значение:
//  Булево -
//
Функция ВерсияБСПДопустимаДляУстановкиКорневыхСертификатов() Экспорт
	
	ТекущаяВерсияБСП = МенеджерОборудованияВызовСервера.ВерсияБСП();
	ТекущаяВерсияБСПБезНомераСборки = 
		ОбщегоНазначенияКлиентСервер.ВерсияКонфигурацииБезНомераСборки(ТекущаяВерсияБСП);
	Если ОбщегоНазначенияКлиентСервер.СравнитьВерсииБезНомераСборки(ТекущаяВерсияБСПБезНомераСборки, "3.1.7")=0 Тогда
		МинимальнаяВерсияБСП = "3.1.7.305";
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ТекущаяВерсияБСП, МинимальнаяВерсияБСП)>=0 Тогда
			Возврат Истина;
		КонецЕсли;
	ИначеЕсли ОбщегоНазначенияКлиентСервер.СравнитьВерсииБезНомераСборки(ТекущаяВерсияБСПБезНомераСборки, "3.1.8")=0 Тогда
		МинимальнаяВерсияБСП = "3.1.8.208";
		Если ОбщегоНазначенияКлиентСервер.СравнитьВерсии(ТекущаяВерсияБСП, МинимальнаяВерсияБСП)>=0 Тогда
			Возврат Истина;
		КонецЕсли;
	ИначеЕсли ОбщегоНазначенияКлиентСервер.СравнитьВерсииБезНомераСборки(ТекущаяВерсияБСПБезНомераСборки, "3.1.8")>0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Завершает установку компоненты
//
Процедура НачатьУстановкуДоверенныхСертификатовЗавершение(Результат, Контекст) Экспорт
	
	РезультатОперации = РезультатОперации();
	Если Результат.Подключено Тогда
		ОбъектКомпоненты = Результат.ПодключаемыйМодуль;
		Сертификаты      = Контекст.Сертификаты;
		ТекстОшибки      = "";
		Попытка
			Для Каждого Элемент Из Сертификаты Цикл
				СертификатНайден = ОбъектКомпоненты.СертификатУстановленВХранилище(Элемент.Сертификат, Элемент.Хранилище);
				СертификатНайден = (СертификатНайден = Истина); // СертификатНайден может содержать Неопределено вместо Ложь
				Если Не СертификатНайден Тогда
					УстановкаВыполнена = ОбъектКомпоненты.УстановитьСертификатВХранилище(Элемент.Сертификат, Элемент.Хранилище);
					УстановкаВыполнена = (УстановкаВыполнена = Истина); // УстановкаВыполнена может содержать Неопределено вместо Ложь
					Если Не УстановкаВыполнена Тогда
						ТекстОшибки = ТекстОшибки + Символы.ПС + ОбъектКомпоненты.GetLastError();
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Не ПустаяСтрока(ТекстОшибки) Тогда
				РезультатОперации.Результат = Ложь;
				РезультатОперации.ОписаниеОшибки     = СтрШаблон(НСтр("ru = 'Установка сертификатов не выполнена. %1'"), ТекстОшибки);
			Иначе
				РезультатОперации.Результат = Истина;
			КонецЕсли;
		Исключение
			РезультатОперации.Результат = Ложь;
			РезультатОперации.ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
	ИначеЕсли ЗначениеЗаполнено(Результат.ОписаниеОшибки) Тогда
		РезультатОперации.Результат      = Ложь;
		РезультатОперации.ОписаниеОшибки = Результат.ОписаниеОшибки;
	Иначе
		РезультатОперации.Результат      = Ложь;
		//@skip-check module-nstr-camelcase
		РезультатОперации.ОписаниеОшибки = НСтр("ru = 'Не удалось подключить внешнюю компоненту ExtraCryptoAPI.'");
	КонецЕсли;
	
	Если Контекст.ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОповещениеЗавершения, РезультатОперации);
	КонецЕсли;
	
КонецПроцедуры

// Завершает получение списка установленных доверенных сертификатов после установки драйвера
//
Процедура НачатьПроверкуДоверенныхСертификатовЗавершение(Результат, Контекст) Экспорт
	
	РезультатОперации = РезультатОперации();
	
	ЕстьНеНайденныеСертификаты = Ложь;
	Текст = "";
	Если Результат.Подключено Тогда
		
		ОбъектКомпоненты = Результат.ПодключаемыйМодуль;
		Сертификаты      = Контекст.Сертификаты;
		Попытка
			Для Каждого Элемент Из Сертификаты Цикл
				СертификатНайден = ОбъектКомпоненты.СертификатУстановленВХранилище(Элемент.Сертификат, Элемент.Хранилище);
				СертификатНайден = (СертификатНайден = Истина); // СертификатНайден может содержать Неопределено вместо Ложь
				Если Не СертификатНайден Тогда
					ЕстьНеНайденныеСертификаты = Истина;
					Текст = Текст + Символы.ПС + СтрШаблон(НСтр("ru = 'Сертификат в хранилище %1 не установлен.'"), Элемент.Хранилище);
				КонецЕсли;
			КонецЦикла;
			РезультатОперации.Результат      = Не ЕстьНеНайденныеСертификаты;
			РезультатОперации.ОписаниеОшибки = Сред(Текст, 2);
		Исключение
			РезультатОперации.Результат      = Ложь;
			РезультатОперации.ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
	ИначеЕсли ЗначениеЗаполнено(Результат.ОписаниеОшибки) Тогда
		
		РезультатОперации.Результат      = Ложь;
		РезультатОперации.ОписаниеОшибки = Результат.ОписаниеОшибки;
		
	Иначе
		
		РезультатОперации.Результат      = Ложь;
		//@skip-check module-nstr-camelcase
		РезультатОперации.ОписаниеОшибки = НСтр("ru = 'Не удалось подключить внешнюю компоненту ExtraCryptoAPI.'");
		
	КонецЕсли;
	
	Если Контекст.ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОповещениеЗавершения, РезультатОперации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру результата операции
//
// Возвращаемое значение:
// 	Структура:
//   * Результат - Булево
//   * ОписаниеОшибки - Строка
//
Функция РезультатОперации()
	
	Возврат Новый Структура("Результат, ОписаниеОшибки", Ложь, "");
	
КонецФункции

Функция НовыйДоверенныйСертификат()
	
	Элемент = Новый Структура();
	Элемент.Вставить("Наименование", "");
	Элемент.Вставить("Хранилище", "");
	Элемент.Вставить("ДействителенДо", '00010101');
	Элемент.Вставить("Результат", Истина);
	Элемент.Вставить("ОписаниеОшибки", "");
	Элемент.Вставить("Сертификат", "");
	
	Возврат Элемент;
	
КонецФункции

Процедура НачатьПодключениеКомпонентыExtraCryptoAPI(Оповещение)
	
	// выполнить установку компоненты
	ИмяОбъекта = "ExtraCryptoAPI";
	ПолныйПуть = "Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Макет.КомпонентаExtraCryptoAPI";
	
	ПараметрыПодключения = ОбщегоНазначенияКлиент.ПараметрыПодключенияКомпоненты();
	ПараметрыПодключения.ТекстПояснения = СтрШаблон(
		НСтр("ru = 'Для упрощения работы с криптографией требуется установка внешней компоненты %1.'"),
		ИмяОбъекта);
	ПараметрыПодключения.ПредложитьУстановить = Истина;
	ПараметрыПодключения.ПредложитьЗагрузить = Ложь;
	
	ОбщегоНазначенияКлиент.ПодключитьКомпонентуИзМакета(Оповещение, 
		ИмяОбъекта, 
		ПолныйПуть,
		ПараметрыПодключения);
		
КонецПроцедуры

#КонецОбласти
