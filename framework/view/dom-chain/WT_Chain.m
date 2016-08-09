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

#import "WT_Chain.h"

@implementation WTChain

+ (id (^)(id))createImageBlockWithView:(UIView *)view action:(void (^)(UIImage *))action
{
    return ^id(id image){
        
        UIImage *img;
        if([image isKindOfClass:[NSString class]])
        {
            img = [UIImage imageFromString:image];
        }
        else if([image isKindOfClass:[UIImage class]])
        {
            img = image;
        }
        
        action(img);
        return view;
    };
}

+ (id (^)(id))createColorBlockWithView:(UIView *)view action:(void (^)(UIColor *))action
{
    return ^id(id color){
        
        UIColor *c;
        if([color isKindOfClass:[NSString class]])
        {
            c = [UIColor colorWithString:color];
        }
        else if([color isKindOfClass:[UIColor class]])
        {
            c = color;
        }
        
        action(c);
        return view;
    };
}

+ (id (^)(CGFloat, BOOL))createFontBlockWithView:(UIView *)view action:(void (^)(UIFont *))action
{
    id block = ^id(CGFloat size, BOOL bold){
        
        action(bold ? [UIFont boldSystemFontOfSize:size] : [UIFont systemFontOfSize:size]);
        return view;
    };
    return block;
}

@end