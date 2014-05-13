//
// This file is part of EventListener
//  
// Created by JC on 4/6/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "EVEEvent.h"
#import "EVEEvent+Friendly.h"

// Private API
@interface EVEEvent ()
@property(nonatomic, strong)NSString                                    *type;
@property(nonatomic, strong)id                                          target;
@property(nonatomic, assign)EVEEventPhase                               eventPhase;
@property(nonatomic, assign)BOOL                                        bubbles;
@property(nonatomic, assign, getter = isStopPropagation)BOOL            stopPropagation;
@property(nonatomic, assign, getter = isStopImmediatePropagation)BOOL   stopImmediatePropagation;
@end

@implementation EVEEvent

#pragma mark - Ctor/Dtor

+ (instancetype)event:(NSString *)type {
   return [[self.class alloc] init:type];
}

+ (instancetype)event:(NSString *)type bubbles:(BOOL)bubbles {
   return [[self.class alloc] init:type bubbles:bubbles];
}

- (instancetype)init:(NSString *)type {
   return [self init:type bubbles:NO];
}

- (instancetype)init:(NSString *)type bubbles:(BOOL)bubbles {
  if (!(self = [super init]))
    return nil;

   self.type = type;
   self.bubbles = bubbles;

  return self;
}

#pragma mark - Public methods

- (void)stopPropagation {
   self.stopPropagation = YES;
}

- (void)stopImmediatePropagation {
   self.stopImmediatePropagation = YES;
}

#pragma mark - Protected methods

#pragma mark - Private methods

@end
