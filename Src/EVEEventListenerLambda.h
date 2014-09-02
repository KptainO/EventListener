//
// This file is part of EventListener
//  
// Created by JC on 4/8/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "EVEEventListener.h"

typedef void(^EVEEventListenerBlock)(EVEEvent *event);

/**
 * A block based listener
 */
@interface EVEEventListenerLambda : NSObject<EVEEventListener>

@property(nonatomic, assign)NSUInteger                      priority;
@property(nonatomic, assign, readonly)BOOL                  useCapture;
/// the block which will be called when listener is triggered
@property(nonatomic, copy, readonly)EVEEventListenerBlock   block;

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithBlock:(EVEEventListenerBlock)block useCapture:(BOOL)useCapture;

@end


// Contain all selectors that are considered as protected
// **MUST** not be used by others
@interface EVEEventListenerLambda (Protected)
@end
