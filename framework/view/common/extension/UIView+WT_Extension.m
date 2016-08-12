//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  UIView+WT_Extension.m
//  WTFramework
//

#import "UIView+WT_Extension.h"

#undef	KEY_NAME
#define KEY_NAME "UIView.name"

@implementation UIView (WT_Extension)

- (NSString *)name
{
    return objc_getAssociatedObject( self, KEY_NAME );
}

- (void)setName:(NSString *)name
{
    objc_setAssociatedObject( self, KEY_NAME, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (__kindof UIView *)viewByName:(NSString *)value
{
    if ( nil == value )
        return nil;
    
    for ( UIView * subview in self.subviews )
    {
        if ( [subview.name isEqualToString:value] )
        {
            return subview;
        }
    }
    return nil;
}

@end
