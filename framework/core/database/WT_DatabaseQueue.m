//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_DatabaseQueue.m
//  WTFramework
//

#import "WT_DatabaseQueue.h"

#import "WT_System.h"
#import "WT_FileSystem.h"

@implementation WTDatabaseQueue
{
    FMDatabaseQueue *_dbQueue;
}

@def_singleton(WTDatabaseQueue)

- (FMDatabaseQueue *)dbQueue
{
    if(!_dbQueue)
    {
        NSString *dir = [[WTFileSystem baseDirectory] stringByAppendingPathComponent:@"Documents/Database/"];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:NULL] ) {
            BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
            if ( !result ) {
                return nil;
            }
        }
        
        NSString * bundleName = [WTSystem appBundleName];
        if ( nil == bundleName )
        {
            bundleName = @"default";
        }
        NSString *dbName = [NSString stringWithFormat:@"%@.sqlite", bundleName];
        NSString *path = [dir stringByAppendingPathComponent:dbName];
        
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    }
    return _dbQueue;
}

+ (void)inDatabase:(void (^)(WTDatabase *))block
{
    [[[self sharedInstance] dbQueue] inDatabase:^(FMDatabase *db) {
        WTDatabase *database = [WTDatabase databaseWithFMDB:db];
        block(database);
    }];
}

+ (void)inTransaction:(void (^)(WTDatabase *, BOOL *))block
{
    [[[self sharedInstance] dbQueue] inTransaction:^(FMDatabase *db, BOOL *rollback) {
        WTDatabase *database = [WTDatabase databaseWithFMDB:db];
        block(database, rollback);
    }];
}

+ (void)inDeferredTransaction:(void (^)(WTDatabase *, BOOL *))block
{
    [[[self sharedInstance] dbQueue] inDeferredTransaction:^(FMDatabase *db, BOOL *rollback) {
        WTDatabase *database = [WTDatabase databaseWithFMDB:db];
        block(database, rollback);
    }];
}

@end