//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  WT_Signal.m
//  WTFramework
//

#import "WT_Signal.h"

#import "NSObject+WT_Extension.h"
#import "UIView+WT_Extension.h"

#import "_pragma_push.h"

#undef	KEY_SIGNALS
#define KEY_SIGNALS	"UIView.signals"


@interface WTSignal ()

- (void)internalSend;
- (void)internalChangeSource:(UIResponder *)source;

@end

@implementation WTSignal
{
    NSString *_name;
    id _object;
    __weak UIResponder *_target;
    __weak UIResponder *_source;
}

- (NSString *)name
{
    return _name;
}

- (id)object
{
    return _object;
}

- (UIResponder *)target
{
    return _target;
}

- (UIResponder *)source
{
    return _source;
}

+ (instancetype)signalWithName:(NSString *)name target:(UIResponder *)target
{
    return [[self alloc] initWithName:name target:target];
}

+ (instancetype)signalWithName:(NSString *)name target:(UIResponder *)target object:(nullable id)object
{
    return [[self alloc] initWithName:name target:target object:object];
}

- (instancetype)initWithName:(NSString *)name target:(UIResponder *)target
{
    return [self initWithName:name target:target object:nil];
}

- (instancetype)initWithName:(NSString *)name target:(UIResponder *)target object:(nullable id)object
{
    self = [super init];
    if(self)
    {
        _name = name;
        _object = object;
        _target = target;
        _source = target;
    }
    return self;
}

- (void)forward
{
    [self forward:nil];
}

- (void)forward:(nullable UIResponder *)responder
{
    UIResponder *receiver = [responder isKindOfClass:[UIViewController class]] ? [(UIViewController *)responder parentViewController] : [responder nextResponder];
    if(receiver)
    {
        [self sendToReceiver:receiver];
    }
//    if([responder isKindOfClass:[UIView class]])
//    {
//        receiver = [(UIView *)responder superview];
//    }
//    else if([responder isKindOfClass:[UIViewController class]])
//    {
//        receiver = [(UIViewController *)responder parentViewController];
//    }
//    if(receiver)
//    {
//        [self sendToReceiver:receiver];
//    }
}

- (void)sendToReceiver:(UIResponder *)receiver
{
    SEL sel = NSSelectorFromString(@"onSignal:");
    if([receiver respondsToSelector:sel])
    {
        _handled = YES;
        [receiver performSelector:sel withObject:self afterDelay:0];
        if(_handled) return;
    }
    
    NSArray *arrNames = [_name componentsSeparatedByString:@"."];
    if(arrNames.count>1)
    {
        NSString *clazz = arrNames[1];
        sel = NSSelectorFromString([NSString stringWithFormat:@"onSignal_%@:", clazz]);
        if([receiver respondsToSelector:sel])
        {
            _handled = YES;
            [receiver performSelector:sel withObject:self afterDelay:0];
            if(_handled) return;
        }
        
        if(arrNames.count>2)
        {
            sel = NSSelectorFromString([NSString stringWithFormat:@"onSignal_%@_%@:", clazz, arrNames[2]]);
            if([receiver respondsToSelector:sel])
            {
                _handled = YES;
                [receiver performSelector:sel withObject:self afterDelay:0];
                if(_handled) return;
            }
        }
        
        if([clazz isEqualToString:NSStringFromClass([_source class])] && [_source isKindOfClass:[UIView class]])
        {
            NSString *sourceName = [(UIView *)_source name];
            if(sourceName.length)
            {
                sel = NSSelectorFromString([NSString stringWithFormat:@"onSignal_%@:", sourceName]);
                if([receiver respondsToSelector:sel])
                {
                    _handled = YES;
                    [receiver performSelector:sel withObject:self afterDelay:0];
                    if(_handled) return;
                }
                
                if(arrNames.count>2)
                {
                    sel = NSSelectorFromString([NSString stringWithFormat:@"onSignal_%@_%@:", sourceName, arrNames[2]]);
                    if([receiver respondsToSelector:sel])
                    {
                        _handled = YES;
                        [receiver performSelector:sel withObject:self afterDelay:0];
                        if(_handled) return;
                    }
                }
            }
        }
    }
    
    [self forward:receiver];
}

#pragma mark - internal method

- (void)internalSend
{
    [self sendToReceiver:self.source];
}

- (void)internalChangeSource:(UIResponder *)source
{
    _source = source;
}

@end

@implementation UIResponder (WT_Signal)

- (NSArray *)signals
{
    return [[self dictionarySignals] allKeys];
}

- (BOOL)isListenedSignal:(NSString *)signal
{
    return !![[self dictionarySignals] objectForKey:signal];
}

- (NSMutableDictionary *)dictionarySignals
{
    NSMutableDictionary *dictSignals = objc_getAssociatedObject( self, KEY_SIGNALS );
    if(!dictSignals)
    {
        objc_setAssociatedObject( self, KEY_SIGNALS, dictSignals, OBJC_ASSOCIATION_RETAIN_NONATOMIC );
    }
    return dictSignals;
}

- (void)addSignalListener:(NSString *)signal
{
    [self addSignalListener:signal callback:nil];
}

- (void)addSignalListener:(NSString *)signal callback:(nullable WTSignalBlock)callback
{
    NSMutableDictionary *dictSignals = [self dictionarySignals];
    WTSignalBlock value = [dictSignals objectForKey:signal];
    if(!value || value != callback)
    {
        [[self dictionarySignals] setObject:callback forKey:signal];
        
        [self didAddSignalListener:signal];
    }
}

- (void)removeSignalListener:(NSString *)signal
{
    NSMutableDictionary *dictSignals = [self dictionarySignals];
    if([dictSignals objectForKey:signal])
    {
        [dictSignals removeObjectForKey:signal];
        
        [self didRemoveSignalListener:signal];
    }
}

- (void)sendSignal:(NSString *)signal withObject:(nullable id)object
{
    NSArray *arrNames = [signal componentsSeparatedByString:@"."];
    if(arrNames.count>2)
    {
        Class clazz = NSClassFromString([arrNames objectAtIndex:1]);
        NSString *event = [arrNames objectAtIndex:2];
        
        if(clazz && [self isKindOfClass:clazz])
        {
            SEL sel = NSSelectorFromString([NSString stringWithFormat:@"on%@", event]);
            if([self respondsToSelector:sel])
            {
                [self performSelector:sel withObject:self afterDelay:0];
                return;
            }
        }
    }
    
    WTSignal *sign = [WTSignal signalWithName:signal target:self object:object];
    [self sendSignal:sign];
}

- (void)sendSignal:(WTSignal *)signal
{
    if(signal.source != self)
    {
        [signal internalChangeSource:self];
    }
    
    WTSignalBlock callback = [[self dictionarySignals] objectForKey:signal.name];
    if(callback)
    {
        signal.handled = YES;
        callback(signal);
    }
    if(!signal.handled)
    {
        [signal internalSend];
    }
}

#pragma mark - override

- (void)didAddSignalListener:(NSString *)signal {}
- (void)didRemoveSignalListener:(NSString *)signal {}

@end

#import "_pragma_pop.h"
