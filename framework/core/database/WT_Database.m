//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Database.m
//  WTFramework
//

#import "WT_Database.h"

#import <sqlite3.h>
#import "NSString+WT_Extension.h"
#import "NSArray+WT_Extension.h"
#import "WT_Model+WT_Database.h"
#import "NSObject+WT_Extension.h"

#import "_pragma_push.h"

@implementation WTDatabase
{
    BOOL _wrap;
    
    BOOL _distinct;
    
    NSMutableArray *_field;
    NSMutableArray *_table;
    
    NSMutableArray *_select;
    NSMutableArray *_from;
    NSMutableArray *_groupby;
    NSMutableArray *_having;
    NSMutableArray *_where;
    NSMutableArray *_like;
    NSMutableArray *_orderby;
    NSUInteger _limit;
    NSUInteger _offset;
    NSMutableDictionary *_set;
}

+ (instancetype)databaseWithFMDB:(FMDatabase *)db
{
    return [[WTDatabase alloc] initWithFMDB:db];
}

- (instancetype)initWithFMDB:(FMDatabase *)db
{
    self = [super init];
    if(self)
    {
        _field = [NSMutableArray array];
        _table = [NSMutableArray array];
        _select = [NSMutableArray array];
        _from = [NSMutableArray array];
        _groupby = [NSMutableArray array];
        _having = [NSMutableArray array];
        _where = [NSMutableArray array];
        _like = [NSMutableArray array];
        _orderby = [NSMutableArray array];
        _limit = 0;
        _offset = 0;
        _set = [NSMutableDictionary dictionary];
        
        self.db = db;
    }
    return self;
}

- (void)setModelClass:(Class)modelClass
{
    NSAssert([modelClass isSubclassOfClass:[WTModel class]], @"ModelClass must be a subclass of WTModel class");
    _modelClass = modelClass;
}

- (id)executeScalar:(NSString *)sql, ...
{
    va_list args;
    va_start(args, sql);
    FMResultSet *set = [self.db executeQuery:sql withVAList:args];
    va_end(args);
    
    if(set)
    {
        id result = nil;
        if ([set next]) {
            result = [set objectForColumnIndex:0];
        }
        [set close];
        
        if(![result isKindOfClass:[NSNull class]])
        {
            return result;
        }
    }
    return nil;
}

- (NSArray *)executeQuery:(NSString *)sql, ...
{
    va_list args;
    va_start(args, sql);
    FMResultSet *set = [self.db executeQuery:sql withVAList:args];
    va_end(args);
    
    if(set)
    {
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        while ([set next]) {
            NSDictionary * dict = [set resultDictionary];
            [resultArray addObject:dict];
        }
        [set close];
        return resultArray;
    }
    return nil;
}

- (BOOL)executeUpdate:(NSString *)sql, ...
{
    va_list args;
    va_start(args, sql);
    BOOL result = [self.db executeUpdate:sql withVAList:args];
    va_end(args);
    
    return result;
}

- (id)executeScalarWithClass:(Class)clazz sql:(NSString *)sql, ...
{
    va_list args;
    va_start(args, sql);
    FMResultSet *set = [self.db executeQuery:sql withVAList:args];
    va_end(args);
    
    if(set)
    {
        id result = nil;
        if ([set next]) {
            result = [set objectForColumnIndex:0];
        }
        [set close];
        
        if(![result isKindOfClass:[NSNull class]])
        {
            return [result toObjectWithClass:clazz];
        }
    }
    return nil;
}

- (NSArray *)executeQueryWith:(Class)clazz sql:(NSString *)sql, ...
{
    va_list args;
    va_start(args, sql);
    FMResultSet *set = [self.db executeQuery:sql withVAList:args];
    va_end(args);
    
    if(set)
    {
        NSMutableArray *resultArray = [[NSMutableArray alloc] init];
        while ([set next]) {
            NSDictionary * dict = [set resultDictionary];
            [resultArray addObject:dict];
        }
        [set close];
        return [resultArray toArrayWithClass:clazz];
    }
    return nil;
}

- (BOOL)beginTransaction
{
    return [_db beginTransaction];
}

- (BOOL)beginDeferredTransaction
{
    return [_db beginDeferredTransaction];
}

- (BOOL)commit
{
    return [_db commit];
}

- (BOOL)rollback
{
    return [_db rollback];
}

- (BOOL)inTransaction
{
    return [_db inTransaction];
}

- (void)clearCachedStatements
{
    [_db clearCachedStatements];
}

- (BOOL)shouldCacheStatements
{
    return [_db shouldCacheStatements];
}

- (void)setShouldCacheStatements:(BOOL)value
{
    [_db setShouldCacheStatements:value];
}

#pragma mark -

- (void)__internalExtendField:(WTDatabaseFieldAttribute)field toDictionary:(NSMutableDictionary *)dict
{
    [dict setObject:@(field.unique) forKey:@"unique"];
    [dict setObject:@(field.index) forKey:@"index"];
    [dict setObject:@(field.nonNull) forKey:@"nonNull"];
    [dict setObject:@(field.size) forKey:@"size"];
    
    if(field.defaultValue != NULL)
    {
        [dict setObject:[NSString stringWithUTF8String:field.defaultValue] forKey:@"defaultValue"];
    } else {
        [dict removeObjectForKey:@"defaultValue"];
    }
    
    if(field.type)
    {
        switch (field.type) {
            case SQLITE_INTEGER:
                [dict setObject:@"INTEGER" forKey:@"type"];
                break;
            case SQLITE_FLOAT:
                [dict setObject:@"FLOAT" forKey:@"type"];
                break;
            case SQLITE_BLOB:
                [dict setObject:@"BLOB" forKey:@"type"];
                break;
            case SQLITE_TEXT:
                [dict setObject:@"TEXT" forKey:@"type"];
                break;
            default:
                [dict removeObjectForKey:@"type"];
                break;
        }
    }
    
    if(field.primaryKey)
    {
        [dict setObject:@"INTEGER" forKey:@"type"];
        [dict setObject:@YES forKey:@"primaryKey"];
        [dict setObject:@(field.autoIncrement) forKey:@"autoIncrement"];
    }
    else
    {
        [dict setObject:@NO forKey:@"primaryKey"];
        [dict setObject:@NO forKey:@"autoIncrement"];
    }
}

#pragma mark -

- (void)__internalResetCreate
{
    [_field removeAllObjects];
    [_table removeAllObjects];
}

- (void)__internalResetSelect
{
    [_select removeAllObjects];
    [_from removeAllObjects];
    [_where removeAllObjects];
    [_like removeAllObjects];
    [_groupby removeAllObjects];
    [_having removeAllObjects];
    [_orderby removeAllObjects];
    
    _distinct = NO;
    _limit = 0;
    _offset = 0;
}

- (void)__internalResetWrite
{
    [_set removeAllObjects];
    [_from removeAllObjects];
    [_where removeAllObjects];
    [_like removeAllObjects];
    [_orderby removeAllObjects];
    
    _limit = 0;
}

#pragma mark -

- (void)internalGroupBy:(NSString *)by
{
    if ( nil == by )
        return;
    
    [_groupby addObject:by];
}

- (void)internalSelect:(NSString *)select alias:(NSString *)alias type:(NSString *)type
{
    if ( nil == select )
        return;
    
    NSArray * fieldNames = [select componentsSeparatedByString:@","];
    if ( fieldNames.count > 0 )
    {
        for ( NSString * item in fieldNames )
        {
            NSString *field = item.trim.unwrap;
            if ( field.length )
            {
                [_select addObject:field];
            }
        }
    }
    else
    {
        NSMutableString * sql = [NSMutableString string];
        
        if ( type && type.length )
        {
            [sql appendFormat:@"%@(%@)", type, select.trim.unwrap];
        }
        else
        {
            [sql appendFormat:@"%@", select.trim.unwrap];
        }
        
        if ( nil == alias || 0 == alias.length )
        {
            alias = [self internalCreateAliasFromTable:alias];
        }
        
        if ( alias )
        {
            [sql appendFormat:@" AS %@", alias.trim.unwrap];
        }
        
        [_select addObject:sql];
    }
}

- (NSString *)internalCreateAliasFromTable:(NSString *)name
{
    NSRange range = [name rangeOfString:@"."];
    if ( range.length )
    {
        NSArray * array = [name componentsSeparatedByString:@"."];
        if ( array && array.count )
        {
            return array.lastObject;
        }
    }
    
    return name;
}

- (void)internalWhere:(NSString *)key expr:(NSString *)expr value:(NSObject *)value type:(NSString *)type
{
    key = key.trim.unwrap;;
    
    NSString *			prefix = (0 == _where.count) ? @"" : type;
    NSMutableString *	sql = [NSMutableString string];
    
    if ( nil == value || [value isKindOfClass:[NSNull class]] )
    {
        [sql appendFormat:@"%@ %@ IS NULL", prefix, key];
    }
    else
    {
        if ( [value isKindOfClass:[NSNumber class]] )
        {
            [sql appendFormat:@"%@ %@ %@ %@", prefix, key, expr, value];
        }
        else
        {
            [sql appendFormat:@"%@ %@ %@ '%@'", prefix, key, expr, value];
        }
    }
    
    if(_wrap)
    {
        NSMutableArray *arrWrap = _where.lastObject;
        [arrWrap addObject:sql];
    }
    else
    {
        [_where addObject:sql];
    }
}

- (void)internalWhereIn:(NSString *)key values:(NSArray *)values invert:(BOOL)invert type:(NSString *)type
{
    if ( nil == key || nil == values || 0 == values.count )
        return;
    
    NSMutableString * sql = [NSMutableString string];
    
    if ( _where.count )
    {
        [sql appendFormat:@"%@ ", type];
    }
    
    [sql appendFormat:@"%@", key.trim.unwrap];
    
    if ( invert )
    {
        [sql appendString:@" NOT"];
    }
    
    [sql appendString:@" IN ("];
    
    for ( NSInteger i = 0; i < values.count; ++i )
    {
        NSObject * value = [values objectAtIndex:i];
        
        if ( i > 0 )
        {
            [sql appendFormat:@", "];
        }
        
        if ( [value isKindOfClass:[NSNumber class]] )
        {
            [sql appendFormat:@"%@", value];
        }
        else
        {
            [sql appendFormat:@"'%@'", value];
        }
    }
    
    [sql appendString:@")"];
    
    if(_wrap)
    {
        NSMutableArray *arrWrap = _where.lastObject;
        [arrWrap addObject:sql];
    }
    else
    {
        [_where addObject:sql];
    }
}

- (void)internalLike:(NSString *)field match:(NSObject *)match type:(NSString *)type side:(NSString *)side invert:(BOOL)invert
{
    if ( nil == field || nil == match )
        return;
    
    NSString * value = nil;
    
    if ( [side isEqualToString:@"before"] )
    {
        value = [NSString stringWithFormat:@"%%%@", match];
    }
    else if ( [side isEqualToString:@"after"] )
    {
        value = [NSString stringWithFormat:@"%@%%", match];
    }
    else
    {
        value = [NSString stringWithFormat:@"%%%@%%", match];
    }
    
    NSMutableString * sql = [NSMutableString string];
    
    if ( _like.count )
    {
        [sql appendString:type];
    }
    
    [sql appendFormat:@" %@", field.trim.unwrap];
    
    if ( invert )
    {
        [sql appendString:@" NOT"];
    }
    
    [sql appendFormat:@" LIKE '%@'", value];
    
    [_like addObject:sql];
}

- (void)internalHaving:(NSString *)key value:(NSObject *)value type:(NSString *)type
{
    if ( nil == key || nil == value )
        return;
    
    [_having addObject:[NSArray arrayWithObjects:key, value, type, nil]];
}

- (void)internalOrderBy:(NSString *)by direction:(NSString *)direction
{
    if ( nil == by || nil == direction )
        return;
    
    [_orderby addObject:[NSArray arrayWithObjects:by, direction, nil]];
}

#pragma mark -

- (NSString *)internalCompileSelect:(NSString *)override
{
    NSMutableString * sql = [NSMutableString string];
    
    if ( override )
    {
        [sql appendString:override];
    }
    else
    {
        if ( _distinct )
        {
            [sql appendString:@"SELECT DISTINCT "];
        }
        else
        {
            [sql appendString:@"SELECT "];
        }
        
        if ( _select.count )
        {
            [_select sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSString * left = (NSString *)obj1;
                NSString * right = (NSString *)obj2;
                return [left compare:right options:NSCaseInsensitiveSearch];
            }];
            
            for ( NSInteger i = 0; i < _select.count; ++i )
            {
                NSString * select = [_select objectAtIndex:i];
                
                if ( 0 == i )
                {
                    [sql appendFormat:@"%@", select];
                }
                else
                {
                    [sql appendFormat:@", %@", select];
                }
            }
        }
        else
        {
            [sql appendString:@"*"];
        }
    }
    
    if ( _from.count )
    {
        [sql appendString:@" FROM "];
        
        for ( NSInteger i = 0; i < _from.count; ++i )
        {
            NSString * from = [_from objectAtIndex:i];
            
            if ( 0 == i )
            {
                [sql appendString:from];
            }
            else
            {
                [sql appendFormat:@", %@", from];
            }
        }
    }
    else
    {
        [sql appendFormat:@" FROM %@ ", [[self modelClass] tableName]];
    }
    
    if ( _where.count || _like.count )
    {
        [sql appendString:@" WHERE"];
    }
    
    if ( _where.count )
    {
        for ( id where in _where )
        {
            if([where isKindOfClass:[NSArray class]])
            {
                [sql appendFormat:@" %@ ", [(NSArray *)where componentsJoinedByString:@" "]];
            }
            else
            {
                [sql appendFormat:@" %@ ", where];
            }
        }
    }
    
    if ( _like.count )
    {
        if ( _where.count )
        {
            [sql appendString:@" AND "];
        }
        
        for ( NSString * like in _like )
        {
            [sql appendFormat:@" %@ ", like];
        }
    }
    
    if ( _groupby.count )
    {
        [sql appendString:@" GROUP BY "];
        
        for ( NSInteger i = 0; i < _groupby.count; ++i )
        {
            NSString * by = [_groupby objectAtIndex:i];
            
            if ( 0 == i )
            {
                [sql appendFormat:@"%@", by];
            }
            else
            {
                [sql appendFormat:@", %@", by];
            }
        }
    }
    
    if ( _having.count )
    {
        [sql appendString:@" HAVING "];
        
        for ( NSInteger i = 0; i < _having.count; ++i )
        {
            NSArray *	array = [_orderby objectAtIndex:i];
            NSString *	key = [array safeObjectAtIndex:0];
            NSString *	value = [array safeObjectAtIndex:1];
            NSString *	type = [array safeObjectAtIndex:2];
            
            if ( type )
            {
                [sql appendFormat:@"%@ ", type];
            }
            
            if ( [value isKindOfClass:[NSNull class]] )
            {
                [sql appendFormat:@"%@ IS NULL ", key];
            }
            else if ( [value isKindOfClass:[NSNumber class]] )
            {
                [sql appendFormat:@"%@ = %@ ", key, value];
            }
            else if ( [value isKindOfClass:[NSString class]] )
            {
                [sql appendFormat:@"%@ = '%@' ", key, value];
            }
            else
            {
                [sql appendFormat:@"%@ = '%@' ", key, value];
            }
        }
    }
    
    if ( _orderby.count )
    {
        [sql appendString:@" ORDER BY "];
        
        for ( NSInteger i = 0; i < _orderby.count; ++i )
        {
            NSArray *	array = [_orderby objectAtIndex:i];
            NSString *	by = [array safeObjectAtIndex:0];
            NSString *	dir = [array safeObjectAtIndex:1];
            
            if ( 0 == i )
            {
                [sql appendFormat:@"%@ %@", by, dir];
            }
            else
            {
                [sql appendFormat:@", %@ %@", by, dir];
            }
        }
    }
    
    if ( _limit )
    {
        if ( _offset )
        {
            [sql appendFormat:@" LIMIT %llu, %llu", (unsigned long long)_offset, (unsigned long long)_limit];
        }
        else
        {
            [sql appendFormat:@" LIMIT %llu", (unsigned long long)_limit];
        }
    }
    
    return sql;
}

- (NSString *)internalCompileInsert:(NSString *)table values:(NSMutableArray *)allValues
{
    NSMutableString *	sql = [NSMutableString string];
    NSMutableArray *	allKeys = [NSMutableArray arrayWithArray:_set.allKeys];
    
    NSString *			field = nil;
    NSObject *			value = nil;
    
    [allKeys sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * left = (NSString *)obj1;
        NSString * right = (NSString *)obj2;
        return [left compare:right options:NSCaseInsensitiveSearch];
    }];
    
    [sql appendFormat:@"INSERT INTO %@ (", table];
    
    for ( NSInteger i = 0; i < allKeys.count; ++i )
    {
        if ( 0 != i )
        {
            [sql appendString:@", "];
        }
        
        [sql appendString:@"\n"];
        
        NSString * key = [allKeys objectAtIndex:i];
        
        field = key.trim.unwrap;
        value = [_set objectForKey:key];
        
        [sql appendString:field];
        [allValues addObject:value];
    }
    
    [sql appendString:@") VALUES ("];
    
    for ( NSInteger i = 0; i < allValues.count; ++i )
    {
        if ( 0 != i )
        {
            [sql appendString:@", "];
        }
        
        [sql appendString:@"\n"];
        [sql appendString:@"?"];
    }
    
    [sql appendString:@")"];
    
    return sql;
}

- (NSString *)internalCompileReplace:(NSString *)table values:(NSMutableArray *)allValues
{
    NSMutableString *	sql = [NSMutableString string];
    NSMutableArray *	allKeys = [NSMutableArray arrayWithArray:_set.allKeys];
    
    NSString *			field = nil;
    NSObject *			value = nil;
    
    [allKeys sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * left = (NSString *)obj1;
        NSString * right = (NSString *)obj2;
        return [left compare:right options:NSCaseInsensitiveSearch];
    }];
    
    [sql appendFormat:@"REPLACE INTO %@ (", table];
    
    for ( NSInteger i = 0; i < allKeys.count; ++i )
    {
        if ( 0 != i )
        {
            [sql appendString:@", "];
        }
        
        [sql appendString:@"\n"];
        
        NSString * key = [allKeys objectAtIndex:i];
        
        field = key.trim.unwrap;
        value = [_set objectForKey:key];
        
        [sql appendString:field];
        [allValues addObject:value];
    }
    
    [sql appendString:@") VALUES ("];
    
    for ( NSInteger i = 0; i < allValues.count; ++i )
    {
        if ( 0 != i )
        {
            [sql appendString:@", "];
        }
        
        [sql appendString:@"\n"];
        [sql appendString:@"?"];
    }
    
    [sql appendString:@")"];
    
    return sql;
}

- (NSString *)internalCompileUpdate:(NSString *)table values:(NSMutableArray *)allValues
{
    NSMutableString *	sql = [NSMutableString string];
    NSMutableArray *	allKeys = [NSMutableArray arrayWithArray:_set.allKeys];
    
    NSString *			field = nil;
    NSString *			key = nil;
    NSObject *			value = nil;
    
    [allKeys sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * left = (NSString *)obj1;
        NSString * right = (NSString *)obj2;
        return [left compare:right options:NSCaseInsensitiveSearch];
    }];
    
    [sql appendFormat:@"UPDATE %@ SET ", table];
    
    for ( NSInteger i = 0; i < allKeys.count; ++i )
    {
        if ( 0 != i )
        {
            [sql appendString:@", "];
        }
        
        [sql appendString:@"\n"];
        
        key = [allKeys objectAtIndex:i];
        field = key.trim.unwrap;
        value = [_set objectForKey:key];
        
        [sql appendFormat:@"%@ = ?", field];
        [allValues addObject:value];
    }
    
    if ( _where.count )
    {
        [sql appendString:@"\n"];
        [sql appendString:@" WHERE"];
        
        for ( id where in _where )
        {
            if([where isKindOfClass:[NSArray class]])
            {
                [sql appendFormat:@" %@ ", [(NSArray *)where componentsJoinedByString:@" "]];
            }
            else
            {
                [sql appendFormat:@" %@ ", where];
            }
        }
    }
    
    if ( _orderby.count )
    {
        [sql appendString:@"\n"];
        [sql appendString:@" ORDER BY "];
        
        for ( NSInteger i = 0; i < _orderby.count; ++i )
        {
            NSString * by = [_orderby objectAtIndex:i];
            
            if ( 0 == i )
            {
                [sql appendString:by];
            }
            else
            {
                [sql appendFormat:@", %@", by];
            }
        }
    }
    
    if ( _limit )
    {
        [sql appendString:@"\n"];
        [sql appendFormat:@" LIMIT %lu", (unsigned long)_limit];
    }
    
    return sql;
}

- (NSString *)internalCompileCreate:(NSString *)table
{
    if(!_field.count)
    {
        for (WTProperty *prop in [[self modelClass] properties]) {
            if(!prop.readonly)
            {
                WTDatabaseFieldAttribute field = [[self modelClass] fieldOfProperty:prop.name];
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:prop.name forKey:@"name"];
                
                [self __internalExtendField:field toDictionary:dict];
                
                [_field addObject:dict];
            }
        }
    }
    
    NSMutableString * sql = [NSMutableString string];
    
    NSMutableArray * arrIndex = [NSMutableArray array];
    
    [sql appendFormat:@"CREATE TABLE IF NOT EXISTS %@ ( ", table];
    
    [_field sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString * left = (NSString *)[(NSDictionary *)obj1 objectForKey:@"name"];
        NSString * right = (NSString *)[(NSDictionary *)obj2 objectForKey:@"name"];
        return [left compare:right options:NSCaseInsensitiveSearch];
    }];
    
    for ( NSInteger i = 0; i < _field.count; ++i )
    {
        if ( 0 != i )
        {
            [sql appendString:@", "];
        }
        
        [sql appendString:@"\n"];
        
        NSDictionary * dict = [_field objectAtIndex:i];
        
        NSString * name = (NSString *)[dict objectForKey:@"name"];
        NSString * type = (NSString *)[dict objectForKey:@"type"];
        NSNumber * size = (NSNumber *)[dict objectForKey:@"size"];
        NSNumber * PK = (NSNumber *)[dict objectForKey:@"primaryKey"];
        NSNumber * AI = (NSNumber *)[dict objectForKey:@"autoIncrement"];
        NSNumber * IX = (NSNumber *)[dict objectForKey:@"index"];
        NSNumber * UN = (NSNumber *)[dict objectForKey:@"unique"];
        NSNumber * NN = (NSNumber *)[dict objectForKey:@"nonNull"];
        
        NSObject * defaultValue = [dict objectForKey:@"defaultValue"];
        
        [sql appendFormat:@"%@", name];
        
        if ( type )
        {
            [sql appendFormat:@" %@", type];
        }
        
        if ( size && size.intValue )
        {
            [sql appendFormat:@"(%@)", size];
        }
        
        if ( PK && PK.boolValue )
        {
            [sql appendString:@" PRIMARY KEY"];
        }
        
        if ( AI && AI.boolValue )
        {
            [sql appendString:@" AUTOINCREMENT"];
        }
        
        if ( UN && UN.boolValue )
        {
            [sql appendString:@" UNIQUE"];
        }
        
        if ( NN && NN.boolValue )
        {
            [sql appendString:@" NOT NULL"];
        }
        
        if( IX && IX.boolValue )
        {
            [arrIndex addObject:[NSString stringWithFormat:@"CREATE INDEX IF NOT EXISTS ix_%@_%@ ON %@ (%@);", table, name, table, name]];
        }
        
        if ( defaultValue )
        {
            if ( [defaultValue isKindOfClass:[NSNull class]] )
            {
                [sql appendString:@" DEFAULT NULL"];
            }
            else if ( [defaultValue isKindOfClass:[NSNumber class]] )
            {
                [sql appendFormat:@" DEFAULT %@", defaultValue];
            }
            else if ( [defaultValue isKindOfClass:[NSString class]] )
            {
                [sql appendFormat:@" DEFAULT '%@'", defaultValue];
            }
            else
            {
                [sql appendFormat:@" DEFAULT '%@'", defaultValue];
            }
        }
    }
    
    [sql appendString:@" );\n"];
    
    if(arrIndex.count)
    {
        [sql appendString:[arrIndex componentsJoinedByString:@"\n"]];
    }
    return sql;
}

- (NSString *)internalCompileEmpty:(NSString *)table
{
    NSString * sql = [NSString stringWithFormat:@"DELETE FROM %@", table];
    return sql;
}

- (NSString *)internalCompileDelete:(NSString *)table
{
    NSMutableString * sql = [NSMutableString string];
    
    [sql appendFormat:@"DELETE FROM %@", table];
    
    if ( _where.count || _like.count )
    {
        [sql appendString:@" WHERE "];
        
        if ( _where.count )
        {
            for ( id where in _where )
            {
                if([where isKindOfClass:[NSArray class]])
                {
                    [sql appendFormat:@" %@ ", [(NSArray *)where componentsJoinedByString:@" "]];
                }
                else
                {
                    [sql appendFormat:@" %@ ", where];
                }
            }
        }
        
        if ( _like.count )
        {
            if ( _where.count )
            {
                [sql appendString:@" AND "];
            }
            
            for ( NSString * like in _like )
            {
                [sql appendFormat:@" %@ ", like];
            }
        }
    }
    
    if ( _limit )
    {
        [sql appendFormat:@" LIMIT %lu", (unsigned long)_limit];
    }
    
    return sql;
}

- (NSString *)internalCompileDrop:(NSString *)table
{
    return [NSString stringWithFormat:@"DROP TABLE IF EXISTS %@", table];
}

#pragma mark -

- (WTDatabaseBlockN)TABLE
{
    return ^ WTDatabase * ( id value, ... )
    {
        if(![_table containsObject:value])
        {
            [_table addObject:value];
        }
        return self;
    };
}

- (WTDatabaseBlockF)FIELD
{
    return ^ WTDatabase * (NSString *key, WTDatabaseFieldAttribute field )
    {
        BOOL found = NO;
        
        for ( NSMutableDictionary * dict in _field )
        {
            NSString * existName = [dict objectForKey:@"name"];
            if ( [key isEqualToString:existName] )
            {
                [self __internalExtendField:field toDictionary:dict];
                
                found = YES;
                break;
            }
        }
        
        if ( NO == found )
        {
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            [dict setObject:key forKey:@"name"];
            [self __internalExtendField:field toDictionary:dict];
            
            [_field addObject:dict];
        }
        return self;
    };
}

- (WTDatabaseBlockV)CREATE
{
    return ^ WTDatabase * ( void )
    {
        NSString *table = [[self modelClass] tableName];
        NSString *sql = [self internalCompileCreate:table];
        [self __internalResetCreate];
        
        [self.db executeUpdate:sql];
        
        return self;
    };
}

- (WTDatabaseBlock)SELECT
{
    return ^ WTDatabase * ( id value )
    {
        [self internalSelect:(NSString *)value alias:nil type:nil];
        return self;
    };
}

- (WTDatabaseBlock)SELECT_MAX
{
    return ^ WTDatabase * ( id value )
    {
        [self internalSelect:(NSString *)value alias:nil type:@"MAX"];
        return self;
    };
}

- (WTDatabaseBlockP)SELECT_MAX_ALIAS
{
    return ^ WTDatabase * ( NSString *key, id value )
    {
        [self internalSelect:key alias:value type:@"MAX"];
        return self;
    };
}

- (WTDatabaseBlock)SELECT_MIN
{
    return ^ WTDatabase * ( id value )
    {
        [self internalSelect:(NSString *)value alias:nil type:@"MIN"];
        return self;
    };
}

- (WTDatabaseBlockP)SELECT_MIN_ALIAS
{
    return ^ WTDatabase * ( NSString *key, id value )
    {
        [self internalSelect:key alias:value type:@"MIN"];
        return self;
    };
}

- (WTDatabaseBlock)SELECT_AVG
{
    return ^ WTDatabase * ( id value )
    {
        [self internalSelect:(NSString *)value alias:nil type:@"AVG"];
        return self;
    };
}

- (WTDatabaseBlockP)SELECT_AVG_ALIAS
{
    return ^ WTDatabase * ( NSString *key, id value )
    {
        [self internalSelect:key alias:value type:@"AVG"];
        return self;
    };
}

- (WTDatabaseBlock)SELECT_SUM
{
    return ^ WTDatabase * ( id value )
    {
        [self internalSelect:(NSString *)value alias:nil type:@"SUM"];
        return self;
    };
}

- (WTDatabaseBlockP)SELECT_SUM_ALIAS
{
    return ^ WTDatabase * ( NSString *key, id value )
    {
        [self internalSelect:key alias:value type:@"SUM"];
        return self;
    };
}

- (WTDatabaseBlockV)DISTINCT
{
    return ^ WTDatabase * ( void )
    {
        _distinct = YES;
        return self;
    };
}

- (WTDatabaseBlock)FROM
{
    return ^ WTDatabase * ( id value )
    {
        if(![_from containsObject:value])
        {
            [_from addObject:value];
        }
        return self;
    };
}

- (WTDatabaseBlock)WRAP
{
    NSAssert(!_wrap, @"Multinest wrapping is nonsupport.");
    
    _wrap = YES;
    [_where addObject:[NSMutableArray array]];
    
    return ^ WTDatabase * ( id val )
    {
        if(![val isKindOfClass:[WTDatabase class]])
        {
            WTDatabaseVoidBlock block = (WTDatabaseVoidBlock)val;
            block(val);
        }
        _wrap = NO;
        return val;
    };
}

- (WTDatabaseBlockN)WHERE
{
    return ^ WTDatabase * ( id value, ... )
    {
        va_list args;
        va_start( args, value );
        
        NSString *field = nil;
        NSInteger index = 0;
        
        for ( ;; value = nil, ++index) 
        {
            NSObject * val = value ? : va_arg( args, NSObject * );
            if ( nil == val || [WTRuntime typeOfClass:[val class]] == WTRuntimeTypeObject)
                break;
            
            if ( [val isKindOfClass:[NSDictionary class]] )
            {
                NSDictionary *dict = (NSDictionary *)val;
                for (NSString *key in dict.allKeys)
                {
                    [self internalWhere:key expr:@"=" value:[dict objectForKey:key] type:@"AND"];
                }
                break;
            }
            else
            {
                if(index%2 == 1)
                {
                    [self internalWhere:field expr:@"=" value:val type:@"AND"];
                }
                else
                {
                    field = (NSString *)val;
                }
            }
        }
        va_end( args );
        
        return self;
    };
}

- (WTDatabaseBlockN)OR_WHERE
{
    return ^ WTDatabase * ( id value, ... )
    {
        va_list args;
        va_start( args, value );
        
        NSString *field = nil;
        NSInteger index = 0;
        
        for ( ;; value = nil, ++index)
        {
            NSObject * val = value ? : va_arg( args, NSObject * );
            if ( nil == val || [WTRuntime typeOfClass:[val class]] == WTRuntimeTypeObject)
                break;
            
            if ( [val isKindOfClass:[NSDictionary class]] )
            {
                NSDictionary *dict = (NSDictionary *)val;
                for (NSString *key in dict.allKeys)
                {
                    [self internalWhere:key expr:@"=" value:[dict objectForKey:key] type:@"OR"];
                }
                break;
            }
            else
            {
                if(index%2 == 1)
                {
                    [self internalWhere:field expr:@"=" value:val type:@"OR"];
                }
                else
                {
                    field = (NSString *)val;
                }
            }
        }
        va_end( args );
        
        return self;
    };
}

- (WTDatabaseBlockN)WHERE_OPERATOR
{
    return ^ WTDatabase * ( NSString *first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * key = (NSString *)first;
        NSString * expr = (NSString *)va_arg( args, NSString * );
        NSObject * value = (NSObject *)va_arg( args, NSObject * );
        
        va_end( args );
        
        [self internalWhere:key expr:expr value:value type:@"AND"];
        return self;
    };
}

- (WTDatabaseBlockN)OR_WHERE_OPERATOR
{
    return ^ WTDatabase * ( id first, ... )
    {
        va_list args;
        va_start( args, first );
        
        NSString * key = (NSString *)first;
        NSString * expr = (NSString *)va_arg( args, NSString * );
        NSObject * value = (NSObject *)va_arg( args, NSObject * );
        
        va_end( args );
        
        [self internalWhere:key expr:expr value:value type:@"OR"];
        return self;
    };
}

- (WTDatabaseBlockN)WHERE_IN
{
    return ^ WTDatabase * ( id field, ... )
    {
        va_list args;
        va_start( args, field );
        
        NSString * key = (NSString *)field;
        
        NSMutableArray * array = [NSMutableArray array];
        for ( ;; )
        {
            NSObject * value = va_arg( args, NSObject * );
            if ( nil == value )
                break;
            
            if ( [value isKindOfClass:[NSArray class]] )
            {
                [array addObjectsFromArray:(id)value];
            }
            else
            {
                [array addObject:(NSString *)value];
            }
        }
        va_end( args );
        
        [self internalWhereIn:key values:array invert:NO type:@"AND"];
        return self;
    };
}

- (WTDatabaseBlockN)OR_WHERE_IN
{
    return ^ WTDatabase * ( id field, ... )
    {
        va_list args;
        va_start( args, field );
        
        NSString * key = (NSString *)field;
        
        NSMutableArray * array = [NSMutableArray array];
        for ( ;; )
        {
            NSObject * value = va_arg( args, NSObject * );
            if ( nil == value )
                break;
            
            if ( [value isKindOfClass:[NSArray class]] )
            {
                [array addObjectsFromArray:(id)value];
            }
            else
            {
                [array addObject:(NSString *)value];
            }
        }
        va_end( args );
        
        [self internalWhereIn:key values:array invert:NO type:@"OR"];
        return self;
    };
}

- (WTDatabaseBlockN)WHERE_NOT_IN
{
    return ^ WTDatabase * ( id field, ... )
    {
        va_list args;
        va_start( args, field );
        
        NSString * key = (NSString *)field;
        
        NSMutableArray * array = [NSMutableArray array];
        for ( ;; )
        {
            NSObject * value = va_arg( args, NSObject * );
            if ( nil == value )
                break;
            
            if ( [value isKindOfClass:[NSArray class]] )
            {
                [array addObjectsFromArray:(id)value];
            }
            else
            {
                [array addObject:(NSString *)value];
            }
        }
        va_end( args );
        
        [self internalWhereIn:key values:array invert:YES type:@"AND"];
        return self;
    };
}

- (WTDatabaseBlockN)OR_WHERE_NOT_IN
{
    return ^ WTDatabase * ( id field, ... )
    {
        va_list args;
        va_start( args, field );
        
        NSString * key = (NSString *)field;
        
        NSMutableArray * array = [NSMutableArray array];
        for ( ;; )
        {
            NSObject * value = va_arg( args, NSObject * );
            if ( nil == value )
                break;
            
            if ( [value isKindOfClass:[NSArray class]] )
            {
                [array addObjectsFromArray:(id)value];
            }
            else
            {
                [array addObject:(NSString *)value];
            }
        }
        va_end( args );
        
        [self internalWhereIn:key values:array invert:YES type:@"OR"];
        return self;
    };
}

- (WTDatabaseBlockP)LIKE
{
    return ^ WTDatabase * ( NSString *key, id value )
    {
        [self internalLike:key match:value type:@"AND" side:@"both" invert:NO];
        return self;
    };
}

- (WTDatabaseBlockP)NOT_LIKE
{
    return ^ WTDatabase * ( NSString *key, id value )
    {
        [self internalLike:key match:value type:@"AND" side:@"both" invert:YES];
        return self;
    };
}

- (WTDatabaseBlockP)OR_LIKE
{
    return ^ WTDatabase * ( NSString *key, id value )
    {
        [self internalLike:key match:value type:@"OR" side:@"both" invert:NO];
        return self;
    };
}

- (WTDatabaseBlockP)OR_NOT_LIKE
{
    return ^ WTDatabase * ( NSString *key, id value )
    {
        [self internalLike:key match:value type:@"OR" side:@"both" invert:YES];
        return self;
    };
}

- (WTDatabaseBlock)GROUP_BY
{
    return ^ WTDatabase * ( id value )
    {
        [self internalGroupBy:value];
        return self;
    };
}

- (WTDatabaseBlockP)HAVING
{
    return ^ WTDatabase * ( NSString *key, id value )
    {
        [self internalHaving:key value:value type:@"AND"];
        return self;
    };
}

- (WTDatabaseBlockP)OR_HAVING
{
    return ^ WTDatabase * ( NSString *key, id value )
    {
        [self internalHaving:key value:value type:@"OR"];
        return self;
    };
}

- (WTDatabaseBlock)ORDER_ASC_BY
{
    return ^ WTDatabase * ( id value )
    {
        [self internalOrderBy:value direction:@"ASC"];
        return self;
    };
}

- (WTDatabaseBlock)ORDER_DESC_BY
{
    return ^ WTDatabase * ( id value )
    {
        [self internalOrderBy:value direction:@"DESC"];
        return self;
    };
}

- (WTDatabaseBlock)ORDER_RAND_BY
{
    return ^ WTDatabase * ( id value )
    {
        [self internalOrderBy:value direction:@"RAND()"];
        return self;
    };
}

- (WTDatabaseBlockP)ORDER_BY
{
    return ^ WTDatabase * ( NSString *key, id value )
    {
        [self internalOrderBy:key direction:value];
        return self;
    };
}

- (WTDatabaseBlockU)LIMIT
{
    return ^ WTDatabase * ( NSUInteger value )
    {
        _limit = value;
        return self;
    };
}

- (WTDatabaseBlockU)OFFSET
{
    return ^ WTDatabase * ( NSUInteger value )
    {
        _offset = value;
        return self;
    };
}

- (WTDatabaseBlock)SET_NULL
{
    return ^ WTDatabase * ( id value )
    {
        [_set setObject:[NSNull null] forKey:value];
        return self;
    };
}

- (WTDatabaseBlockN)SET
{
    return ^ WTDatabase * (id value, ... )
    {
        va_list args;
        va_start( args, value );
        
        NSString *field = nil;
        NSInteger index = 0;
        
        for ( ;; value = nil, ++index)
        {
            NSObject * val = value ? : va_arg( args, NSObject * );
            if ( nil == val || [WTRuntime typeOfClass:[val class]] == WTRuntimeTypeObject)
                break;
            
            if ( [val isKindOfClass:[NSDictionary class]] )
            {
                [_set setDictionary:(NSDictionary *)val];
                break;
            }
            else
            {
                if(index%2 == 1)
                {
                    [_set setObject:val forKey:field];
                }
                else
                {
                    field = (NSString *)val;
                }
            }
        }
        va_end( args );
        
        return self;
    };
}

- (WTDatabaseIntBlockV)INSERT
{
    return ^ NSInteger ( void )
    {
        if ( _set.count )
        {
            NSString *table = [[self modelClass] tableName];
            
            NSMutableArray * allValues = [NSMutableArray array];
            NSString * sql = [self internalCompileInsert:table values:allValues];
            
            [self __internalResetWrite];
            
            BOOL ret = [self.db executeUpdate:sql withArgumentsInArray:allValues];
            if ( ret )
            {
                return (NSInteger)self.db.lastInsertRowId;
            }
        }
        return -1;
    };
}

- (WTDatabaseUintBlockV)UPDATE
{
    return ^ NSUInteger ( void )
    {
        if ( _set.count )
        {
            NSString *table = [[self modelClass] tableName];
            
            NSMutableArray * allValues = [NSMutableArray array];
            NSString * sql = [self internalCompileUpdate:table values:allValues];
            
            [self __internalResetWrite];
            
            BOOL ret = [self.db executeUpdate:sql withArgumentsInArray:allValues];
            if ( ret )
            {
                return self.db.changes;
            }
        }
        return 0;
    };
}

- (WTDatabaseIntBlockV)REPLACE
{
    return ^ NSInteger ( void )
    {
        if ( _set.count )
        {
            NSString *table = [[self modelClass] tableName];
            
            NSMutableArray * allValues = [NSMutableArray array];
            NSString * sql = [self internalCompileReplace:table values:allValues];
            
            [self __internalResetWrite];
            
            BOOL ret = [self.db executeUpdate:sql withArgumentsInArray:allValues];
            if ( ret )
            {
                NSInteger rowId = (NSInteger)self.db.lastInsertRowId;
                if(rowId)
                {
                    return (NSInteger)rowId;
                }
                return 0;
            }
        }
        return -1;
    };
}

- (WTDatabaseBoolBlockV)EMPTY
{
    return ^ BOOL ( void )
    {
        NSString *table = [[self modelClass] tableName];
        
        NSString * sql = [self internalCompileEmpty:table];
        
        [self __internalResetWrite];
        
        return [self.db executeUpdate:sql];
    };
}

- (WTDatabaseBoolBlockV)DROP
{
    return ^ BOOL ( void )
    {
        NSString *table = [[self modelClass] tableName];
        
        NSString * sql = [self internalCompileDrop:table];
        
        [self __internalResetWrite];
        
        return [self.db executeUpdate:sql];
    };
}

- (WTDatabaseBoolBlockV)DELETE
{
    return ^ BOOL ( void )
    {
        NSString * sql = [self internalCompileDelete:[[self modelClass] tableName]];
        
        [self __internalResetWrite];
        
        return [self.db executeUpdate:sql];
    };
}

- (WTDatabaseUintBlockV)COUNT
{
    return ^ NSUInteger ( void )
    {
        NSString * sql = [self internalCompileSelect:@"SELECT COUNT(*)"];
        [self __internalResetSelect];
        
        return [self.db intForQuery:sql];
    };
}

- (WTDatabaseArrayBlockV)GET
{
    return ^ NSArray * ( void )
    {
        NSString * sql = [self internalCompileSelect:nil];
        
        [self __internalResetSelect];
        
        FMResultSet * result = [self.db executeQuery:sql];
        if ( result )
        {
            NSMutableArray *arrResult = [NSMutableArray array];
            while ( [result next] )
            {
                NSDictionary * dict = [result resultDictionary];
                [arrResult addObject:[[self modelClass] objectFromDictionary:dict]];
            }
            return arrResult;
        }
        return nil;
    };
}

- (WTDatabaseObjectBlockV)GET_FIRST
{
    return ^ id ( void )
    {
        _limit = 1;
        _offset = 0;
        
        NSString * sql = [self internalCompileSelect:nil];
        
        [self __internalResetSelect];
        
        FMResultSet * result = [self.db executeQuery:sql];
        if ( result )
        {
            if ( [result next] )
            {
                NSDictionary * dict = [result resultDictionary];
                return [[self modelClass] objectFromDictionary:dict];
            }
        }
        return nil;
    };
}

@end

#import "_pragma_pop.h"

