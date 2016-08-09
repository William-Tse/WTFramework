//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Chain.h
//  WTFramework
//

#import "WT_Precompile.h"

#import "UIColor+WT_Extension.h"
#import "UIImage+WT_Extension.h"

#define TEXT_INSETS(...) __TEXT_INSETS(MASBoxValue((__VA_ARGS__)))
#define IMAGE_INSETS(...) __IMAGE_INSETS(MASBoxValue((__VA_ARGS__)))
#define SECTION_INSET(...) __SECTION_INSET(MASBoxValue((__VA_ARGS__)))
#define ITEM_SIZE(...) __ITEM_SIZE(MASBoxValue((__VA_ARGS__)))

@interface WTChain : NSObject

+ (id (^)(id))createImageBlockWithView:(UIView *)view action:(void (^)(UIImage *))action;
+ (id (^)(id))createColorBlockWithView:(UIView *)view action:(void (^)(UIColor *))action;
+ (id (^)(CGFloat, BOOL))createFontBlockWithView:(UIView *)view action:(void (^)(UIFont *))action;

@end