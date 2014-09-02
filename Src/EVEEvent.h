//
// This file is part of EventListener
//  
// Created by JC on 4/6/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

/// the phase an event might be in while being dispatched
typedef enum EVEEventPhase : NSUInteger {
   EVEEventPhaseNone,
   EVEEventPhaseCapturing,
   EVEEventPhaseTarget,
   EVEEventPhaseBubbling
} EVEEventPhase;

/**
 * Basic event class defining event attributes to dispatch it correctly through the DOM
 *
 * Unlinke NSNotification you MUST inherit from it when dispatching your own event and add your own attributes to it
 * for all your data
 */
@interface EVEEvent : NSObject

/**
 * A unique string to identify and filter the event
 * Most of the time the identifier use the class name as prefix
**/
@property(nonatomic, strong, readonly)NSString                                      *type;
/// the DOM node which dispatched this event. Setted by EVEEventDispatcher
@property(nonatomic, strong, readonly)id                                            target;
/// the current DOM node upon which event listeners are invoked. Setted by EVEEventDispatcher
@property(nonatomic, strong, readonly)id                                            currentTarget;
/// current dispatch phase. Setted by EVEEventDispatcher
@property(nonatomic, assign, readonly)EVEEventPhase                                 eventPhase;
/**
 * By default an event is dispatched through EVEEventPhaseCapturing and EVEEventPhaseTarget phases only.
 * Set this attribute to YES if you want the EVEEventPhaseBubbling to be active
 */
@property(nonatomic, assign, readonly)BOOL                                          bubbles;
/// informational attribute. If set to YES listeners can call preventDefault to cancel default event behaviour
@property(nonatomic, assign, readonly)BOOL                                          cancelable;
/// informational attribute. It is your responsability to check it after dispatch to cancel default action(s) if
/// preventDefault has been called
@property(nonatomic, assign, readonly, getter = isDefaultPrevented)BOOL             defaultPrevented;
/// Stop event propagation through DOM. Note however that current DOM node listeners will still continue to be called
@property(nonatomic, assign, readonly, getter = isPropagationStopped)BOOL           stopPropagation;
/// Stop event propagation through DOM. Current DOM node listeners won't continue to be invoked
@property(nonatomic, assign, readonly, getter = isImmediatePropagationStopped)BOOL  stopImmediatePropagation;

/**
 * Listeners should call this method to cancel default event behaviour. It has no effect if cancelable is set to NO
 */
- (void)preventDefault;

- (void)stopPropagation;
- (void)stopImmediatePropagation;

+ (instancetype)event:(NSString *)type;
+ (instancetype)event:(NSString *)type bubbles:(BOOL)bubbles;
+ (instancetype)event:(NSString *)type bubbles:(BOOL)bubbles cancelable:(BOOL)cancelable;

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)init:(NSString *)type;
- (instancetype)init:(NSString *)type bubbles:(BOOL)bubbles;
- (instancetype)init:(NSString *)type bubbles:(BOOL)bubbles cancelable:(BOOL)cancelable;

@end


// Contain all selectors that are considered as protected
// **MUST** not be used by others
@interface EVEEvent (Protected)
@end