//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  UITextView+WT_Event.m
//  WTFramework
//

#import "UITextView+WT_Event.h"

#import "NSObject+WT_Extension.h"
#import "NSDictionary+WT_Extension.h"
#import "WT_Notification.h"

@implementation UITextView (WT_Event)

@def_signal(TextChanged)
@def_signal(BeginEditing)
@def_signal(EndEditing)

+ (instancetype)textField
{
    UITextView *txt = [[self alloc] init];
    
    [self observeNotification:UITextViewTextDidChangeNotification];
    [self observeNotification:UITextViewTextDidBeginEditingNotification];
    [self observeNotification:UITextViewTextDidEndEditingNotification];
    
    return txt;
}

- (void)dealloc
{
    [self unobserveNotification:UITextViewTextDidChangeNotification];
    [self unobserveNotification:UITextViewTextDidBeginEditingNotification];
    [self unobserveNotification:UITextViewTextDidEndEditingNotification];
}

- (void)onNotification_UITextViewTextDidChangeNotification:(NSNotification *)notification
{
    [self sendSignal:self.TextChanged withObject:nil];
}

- (void)onNotification_UITextViewTextDidBeginEditingNotification:(NSNotification *)notification
{
    [self sendSignal:self.BeginEditing withObject:nil];
}

- (void)onNotification_UITextViewTextDidEndEditingNotification:(NSNotification *)notification
{
    [self sendSignal:self.EndEditing withObject:nil];
}

@end
