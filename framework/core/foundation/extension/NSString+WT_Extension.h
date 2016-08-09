//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSString+WT_Extension.h
//  WTFramework
//

#import "WT_Precompile.h"
#import "WT_Generic.h"

@interface NSString (WT_Extension)

@property (nonatomic, copy, readonly) NSString *MD5;
@property (nonatomic, copy, readonly) NSData *MD5Data;

@property (nonatomic, copy, readonly) NSString *SHA1;
@property (nonatomic, copy, readonly) NSData *SHA1Data;

- (NSString *)trim;
- (NSString *)unwrap;

- (NSString *)URLEncode;
- (NSString *)URLDecode;

- (NSString *)base64Encode;
- (NSString *)base64Decode;

@end
