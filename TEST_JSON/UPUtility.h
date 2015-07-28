//
//  UPUtility.h
//  SBK
//
//  Created by Pavel Akhrameev on 18.10.13.
//  Copyright (c) 2013 Asteros. All rights reserved.
//

#import <Foundation/Foundation.h>


//
// Сервисные макросы для вывода отладочной информации с указанием класса, метода и номера строки
// См. http://stackoverflow.com/questions/969130/how-to-print-out-the-method-name-and-line-number-and-conditionally-disable-NSLog
//

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#   define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

// Вывод отладочной информации в UIAlert.
//#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
//#else
//#   define ULog(...)
//#endif

/**
 RStr - Resource String
 Provides localized string from default localization storage
 */
#define RStr(name) NSLocalizedString(name, name)


#define UIColorFromRGB(rgbValue) \
		[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
				green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
				blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
				alpha:1.0]



#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@interface UPUtility : NSObject


+ (NSDateFormatter *) shortDateFormatter;					// "2012-01-16",
+ (NSDateFormatter *) longDateFormatter;					// "2011-03-23T14:21:55.000"
+ (NSDateFormatter *) iWishServerDateFormatter;				// "2014-11-07T06:10:45.449Z"

// Формирование даты из текстового представления timestamp, отсчитываемого от начала эры Unix
+ (NSDate *)dateFromTimestamp:(NSString *)timestamp;

// Форматирование числа как денежной суммы с запятыми и разделителями
+ (NSString *)formatMoneyData:(NSNumber *)money;

// Точечное форматирование счета для его удобчитаемости
// Простановка точек в номере счета в соответствии с обычаями СБ
+ (NSString *)pinpointAccountNumber:(NSString *)account;


// Возваращает строку для отображения в UI c форматом - shortDateFormatter
+ (NSString *)displayStrFromDate:(NSDate *)date;

// Возваращает строку для отображения в UI c форматом - "2011-03-23T14:21:55"
+ (NSString *)displayStrWithTimeFromDate:(NSDate *)date;

+ (NSString *) russianStringFromDate:(NSDate *)aDate;				// "31.06.2013"
+ (NSString *) russianStringFromDateWithSlash:(NSDate *) aDate;		// "31/06/2014"

+ (NSDate *) russianDateFromString:(NSString *)string; // "31.06.2013"

+ (NSString *)moneyFormatWithRank:(id)number; // 100 000,00 handle NSString and NSNumber
+ (NSString *)moneyFormatWithoutCents:(id)number;// 100 000 handle NSString and NSNumber


+ (BOOL)checkEasterEgg;		// Врзвращает YES если для текущей даты нужно показывать яйцо

+ (NSString *)boldFontFromFamily:(NSArray *)fonts; //Возвращает Bold Font из заданной группы шрифтов, если не находит то возвращает первый

+ (NSString *)fontNameRegular; // Возвращает Regular шрифт из используемого семейства шрифтов

+ (NSString *)fontNameLight; // Возвращает Light шрифт из используемого семейства шрифтов

+ (NSString *)fontNameBold; // Возвращает Bold  шрифт из используемого семейства шрифтов

typedef enum {
	NoEasterEgg = -1,						// яйца нет
	ChristmassEasterEgg,					// Новый Год						- 20.12	-- 10.01
	SpringEasterEgg,						// 8 Марта близко близко			- 03.03 -- 10.03
	LabourDayEasterEgg,						// День дачника						- 28.04 -- 06.05
	VictoryDayEasterEgg,					// День Победы						- 07.05 -- 10.05
	IndependenceDayEasterEgg,				// День независимости от Украины	- 09.06 -- 15.06
	KnowledgeDayEasterEgg,					// День знаний						- 28.08 -- 03.09
	SusaninDayEasterEgg,					// Годовщина Октябрьской революции	- 02.11 -- 10.11
} EASTER_EGGS;

+ (EASTER_EGGS) currentEasterEgg;			// Код пасхального яйца для текущей даты

+ (NSArray *) imagesForEasterEgg:(EASTER_EGGS) easterEgg;	// массив с именами файлов картинок для выбранного яйца

+ (NSNumber *)numberFronString:(NSString *)string;

+ (void) ASTbeep;		// вывод предупреждающего сигнала при неверном нажатии енописьки

// Декодирование строкового представления даты
+ (NSDate *) decodeJsonDateString:(NSString *)inpString;

//
// Возвращает строку, содержащую содержимое текстового файла в XMLформате (с расширением XML)
// Используется для загрузки содержимого демонмстрационных версий отчетов вместо обращения к серверу
// в демо-режиме. 
//
+ (NSString *) demoFile:(NSString *)fileNameWithoutExtension;

// Проверяем чем является входная строка, и если это значение отличное от числа и даты, выравниваем это значение по левому краю
+ (BOOL)needToBeAligned:(NSString *)aString;


@end
