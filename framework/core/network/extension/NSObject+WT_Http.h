//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSObject+WT_Http.h
//  WTFramework
//

#import "WT_Precompile.h"

@interface NSObject (WT_Http)

- (void)responderWithSession:(NSURLSessionTask *)session;

- (void)cancelRequestByIdentifier:(NSUInteger)identifier;
- (void)cancelAllRequests;

@end

