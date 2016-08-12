//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Database.h
//  WTFramework
//

#import "WT_Precompile.h"

#import "FMDB.h"
#import "WT_Model.h"


NS_ASSUME_NONNULL_BEGIN

@class WTDatabase;

typedef struct __attribute__((objc_boxable)) {
    BOOL primaryKey;
    BOOL autoIncrement;
    BOOL unique;
    BOOL index;
    BOOL nonNull;
    NSInteger type;
    NSInteger size;
    char * __nullable defaultValue;
} WTDatabaseFieldAttribute;

#if NS_BLOCKS_AVAILABLE

typedef WTDatabase * __nonnull  (^WTDatabaseBlock)( id value );
typedef WTDatabase * __nonnull  (^WTDatabaseBlockV)( void );
typedef WTDatabase * __nonnull  (^WTDatabaseBlockU)( NSUInteger value );
typedef WTDatabase * __nonnull  (^WTDatabaseBlockB)( BOOL flag );
typedef WTDatabase * __nonnull  (^WTDatabaseBlockP)( NSString *key, id value );
typedef WTDatabase * __nonnull  (^WTDatabaseBlockF)( NSString *key, WTDatabaseFieldAttribute value );
typedef WTDatabase * __nonnull  (^WTDatabaseBlockN)( id key, ... );

typedef void                    (^WTDatabaseVoidBlock)( id value );

typedef BOOL                    (^WTDatabaseBoolBlockV)( void );
typedef NSInteger               (^WTDatabaseIntBlockV)( void );
typedef NSUInteger              (^WTDatabaseUintBlockV)( void );
typedef NSArray * __nullable    (^WTDatabaseArrayBlockV)( void );
typedef id __nullable           (^WTDatabaseObjectBlockV)( void );

#endif


@interface WTDatabase : NSObject

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, copy) Class modelClass;

+ (instancetype)databaseWithFMDB:(FMDatabase *)db;
- (instancetype)initWithFMDB:(FMDatabase *)db;

- (id)executeScalar:(NSString *)sql, ...;
- (NSArray *)executeQuery:(NSString *)sql, ...;
- (BOOL)executeUpdate:(NSString *)sql, ...;

- (id)executeScalarWithClass:(Class)clazz sql:(NSString *)sql, ...;
- (NSArray *)executeQueryWith:(Class)clazz sql:(NSString *)sql, ...;

- (BOOL)beginTransaction;
- (BOOL)beginDeferredTransaction;
- (BOOL)commit;
- (BOOL)rollback;
- (BOOL)inTransaction;

- (void)clearCachedStatements;
- (BOOL)shouldCacheStatements;
- (void)setShouldCacheStatements:(BOOL)value;

#pragma mark -

- (WTDatabaseBlockN)TABLE;
- (WTDatabaseBlockF)FIELD;
- (WTDatabaseBlockV)CREATE;

- (WTDatabaseBlock)SELECT;
- (WTDatabaseBlock)SELECT_MAX;
- (WTDatabaseBlockP)SELECT_MAX_ALIAS;
- (WTDatabaseBlock)SELECT_MIN;
- (WTDatabaseBlockP)SELECT_MIN_ALIAS;
- (WTDatabaseBlock)SELECT_AVG;
- (WTDatabaseBlockP)SELECT_AVG_ALIAS;
- (WTDatabaseBlock)SELECT_SUM;
- (WTDatabaseBlockP)SELECT_SUM_ALIAS;

- (WTDatabaseBlockV)DISTINCT;

- (WTDatabaseBlock)WRAP;

- (WTDatabaseBlockN)WHERE;
- (WTDatabaseBlockN)OR_WHERE;

- (WTDatabaseBlockN)WHERE_IN;
- (WTDatabaseBlockN)WHERE_NOT_IN;

- (WTDatabaseBlockN)WHERE_OPERATOR;
- (WTDatabaseBlockN)OR_WHERE_OPERATOR;

- (WTDatabaseBlockP)LIKE;
- (WTDatabaseBlockP)NOT_LIKE;
- (WTDatabaseBlockP)OR_LIKE;
- (WTDatabaseBlockP)OR_NOT_LIKE;

- (WTDatabaseBlock)GROUP_BY;

- (WTDatabaseBlockP)HAVING;
- (WTDatabaseBlockP)OR_HAVING;

- (WTDatabaseBlock)ORDER_ASC_BY;
- (WTDatabaseBlock)ORDER_DESC_BY;
- (WTDatabaseBlock)ORDER_RAND_BY;
- (WTDatabaseBlockP)ORDER_BY;

- (WTDatabaseBlockU)LIMIT;
- (WTDatabaseBlockU)OFFSET;

- (WTDatabaseBlockN)SET;
- (WTDatabaseBlock)SET_NULL;

- (WTDatabaseIntBlockV)INSERT;
- (WTDatabaseUintBlockV)UPDATE;
- (WTDatabaseIntBlockV)REPLACE;

- (WTDatabaseBoolBlockV)EMPTY;
- (WTDatabaseBoolBlockV)DROP;
- (WTDatabaseBoolBlockV)DELETE;

- (WTDatabaseUintBlockV)COUNT;
- (WTDatabaseArrayBlockV)GET;
- (WTDatabaseObjectBlockV)GET_FIRST;

@end

NS_ASSUME_NONNULL_END
