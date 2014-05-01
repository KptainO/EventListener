//
// This file is part of EventListener
//  
// Created by JC on 4/19/14.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

#import "EVEEventDispatcher.h"
#import "EVEEvent.h"
#import "EVEEvent+Friendly.h"
#import "EVEEventListener.h"

SPEC_BEGIN(EVEEventDispatcherTests)

__block EVEEventDispatcher             *dispatcher;
__block NSObject<EVEEventDispatcher>   *dispatcherTarget;

beforeEach (^{
   dispatcherTarget = [KWMock mockForProtocol:@protocol(EVEEventDispatcher)];
   dispatcher = [EVEEventDispatcher new:dispatcherTarget];

   [dispatcherTarget stub:@selector(nextDispatcher) andReturn:nil];
});

describe(@"dispatch", ^{
   __block EVEEvent *event;

   beforeEach(^{
      event = [EVEEvent new];
   });

   it(@"should retrieve dispatcher chain", ^{
      NSObject<EVEEventDispatcher> *parentDispatcher = [KWMock mockForProtocol:@protocol(EVEEventDispatcher)];

      [parentDispatcher stub:@selector(dispatchEvent:)];

      [[dispatcherTarget should] receive:@selector(nextDispatcher) andReturn:parentDispatcher];
      [[parentDispatcher should] receive:@selector(nextDispatcher) andReturn:nil];

      [dispatcher dispatchEvent:event];
   });

   describe(@"listeners", ^ {
      __block NSObject<EVEEventListener>  *listener1;
      __block NSObject<EVEEventListener>  *listener2;

      beforeEach(^{
         listener1 = [KWMock mockForProtocol:@protocol(EVEEventListener)];
         listener2 = [KWMock mockForProtocol:@protocol(EVEEventListener)];
      });

      it(@"should be invoked on priority order", ^{
         SEL selector1 = NSSelectorFromString(@"callback1");
         SEL selector2 = NSSelectorFromString(@"callback2");

         [dispatcher addEventListener:@"customName" listener:selector1 useCapture:NO priority:1];
         [dispatcher addEventListener:@"customName" listener:selector2 useCapture:NO priority:2];
         [event stub:@selector(eventPhase) andReturn:theValue(EVEEventPhaseTarget)];
         [event stub:@selector(type) andReturn:@"customName"];

         [[dispatcherTarget should] receive:selector1];
         [[dispatcherTarget should] receive:selector2];

         [dispatcher dispatchEvent:event];

      });

      it(@"should ONLY invoke listeners matching event.name", ^{
         SEL selector = NSSelectorFromString(@"callback");

         [dispatcher addEventListener:@"wrongEvent" listener:selector useCapture:NO priority:1];
         [event stub:@selector(type) andReturn:@"customName"];

         [[dispatcherTarget shouldNot] receive:selector];

         [dispatcher dispatchEvent:event];
      });

      describe(@"chain", ^{
         __block NSObject<EVEEventDispatcher> *parent;

         beforeEach(^{
            parent = [KWMock mockForProtocol:@protocol(EVEEventDispatcher)];

            [[dispatcherTarget should] receive:@selector(nextDispatcher) andReturn:parent];
            [[parent should] receive:@selector(nextDispatcher) andReturn:nil];
         });

         it(@"should be invoked on bubbling phase if useCapture == NO", ^{
            SEL selector = NSSelectorFromString(@"callback");

            [parent addEventListener:@"event" listener:selector];

            [event stub:@selector(type) andReturn:@"event"];

            [parent stub:@selector(selector) withBlock:^id(NSArray *params) {
               EVEEvent *event = params[0];

               [[theValue(event.eventPhase) should] equal:theValue(EVEEventPhaseCapturing)];
               return nil;
            }];

            [dispatcher dispatchEvent:event];
         });

         it(@"should be invoked on target phase if event.target is self", ^{
            SEL selector = NSSelectorFromString(@"callback");

            [dispatcher addEventListener:@"event" listener:selector];
            [event stub:@selector(type) andReturn:@"event"];

            [dispatcherTarget stub:@selector(selector) withBlock:^id(NSArray *params) {
               EVEEvent *event = params[0];

               [[theValue(event.eventPhase) should] equal:theValue(EVEEventPhaseTarget)];
               return nil;
            }];

            [dispatcher dispatchEvent:event];
         });

         it(@"should be invoked on capture phase if useCapture == YES", ^{
            SEL selector = NSSelectorFromString(@"callback");

            [parent addEventListener:@"event" listener:selector useCapture:YES];

            [event stub:@selector(type) andReturn:@"event"];

            [parent stub:@selector(selector) withBlock:^id(NSArray *params) {
               EVEEvent *event = params[0];

               [[theValue(event.eventPhase) should] equal:theValue(EVEEventPhaseBubbling)];
               return nil;
            }];
            
            [dispatcher dispatchEvent:event];
         });

         it(@"should not be invoked if event.stopImmediatePropagation", ^{

         });
         
         it(@"should not be invoked on dispatcher chain if event.stopPropagation", ^{
            
         });

      });


      it(@"TODO.preventDefault", ^{

      });
   });

   describe(@"event", ^{
      it(@"should have target set to dispatcherTarget", ^{
         [[event should] receive:@selector(setTarget:) withCount:1 arguments:dispatcherTarget];
         [[event should] receive:@selector(setTarget:) withCount:1 arguments:nil];

         [dispatcher dispatchEvent:event];
      });

      it(@"should have capturePhase to EVEEventPhaseCapturing on capture phase", ^{
         [[event should] receive:@selector(setEventPhase:) withCount:1 arguments:theValue(EVEEventPhaseCapturing)];

         [dispatcher dispatchEvent:event];
      });

      it(@"should have event.capturePhase to EVEEventPhaseTarget on target phase", ^{
         [[event should] receive:@selector(setEventPhase:) withCount:1 arguments:theValue(EVEEventPhaseTarget)];

         [dispatcher dispatchEvent:event];
      });

      it(@"should have event.capturePhase to EVEEventPhaseBubbling on bubbling phase", ^{
         [[event should] receive:@selector(setEventPhase:) withCount:1 arguments:theValue(EVEEventPhaseBubbling)];

         [dispatcher dispatchEvent:event];
      });

      it(@"should be reset after dispatch", ^ {
         [dispatcher dispatchEvent:event];

         [event.target shouldBeNil];
         [[theValue(event.eventPhase) should] equal:theValue(EVEEventPhaseNone)];
      });
   });
});

SPEC_END