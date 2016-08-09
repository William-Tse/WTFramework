//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  UITextView+WT_Event.h
//  WTFramework
//

#import "WT_Precompile.h"

#import "WT_Signal.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (WT_Event)

@signal(TextChanged)
@signal(BeginEditing)
@signal(EndEditing)

+ (instancetype)textField;

@end

NS_ASSUME_NONNULL_END
