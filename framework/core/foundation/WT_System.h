//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_System.h
//  WTFramework
//

#import "WT_Precompile.h"
#import "NSObject+WT_Extension.h"

#define VersionCompare(version1, version2) ({\
NSArray *arrV1 = [version1 componentsSeparatedByString:@"."];\
NSArray *arrV2 = [version2 componentsSeparatedByString:@"."];\
BOOL success = NO;\
NSComparisonResult result = NSOrderedSame;\
for( int i=0; i<arrV1.count; i++){\
    int v1 = [[arrV1 objectAtIndex:i] intValue];\
    if(arrV2.count>i){\
        int v2 = [[arrV2 objectAtIndex:i] intValue];\
        if(v1>v2){\
            result = 1; success = YES; break;\
        }else if(v1<v2){\
            result = -1; success = YES; break;\
        }\
    } else if(v1>0){\
        result = 1; success = YES; break;\
    }\
}\
if(!success && arrV2.count>arrV1.count){\
    result = -1;\
}\
result;\
})


@interface WTSystem : NSObject

+ (NSString *)osVersion;
+ (BOOL)isVersionEqualOrLaterThan:(NSString *)version;
+ (BOOL)isVersionEqualOrEarlierThan:(NSString *)version;

+ (NSString *)appName;
+ (NSString *)appBundleName;
+ (NSString *)appVersion;
+ (NSString *)appShortVersion;
+ (NSString *)appIdentifier;

+ (NSString *)deviceModel;
+ (NSString *)deviceUUID;
+ (CGSize)deviceScreenSize;
+ (BOOL)isDeviceScreenSizeSmallerThan:(CGSize)size;
+ (BOOL)isDeviceScreenSizeBiggerThan:(CGSize)size;
+ (BOOL)isDeviceScreenSizeEqualTo:(CGSize)size;
+ (BOOL)isDevicePhone;
+ (BOOL)isDevicePad;

+ (CGSize)screenSize;

@end
