//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Runtime.m
//  WTFramework
//

#import "WT_Runtime.h"
#import "WT_ArrayList.h"

@implementation WTRuntime

+ (BOOL)isReadOnly:(const char *)attr
{
    if (strstr(attr, "_ro") || strstr(attr, ",R"))
    {
        return YES;
    }
    return NO;
}

+ (WTRuntimeType)typeOfAttribute:(const char *)attr
{
    if ( attr[0] != 'T' )
        return WTRuntimeTypeUnknown;
    
    const char * type = &attr[1];
    if ( type[0] == '@' )
    {
        if ( type[1] != '"' )
            return WTRuntimeTypeUnknown;
        
        char typeClazz[128] = { 0 };
        
        const char * clazz = &type[2];
        const char * clazzEnd = strchr( clazz, '"' );
        
        if ( clazzEnd && clazz != clazzEnd )
        {
            unsigned int size = (unsigned int)(clazzEnd - clazz);
            strncpy( &typeClazz[0], clazz, size );
        }
        
        return [self typeOfClassName:typeClazz];
    }
    
    return WTRuntimeTypeUnknown;
}

+ (WTRuntimeType)typeOfClass:(Class)typeClazz
{
    if ( nil == typeClazz )
        return WTRuntimeTypeUnknown;
    
    if(typeClazz == [NSArray class] || [typeClazz isSubclassOfClass:[NSArray class]] || typeClazz == [NSSet class] || [typeClazz isSubclassOfClass:[NSSet class]])
    {
        return WTRuntimeTypeArray;
    }
    else if(typeClazz == [NSDictionary class] || [typeClazz isSubclassOfClass:[NSDictionary class]])
    {
        return WTRuntimeTypeDictionary;
    }
    else if(typeClazz == [NSString class] || [typeClazz isSubclassOfClass:[NSString class]])
    {
        return WTRuntimeTypeString;
    }
    else if(typeClazz == [NSNumber class] || [typeClazz isSubclassOfClass:[NSNumber class]])
    {
        return WTRuntimeTypeString;
    }
    else if(typeClazz == [NSList class] || [typeClazz isSubclassOfClass:[NSList class]])
    {
        return WTRuntimeTypeList;
    }
    
    const char * className = [NSStringFromClass(typeClazz) UTF8String];
    return [self typeOfClassName:className];
}

+ (WTRuntimeType)typeOfClassName:(const char *)className
{
    if ( NULL == className )
        return WTRuntimeTypeUnknown;
    
    if ( 0 == strncasecmp((const char *)className, "__WTArrayList_", strlen("__WTArrayList_")))
    {
        return WTRuntimeTypeList;
    }
    
#undef	__MATCH_CLASS
#define	__MATCH_CLASS( X ) \
0 == strcmp((const char *)className, "NS" #X) || \
0 == strcmp((const char *)className, "NSMutable" #X) || \
0 == strcmp((const char *)className, "_NSInline" #X) || \
0 == strcmp((const char *)className, "__NS" #X) || \
0 == strcmp((const char *)className, "__NS" #X "M") || \
0 == strcmp((const char *)className, "__NSMutable" #X) || \
0 == strcmp((const char *)className, "__NSCF" #X) || \
0 == strcmp((const char *)className, "__NSCFConstant" #X)
    
    if ( __MATCH_CLASS( Number ) )
    {
        return WTRuntimeTypeNumber;
    }
    else if ( __MATCH_CLASS( String ) )
    {
        return WTRuntimeTypeString;
    }
    else if ( __MATCH_CLASS( Date ) )
    {
        return WTRuntimeTypeDate;
    }
    else if ( __MATCH_CLASS( Array ) )
    {
        return WTRuntimeTypeArray;
    }
    else if ( __MATCH_CLASS( Set ) )
    {
        return WTRuntimeTypeArray;
    }
    else if ( __MATCH_CLASS( Dictionary ) )
    {
        return WTRuntimeTypeDictionary;
    }
    else if ( __MATCH_CLASS( Data ) )
    {
        return WTRuntimeTypeData;
    }
    else if ( __MATCH_CLASS( URL ) )
    {
        return WTRuntimeTypeUrl;
    }
    
    return WTRuntimeTypeObject;
}

+ (WTRuntimeType)typeOfObject:(id)obj
{
    if ( nil == obj )
        return WTRuntimeTypeUnknown;
    
    if ( [obj isKindOfClass:[NSNumber class]] )
    {
        return WTRuntimeTypeNumber;
    }
    else if ( [obj isKindOfClass:[NSString class]] )
    {
        return WTRuntimeTypeString;
    }
    else if ( [obj isKindOfClass:[NSArray class]] )
    {
        return WTRuntimeTypeArray;
    }
    else if ( [obj isKindOfClass:[NSSet class]] )
    {
        return WTRuntimeTypeArray;
    }
    else if ( [obj isKindOfClass:[NSList class]] )
    {
        return WTRuntimeTypeList;
    }
    else if ( [obj isKindOfClass:[NSDictionary class]] )
    {
        return WTRuntimeTypeDictionary;
    }
    else if ( [obj isKindOfClass:[NSDate class]] )
    {
        return WTRuntimeTypeDate;
    }
    else if ( [obj isKindOfClass:[NSData class]] )
    {
        return WTRuntimeTypeData;
    }
    else if ( [obj isKindOfClass:[NSURL class]] )
    {
        return WTRuntimeTypeUrl;
    }
    else
    {
        const char * className = [NSStringFromClass([obj class]) UTF8String];
        return [self typeOfClassName:className];
    }
}

+ (NSString *)classNameOfAttribute:(const char *)attr
{
    if ( attr[0] != 'T' )
        return nil;
    
    const char * type = &attr[1];
    if ( type[0] == '@' )
    {
        if ( type[1] != '"' )
            return nil;
        
        char typeClazz[128] = { 0 };
        
        const char * clazz = &type[2];
        const char * clazzEnd = strchr( clazz, '"' );
        
        if ( clazzEnd && clazz != clazzEnd )
        {
            unsigned int size = (unsigned int)(clazzEnd - clazz);
            strncpy( &typeClazz[0], clazz, size );
        }
        
        return [NSString stringWithUTF8String:typeClazz];
    }
    
    return nil;
}

+ (Class)classOfAttribute:(const char *)attr
{
    NSString * className = [self classNameOfAttribute:attr];
    if ( nil == className )
        return nil;
    
    return NSClassFromString( className );
}

+ (BOOL)isAtomClass:(Class)clazz
{
    if ( nil == clazz )
        return NO;
    
    if ( WTRuntimeTypeUnknown != [self typeOfClass:clazz] )
    {
        return YES;
    }
    return NO;
}

@end