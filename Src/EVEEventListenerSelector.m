//
// This file is part of EventListener
//  
// Created by JC on 4/8/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "EVEEventListenerSelector.h"

#import "EVEEvent.h"

// Private API
@interface EVEEventListenerSelector ()
@property(nonatomic, assign)BOOL useCapture;
@property(nonatomic, assign)SEL  selector;
@end

@implementation EVEEventListenerSelector

#pragma mark - Ctor/Dtor

- (instancetype)initWithSelector:(SEL)selector useCapture:(BOOL)useCapture {
   if (!(self = [super init]))
      return nil;

   self.selector = selector;
   self.useCapture = useCapture;

   return self;
}

#pragma mark - Public methods

- (void)handleEvent:(EVEEvent *)event {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [event.currentTarget performSelector:self.selector withObject:event];
#pragma clang diagnostic pop
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;

    if (![object isKindOfClass:[EVEEventListenerSelector class]])
        return NO;

    return [self isEqualToListener:object];
}

- (BOOL)isEqualToListener:(EVEEventListenerSelector *)listener {
    return (self.useCapture == listener.useCapture) && (self.selector == listener.selector);
}

- (NSUInteger)hash {
   return [NSStringFromSelector(self.selector) hash] ^ (self.useCapture ? 1234 : 5678);
}

#pragma mark - Protected methods

#pragma mark - Private methods

@end
