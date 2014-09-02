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
 * Base protocol defining methods to handle/dispatch events
 *
 * Take a look at:
 * - EVEEventDispatcher class
 * - http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/events/EventDispatcher.html
 * - http://www.w3.org/TR/DOM-Level-3-Events/
 * for more information
 */
@protocol EVEEventDispatcher<NSObject>

/**
 * @see addEventListener:listener:useCapture:priority:
 */
- (void)addEventListener:(NSString *)type listener:(SEL)selector DEPRECATED_MSG_ATTRIBUTE("use addEventListener:listener:useCapture instead");

/**
 * @see addEventListener:listener:useCapture:priority:
 */
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

/**
 * @see removeEventListener:listener:useCapture
 */
- (void)removeEventListener:(NSString *)type listener:(SEL)selector DEPRECATED_MSG_ATTRIBUTE("use removeEventListener:listener:useCapture instead");

/**
 * Remove all registered event listeners on capture or bubbling phase
 * @param type the event type
 * @param useCapture if set to YES events from capture phase will be removed. Otherwise those from bubbling phase will be
 */
- (void)removeEventListener:(NSString *)type useCapture:(BOOL)capture;

/**
 * Remove a previously registered listener
 * @param type event specific type/name
 * @param useCapture if set to YES event registered on capture phase will be removed. Otherwise the one from bubbling phase will be (if any)
 */
- (void)removeEventListener:(NSString *)type listener:(SEL)selector useCapture:(BOOL)useCapture;

/**
 * Dispatch the event through the DOM calling each DOM element registered listeners
 *
 * The dispatch happen in 4 phases:
 * 1. the dispatcher retrieve the current DOM element parent chain until root by calling nextDispatcher on each DOM node
 * 2. the dispatcher call registered listeners for EVEEventPhaseCapturing phase from root node to (not included) current DOM node
 * 3. the dispatcher call registered listeners on current node for EVEEventPhaseTarget phase
 * 4. the dispatcher call registered listeners for EVEEventPhaseBubbling phase from (not included) current node to root node if
 * event.bubbles is set to YES
 *
 * @param event event to dispatch through the DOM parents of the current DOM element. Only listeners registered to event.type
 * will be called on each EVEEventPhase. Some attributes will be updated all along the dispatch course:
 * - event.phase to reflect the current dispatch phase
 * - event.currentTarget will be updated to reflect DOM node on which currently called listener were registered
 * - event.target will be setted at the very beginning to reflect the DOM node uon which dispatchEvent method was called
 */
- (void)dispatchEvent:(EVEEvent *)event;

/**
 * Return the next dispatcher into the dispatch chain
 * Most of the time it will contain UIView elements and their controllers. All of them are called DOM node through the
 * documention with no distinction
 */
- (id<EVEEventDispatcher>)nextDispatcher;

@end

/**
 * Base class for all classes that dispatch events. You can inherit from this class or use it as composition when
 * necessary. See EventDispatcher UIKit categories to see composition in action
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