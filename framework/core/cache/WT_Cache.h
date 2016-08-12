//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  WT_Cache.h
//  WTFramework
//

#import "WT_Precompile.h"

#import "WT_FileSystem.h"

//#import "WT_Keychain.h"
//#import "WT_UserDefaults.h"

//#import "NSObject+WT_Keychain.h"
//#import "NSObject+WT_UserDefaults.h"

@protocol WTCacheProtocol<NSObject>

- (BOOL)hasObjectForKey:(id)key;

- (id)objectForKey:(id)key;
- (void)setObject:(id)object forKey:(id)key;

- (void)removeObjectForKey:(id)key;
- (void)removeAllObjects;

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id)key;

@end
