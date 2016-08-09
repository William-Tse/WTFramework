//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  UIButton+WT_Event.h
//  WTFramework
//

#import "WT_Precompile.h"

#import "WT_Signal.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (WT_Event)

@signal(TouchDown)
@signal(TouchDownRepeat)
@signal(TouchUpInside)
@signal(TouchUpOutside)
@signal(TouchLong)

@signal(DragInside)
@signal(DragOutside)
@signal(DragEnter)
@signal(DragExit)

+ (instancetype)button;

@end

NS_ASSUME_NONNULL_END
