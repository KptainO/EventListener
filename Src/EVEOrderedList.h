//
// This file is part of EventListener
//  
// Created by JC on 4/7/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

/**
 * Ordered List wrapping a NSArray object
 * This is used internally by EventListener project and not exposed to end-user
 */
@interface EVEOrderedList : NSObject <NSFastEnumeration>

+ (id)new UNAVAILABLE_ATTRIBUTE;
+ (instancetype)orderedListWithComparator:(NSComparator)orderComparator duplicate:(BOOL)duplicate;

- (instancetype)initWithComparator:(NSComparator)orderComparator duplicate:(BOOL)duplicate;
- (id)init UNAVAILABLE_ATTRIBUTE;

- (void)add:(id)object;
- (void)remove:(id)object;
- (BOOL)contains:(id)object;

- (NSUInteger)count;

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len;

@end


// Contain all selectors that are considered as protected
// **MUST** not be used by others
@interface EVEOrderedList (Protected)
@end
