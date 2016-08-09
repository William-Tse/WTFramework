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

#import "WT_Precompile.h"
#import "WT_Cache.h"

NS_ASSUME_NONNULL_BEGIN

@interface WTMemoryCache : NSObject<WTCacheProtocol>

@property (nonatomic, assign) BOOL clearWhenMemoryLow;
@property (nonatomic, assign) NSUInteger maxCacheCount;
@property (nonatomic, assign) NSUInteger cachedCount;

@singleton( WTMemoryCache );

- (BOOL)hasCoreObjectForKey:(id)key;
- (__nullable id)coreObjectForKey:(id)key;
- (void)setCoreObject:(id)object forKey:(id)key;
- (void)removeCoreObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

