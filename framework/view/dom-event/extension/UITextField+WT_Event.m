//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  UITextField+WT_Event.m
//  WTFramework
//

#import "UITextField+WT_Event.h"

#import "NSObject+WT_Extension.h"
#import "NSDictionary+WT_Extension.h"
#import "WT_Notification.h"

@implementation UITextField (WT_Event)

@def_signal(TextChanged)
@def_signal(BeginEditing)
@def_signal(EndEditing)

+ (instancetype)textField
{
    UITextField *txt = [[self alloc] init];
    
    [txt observeNotification:UITextFieldTextDidChangeNotification];
    [txt observeNotification:UITextFieldTextDidBeginEditingNotification];
    [txt observeNotification:UITextFieldTextDidEndEditingNotification];
    
    return txt;
}

- (void)dealloc
{
    [self unobserveNotification:UITextFieldTextDidChangeNotification];
    [self unobserveNotification:UITextFieldTextDidBeginEditingNotification];
    [self unobserveNotification:UITextFieldTextDidEndEditingNotification];
}

- (void)onNotification_UITextFieldTextDidChangeNotification:(NSNotification *)notification
{
    [self sendSignal:self.TextChanged withObject:nil];
}

- (void)onNotification_UITextFieldTextDidBeginEditingNotification:(NSNotification *)notification
{
    [self sendSignal:self.BeginEditing withObject:nil];
}

- (void)onNotification_UITextFieldTextDidEndEditingNotification:(NSNotification *)notification
{
    [self sendSignal:self.EndEditing withObject:nil];
}

@end
