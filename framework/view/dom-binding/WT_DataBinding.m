//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  WT_DataBinding.m
//  WTFramework
//

#import "WT_DataBinding.h"

#undef	KEY_DATA
#define KEY_DATA	"UIView.data"

@implementation UIView (WT_DataBinding)

@dynamic data;

- (id)data
{
    return objc_getAssociatedObject( self, KEY_DATA );
}

- (void)setData:(id)data
{
    [self bindData:data];
}

- (void)bindData:(id)data
{
    objc_setAssociatedObject( self, KEY_DATA, data, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
}

- (void)unbindData
{
    [self setData:nil];
}

@end
