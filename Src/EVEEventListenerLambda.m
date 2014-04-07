//
// This file is part of EventListener
//  
// Created by JC on 4/8/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "EVEEventListenerLambda.h"

// Private API
@interface EVEEventListenerLambda ()
@property(nonatomic, copy)EVEEventListenerBlock   block;
@end

@implementation EVEEventListenerLambda

#pragma mark - Ctor/Dtor

- (id)initWithBlock:(EVEEventListenerBlock)block {
   if (!(self = [super init]))
      return nil;

   self.block = block;

   return self;
}

#pragma mark - Public methods

- (void)handleEvent:(EVEEvent *)event {
   self.block(event);
}

#pragma mark - Protected methods

#pragma mark - Private methods

@end
