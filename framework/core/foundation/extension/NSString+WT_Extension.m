//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSString+WT_Extension.m
//  WTFramework
//

#import "NSString+WT_Extension.h"
#import "NSObject+WT_Extension.h"
#import "NSData+WT_Extension.h"

@implementation NSString (WT_Extension)

- (NSString *)MD5
{
    return [[self toData] MD5];
}

- (NSData *)MD5Data
{
    return [[self toData] MD5Data];
}

- (NSString *)SHA1
{
    return [[self toData] SHA1];
}

- (NSData *)SHA1Data
{
    return [[self toData] SHA1Data];
}

- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)unwrap
{
    if ( self.length >= 2 )
    {
        if ( [self hasPrefix:@"\""] && [self hasSuffix:@"\""] )
        {
            return [self substringWithRange:NSMakeRange(1, self.length - 2)];
        }
        
        if ( [self hasPrefix:@"'"] && [self hasSuffix:@"'"] )
        {
            return [self substringWithRange:NSMakeRange(1, self.length - 2)];
        }
    }
    
    return self;
}

- (NSString *)URLEncode
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]];
}

- (NSString *)URLDecode
{
    NSMutableString * string = [self mutableCopy];
    
    [string replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [string length])];
    
    return [string stringByRemovingPercentEncoding];
}

- (NSString *)base64Encode
{
    ///TODO:
    return nil;
}

- (NSString *)base64Decode
{
    ///TODO:
    return nil;
}



@end
