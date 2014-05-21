//
// This file is part of EventListener
//  
// Created by JC on 5/20/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "EVEUIKit.h"
#import <UIKit/UIKit.h>

SPEC_BEGIN(EVEUIKitTests)

__block UIViewController   *viewController;
__block UIWindow           *window;

beforeEach(^{
   window = [UIWindow new];
   viewController = [UIViewController new];

   viewController.view = [UIView new];
   window.rootViewController = viewController;
   [window addSubview:viewController.view];
});

describe(@"dispatcher chain", ^{
   it(@"view > viewcontroller > window", ^{
      id<EVEEventDispatcher> dispatcher = viewController.view;
      NSMutableArray *dispatchers = [NSMutableArray array];

      while (dispatcher)
      {
         [dispatchers addObject:dispatcher];
         dispatcher = [dispatcher nextDispatcher];
      }

      [[dispatchers should] equal:@[viewController.view, viewController, window]];
   });
});


SPEC_END
