//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSObject+WT_Http.m
//  WTFramework
//

#import "NSObject+WT_Http.h"

#import "WT_Http.h"

#undef	KEY_REQUEST
#define KEY_REQUEST "NSObject.Request"

@implementation NSObject (WT_Http)

- (NSMutableArray *)requestSessions
{
    NSMutableArray *array = objc_getAssociatedObject( self, KEY_REQUEST );
    if(!array)
    {
        array = [NSMutableArray array];
        objc_setAssociatedObject( self, KEY_REQUEST, array, OBJC_ASSOCIATION_RETAIN );
    }
    return array;
}

- (void)responderWithSession:(NSURLSessionTask *)session
{
    NSMutableArray *array = [self requestSessions];
    if(![array containsObject:@(session.taskIdentifier)])
    {
        [array addObject:@(session.taskIdentifier)];
    }
}

- (void)cancelRequestByIdentifier:(NSUInteger)identifier
{
    NSMutableArray *array = objc_getAssociatedObject( self, KEY_REQUEST );
    if(array && array.count)
    {
        [WTHttp cancelRequestByIdentifier:identifier];
        [array removeObject:@(identifier)];
    }
}

- (void)cancelAllRequests
{
    NSMutableArray *array = objc_getAssociatedObject( self, KEY_REQUEST );
    if(array && array.count)
    {
        [WTHttp cancelRequestsByIdentifiers:array];
        [array removeAllObjects];
    }
}

@end