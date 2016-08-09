//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Notification.m
//  WTFramework
//

#import "WT_Notification.h"

#import "NSObject+WT_Extension.h"

@implementation NSNotification(WT_Extension)

- (BOOL)is:(NSString *)name
{
    return [self.name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix
{
    return [self.name hasPrefix:prefix];
}

@end

@implementation NSObject(WT_Notification)

- (void)onNotification:(NSNotification *)notification
{
}

- (void)observeNotification:(NSString *)notificationName
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:notificationName
                                                  object:nil];
    
    NSString * selectorName;
    SEL selector;
    
    NSArray * array = [notificationName componentsSeparatedByString:@"."];
    if ( array && array.count > 1 )
    {
        //		NSString * prefix = (NSString *)[array objectAtIndex:0];
        NSString * clazz = (NSString *)[array objectAtIndex:1];
        NSString * name = (NSString *)[array objectAtIndex:2];
        
        {
            
            selectorName = [NSString stringWithFormat:@"onNotification_%@_%@:", clazz, name];
            selector = NSSelectorFromString(selectorName);
            
            if ( [self respondsToSelector:selector] )
            {
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:selector
                                                             name:notificationName
                                                           object:nil];
                return;
            }
            
            selectorName = [NSString stringWithFormat:@"onNotification_%@:", clazz];
            selector = NSSelectorFromString(selectorName);
            
            if ( [self respondsToSelector:selector] )
            {
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:selector
                                                             name:notificationName
                                                           object:nil];
                return;
            }
        }
    }
    
    selectorName = [NSString stringWithFormat:@"onNotification_%@:", notificationName];
    selector = NSSelectorFromString(selectorName);
    if ( [self respondsToSelector:selector] )
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:selector
                                                     name:notificationName
                                                   object:nil];
        return;
    }
    
    selector = NSSelectorFromString(@"onNotification:");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:selector
                                                 name:notificationName
                                               object:nil];
}

- (void)observeAllNotifications
{
    NSArray * methods = [[self class] methodsWithPrefix:@"onNotification_" untilClass:[NSObject class]];
    
    if ( nil == methods || 0 == methods.count )
    {
        return;
    }
    
    for ( NSString * selectorName in methods )
    {
        SEL sel = NSSelectorFromString( selectorName );
        if ( NULL == sel )
            continue;
        
        NSMutableString *notificationName = nil;
        SuppressPerformSelectorLeakWarning(
            notificationName = [self performSelector:sel];
        );
        if ( nil == notificationName  )
            continue;
        
        [self observeNotification:notificationName];
    }
}

- (void)unobserveNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)unobserveAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (BOOL)postNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
    return YES;
}

+ (BOOL)postNotification:(NSString *)name withObject:(id)object
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
    return YES;
}

- (BOOL)postNotification:(NSString *)name
{
    return [[self class] postNotification:name];
}

- (BOOL)postNotification:(NSString *)name withObject:(id)object
{
    return [[self class] postNotification:name withObject:object];
}

@end
