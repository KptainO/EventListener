//
// This file is part of EventListener
//
// Created by JC on 6/22/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "UIApplication+EventListener.h"

#import <objc/runtime.h>

NSString *const UIApplicationEventDispatcherAttrKey;

// Private API
@interface UIApplication (EventListener_Private)
@property(nonatomic, strong)EVEEventDispatcher  *eventDispatcher;
@end

@implementation UIApplication (EventListener)

#pragma mark - Public methods

- (void)addEventListener:(NSString *)type listener:(SEL)selector {
    [self.eventDispatcher addEventListener:type listener:selector];
}

- (void)addEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture {
    [self.eventDispatcher addEventListener:type listener:selector useCapture:useCapture];
}

- (void)addEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture priority:(NSUInteger)priority {
    [self.eventDispatcher addEventListener:type listener:selector useCapture:useCapture priority:priority];
}

- (void)addEventListener:(NSString *)type block:(EVEEventListenerBlock)block useCapture:(BOOL)useCapture {
    [self.eventDispatcher addEventListener:type block:block useCapture:useCapture];
}

- (void)addEventListener:(NSString *)type block:(EVEEventListenerBlock)block useCapture:(BOOL)useCapture priority:(NSUInteger)priority {
    [self.eventDispatcher addEventListener:type block:block useCapture:useCapture priority:priority];
}

- (void)removeEventListener:(NSString *)type listener:(SEL)selector {
    [self.eventDispatcher addEventListener:type listener:selector];
}

- (void)removeEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture {
    [self.eventDispatcher removeEventListener:type listener:selector useCapture:useCapture];
}

- (void)dispatchEvent:(EVEEvent *)event {
    [self.eventDispatcher dispatchEvent:event];
}

- (id<EVEEventDispatcher>)nextDispatcher {
    id next = (id<EVEEventDispatcher>)[self nextResponder];

    return [next conformsToProtocol:@protocol(EVEEventDispatcher)] ? next : nil;
}

#pragma mark - Private methods

- (EVEEventDispatcher *)eventDispatcher {
    EVEEventDispatcher *dispatcher = objc_getAssociatedObject(self, &UIApplicationEventDispatcherAttrKey);

    if (!dispatcher)
    {
        dispatcher = [[EVEEventDispatcher alloc] initWithDispatcher:self];
        self.eventDispatcher = dispatcher;
    }

    return dispatcher;
}

- (void)setEventDispatcher:(EVEEventDispatcher *)eventDispatcher {
    objc_setAssociatedObject(self, &UIApplicationEventDispatcherAttrKey, eventDispatcher, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
