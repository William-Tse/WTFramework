//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  WT_MemoryCache.h
//  WTFramework
//

#import "WT_MemoryCache.h"

#import "NSObject+WT_Extension.h"
#import "NSArray+WT_Extension.h"
#import "WT_Notification.h"
#import "WT_Http.h"

#undef	DEFAULT_MAX_COUNT
#define DEFAULT_MAX_COUNT	(48)

#pragma mark -

@interface WTMemoryCache ()

@property (atomic, strong) NSMutableArray *cacheKeys;
@property (atomic, strong) NSMutableDictionary *cacheObjs;

@property (atomic, strong) NSMutableArray *cacheCoreKeys;
@property (atomic, strong) NSMutableDictionary *cacheCoreObjs;

@end

@implementation WTMemoryCache

@def_singleton( WTMemoryCache );

- (id)init
{
	self = [super init];
	if ( self )
	{
		_clearWhenMemoryLow = YES;
		_maxCacheCount = DEFAULT_MAX_COUNT;
		_cachedCount = 0;
		
		_cacheKeys = [NSMutableArray array];
		_cacheObjs = [NSMutableDictionary dictionary];
        
        _cacheCoreKeys = [NSMutableArray array];
        _cacheCoreObjs = [NSMutableDictionary dictionary];

		[self observeNotification:UIApplicationDidReceiveMemoryWarningNotification];
	}

	return self;
}

- (void)dealloc
{
	[self unobserveAllNotifications];
	
	[_cacheObjs removeAllObjects];
	[_cacheKeys removeAllObjects];
}

- (BOOL)hasObjectForKey:(id)key
{
	return [_cacheObjs objectForKey:key] ? YES : NO;
}

- (__nullable id)objectForKey:(id)key
{
    return [_cacheObjs objectForKey:key];
}

- (void)setObject:(id)object forKey:(id)key
{
    id cachedObj = [_cacheObjs objectForKey:key];
    if ( cachedObj == object )
        return;
    
    _cachedCount += 1;

    if ( _maxCacheCount > 0 )
    {
        while ( _cachedCount >= _maxCacheCount )
        {
            NSString * tempKey = [_cacheKeys safeObjectAtIndex:0];
            if ( tempKey )
            {
                [_cacheObjs removeObjectForKey:tempKey];
                [_cacheKeys removeObjectAtIndex:0];
            }

            _cachedCount -= 1;
        }
    }
    [_cacheKeys addObject:key];
    [_cacheObjs setObject:object forKey:key];
}

- (void)removeObjectForKey:(NSString *)key
{
    if ( [_cacheObjs objectForKey:key] )
    {
        [_cacheKeys removeObjectIdenticalTo:key];
        [_cacheObjs removeObjectForKey:key];

        _cachedCount -= 1;
    }
}

- (void)removeAllObjects
{
    [_cacheKeys removeAllObjects];
    [_cacheObjs removeAllObjects];
    
    _cachedCount = 0;
}

- (__nullable id)objectForKeyedSubscript:(id)key
{
	return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[self setObject:obj forKey:key];
}

#pragma mark -

- (BOOL)hasCoreObjectForKey:(id)key
{
    return [_cacheCoreObjs objectForKey:key] ? YES : NO;
}

- (__nullable id)coreObjectForKey:(id)key
{
    return [_cacheCoreObjs objectForKey:key];
}

- (void)setCoreObject:(id)object forKey:(id)key
{
    id cachedObj = [_cacheCoreObjs objectForKey:key];
    if ( cachedObj == object )
        return;
    
    [_cacheCoreKeys addObject:key];
    [_cacheCoreObjs setObject:object forKey:key];
}

- (void)removeCoreObjectForKey:(NSString *)key
{
    if([_cacheCoreObjs objectForKey:key])
    {
        [_cacheCoreKeys removeObjectIdenticalTo:key];
        [_cacheCoreObjs removeObjectForKey:key];
    }
}

#pragma mark -

- (void)handleNotification:(NSNotification *)notification
{
	if ( [notification is:UIApplicationDidReceiveMemoryWarningNotification] )
	{
		if ( _clearWhenMemoryLow )
		{
            [WTHttp clearCachedResponses];
            if(_cacheKeys.count)
            {
                [self removeAllObjects];
            }
            else
            {
                [_cacheCoreKeys removeAllObjects];
                [_cacheCoreObjs removeAllObjects];
            }
		}
	}
}

@end
