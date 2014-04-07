//
// This file is part of EventListener
//  
// Created by JC on 4/7/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "EVEOrderedList.h"

// Private API
@interface EVEOrderedList ()
@property(nonatomic, strong)NSMutableArray   *list_;
@property(nonatomic, copy)NSComparator       orderComparator_;
@property(nonatomic, assign)BOOL             allowDuplicates_;
@end


@implementation EVEOrderedList

#pragma mark - Ctor/Dtor

+ (instancetype)orderedListWithComparator:(NSComparator)orderComparator duplicate:(BOOL)duplicate {
   return [[self.class alloc] initWithComparator:orderComparator duplicate:duplicate];
}

- (id)initWithComparator:(NSComparator)orderComparator duplicate:(BOOL)duplicate {
  if (!(self = [super init]))
    return nil;

   self.orderComparator_ = orderComparator;
   self.allowDuplicates_ = duplicate;

  return self;
}

#pragma mark - Public methods

- (void)add:(id)object {
   NSUInteger index = [self _search:object options:NSBinarySearchingInsertionIndex];

   if (index == self.list_.count || self.list_[index] != object || self.allowDuplicates_)
      [self insertObject:object inList_AtIndex:index];
}

- (void)remove:(id)object {
   NSUInteger index = [self _search:object options:0];

   if (index != NSNotFound)
      [self removeObjectFromList_AtIndex:index];
}

- (BOOL)contains:(id)object {
   return [self _search:object options:0] != NSNotFound;
}

#pragma mark - Protected methods

- (NSUInteger)_search:(id)object options:(NSBinarySearchingOptions)options {
   return [self.list_ indexOfObject:object
               inSortedRange:NSMakeRange(0, self.list_.count)
                     options:NSBinarySearchingFirstEqual|options
             usingComparator:self.orderComparator_];
}

- (void)insertObject:(id)object inList_AtIndex:(NSUInteger)index {
   [self.list_ insertObject:object atIndex:index];
}

- (void)removeObjectFromList_AtIndex:(NSUInteger)index {
   [self.list_ removeObjectAtIndex:index];
}

#pragma mark - Private methods

@end