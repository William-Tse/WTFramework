//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_System.m
//  WTFramework
//

#import "WT_System.h"


@implementation WTSystem

+ (NSString *)osVersion
{
    return [NSString stringWithFormat:@"%@ %@", [UIDevice currentDevice].systemName, [UIDevice currentDevice].systemVersion];
}

+ (BOOL)isVersionEqualOrLaterThan:(NSString *)version
{
    return VersionCompare([UIDevice currentDevice].systemVersion, version)>=0;
}

+ (BOOL)isVersionEqualOrEarlierThan:(NSString *)version
{
    return VersionCompare([UIDevice currentDevice].systemVersion, version)<=0;
}

+ (NSString *)appName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}

+ (NSString *)appBundleName
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

+ (NSString *)appVersion
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}

+ (NSString *)appShortVersion
{
	return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appIdentifier
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}

+ (NSString *)deviceModel
{
	return [UIDevice currentDevice].model;
}

+ (NSString *)deviceUUID
{
    //TODO:
	return nil;
}

+ (CGSize)deviceScreenSize
{
    return [UIScreen mainScreen].currentMode.size;
}

+ (BOOL)isDeviceScreenSizeEqualTo:(CGSize)size
{
    CGSize size2 = CGSizeMake( size.height, size.width );
    CGSize screenSize = [self deviceScreenSize];
    
    if ( CGSizeEqualToSize(size, screenSize) || CGSizeEqualToSize(size2, screenSize) )
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isDeviceScreenSizeSmallerThan:(CGSize)size
{
    CGSize size2 = CGSizeMake( size.height, size.width );
    CGSize screenSize = [self deviceScreenSize];
    
    if ( (size.width > screenSize.width && size.height > screenSize.height) ||
        (size2.width > screenSize.width && size2.height > screenSize.height) )
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isDeviceScreenSizeBiggerThan:(CGSize)size
{
    CGSize size2 = CGSizeMake( size.height, size.width );
    CGSize screenSize = [self deviceScreenSize];
    
    if ( (size.width < screenSize.width && size.height < screenSize.height) ||
        (size2.width < screenSize.width && size2.height < screenSize.height) )
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isDevicePhone
{
	NSString * deviceModel = [self deviceModel];
	if ( [deviceModel rangeOfString:@"iPhone" options:NSCaseInsensitiveSearch].length > 0 ||
		[deviceModel rangeOfString:@"iPod" options:NSCaseInsensitiveSearch].length > 0 ||
		[deviceModel rangeOfString:@"iTouch" options:NSCaseInsensitiveSearch].length > 0 )
	{
		return YES;
	}
	return NO;
}

+ (BOOL)isDevicePad
{
    NSString * deviceModel = [self deviceModel];
	if ( [deviceModel rangeOfString:@"iPad" options:NSCaseInsensitiveSearch].length > 0 )
	{
		return YES;
	}
	return NO;
}

+ (CGSize)screenSize
{
    return [UIScreen mainScreen].bounds.size;
}

@end
