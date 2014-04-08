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
   IMP imp = [event.target methodForSelector:self.selector];
   void (*func)(id, SEL, EVEEvent *) = (void *)imp;

   func(event.target, self.selector, event);
}

- (NSUInteger)hash {
   return [NSStringFromSelector(self.selector) hash] ^ self.useCapture ? 1234 : 5678;
}

#pragma mark - Protected methods

#pragma mark - Private methods

@end
