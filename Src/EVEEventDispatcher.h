//
// This file is part of EventListener
//
// Created by JC on 4/6/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import <Foundation/Foundation.h>

#import "EVEEventListenerLambda.h"

@class EVEEvent;

typedef void(^EVEEventDispatcherListener)(EVEEvent *event);

/**
 * Base protocol for handling/dispatching events
 * Take a look at:
 * - http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/EventDispatcher.html
 * - http://www.w3.org/TR/DOM-Level-3-Events/
 * for more advanced information
 */
@protocol EVEEventDispatcher<NSObject>

- (void)addEventListener:(NSString *)type listener:(SEL)selector DEPRECATED_MSG_ATTRIBUTE("use addEventListener:listener:useCapture instead");
- (void)addEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture;

/**
 * Register an event listener object on the EventDispatcher so that the listener receive notifications of an event
 * @param type the event type/name. Only event notifications named type will be listened to
 * @param listener a selector method that will process the event.
 * @param useCapture determine whether the listener wok on the capture/target phase or target/bubbling phase 
 * @param priority the event listener priority. The higher the number, the higher the priority
 */
- (void)addEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture priority:(NSUInteger)priority;

- (void)addEventListener:(NSString *)type block:(EVEEventListenerBlock)block useCapture:(BOOL)useCapture;
- (void)addEventListener:(NSString *)type block:(EVEEventListenerBlock)block useCapture:(BOOL)useCapture priority:(NSUInteger)priority;

- (void)removeEventListener:(NSString *)type listener:(SEL)selector DEPRECATED_MSG_ATTRIBUTE("use removeEventListener:listener:useCapture instead");

/**
 * Remove all registered event listeners on capture or bubbling phase
 * @param type the event type
 * @param useCapture if set to YES events from capture phase will be removed. Otherwise those from bubbling phase will be
 */
- (void)removeEventListener:(NSString *)type useCapture:(BOOL)capture;

/**
 * @param useCapture if set to YES events from capture phase will be removed. Otherwise those from bubbling phase will be
 */
- (void)removeEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture;

/**
 * Main method from EVEEventDispatcher: dispatch an event into the event flow. The event target is the object upon which the dispatchEvent() method is called
 *
 * @param event
 */
- (void)dispatchEvent:(EVEEvent *)event;

- (id<EVEEventDispatcher>)nextDispatcher;

@end

/**
 * Base class for all classes that dispatch events. You can inherit from this class or use it as composition when
 * necessary. See UIKit categories to see how this work
 *
 * The target is an important element as it define the element which will be reachable by events and which will
 * define listener methods/blocks
 */
@interface EVEEventDispatcher : NSObject<EVEEventDispatcher>

+ (id)new UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new:(id<EVEEventDispatcher>)target;
/**
 * @param target the dispatcher target which will define listener methods
 * when receiving event the event.currentTarget property will be set to target
 */
+ (instancetype)eventDispatcher:(id<EVEEventDispatcher>)target;

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithDispatcher:(id<EVEEventDispatcher>)target;


@end