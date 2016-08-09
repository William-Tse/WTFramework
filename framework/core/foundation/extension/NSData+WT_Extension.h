//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSData+WT_Extension.h
//  WTFramework
//

#import "WT_Precompile.h"
#import "WT_Generic.h"

@interface NSData (WT_Extension)

@property (nonatomic, copy, readonly) NSString *MD5;
@property (nonatomic, copy, readonly) NSData *MD5Data;

@property (nonatomic, copy, readonly) NSString *SHA1;
@property (nonatomic, copy, readonly) NSData *SHA1Data;

@end
