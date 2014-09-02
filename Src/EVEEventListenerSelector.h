//
// This file is part of EventListener
//  
// Created by JC on 4/8/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "EVEEventListener.h"

/**
 * A selector listener
 *
 * When listener is triggered it call the selector on the event currentTarget attribute
 */
@interface EVEEventListenerSelector : NSObject<EVEEventListener>

@property(nonatomic, assign)NSUInteger       priority;
@property(nonatomic, assign, readonly)BOOL   useCapture;

/// the selector the listener should call back when triggered
@property(nonatomic, assign, readonly)SEL    selector;

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithSelector:(SEL)selector useCapture:(BOOL)useCapture;

@end


// Contain all selectors that are considered as protected
// **MUST** not be used by others
@interface EVEEventListenerSelector (Protected)
@end
