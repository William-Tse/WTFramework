//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSDate+WT_Extension.m
//  WTFramework
//

#import "NSDate+WT_Extension.h"


@implementation NSDate(WT_Extension)

- (NSInteger)year
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self].year;
}

- (NSInteger)month
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self].month;
}

- (NSInteger)day
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self].day;
}

- (NSInteger)hour
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self].hour;
}

- (NSInteger)minute
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self].minute;
}

- (NSInteger)second
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self].second;
}

- (NSInteger)weekday
{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self].weekday-1;
}

#pragma mark -

+ (instancetype)dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day, ...
{
    NSUInteger hour = 0, minute = 0, second = 0, millisecond = 0, zone = 0;
    
    va_list components;
    va_start(components, day);
    for (NSInteger i=0; i<=5; ++i) {
        NSNumber *value =  va_arg( components, NSNumber * );
        if(i==0)
            continue;
        if(!value)
            break;
        
        switch (i) {
            case 1:
                hour = [value unsignedIntegerValue];
                break;
            case 2:
                minute = [value unsignedIntegerValue];
            case 3:
                second = [value unsignedIntegerValue];
                break;
            case 4:
                millisecond = [value unsignedIntegerValue];
            case 5:
                zone = [value unsignedIntegerValue];
            default:
                break;
        }
    }
    va_end(components);
    
    if(year<1970)
        year = 1970;
    
    if(month<1)
        month = 1;
    else if(month>12)
        month = 12;
    
    NSInteger maxDay = [self daysByYear:year month:month];
    if(day<1)
        day = maxDay;
    else if(day>maxDay)
        day = maxDay;
    
    if(hour>59)
        hour = 59;
    if(minute>59)
        minute = 59;
    if(second>59)
        second = 59;
    
    if(millisecond>999){
        NSString *strMillisecond = [NSString stringWithFormat:@"%ld", (long)millisecond];
        millisecond = [[strMillisecond substringToIndex:2] integerValue];
    }
    
    if(zone>=24*60*60)
        zone = 24*60*60-1;
    
    NSString *strDate = [NSString stringWithFormat:@"%4ld-%2ld-%2ld %2ld:%2ld:%2ld %3ld", (long)year, (long)month, (long)day, (long)hour, (long)minute, (long)second, (long)millisecond];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:zone]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss SSS"];
    return [formatter dateFromString:strDate];
}

+ (instancetype)dateWithString:(nonnull NSString *)str
{
    NSInteger year = 0, month = 0, day = 0, hour = 0, minute = 0, second = 0, millisecond = 0, zone = 0;
    
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"(\\d{4})(\\-|\\/)(\\d{1,2})(\\-|\\/)(\\d{1,2})([\\sT](\\d{1,2}):(\\d{1,2}):(\\d{1,2}))?([\\s\\.](\\d+))?(\\+(\\d{1,2})(:(\\d{1,2}))?)?" options:0 error:nil];
    
    NSTextCheckingResult *result = [regexp firstMatchInString:str options:0 range:NSMakeRange(0, str.length)];
    if(result)
    {
        year = [[str substringWithRange:[result rangeAtIndex:1]] integerValue];
        month = [[str substringWithRange:[result rangeAtIndex:3]] integerValue];
        day = [[str substringWithRange:[result rangeAtIndex:5]] integerValue];
        hour = [[str substringWithRange:[result rangeAtIndex:7]] integerValue];
        minute = [[str substringWithRange:[result rangeAtIndex:8]] integerValue];
        second = [[str substringWithRange:[result rangeAtIndex:9]] integerValue];
        millisecond = [[str substringWithRange:[result rangeAtIndex:11]] integerValue];
        NSInteger zoneHour = [[str substringWithRange:[result rangeAtIndex:13]] integerValue];
        NSInteger zoneMinite = [[str substringWithRange:[result rangeAtIndex:15]] integerValue];
        zone = zoneHour*60*60+zoneMinite*60;
    }
    
    return [self dateWithYear:year month:month day:day, hour, minute, second, millisecond, zone];
}

+ (NSInteger)daysByYear:(NSInteger)year month:(NSInteger)month
{
    switch (month) {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            return 31;
        case 4:
        case 6:
        case 9:
        case 11:
            return 30;
        case 2:
            if(year % 4){
                return 28;
            }else{
                if(year % 100){
                    return 29;
                }else{
                    if(year % 400){
                        return 28;
                    }else{
                        return 29;
                    }
                }
            }
        default:
            return 0;
    }
}

#pragma mark -

- (instancetype)local
{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:self];
    return [self dateByAddingTimeInterval:interval];
}

- (NSString *)stringWithFormat:(NSString *)format
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)toString:(NSString *)format
{
    return [self toString:format timeZoneGMT:[[NSTimeZone defaultTimeZone] secondsFromGMT]];
}

- (NSString *)toString:(NSString *)format timeZoneGMT:(NSInteger)seconds
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:seconds]];
    
    return [formatter stringFromDate:self];
}

- (NSString *)toString:(NSString *)format timeZoneName:(NSString *)name
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:name]];
    
    return [formatter stringFromDate:self];
}

@end

