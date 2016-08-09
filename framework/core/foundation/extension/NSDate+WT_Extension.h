//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSDate+WT_Extension.h
//  WTFramework
//

#import "WT_Precompile.h"

@interface NSDate(WT_Extension)

@property (nonatomic, assign, readonly) NSInteger year;
@property (nonatomic, assign, readonly) NSInteger month;
@property (nonatomic, assign, readonly) NSInteger day;
@property (nonatomic, assign, readonly) NSInteger hour;
@property (nonatomic, assign, readonly) NSInteger minute;
@property (nonatomic, assign, readonly) NSInteger second;
@property (nonatomic, assign, readonly) NSInteger weekday;

#pragma mark -

/*!
 * datetime from year,month,day,hour,minute,second,millisecond
 */
+ (instancetype)dateWithYear:(NSUInteger)year month:(NSUInteger)month day:(NSUInteger)day, ...;

/*!
 * datetime from string with format "yyyy-MM-dd HH:mm:ss SSS z"
 */
+ (instancetype)dateWithString:(NSString *)str;

#pragma mark -

/*!
 * datetime on current time zone
 */
- (instancetype)local;

/*!
 * convert datetime to string with format
 */
- (NSString *)toString:(NSString *)format;
- (NSString *)toString:(NSString *)format timeZoneGMT:(NSInteger)hours;
- (NSString *)toString:(NSString *)format timeZoneName:(NSString *)name;

@end
