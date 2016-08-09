//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  WT_FileCache.h
//  WTFramework
//

#import "WT_Cache.h"

@interface WTFileCache : NSObject<WTCacheProtocol>

@property (nonatomic, strong) NSString *cachePath;
@property (nonatomic, strong) NSString *cacheUser;

@singleton( WTFileCache );

- (NSString *)fileNameForKey:(NSString *)key;

@end
