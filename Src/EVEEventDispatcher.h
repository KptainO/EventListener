//
// This file is part of EventListener
//
// Created by JC on 4/6/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>

@class EVEEvent;

typedef void(^EVEEventDispatcherListener)(EVEEvent *event);

@protocol EVEEventDispatcher<NSObject>

- (void)addEventListener:(NSString *)type listener:(SEL)selector;
- (void)addEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture;
- (void)addEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture priority:(NSUInteger)priority;

- (void)removeEventListener:(NSString *)type listener:(SEL)selector;
- (void)removeEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture;

- (void)dispatchEvent:(EVEEvent *)event;

- (id<EVEEventDispatcher>)nextDispatcher;

@end

@interface EVEEventDispatcher : NSObject<EVEEventDispatcher>

+ (id)new UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new:(id<EVEEventDispatcher>)target;
+ (instancetype)eventDispatcher:(id<EVEEventDispatcher>)target;

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithDispatcher:(id<EVEEventDispatcher>)target;


@end