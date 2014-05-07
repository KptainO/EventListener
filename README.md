EventListener
=============

EventListener is an Obsever design pattern implementation with an API very similar to those from Javascript DOM/ActionScript

## What's wrong with NSNotification?

Like EventListener, NSNotification implement the Obsever design pattern: you subscribe to events/notifications. And it is very good at doing one job: getting global (or from specific set of objects) notifications. But it lacks some crucial functionalities when working with UI:

- You can't stop an event. Once it is fired *EVERY* listener will get it
- You can't observe events only from your children. As you need to listen globally or provide the set of objects to filter with, you're stuck of getting everything or just from you child at depth n + 1
- You don't know in which order your listeners will be called

EventListener tries to overtake those limitations and even more by bringing the well-known Javascript DOM API to iOS

> NOTE: You should still continue to use NSNotification when you want to send global notifications
