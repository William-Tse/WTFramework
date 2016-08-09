//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Model+WT_Database.h
//  WTFramework
//

#import "WT_Precompile.h"

#import "WT_Model.h"
#import "WT_Database.h"

#undef  WT_DATABASE_FIELD
#define WT_DATABASE_FIELD(__prop, __value) \
+ (WTDatabaseFieldAttribute)__field_##__prop { return __value;}

NS_ASSUME_NONNULL_BEGIN

@interface WTModel (WT_Database)

+ (NSString *)tableName;
+ (WTDatabaseFieldAttribute)fieldOfProperty:(NSString *)prop;
+ (__nullable id)primaryKey;

+ (WTDatabase * (^)(WTDatabase *db))DB;

- (void (^)(WTDatabase *db))DELETE_FROM;
- (void (^)(WTDatabase *db))SAVE_INTO;

@end

NS_ASSUME_NONNULL_END

