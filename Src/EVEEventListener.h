//
// This file is part of EventListener
//  
// Created by JC on 4/7/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

@class EVEEvent;

/**
 * A listener is merely only an object with some attributes to determine whether and when to call it
 */
@protocol EVEEventListener <NSObject>

/// the listener priority upon other listeners
@property(nonatomic, assign)NSUInteger       priority;
/// whether this listener should be called on target or bubble phase
@property(nonatomic, assign, readonly)BOOL   useCapture;

/// Trigger the listener action for given event
- (void)handleEvent:(EVEEvent *)event;

- (NSUInteger)hash;

@end
