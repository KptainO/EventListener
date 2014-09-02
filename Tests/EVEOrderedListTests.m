//
// This file is part of EventListener
//  
// Created by JC on 5/1/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "EVEOrderedList.h"
#import "EVEEventListener.h"

SPEC_BEGIN(EVEOrderedListTests)

__block EVEOrderedList *list;
__block NSObject<EVEEventListener> *obj1;
__block NSObject<EVEEventListener> *obj2;

beforeEach(^{
    obj1 = [KWMock mockForProtocol:@protocol(EVEEventListener)];
    obj2 = [KWMock mockForProtocol:@protocol(EVEEventListener)];

    [obj1 stub:@selector(priority) andReturn:theValue(1)];
    [obj2 stub:@selector(priority) andReturn:theValue(2)];

    list = [EVEOrderedList orderedListWithComparator:^NSComparisonResult(id obj1, id obj2) {
        if (obj1 == obj2)
            return NSOrderedSame;

        return [obj1 priority] <= [obj2 priority] ? NSOrderedAscending : NSOrderedDescending;
    }
                                           duplicate:NO];
});

describe(@"when duplicate == NO", ^{
   describe(@"add", ^{
      it(@"should accept single value", ^{
         [list add:obj1];

         [[theValue(list.count) should] equal:theValue(1)];
      });

      it(@"should accept 2 values", ^{
         [list add:obj1];
         [list add:obj2];

         [[theValue(list.count) should] equal:theValue(2)];
      });

      it(@"should refuse duplicate", ^{
         [list add:obj1];
         [list add:obj2];
         [list add:obj1];

         [[theValue(list.count) should] equal:theValue(2)];
      });

      it(@"should refuse when comparator return NSOrderedSame", ^{
         list = [EVEOrderedList orderedListWithComparator:^NSComparisonResult(id obj1, id obj2) { return NSOrderedSame; } duplicate:NO];

         [list add:obj1];
         [list add:obj2];

         [[theValue(list.count) should] equal:theValue(1)];
      });
   });

   describe(@"remove", ^{
      it(@"should", ^{
         [list add:obj1];
         [list remove:obj1];

         [[theValue(list.count) should] equal:theValue(0)];
      });
   });
});

describe(@"filter", ^{
    it(@"should remove items matching criteria", ^{
        [list add:obj1];
        [list add:obj2];
        [list filter:^BOOL(id<EVEEventListener> listener) { return listener.priority == 1; }];

        [[theValue(list.count) should] equal:theValue(1)];
        [[theValue([list contains:obj1]) should] equal:theValue(YES)];
        [[theValue([list contains:obj2]) should] equal:theValue(NO)];
    });
});

describe(@"order", ^{
   it(@"should respect priority", ^{
      NSMutableArray *res = [NSMutableArray new];

      [list add:obj2];
      [list add:obj1];

      for (id obj in list)
         [res addObject:obj];

      [[res[0] should] equal:obj1];
      [[res[1] should] equal:obj2];
   });
});

SPEC_END
