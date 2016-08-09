//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  UIImage+WT_Extension.h
//  WTFramework
//

#import "WT_Precompile.h"

#undef	__IMAGE
#define __IMAGE( __name )	[UIImage imageNamed:__name]

#pragma mark -

@interface UIImage(WT_Extension)

- (UIImage *)imageInRect:(CGRect)rect;

+ (UIImage *)imageFromString:(NSString *)name;
+ (UIImage *)imageFromString:(NSString *)name atPath:(NSString *)path;
+ (UIImage *)imageFromString:(NSString *)name stretched:(UIEdgeInsets)capInsets;

- (NSData *)dataWithExt:(NSString *)ext;

- (UIImage *)fixOrientation;

@end
