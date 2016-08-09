//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_FileSystem.h
//  WTFramework
//

#import "WT_Precompile.h"

@interface WTFileSystem : NSObject

@singleton(WTFileSystem)

+ (NSString *)baseDirectory;
+ (void)setSharedGroupIdentifier:(NSString *)groupId;

@end
