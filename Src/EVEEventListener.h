//
// This file is part of EventListener
//  
// Created by JC on 4/7/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

@class EVEEvent;

@protocol EVEEventListener <NSObject>

@property(nonatomic, assign)NSUInteger priority;
@property(nonatomic, assign)BOOL       useCapture;

- (void)handleEvent:(EVEEvent *)event;

@end
