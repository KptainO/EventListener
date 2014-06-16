//
// This file is part of EventListener
//  
// Created by JC on 5/18/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "UIView+EventListener.h"

#import <objc/runtime.h>

NSString *const UIViewEventDispatcherAttrKey;

@interface UIView (EventListener_Private)
@property(nonatomic, strong)EVEEventDispatcher  *eventDispatcher;
@end

@implementation UIView (EventListener)

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
   // UIViewController or superview
   return (id<EVEEventDispatcher>)[self nextResponder];
}

#pragma mark - Private methods

- (EVEEventDispatcher *)eventDispatcher {
   EVEEventDispatcher *dispatcher = objc_getAssociatedObject(self, &UIViewEventDispatcherAttrKey);

   if (!dispatcher)
   {
      dispatcher = [[EVEEventDispatcher alloc] initWithDispatcher:self];
      self.eventDispatcher = dispatcher;
   }

   return dispatcher;
}

- (void)setEventDispatcher:(EVEEventDispatcher *)eventDispatcher {
   objc_setAssociatedObject(self, &UIViewEventDispatcherAttrKey, eventDispatcher, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
