//
// This file is part of EventListener
//  
// Created by JC on 4/6/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "EVEEvent.h"

// Private API
@interface EVEEvent ()
@property(nonatomic, strong)NSString                                    *type;
@property(nonatomic, strong)id                                          target;
@property(nonatomic, assign)EVEEventPhase                               eventPhase;
@property(nonatomic, assign, getter = isStopPropagation)BOOL            stopPropagation;
@property(nonatomic, assign, getter = isStopImmediatePropagation)BOOL   stopImmediatePropagation;
@end

@implementation EVEEvent

#pragma mark - Ctor/Dtor

+ (instancetype)event:(NSString *)type {
   return [[self.class alloc] init:type];
}

- (instancetype)init:(NSString *)type {
  if (!(self = [super init]))
    return nil;

   self.type = type;

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
