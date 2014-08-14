//
// This file is part of EventListener
//
// Created by JC on 4/6/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "EVEEventDispatcher.h"
#import "EVEEvent.h"
#import "EVEEvent+Friendly.h"
#import "EVEEventListener.h"
#import "EVEEventListenerSelector.h"
#import "EVEOrderedList.h"

#import <UIKit/UIKit.h>

// Private API
@interface EVEEventDispatcher ()
@property(nonatomic, weak)id<EVEEventDispatcher>   target;

@property(nonatomic, strong)NSMutableDictionary    *listeners_;
@end

@implementation EVEEventDispatcher

#pragma mark - Ctor/Dtor

+ (instancetype)new:(id<EVEEventDispatcher>)target {
   return [self eventDispatcher:target];
}

+ (instancetype)eventDispatcher:(id<EVEEventDispatcher>)target {
   return [[[self class] alloc] initWithDispatcher:target];
}

- (instancetype)initWithDispatcher:(id<EVEEventDispatcher>)target {
   if (!(self = [super init]))
      return nil;

   self.target = target ?: self;
   self.listeners_ = [NSMutableDictionary new];

   return self;
}

#pragma mark - Public methods

- (void)addEventListener:(NSString *)type listener:(SEL)selector {
   [self addEventListener:type listener:selector useCapture:NO];
}

- (void)addEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture {
   [self addEventListener:type listener:selector useCapture:useCapture priority:0];
}

- (void)addEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture priority:(NSUInteger)priority {
   id<EVEEventListener> listener = [[EVEEventListenerSelector alloc] initWithSelector:selector useCapture:useCapture];

    [self addEventListener:listener type:type priority:priority];
}

- (void)addEventListener:(NSString *)type block:(EVEEventListenerBlock)block useCapture:(BOOL)useCapture {
    [self addEventListener:type block:block useCapture:useCapture priority:0];
}

- (void)addEventListener:(NSString *)type block:(EVEEventListenerBlock)block useCapture:(BOOL)useCapture priority:(NSUInteger)priority {
    id<EVEEventListener> listener = [[EVEEventListenerLambda alloc] initWithBlock:block useCapture:useCapture];

    [self addEventListener:listener type:type priority:priority];
}

- (void)addEventListener:(id<EVEEventListener>)listener type:(NSString *)type priority:(NSUInteger)priority {
    EVEOrderedList *listeners = [self _listenersContainer:type];

    listener.priority = priority;

    // EVEOrderedList will take care of avoiding duplicates
    // and keep listeners ordered by priority
    [listeners add:listener];

}

- (void)removeEventListener:(NSString *)type {
    [self _removeContainer:type];
}

- (void)removeEventListener:(NSString *)type useCapture:(BOOL)capture {
    EVEOrderedList *listeners = [self _listenersContainer:type];

    [listeners filter:^BOOL(id<EVEEventListener> listener) { return listener.useCapture != capture; }];
}

- (void)removeEventListener:(NSString *)type listener:(SEL)selector {
   [self removeEventListener:type listener:selector useCapture:NO];
}

- (void)removeEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture {
   id<EVEEventListener> listener = [[EVEEventListenerSelector alloc] initWithSelector:selector useCapture:useCapture];
   EVEOrderedList *listeners = [self _listenersContainer:type];

   [listeners remove:listener];
}

- (id<EVEEventDispatcher>)nextDispatcher {
   return nil;
}

- (void)dispatchEvent:(EVEEvent *)event {
    if (event.isPropagationStopped)
        return;

    // Capturing or bubbling event already being handled: just execute listeners
    if (event.eventPhase != EVEEventPhaseNone)
        return [self _handleEvent:event];

    NSArray *dispatchChain = [self _dispatchChain];

    event.target = self.target;

    [self _dispatchCaptureEvent:event chain:dispatchChain];
    [self _dispatchTargetEvent:event];
    [self _dispatchBubbleEvent:event chain:dispatchChain];

   event.eventPhase = EVEEventPhaseNone;
   event.target = nil;
}

#pragma mark - Protected methods

- (void)_dispatchCaptureEvent:(EVEEvent *)event chain:(NSArray *)dispatchChain {
    // Browse chain from top to bottom
    event.eventPhase = EVEEventPhaseCapturing;
    for (id<EVEEventDispatcher> dispatcher in dispatchChain) {
        [dispatcher dispatchEvent:event];
    }
}

- (void)_dispatchTargetEvent:(EVEEvent *)event {
    if (!event.isImmediatePropagationStopped && !event.isPropagationStopped)
    {
        event.eventPhase = EVEEventPhaseTarget;
        [self _handleEvent:event];
    }
}

- (void)_dispatchBubbleEvent:(EVEEvent *)event chain:(NSArray *)dispatchChain {
    // Browse chain from bottom to top
    if (event.bubbles && !event.isImmediatePropagationStopped && !event.isPropagationStopped)
    {
        event.eventPhase = EVEEventPhaseBubbling;
        for (id<EVEEventDispatcher> dispatcher in [dispatchChain reverseObjectEnumerator])
            [dispatcher dispatchEvent:event];
    }
}

- (void)_handleEvent:(EVEEvent *)event {
   EVEOrderedList *listeners = [self _listenersContainer:event.type];
    BOOL isTargetPhase = (event.eventPhase == EVEEventPhaseTarget);
    // Capturing phase => useCapture should be set to TRUE
    // Bubbling phase => useCapture should be set to FALSE
    BOOL shouldCapture = (event.eventPhase == EVEEventPhaseCapturing);

    event.currentTarget = self.target;
    for (id<EVEEventListener> listener in listeners)
        if (isTargetPhase || listener.useCapture == shouldCapture)
        {
            [listener handleEvent:event];

            if (event.isImmediatePropagationStopped)
                break;
        }
    event.currentTarget = nil;
}

- (NSArray *)_dispatchChain {
   NSMutableArray *chain = [NSMutableArray new];

   for (id<EVEEventDispatcher> dispatcher = [self.target nextDispatcher]; dispatcher != nil; dispatcher = [dispatcher nextDispatcher])
      [chain insertObject:dispatcher atIndex:0];

   return chain;
}

#pragma mark - Private methods

- (EVEOrderedList *)_listenersContainer:(NSString *)type {
   EVEOrderedList *container = self.listeners_[type];

   if (!container)
   {
      container = [EVEOrderedList orderedListWithComparator:
                   ^NSComparisonResult(id<EVEEventListener> obj1, id<EVEEventListener> obj2)
                   {
                      return obj1.priority <= obj2.priority ? NSOrderedAscending : NSOrderedDescending;
                   }
                                                  duplicate:NO];
      self.listeners_[type] = container;
   }

   return container;
}

- (void)_removeContainer:(NSString *)type {
    [self.listeners_ removeObjectForKey:type];
}

@end
