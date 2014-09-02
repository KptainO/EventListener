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
@property(nonatomic, assign)BOOL                   useCapture;
@property(nonatomic, copy)EVEEventListenerBlock    block;
@end

@implementation EVEEventListenerLambda

#pragma mark - Ctor/Dtor

- (id)initWithBlock:(EVEEventListenerBlock)block useCapture:(BOOL)useCapture {
   if (!(self = [super init]))
      return nil;

   self.block = block;
   self.useCapture = useCapture;

   return self;
}

#pragma mark - Public methods

- (void)handleEvent:(EVEEvent *)event {
   if (self.block)
       self.block(event);
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;

    if (![object isKindOfClass:[EVEEventListenerLambda class]])
        return NO;

    return [self isEqualToListener:object];
}

- (BOOL)isEqualToListener:(EVEEventListenerLambda *)listener {
    return (self.useCapture == listener.useCapture) && ([self.block hash] == [listener.block hash]);
}

- (NSUInteger)hash {
   return [self.block hash] ^ (self.useCapture ? 1234 : 5678);
}

#pragma mark - Protected methods

#pragma mark - Private methods

@end
