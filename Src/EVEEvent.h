//
// This file is part of EventListener
//  
// Created by JC on 4/6/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//


typedef enum EVEEventPhase : NSUInteger {
   EVEEventPhaseNone,
   EVEEventPhaseCapturing,
   EVEEventPhaseTarget,
   EVEEventPhaseBubbling
} EVEEventPhase;

@interface EVEEvent : NSObject

@property(nonatomic, strong, readonly)NSString                                   *type;
@property(nonatomic, strong, readonly)id                                         target;
@property(nonatomic, assign, readonly)EVEEventPhase                              eventPhase;
@property(nonatomic, assign, readonly)BOOL                                       bubbles;
@property(nonatomic, assign, readonly, getter = isStopPropagation)BOOL           stopPropagation;
@property(nonatomic, assign, readonly, getter = isStopImmediatePropagation)BOOL  stopImmediatePropagation;

- (void)stopPropagation;
- (void)stopImmediatePropagation;

+ (instancetype)event:(NSString *)type;
+ (instancetype)event:(NSString *)type bubbles:(BOOL)bubbles;

- (id)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)init:(NSString *)type;
- (instancetype)init:(NSString *)type bubbles:(BOOL)bubbles;

@end


// Contain all selectors that are considered as protected
// **MUST** not be used by others
@interface EVEEvent (Protected)
@end