﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Возвращает группы основных средств, которые относятся к недвижимому имуществу 
// (прежде всего, для исчисления налога на имущество).
// 
// Возвращаемое значение:
//	Массив - Содержит перечень групп ОС, относящихся к недвижимому имуществу.
//
Функция НедвижимоеИмущество() Экспорт
	
	НедвижимоеИмущество = Новый Массив;
	
	НедвижимоеИмущество.Добавить(Перечисления.ГруппыОС.Здания);
	НедвижимоеИмущество.Добавить(Перечисления.ГруппыОС.Сооружения);
	НедвижимоеИмущество.Добавить(Перечисления.ГруппыОС.МноголетниеНасаждения);
	НедвижимоеИмущество.Добавить(Перечисления.ГруппыОС.ПрочееИмуществоТребующееГосударственнойРегистрации);
	
	Возврат НедвижимоеИмущество;
	
КонецФункции

#КонецЕсли
