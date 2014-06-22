EventListener
=============

EventListener is an Obsever design pattern implementation with an API very similar to those from Javascript/ActionScript DOM including:

- Event priority. Events with a high priority are called before those with a lower one
- Capture/Target/Bubbling phase
- Event default behaviour cancellation
- Event propagation cancellation

More information on DOM events [http://www.w3.org/TR/DOM-Level-3-Events/](here)

## What's wrong with NSNotification?

Like EventListener, NSNotification implement the Obsever design pattern: you subscribe to events/notifications. And it is very good at doing one job: getting global (or from specific set of objects) notifications. But it lacks some crucial functionalities when working with UI:

- You can't stop an event. Once it is fired *EVERY* listener will get it
- You can't observe events only from your children. As you need to listen globally or provide the set of objects to filter with, you're stuck of getting everything or just from you child at depth n + 1
- You don't know in which order your listeners will be called

EventListener tries to overtake those limitations and even more by bringing the well-known Javascript DOM API to iOS

> NOTE: You should still continue to use NSNotification when you want to send global notifications

## How to use it

API behaves a lot like the one from DOM events. All you need to do is:

- Create a custom event
- Add a listener listening to it
- Trigger it

```obj-c

extern NSString *MyCustomEventClicked;
extern NSString *MyCustomEventDoubleClicked;

@interface MyCustomEvent : EVEEvent

// Add all your custom event properties

@end

@implementation aViewController

- (void)aMethod {
  [self addEventListener:MyCustomEventCliked listener:@selector(onClicked:) useCapture:YES];
}

- (void)onClicked:(MyCustomEvent *)event {
  // Do whatever you want
}

@end

/// somewhere in your code
MyCustomEvent *event = [MyCustomEvent event:MyCustomEventClicked];

// configure it
[self dispatchEvent:event];

```

> NOTE: UIViewController and UIView are event listeners ready. So you can trigger and listen to events inside those classes right away!

## Dispatch chain

EventListener is dispatching the event along the iOS responder chain. That's how both UIViewConttoller and UIView are able to trigger and/or listen to events

