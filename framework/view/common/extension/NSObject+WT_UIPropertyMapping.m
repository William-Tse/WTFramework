//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  NSObject+WT_UIPropertyMapping.m
//  WTFramework
//
#import "NSObject+WT_UIPropertyMapping.h"
#import "WT_Runtime.h"
#import "UIView+WT_Extension.h"

@implementation NSObject(WT_UIPropertyMapping)

- (void)mapPropertiesFromView:(UIView *)view
{
    for ( UIView * subview in view.subviews )
    {
        NSString * name = subview.name;
        if ( nil == name || !name.length )
            continue;
        
        NSString * propertyName = name;
        propertyName = [propertyName stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        propertyName = [propertyName stringByReplacingOccurrencesOfString:@"." withString:@"_"];
        propertyName = [propertyName stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
        
        objc_property_t property = class_getProperty( [self class], [propertyName UTF8String] );
        if ( property )
        {
            const char *	attr = property_getAttributes( property );
            WTRuntimeType		type = [WTRuntime typeOfAttribute:attr];
            
            if ( WTRuntimeTypeObject == type )
            {
                NSString * attrClassName = [WTRuntime classNameOfAttribute:attr];
                if ( attrClassName )
                {
                    Class class = NSClassFromString( attrClassName );
                    if ( class && ([class isSubclassOfClass:[UIView class]] || [class isSubclassOfClass:[UIViewController class]]) )
                    {
                        [self setValue:subview forKey:propertyName];
                    }
                }
            }
            
//            if ( [subview isContainable] )
//            {
//                [self mapPropertiesFromView:subview];
//            }
        }
    }
}

@end
