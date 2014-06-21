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
       [event stub:@selector(type) andReturn:@"eventName"];
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

          [dispatcher addEventListener:@"eventName" listener:selector2 useCapture:NO priority:2];
          [dispatcher addEventListener:@"eventName" listener:selector1 useCapture:NO priority:1];
          [event stub:@selector(eventPhase) andReturn:theValue(EVEEventPhaseTarget)];

         [[dispatcherTarget should] receive:selector1];
         [[dispatcherTarget should] receive:selector2];

         [dispatcher dispatchEvent:event];

      });

      it(@"should ONLY invoke listeners matching event.name", ^{
         SEL selector = NSSelectorFromString(@"callback");

         [dispatcher addEventListener:@"wrongEvent" listener:selector useCapture:NO priority:1];

         [[dispatcherTarget shouldNot] receive:selector];

         [dispatcher dispatchEvent:event];
      });

       it(@"should not be invoked if event.stopImmediatePropagation", ^{
           SEL selector1 = NSSelectorFromString(@"callback1");
           SEL selector2 = NSSelectorFromString(@"callback2");

           [event stub:@selector(eventPhase) andReturn:theValue(EVEEventPhaseTarget)];
           [dispatcherTarget stub:selector1 withBlock:^id(NSArray *params) {
               [event stub:@selector(isImmediatePropagationStopped) andReturn:theValue(YES)];
               return nil;
           }];

           [dispatcher addEventListener:@"eventName" listener:selector1];
           [dispatcher addEventListener:@"eventName" listener:selector2];

           [[dispatcherTarget should] receive:selector1];
           [[dispatcherTarget shouldNot] receive:selector2];

           [dispatcher dispatchEvent:event];
       });

      describe(@"phase", ^{
          __block NSObject<EVEEventDispatcher> *parent;

          beforeEach(^{
              parent = [KWMock mockForProtocol:@protocol(EVEEventDispatcher)];

              [dispatcherTarget stub:@selector(nextDispatcher) andReturn:parent];
              [parent stub:@selector(nextDispatcher) andReturn:nil];
              [parent stub:@selector(dispatchEvent:)];
          });

         describe(@"capture", ^{
            it(@"should be invoked if useCapture == YES", ^{
                SEL selector = NSSelectorFromString(@"callback");

                [dispatcher addEventListener:@"eventName" listener:selector useCapture:YES];
                [event stub:@selector(eventPhase) andReturn:theValue(EVEEventPhaseCapturing)];

                // We setted phase to Capturing
                // So if target is receiving the desired it means it was trigerred while into Capturing phase
                [[dispatcherTarget should] receive:selector];

                [dispatcher dispatchEvent:event];
            });

            it(@"should be skipped if event.stopPropagation called before dispatch", ^{
                [event stub:@selector(isPropagationStopped) andReturn:theValue(YES)];

                [[dispatcherTarget shouldNot] receive:@selector(nextDispatcher)];

                [dispatcher dispatchEvent:event];
            });
         });

         describe(@"target", ^{
            it(@"should be invoked if event.target is self", ^{
                SEL selector = NSSelectorFromString(@"callback");

                [dispatcher addEventListener:@"eventName" listener:selector useCapture:NO priority:1];
                [event stub:@selector(eventPhase) andReturn:theValue(EVEEventPhaseTarget)];

                [[dispatcherTarget should] receive:selector];

                [dispatcher dispatchEvent:event];
            });

            it(@"should be skipped if event.stopPropagation", ^{
                [parent stub:@selector(dispatchEvent:) withBlock:^id(NSArray *params) {
                    [event stub:@selector(isPropagationStopped) andReturn:theValue(YES)];
                    return nil;
                }];

                [[parent should] receive:@selector(dispatchEvent:)];
                [[event shouldNot] receive:@selector(setEventPhase:) withArguments:theValue(EVEEventPhaseTarget), nil];
                [[event shouldNot] receive:@selector(setEventPhase:) withArguments:theValue(EVEEventPhaseBubbling), nil];

                [dispatcher dispatchEvent:event];
            });
         });

         describe(@"bubbling", ^{
            it(@"should be invoked if useCapture == NO", ^{
                SEL selector = NSSelectorFromString(@"callback:");

                [dispatcher addEventListener:@"eventName" listener:selector];
                [event stub:@selector(eventPhase) andReturn:theValue(EVEEventPhaseBubbling)];

                // We setted phase to Bubbling
                // So if target is receiving the desired it means it was trigerred while into Bubbling phase
                [[dispatcherTarget should] receive:selector];

                [dispatcher dispatchEvent:event];
            });

            it(@"should not be invoked if event.stopPropagation", ^{
                SEL selector = NSSelectorFromString(@"callback");

                [dispatcherTarget stub:selector withBlock:^id(NSArray *params) {
                    [event stub:@selector(isPropagationStopped) andReturn:theValue(YES)];

                    return nil;
                }];
                [dispatcher addEventListener:@"eventName" listener:selector];

                [[dispatcherTarget should] receive:selector];
                [[event shouldNot] receive:@selector(setEventPhase:) withArguments:theValue(EVEEventPhaseBubbling), nil];

                [dispatcher dispatchEvent:event];
            });
         });
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

      it(@"should have event.capturePhase to EVEEventPhaseBubbling on bubbling phase when event.bubbles", ^{
         [event stub:@selector(bubbles) andReturn:theValue(YES)];

         [[event should] receive:@selector(setEventPhase:) withCount:1 arguments:theValue(EVEEventPhaseBubbling)];

         [dispatcher dispatchEvent:event];
      });

      it(@"should NOT have event.capturePhase to EVEEventPhaseBubbling on bubbling phase when !event.bubbles", ^{
         [event stub:@selector(bubbles) andReturn:theValue(NO)];
         
         [[event shouldNot] receive:@selector(setEventPhase:) withCount:1 arguments:theValue(EVEEventPhaseBubbling)];

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
