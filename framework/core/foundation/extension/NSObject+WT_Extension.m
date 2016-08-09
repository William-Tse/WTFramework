//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSObject+WT_TypeConversion.m
//  WTFramework
//

#import "NSObject+WT_Extension.h"
#import "NSDate+WT_Extension.h"
#import "NSArray+WT_Extension.h"
#import "NSList+WT_Extension.h"
#import "NSString+WT_Extension.h"

#import "WT_Runtime.h"
#import "WT_Model.h"
#import "WT_MemoryCache.h"

#import "_pragma_push.h"

#undef	CACHE_KEY_METHODS
#define CACHE_KEY_METHODS       @"__WT_CACHE_OBJECT_METHODS__"

#undef	CACHE_KEY_PROPERTIES
#define CACHE_KEY_PROPERTIES    @"__WT_CACHE_OBJECT_PROPERTIES__"

@implementation NSObject(WT_Extension)



- (nullable NSNumber *)toNumber
{
	if ( [self isKindOfClass:[NSNumber class]] )
	{
		return (NSNumber *)self;
	}
	else if ( [self isKindOfClass:[NSString class]] )
	{
		return [NSNumber numberWithFloat:[(NSString *)self floatValue]];
	}
	else if ( [self isKindOfClass:[NSDate class]] )
	{
		return [NSNumber numberWithDouble:[(NSDate *)self timeIntervalSince1970]];
	}
	return nil;
}

- (nullable NSString *)toString
{
	if ( [self isKindOfClass:[NSString class]] )
	{
		return (NSString *)self;
    }
    else if ( !self || [self isKindOfClass:[NSNull class]] )
    {
        return nil;
    }
	else if ( [self isKindOfClass:[NSData class]] )
	{
		NSData * data = (NSData *)self;
		
		NSString * text = [[NSString alloc] initWithBytes:data.bytes length:data.length encoding:NSUTF8StringEncoding];
		if ( nil == text )
		{
			text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
			if ( nil == text )
			{
				text = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
			}
		}
		return text;
    }
    else if([self isKindOfClass:[NSURL class]])
    {
        return [(NSURL *)self absoluteString];
    }
    else if([self isKindOfClass:[NSNumber class]])
    {
        return [NSString stringWithFormat:@"%@", self];
    }
    else if([self isKindOfClass:[NSDate class]])
    {
        return [(NSDate *)self toString:@"yyyy-MM-dd HH:mm:ss z"];
    }
    else
    {
        return [self toJSONString];
    }
}

- (nullable NSDate *)toDate
{
	if ( [self isKindOfClass:[NSDate class]] )
	{
		return (NSDate *)self;
	}
	else if ( [self isKindOfClass:[NSString class]] )
    {
        [NSDate dateWithString:(NSString *)self];
	}
	else
	{
		return [NSDate dateWithTimeIntervalSince1970:[self toNumber].doubleValue];
	}
	
	return nil;	
}

- (nullable NSData *)toData
{
    if ( [self isKindOfClass:[NSData class]] )
    {
        return (NSData *)self;
    }
    else
	{
        NSString * string = [self toString];
        if ( string )
        {
            return [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        }
	}
	return nil;
}

- (nullable NSURL *)toURL
{
    if ( [self isKindOfClass:[NSURL class]] )
    {
        return (NSURL *)self;
    }
    else
    {
        NSString * string = [self toString];
        if ( string )
        {
            return [NSURL URLWithString:string];
        }
    }
    return nil;
}

@end


@implementation NSObject(WT_Serialize)

+ (instancetype)objectFromDictionary:(NSDictionary *)dictionary
{
    return [dictionary toObjectWithClass:[self class]];
}

+ (instancetype)objectsFromArray:(NSArray *)array
{
    return [array toArrayWithClass:[self class]];
}

- (nullable id)serialize
{
    id obj = self;
    
    WTRuntimeType type = [WTRuntime typeOfObject:obj];
    switch (type) {
        case WTRuntimeTypeNumber:
        case WTRuntimeTypeString:
        case WTRuntimeTypeData:
            return obj;
        case WTRuntimeTypeDate:
            return [(NSDate *)obj toString:@"yyyy-MM-dd HH:mm:ss z"];
        case WTRuntimeTypeUrl:
            return [self toString];
        case WTRuntimeTypeList:
            obj = [(NSList *)self toArray];
        case WTRuntimeTypeArray:
        {
            NSMutableArray * result = [NSMutableArray array];
            for (id elem in (NSArray *)obj)
            {
                id subResult = [elem serialize];
                if (subResult)
                {
                    [result addObject:subResult];
                }
            }
            return result;
        }
        case WTRuntimeTypeDictionary:
        {
            NSMutableDictionary * result = [NSMutableDictionary dictionary];
            for ( NSString * key in [(NSDictionary *)obj allKeys] )
            {
                NSObject * value = [(NSDictionary *)obj objectForKey:key];
                if (value)
                {
                    id subResult = [value serialize];
                    if (subResult)
                    {
                        [result setObject:subResult forKey:key];
                    }
                }
            }
            return result;
        }
        default:
        {
            if(obj)
            {
                NSMutableDictionary * result = [NSMutableDictionary dictionary];
                for (WTProperty *prop in [[self class] properties]) {
                    id value = [self valueForKey:prop.name];
                    if(value)
                    {
                        id propResult = [value serialize];
                        if(propResult)
                        {
                            [result setObject:propResult forKey:prop.name];
                        }
                    }
                }
                return result;
            }
        }
            break;
    }
    return nil;
}

- (nullable id)deserialize
{
    id obj = self;
    
    WTRuntimeType type = [WTRuntime typeOfObject:obj];
    switch (type) {
        case WTRuntimeTypeData:
        {
            NSError * error = nil;
            NSObject * result = [NSJSONSerialization JSONObjectWithData:(NSData *)self options:NSJSONReadingAllowFragments error:&error];
            if ( !result )
            {
                NSLog(@"%@", error);
                return nil;
            }
            return result;
        }
            break;
        case WTRuntimeTypeString:
        {
            return [[self toData] deserialize];
        }
            break;
        default:
        {
            return self;
        }
    }
}

- (nullable NSString *)toJSONString
{
    NSError * error = nil;
    NSData * result = [NSJSONSerialization dataWithJSONObject:[self serialize] options:NSJSONWritingPrettyPrinted error:&error];
    if ( !result )
    {
        NSLog(@"%@", error);
        return nil;
    }
    return [result toString];
}

- (nullable NSString *)toXMLString
{
    //TODO:XMLString
    return nil;
}

- (nullable id)toObjectWithClass:(Class)cls
{
    id obj = [self deserialize];
    if(obj && [obj isKindOfClass:[NSDictionary class]])
    {
        id result = [[cls alloc] init];
        for (WTProperty *prop in [cls properties])
        {
            id value = [obj objectForKey:prop.name];
            if(value)
            {
                switch (prop.runtimeType) {
                    case WTRuntimeTypeList:
                    {
                        if([value isKindOfClass:[NSString class]])
                        {
                            value = [value toArrayWithClass:prop.clazz];
                        }
                        if([value isKindOfClass:[NSArray class]])
                        {
                            NSList *list = [prop.clazz list];
                            for (id item in (NSArray *)value) {
                                Class itemClass = [[list class] itemClass];
                                id itemObj = [item toObjectWithClass:itemClass];
                                [list addObject:itemObj];
                            }
                            [result setValue:list forKey:prop.name];
                        }
                    }
                        break;
                    case WTRuntimeTypeArray:
                    {
                        if([value isKindOfClass:[NSString class]])
                        {
                            value = [value toArrayWithClass:prop.clazz];
                        }
                        if([value isKindOfClass:[NSArray class]])
                        {
                            NSMutableArray *array = [NSMutableArray arrayWithArray:value];
                            [result setValue:array forKey:prop.name];
                        }
                    }
                        break;
                    case WTRuntimeTypeDate:
                    {
                        NSDate *dateValue = [value toDate];
                        if(dateValue && dateValue.timeIntervalSince1970 > 0)
                        {
                            [result setValue:dateValue forKey:prop.name];
                        }
                    }
                        break;
                    case WTRuntimeTypeUrl:
                    {
                        NSURL *urlValue = [value toURL];
                        if(urlValue)
                        {
                            [result setValue:urlValue forKey:prop.name];
                        }
                    }
                        break;
                    case WTRuntimeTypeNumber:
                    {
                        NSNumber *numValue = [value toNumber];
                        if(numValue)
                        {
                            [result setValue:numValue forKey:prop.name];
                        }
                    }
                        break;
                    case WTRuntimeTypeString:
                    {
                        NSString *strValue = [value toString];
                        if(strValue)
                        {
                            [result setValue:strValue forKey:prop.name];
                        }
                    }
                        break;
                    default:
                    {
                        if([value isKindOfClass:[NSString class]])
                        {
                            value = [value toObjectWithClass:prop.clazz];
                        }
                        if([result isKindOfClass:[NSDictionary class]])
                        {
                            id propValue = [result toObjectWithClass:prop.clazz];
                            [result setValue:propValue forKey:prop.name];
                        }
                        else
                        {
                            [result setValue:value forKey:prop.name];
                        }
                    }
                        break;
                }
            }
        }
        return result;
    }
    return nil;
}

- (nullable NSArray *)toArrayWithClass:(Class)cls
{
    id obj = [self serialize];
    if([obj isKindOfClass:[NSArray class]])
    {
        NSMutableArray *result = [NSMutableArray array];
        for (id item in (NSArray *)obj) {
            id resultItem = [item toObjectWithClass:cls];
            [result addObject:resultItem];
        }
        return obj;
    }
    return nil;
}

- (nullable NSDictionary *)toDictionary
{
    id obj = [self serialize];
    if([obj isKindOfClass:[NSDictionary class]])
    {
        return obj;
    }
    return nil;
}

- (nullable NSDictionary *)toQueryParameters
{
    NSDictionary *dictObj = [self toDictionary];
    if(dictObj)
    {
        NSMutableDictionary *result = [NSMutableDictionary dictionary];
        for (id key in dictObj.allKeys) {
            NSString *strKey = [key toString];
            if(strKey)
            {
                [self writeQueryParameters:result withKey:[key toString] value:[dictObj objectForKey:key]];
            }
        }
        return result;
    }
    return nil;
}

- (void)writeQueryParameters:(NSMutableDictionary *)parameters withKey:(NSString *)key value:(id)value
{
    WTRuntimeType runtimeType = [WTRuntime typeOfClass:[value class]];
    switch (runtimeType) {
        case WTRuntimeTypeNumber:
        case WTRuntimeTypeString:
        case WTRuntimeTypeUrl:
        case WTRuntimeTypeDate:
        case WTRuntimeTypeData:
        {
            NSString *strValue = [value toString];
            if(strValue)
            {
                [parameters setObject:strValue forKey:key];
            }
        }
            break;
        case WTRuntimeTypeList:
        case WTRuntimeTypeArray:
        {
            NSArray *arrValue = [value isKindOfClass:[NSList class]] ? [(NSList *)value toArray] : (NSArray *)value;
            for (NSInteger i=0; i<arrValue.count; ++i) {
                NSString *itemKey = [key stringByAppendingFormat:@"[%ld]", (long)i];
                id itemValue = [arrValue objectAtIndex:i];
                [self writeQueryParameters:parameters withKey:itemKey value:itemValue];
            }
        }
            break;
        case WTRuntimeTypeDictionary:
        {
            NSDictionary *dictValue = (NSDictionary *)value;
            for (id dictKey in dictValue.allKeys) {
                NSString *itemKey = [key stringByAppendingFormat:@".%@", dictKey];
                id itemValue = [dictValue objectForKey:dictKey];
                [self writeQueryParameters:parameters withKey:itemKey value:itemValue];
            }
        }
            break;
        default:
            break;
    }
}

- (NSString *)toQueryString
{
    NSDictionary *parameters = [self toQueryParameters];
    NSArray *keys = [parameters.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2];
    }];
    
    NSMutableArray * pairs = [NSMutableArray array];
    for ( NSString * key in keys )
    {
        NSString * value = [[parameters objectForKey:key] toString];
        if(value)
        {
            [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
        }
    }
    return [pairs componentsJoinedByString:@"&"];
}

@end

@implementation NSObject(WT_Runtime)

+ (Class)baseClass
{
    if([self isKindOfClass:[WTModel class]])
    {
        return [WTModel class];
    }
    return [NSObject class];
}

+ (NSArray *)loadedClassNames
{
    static dispatch_once_t		once;
    static NSMutableArray *		classNames;
    
    dispatch_once( &once, ^
      {
          classNames = [[NSMutableArray alloc] init];
          
          unsigned int 	classesCount = 0;
          Class *		classes = objc_copyClassList( &classesCount );
          
          for ( unsigned int i = 0; i < classesCount; ++i )
          {
              Class classType = classes[i];
              
              if ( class_isMetaClass( classType ) )
                  continue;
              
              Class superClass = class_getSuperclass( classType );
              
              if ( nil == superClass )
                  continue;
              
              [classNames addObject:[NSString stringWithUTF8String:class_getName(classType)]];
          }
          
          [classNames sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
              return [obj1 compare:obj2];
          }];
          
          free( classes );
      });
    
    return classNames;
}

+ (NSArray *)subClasses
{
    NSMutableArray * results = [[NSMutableArray alloc] init];
    
    for ( NSString * className in [self loadedClassNames] )
    {
        Class classType = NSClassFromString( className );
        if ( classType == self )
            continue;
        
        if ( NO == [classType isSubclassOfClass:self] )
            continue;
        
        [results addObject:[classType description]];
    }
    
    return results;
}

+ (NSArray *)methods
{
    WTMemoryCache *cache = [WTMemoryCache sharedInstance];
    
    NSMutableDictionary *dictMethods = [cache coreObjectForKey:CACHE_KEY_METHODS];
    
    if (!dictMethods)
    {
        dictMethods = [NSMutableDictionary dictionary];
        [cache setCoreObject:dictMethods forKey:CACHE_KEY_METHODS];
    }
    
    NSString *className = NSStringFromClass([self class]);
    NSArray *methods = [dictMethods objectForKey:className];
    if(!methods)
    {
        methods = [NSMutableArray arrayWithArray:[self methodsUntilClass:nil]];
        [dictMethods setObject:methods forKey:className];
    }
    return methods;
}

+ (NSArray *)methodsUntilClass:(nullable Class)baseClass
{
    NSMutableArray * methodNames = [[NSMutableArray alloc] init];
    
    Class thisClass = self;
    baseClass = baseClass ?: [self baseClass];
    
    while ( NULL != thisClass )
    {
        unsigned int	methodCount = 0;
        Method *		methodList = class_copyMethodList( thisClass, &methodCount );
        
        for ( unsigned int i = 0; i < methodCount; ++i )
        {
            SEL selector = method_getName( methodList[i] );
            if ( selector )
            {
                const char * cstrName = sel_getName(selector);
                if ( NULL == cstrName )
                    continue;
                
                NSString * selectorName = [NSString stringWithUTF8String:cstrName];
                if ( NULL == selectorName )
                    continue;
                
                [methodNames addObject:selectorName];
            }
        }
        
        free( methodList );
        
        thisClass = class_getSuperclass( thisClass );
        
        if ( nil == thisClass || baseClass == thisClass )
        {
            break;
        }
    }
    
    return methodNames;
}

+ (NSArray *)methodsWithPrefix:(NSString *)prefix
{
    return [self methodsWithPrefix:prefix untilClass:[self baseClass]];
}

+ (NSArray *)methodsWithPrefix:(NSString *)prefix untilClass:(nullable Class)baseClass
{
    NSArray * methods = [self methodsUntilClass:baseClass];
    
    if ( !methods.count )
    {
        return methods;
    }
    
    NSMutableArray * result = [[NSMutableArray alloc] init];
    
    for ( NSString * selectorName in methods )
    {
        if ( NO == [selectorName hasPrefix:prefix] )
        {
            continue;
        }
        
        [result addObject:selectorName];
    }
    
    [result sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    
    return result;
}

+ (NSArray *)properties
{
    WTMemoryCache *cache = [WTMemoryCache sharedInstance];
    
    NSMutableDictionary *dictProperties = [cache coreObjectForKey:CACHE_KEY_PROPERTIES];
    if (!dictProperties)
    {
        dictProperties = [NSMutableDictionary dictionary];
        [cache setCoreObject:dictProperties forKey:CACHE_KEY_PROPERTIES];
    }
    
    NSString *className = NSStringFromClass([self class]);
    NSArray *properties = [dictProperties objectForKey:className];
    if(!properties)
    {
        properties = [NSMutableArray arrayWithArray:[self propertiesUntilClass:nil]];
        [dictProperties setObject:properties forKey:className];
    }
    return properties;
}

+ (NSArray *)propertiesUntilClass:(nullable Class)baseClass
{
    NSMutableArray * properties = [[NSMutableArray alloc] init];
    
    Class thisClass = self;
    baseClass = baseClass ?: [self baseClass];
    
    while ( NULL != thisClass )
    {
        unsigned int		propertyCount = 0;
        objc_property_t *	propertyList = class_copyPropertyList( thisClass, &propertyCount );
        
        for ( unsigned int i = 0; i < propertyCount; ++i )
        {
            const char * cstrName = property_getName( propertyList[i] );
            if ( NULL == cstrName )
                continue;
            
            NSString * propName = [NSString stringWithUTF8String:cstrName];
            if ( NULL == propName )
                continue;
            
            const char * cstrAttr = property_getAttributes( propertyList[i] );
            
            WTProperty *property = [[WTProperty alloc] init];
            property.name = propName;
            property.clazz = [WTRuntime classOfAttribute:cstrAttr];
            property.readonly = [WTRuntime isReadOnly:cstrAttr];
            
            [properties addObject:property];
        }
        
        free( propertyList );
        
        thisClass = class_getSuperclass( thisClass );
        
        if ( nil == thisClass || baseClass == thisClass )
        {
            break;
        }
    }
    return properties;
}

+ (NSArray *)classesWithProtocolName:(NSString *)protocolName
{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    Protocol * protocol = NSProtocolFromString(protocolName);
    for ( NSString *className in [self loadedClassNames] )
    {
        Class classType = NSClassFromString( className );
        if ( classType == self )
            continue;
        
        if ( NO == [classType conformsToProtocol:protocol] )
            continue;
        
        [results addObject:[classType description]];
    }
    
    return results;
}

+ (void *)replaceSelector:(SEL)sel1 withSelector:(SEL)sel2
{
    Method method = class_getInstanceMethod( self, sel1 );
    
    IMP implement = (IMP)method_getImplementation( method );
    IMP implement2 = class_getMethodImplementation( self, sel2 );
    
    method_setImplementation( method, implement2 );
    
    return (void *)implement;
}


- (id)performSelectorSafetyWithName:(NSString *)selName
{
    return [self performSelectorSafetyWithName:selName withObject:nil];
}

- (id)performSelectorSafetyWithName:(NSString *)selName withObject:(id)object
{
    SEL sel = NSSelectorFromString(selName);
    if([self respondsToSelector:sel])
    {
        [self performSelector:sel withObject:object afterDelay:0];
    }
    return nil;
}

@end

@implementation NSObject(Loader)

- (void)load
{
}

- (void)unload
{
}

- (void)performLoad
{
    [self performSelectorSafetyWithName:@"onWillLoad"];
    [self load];
    [self performSelectorSafetyWithName:@"onDidLoad"];
}

- (void)performUnload
{
    [self performSelectorSafetyWithName:@"onWillUnload"];
    [self unload];
    [self performSelectorSafetyWithName:@"onDidUnload"];
}

@end

#import "_pragma_pop.h"
