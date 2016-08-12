//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSData+WT_Extension.m
//  WTFramework
//

#import "NSData+WT_Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (WT_Extension)

- (NSString *)MD5
{
    uint8_t	digest[CC_MD5_DIGEST_LENGTH + 1] = { 0 };
    
    CC_MD5( [self bytes], (CC_LONG)[self length], digest );
    
    char tmp[16] = { 0 };
    char hex[256] = { 0 };
    
    for ( CC_LONG i = 0; i < CC_MD5_DIGEST_LENGTH; ++i )
    {
        sprintf( tmp, "%02X", digest[i] );
        strcat( (char *)hex, tmp );
    }
    return [NSString stringWithUTF8String:(const char *)hex];
}

- (NSData *)MD5Data
{
    uint8_t	digest[CC_MD5_DIGEST_LENGTH + 1] = { 0 };
    
    CC_MD5( [self bytes], (CC_LONG)[self length], digest );
    
    return [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)SHA1
{
    uint8_t	digest[CC_SHA1_DIGEST_LENGTH + 1] = { 0 };
    
    CC_SHA1( self.bytes, (CC_LONG)self.length, digest );
    
    char tmp[16] = { 0 };
    char hex[256] = { 0 };
    
    for ( CC_LONG i = 0; i < CC_SHA1_DIGEST_LENGTH; ++i )
    {
        sprintf( tmp, "%02X", digest[i] );
        strcat( (char *)hex, tmp );
    }
    return [NSString stringWithUTF8String:(const char *)hex];
}

- (NSData *)SHA1Data
{
    uint8_t	digest[CC_SHA1_DIGEST_LENGTH + 1] = { 0 };
    
    CC_SHA1( self.bytes, (CC_LONG)self.length, digest );
    
    return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
}

@end
