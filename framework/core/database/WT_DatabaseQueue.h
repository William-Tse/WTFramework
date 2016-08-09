//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_DatabaseQueue.h
//  WTFramework
//

#import "WT_Precompile.h"
#import "WT_Database.h"

NS_ASSUME_NONNULL_BEGIN

@interface WTDatabaseQueue : NSObject

@singleton(WTDatabaseQueue)

+ (void)inDatabase:(void (^)(WTDatabase *db))block;
+ (void)inTransaction:(void (^)(WTDatabase *db, BOOL *rollback))block;
+ (void)inDeferredTransaction:(void (^)(WTDatabase *db, BOOL *rollback))block;

@end

NS_ASSUME_NONNULL_END
