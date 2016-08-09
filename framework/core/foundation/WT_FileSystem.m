//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_FileSystem.m
//  WTFramework
//

#import "WT_FileSystem.h"

@interface WTFileSystem ()

@property (nonatomic, copy) NSString *baseDirectory;

@end

@implementation WTFileSystem

@def_singleton(WTFileSystem)

- (NSString *)baseDirectory
{
    if(!_baseDirectory)
    {
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        _baseDirectory = [array objectAtIndex:0];
    }
    return _baseDirectory;
}

+ (NSString *)baseDirectory
{
    return [WTFileSystem sharedInstance].baseDirectory;
}

+ (void)setSharedGroupIdentifier:(NSString *)groupId
{
    NSURL *url = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:groupId];
    if(url)
    {
        NSString *fullPath = [url relativePath];
        if([fullPath hasPrefix:@"/private/"])
        {
            [WTFileSystem sharedInstance].baseDirectory = [fullPath substringFromIndex:8];
        }
    }
}

@end
