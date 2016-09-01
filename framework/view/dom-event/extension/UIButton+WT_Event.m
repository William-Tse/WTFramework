//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  UIButton+WT_Event.m
//  WTFramework
//

#import "UIButton+WT_Event.h"

#import "UIView+WT_Extension.h"
#import "NSObject+WT_Extension.h"
#import "NSDictionary+WT_Extension.h"

@implementation UIButton (WT_Event)

@def_signal(TouchDown)
@def_signal(TouchDownRepeat)
@def_signal(TouchUpInside)
@def_signal(TouchUpOutside)
@def_signal(TouchLong)

@def_signal(DragInside)
@def_signal(DragOutside)
@def_signal(DragEnter)
@def_signal(DragExit)

+ (instancetype)button
{
    UIButton * btn = [self buttonWithType:UIButtonTypeCustom];
    [btn addSignalListener:self.TouchDown];
    [btn addSignalListener:self.TouchUpInside];
    
    return btn;
}

- (void)setName:(NSString *)name
{
    [super setName:name];
    
    [self addSignalListener:self.TouchDown];
    [self addSignalListener:self.TouchUpInside];
}

- (void)dealloc
{
    
}

- (NSDictionary *)actionMaps
{
    return @{
        self.TouchDown:@(UIControlEventTouchDown),
        self.TouchUpInside:@(UIControlEventTouchUpInside),
        self.TouchUpOutside:@(UIControlEventTouchUpOutside),
        self.TouchDownRepeat:@(UIControlEventTouchDownRepeat),
        self.DragEnter:@(UIControlEventTouchDragEnter),
        self.DragInside:@(UIControlEventTouchDragInside),
        self.DragOutside:@(UIControlEventTouchDragOutside),
        self.DragExit:@(UIControlEventTouchDragExit)
    };
}

- (void)didAddSignalListener:(NSString *)signal
{
    NSArray *arrSignal = [signal componentsSeparatedByString:@"."];
    if(arrSignal.count>2)
    {
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"did%@", arrSignal[2]]);
        id value = [[self actionMaps] objectForKey:signal];
        if(value)
        {
            [self addTarget:self action:sel forControlEvents:[value integerValue]];
        }
    }
}

- (void)didHandleEvent:(UIControlEvents)event
{
    WTKeyValuePair *pair = [[self actionMaps] findOne:^BOOL(id key, id value) {
        return event == [value integerValue];
    }];
    if(pair)
    {
        [self sendSignal:pair.key withObject:nil];
    }
}

- (void)didTouchDown
{
    [self didHandleEvent:UIControlEventTouchDown];
}

- (void)didTouchUpInside
{
    [self didHandleEvent:UIControlEventTouchUpInside];
}

- (void)didTouchUpOutside
{
    [self didHandleEvent:UIControlEventTouchUpOutside];
}

- (void)didTouchDownRepeat
{
    [self didHandleEvent:UIControlEventTouchDownRepeat];
}

- (void)didTouchLong
{
    //TODO:
}

- (void)didDragEnter
{
    [self didHandleEvent:UIControlEventTouchDragEnter];
}

- (void)didDragInside
{
    [self didHandleEvent:UIControlEventTouchDragInside];
}

- (void)didDragOutside
{
    [self didHandleEvent:UIControlEventTouchDragOutside];
}

- (void)didDragExit
{
    [self didHandleEvent:UIControlEventTouchDragExit];
}

@end
