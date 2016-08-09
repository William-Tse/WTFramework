//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  WT_FileCache.h
//  WTFramework
//

#import "WT_FileCache.h"

#import "NSObject+WT_Extension.h"

#pragma mark -

@implementation WTFileCache
{
    NSString *_cachePath;
    NSString *_cacheUser;
    NSFileManager *_fileManager;
}

@def_singleton( WTFileCache );

- (id)init
{
	self = [super init];
	if ( self )
	{
		self.cacheUser = @"";
//		self.cachePath = [NSString stringWithFormat:@"%@/%@/Cache/", [BeeSandbox libCachePath], [BeeSystemInfo appVersion]];
		
		_fileManager = [[NSFileManager alloc] init];
	}
	return self;
}

- (NSString *)fileNameForKey:(NSString *)key
{
	NSString * pathName = nil;

	if ( self.cacheUser && [self.cacheUser length] )
	{
		pathName = [self.cachePath stringByAppendingFormat:@"%@/", self.cacheUser];
	}
	else
	{
		pathName = self.cachePath;
	}
	
	if ( NO == [_fileManager fileExistsAtPath:pathName] )
	{
		[_fileManager createDirectoryAtPath:pathName withIntermediateDirectories:YES attributes:nil error:nil];
	}
	return [pathName stringByAppendingString:key];
}

- (BOOL)hasObjectForKey:(id)key
{
	return [_fileManager fileExistsAtPath:[self fileNameForKey:key]];
}

- (id)objectForKey:(id)key
{
	return [NSData dataWithContentsOfFile:[self fileNameForKey:key]];
}

- (void)setObject:(id)object forKey:(id)key
{
	if ( nil == object )
	{
		[self removeObjectForKey:key];
	}
	else
	{
		NSData * data = [object toData];
		if ( data )
		{
			[data writeToFile:[self fileNameForKey:key]
					  options:NSDataWritingAtomic
						error:NULL];
		}
	}
}

- (void)removeObjectForKey:(NSString *)key
{
	[_fileManager removeItemAtPath:[self fileNameForKey:key] error:nil];
}

- (void)removeAllObjects
{
	[_fileManager removeItemAtPath:_cachePath error:NULL];
	[_fileManager createDirectoryAtPath:_cachePath
			withIntermediateDirectories:YES
							 attributes:nil
								  error:NULL];
}

- (id)objectForKeyedSubscript:(id)key
{
	return [self objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	[self setObject:obj forKey:key];
}

@end

