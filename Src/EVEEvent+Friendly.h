//
// This file is part of EventListener
//
// Created by JC on 4/21/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "EVEEvent.h"

@interface EVEEvent (Friendly)

@property(nonatomic, strong)id                                         target;
@property(nonatomic, assign)EVEEventPhase                              eventPhase;

//- (void)setTarget:(id)target;
//- (void)setEventPhase:(EVEEventPhase)eventPhase;

@end
