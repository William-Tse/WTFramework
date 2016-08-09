//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Property.h
//  WTFramework
//

#import "WT_Property.h"

#import "NSObject+WT_Extension.h"
#import "NSArray+WT_Extension.h"
#import "NSString+WT_Extension.h"

#import "_pragma_push.h"

@implementation WTProperty

- (WTRuntimeType)runtimeType
{
    return [WTRuntime typeOfClass:self.clazz];
}

- (BOOL)isAtom
{
    return [WTRuntime isAtomClass:self.clazz];
}

@end


#pragma mark -

@implementation NSObject(WT_Property)

+ (const char *)attributesForProperty:(NSString *)property
{
    Class baseClass = [self baseClass];
    
    for ( Class clazzType = self; clazzType != baseClass; )
    {
        objc_property_t prop = class_getProperty( clazzType, [property UTF8String] );
        if ( prop )
        {
            return property_getAttributes( prop );
        }
        
        clazzType = class_getSuperclass( clazzType );
        if ( !clazzType )
            break;
    }
    return NULL;
}

- (const char *)attributesForProperty:(NSString *)property
{
    return [[self class] attributesForProperty:property];
}

- (id)getAssociatedObjectForKey:(const char *)key
{
    const char * propName = key; // [[NSString stringWithFormat:@"%@.%s", NSStringFromClass([self class]), key] UTF8String];
    
    id currValue = objc_getAssociatedObject( self, propName );
    return currValue;
}

- (id)copyAssociatedObject:(id)obj forKey:(const char *)key
{
    const char * propName = key; // [[NSString stringWithFormat:@"%@.%s", NSStringFromClass([self class]), key] UTF8String];
    
    id oldValue = objc_getAssociatedObject( self, propName );
    objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_COPY );
    return oldValue;
}

- (id)retainAssociatedObject:(id)obj forKey:(const char *)key;
{
    const char * propName = key; // [[NSString stringWithFormat:@"%@.%s", NSStringFromClass([self class]), key] UTF8String];
    
    id oldValue = objc_getAssociatedObject( self, propName );
    objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    return oldValue;
}

- (id)assignAssociatedObject:(id)obj forKey:(const char *)key
{
    const char * propName = key; // [[NSString stringWithFormat:@"%@.%s", NSStringFromClass([self class]), key] UTF8String];
    
    id oldValue = objc_getAssociatedObject( self, propName );
    objc_setAssociatedObject( self, propName, obj, OBJC_ASSOCIATION_ASSIGN );
    return oldValue;
}

- (void)removeAssociatedObjectForKey:(const char *)key
{
    const char * propName = key; // [[NSString stringWithFormat:@"%@.%s", NSStringFromClass([self class]), key] UTF8String];
    
    objc_setAssociatedObject( self, propName, nil, OBJC_ASSOCIATION_ASSIGN );
}

- (void)removeAllAssociatedObjects
{
    objc_removeAssociatedObjects( self );
}

@end

#import "_pragma_pop.h"
