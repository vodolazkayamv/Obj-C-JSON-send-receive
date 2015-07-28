//
//  UPUtility.m
//  SBK
//
//  Created by Pavel Akhrameev on 18.10.13.
//  Copyright (c) 2013 Asteros. All rights reserved.
//

#import "UPUtility.h"

#import <AudioToolbox/AudioToolbox.h>



@implementation UPUtility


+ (NSDateFormatter *) shortDateFormatter			// "2012-01-16",
{
	static NSDateFormatter *df = nil;
	if (!df) {
		df = [[NSDateFormatter alloc] init];
		[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*4]];
		[df setDateFormat:@"YYYY-MM-dd"];
	}
	return df;
}

+ (NSDateFormatter *) longDateFormatter				// "2011-03-23T14:21:55.000"
{
	static NSDateFormatter *ldf = nil;
	if (!ldf) {
		ldf = [[NSDateFormatter alloc] init];
		[ldf setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*4]];
		[ldf setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSS"];
	}
	return ldf;
}

+ (NSDateFormatter *) iWishServerDateFormatter		// "2014-11-07T06:10:45.449Z"
{
	static NSDateFormatter *idf = nil;
	if (!idf) {
		idf = [[NSDateFormatter alloc] init];
		[idf setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
		[idf setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	}
	return idf;

}

+ (NSDate *) dateFromTimestamp:(NSString *)timestamp
{
	NSTimeInterval ts = [timestamp doubleValue] / 1000.0;
	if (ts < 1.0) return nil;
	NSDate *retValue = [NSDate dateWithTimeIntervalSince1970:ts];
	//	DLog(@"timestamp = %@ ts = %.3f retValue = %@", timestamp, ts, retValue);
	return retValue;
}

+ (NSString *) formatMoneyData:(NSNumber *)money
{
	static NSNumberFormatter *moneyFormatter = nil;
	if (!moneyFormatter) {
		moneyFormatter = [[NSNumberFormatter alloc] init];
		// Для формирования денежного представления используется стандартный DecimalStyle!
		[moneyFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	}
	return [moneyFormatter stringFromNumber:money];
}

// Простановка точек в номере счета в соответствии с обычаями СБ
+ (NSString *) pinpointAccountNumber:(NSString *)account
{
    if (!account)
        DLog(@"WARNING! pinpointAccountNumber with nil!");
	NSInteger accountLength = [account length];
	if (accountLength != 20) return account;
	NSRange r = NSMakeRange(0, 5);
	NSString *part1 = [account substringWithRange:r];
	r = NSMakeRange(5, 3);
	NSString *part2 = [account substringWithRange:r];
	r = NSMakeRange(8, 1);
	NSString *part3 = [account substringWithRange:r];
	NSString *remainder = [account substringFromIndex:9];
	return [NSString stringWithFormat:@"%@.%@.%@.%@",part1, part2, part3,remainder];
}


+ (NSString *) displayStrFromDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd.MM.YYYY"];
    return [df stringFromDate:date];
}

+ (NSString *)displayStrWithTimeFromDate:(NSDate *)date
{
    static NSDateFormatter *tdf = nil;
	if (!tdf) {
        tdf = [[NSDateFormatter alloc] init];
        [tdf setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:3600*4]];
        [tdf setDateFormat:@"yyyy-MM-dd' 'HH:mm:ss"];
	}
    return [tdf stringFromDate:date];
}

+ (NSDate *) decodeJsonDateString:(NSString *)inpString
{
	static NSDateFormatter *fullDF = nil;
	if (!fullDF) {
		fullDF = [[NSDateFormatter alloc] init];
		// "2014-10-20T07:45:05.220Z",
		[fullDF setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSz"];
	}
	return [fullDF dateFromString:inpString];
}


+ (NSString *) russianStringFromDate:(NSDate *)aDate
{
	static NSDateFormatter *rusDateFormatter = nil;
	if (!rusDateFormatter) {
		rusDateFormatter = [[NSDateFormatter alloc] init];
		[rusDateFormatter setDateFormat:@"dd.MM.YYYY"];
	}
	return [rusDateFormatter stringFromDate:aDate];
}

+ (NSString *) russianStringFromDateWithSlash:(NSDate *) aDate
{
	static NSDateFormatter *rusDateFormatter = nil;
	if (!rusDateFormatter) {
		rusDateFormatter = [[NSDateFormatter alloc] init];
		[rusDateFormatter setDateFormat:@"dd/MM/YYYY"];
	}
	return [rusDateFormatter stringFromDate:aDate];
}

+ (NSDate *) russianDateFromString:(NSString *)string
{
	static NSDateFormatter *rusDateFormatter = nil;
	if (!rusDateFormatter) {
		rusDateFormatter = [[NSDateFormatter alloc] init];
		[rusDateFormatter setDateFormat:@"dd.MM.yyyy"];
	}
	return [rusDateFormatter dateFromString:string];
}

+ (NSString *)moneyFormatWithRank:(id)number
{
    float floatValue = [number floatValue];
    
    static NSNumberFormatter *formatterWithRank = nil;
	if (!formatterWithRank) {
        formatterWithRank = [[NSNumberFormatter alloc] init];
        [formatterWithRank setGroupingSeparator:@" "];
        [formatterWithRank setDecimalSeparator:@","];
        [formatterWithRank setGroupingSize:3];
        [formatterWithRank setUsesGroupingSeparator:YES];
        formatterWithRank.maximumFractionDigits = 2;
        formatterWithRank.minimumFractionDigits = 2;
        [formatterWithRank setZeroSymbol:@"0,00"];
    }
    return [formatterWithRank stringFromNumber:[NSNumber numberWithFloat:floatValue]];
}

+ (NSString *)moneyFormatWithoutCents:(id)number
{
    float floatValue = [number floatValue];
    
    static NSNumberFormatter *formatterWithRank = nil;
	if (!formatterWithRank) {
        formatterWithRank = [[NSNumberFormatter alloc] init];
        [formatterWithRank setGroupingSeparator:@" "];
        [formatterWithRank setDecimalSeparator:@","];
        [formatterWithRank setGroupingSize:3];
        [formatterWithRank setUsesGroupingSeparator:YES];
        formatterWithRank.maximumFractionDigits = 0;
        formatterWithRank.minimumFractionDigits = 0;
        [formatterWithRank setZeroSymbol:@"0,00"];
    }
    return [formatterWithRank stringFromNumber:[NSNumber numberWithFloat:floatValue]];
}


#pragma mark EasterEgg

+ (NSArray *) easterEggs
{
	static NSArray *__easterEggsArray = nil;
	if (__easterEggsArray) {
		return __easterEggsArray;
	}
	// формат : @(код яйца) @(включен) @(дата начала) @(месяц ачала) @(дата конца) @(месяц конца) @"картинка" @"альтернативная картинка"...
	__easterEggsArray = @[ @[ @(ChristmassEasterEgg),		@(YES), @(20), @(12), @(10), @(1), @"VENSnowFlake.png"],
						   @[ @(SpringEasterEgg),			@(YES), @(3), @(03), @(10), @(3), @"VENCherryBlossomDARK.png", @"VENCherryBlossomLIGHT.png"],
						   @[ @(LabourDayEasterEgg),		@(YES),  @(28), @(4), @(6), @(5), @"VENDandelionParticle.png"],
						   @[ @(VictoryDayEasterEgg),		@(NO),  @(7), @(5), @(10), @(5), @"victory.png"],
						   @[ @(IndependenceDayEasterEgg),	@(YES), @(9), @(6), @(15), @(6), @"VENRussianFlag.png", @"VENDandelionParticle.png"],
						   @[ @(KnowledgeDayEasterEgg),		@(YES),	@(28), @(8), @(3), @(9),
																@"VENMapleLeafYELLOW.png", @"VENMapleLeafRED.png"],
						   @[ @(SusaninDayEasterEgg),		@(YES), @(2), @(11), @(10), @(11), @"VENMapleLeafRED.png",
																@"VENMapleLeafYELLOW.png", @"VENMapleLeafORANGE.png"],
						   
						   ];
	return __easterEggsArray;
}

+ (BOOL)checkEasterEgg
{
	return ([UPUtility currentEasterEgg] != NoEasterEgg);
}



+ (EASTER_EGGS) currentEasterEgg
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger components = (NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear);
    
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComponents = [calendar components:components fromDate:currentDate];
    
    NSDateFormatter *checkFormatter = [[NSDateFormatter alloc] init] ;
    [checkFormatter setDateFormat:@"dd.MM.yyyy"];
	
    NSString *currentDayStr = [NSString stringWithFormat:@"%d.%d.%d",(int)currentComponents.day,(int)currentComponents.month,(int)currentComponents.year];
    currentDate = [checkFormatter dateFromString:currentDayStr];
	
	for (NSArray *easterRecord in [UPUtility easterEggs ]) {
		if ([[easterRecord objectAtIndex:1] boolValue]) {
			NSInteger earlyDay = [[easterRecord objectAtIndex:2] integerValue];
			NSInteger earlyMonth = [[easterRecord objectAtIndex:3] integerValue];
			NSInteger laterDay = [[easterRecord objectAtIndex:4] integerValue];
			NSInteger laterMonth = [[easterRecord objectAtIndex:5] integerValue];
			
			NSInteger year = (int)currentComponents.year;
			NSString *lowerLimitStr = [NSString stringWithFormat:@"%ld.%ld.%ldl",(long)earlyDay,(long)earlyMonth,(long)year];
			NSDate *lowerLimitDay = [checkFormatter dateFromString:lowerLimitStr];
			
			// Необходимо учесть, что новогоднее яйцо переваливает за границу текущего года
			if (laterMonth < earlyMonth) {
				year++;
			}
			
			NSString *upperLimitStr = [NSString stringWithFormat:@"%d.%d.%d",(int)laterDay,(int)laterMonth,(int)year];
			NSDate *upperLimitDay = [checkFormatter dateFromString:upperLimitStr];
			
			if (([currentDate laterDate:lowerLimitDay] == currentDate) && ([currentDate earlierDate:upperLimitDay] == currentDate)) {
				return (EASTER_EGGS)[[easterRecord objectAtIndex:0] integerValue];
			}
		}
	}
	return NoEasterEgg;
}

+ (NSArray *) imagesForEasterEgg:(EASTER_EGGS) easterEgg
{
	for (NSArray *easterRecord in [UPUtility easterEggs]) {
		NSInteger code = [[easterRecord objectAtIndex:0] integerValue];
		if (code == easterEgg) {
			NSInteger count = [easterRecord count];
			if (count > 6) {
				// да, в данной записи есть элементы, соответствующие картинкам
				NSMutableArray *result = [[NSMutableArray alloc] initWithArray:easterRecord copyItems:YES];
				// первые шесть элементов нам не нужны
				NSRange range = NSMakeRange(0, 6);
				[result removeObjectsInRange:range];
				DLog(@"result = %@",result);
				return [NSArray arrayWithArray:result];
			}
		}
	}
	return nil;
}

+ (NSString *)boldFontFromFamily:(NSArray *)fonts
{
    NSString *boldFont = nil;
    for (NSString *font in fonts) {
        if([font rangeOfString:@"Bold"].length > 0 && [font rangeOfString:@"Italic"].location == NSNotFound)
            boldFont = font;
    }
    if (!boldFont)
        boldFont = fonts[0];
    return boldFont;
}

+ (NSString *)fontNameRegular
{
    return @"OpenSans";
}

+ (NSString *)fontNameLight
{
    return @"OpenSans-Light";
}

+ (NSString *)fontNameBold
{
    return @"OpenSans-Semibold";
}

+ (NSNumber *)numberFronString:(NSString *)string
{
    NSNumberFormatter * fNumber = [[NSNumberFormatter alloc] init];
    [fNumber setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * number = [fNumber numberFromString:string];
    if (!number) {
        double val = [string doubleValue];
        if (val) {
            return @(val);
        }
    }
    return number;
}


+ (void) ASTbeep
{
#if AST_DUMP_LOADER
}
#else

    static SystemSoundID soundID;
	if (!soundID) {
		NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"alert" ofType:@"mp3"];
		AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
	}
    AudioServicesPlaySystemSound (soundID);
}
#endif


+ (NSString *) demoFile:(NSString *)fileNameWithoutExtension
{
	NSError *error = nil;
	NSString* text = [[NSString alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: fileNameWithoutExtension ofType: @"xml"]
													  encoding:NSUTF8StringEncoding
														 error:&error ];
	if (error) {
		DLog(@"Не могу достать строку из файла %@ ===> %@", fileNameWithoutExtension, [error localizedDescription]);
		return @"";
	}
	return text;
}

+ (BOOL)needToBeAligned:(NSString *)string{
    
    // проверка на то что только цифры или счет

    NSString *expression = @"^[0-9\\-,.  ]+$";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:nil];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string
                                                        options:0
                                                          range:NSMakeRange(0, [string length])];
    if (numberOfMatches != 0)
        return NO;
    
    return YES;
}

@end