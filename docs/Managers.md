# Managers

Managers are special classes which collate information which pertains to the entire device. Each manager class applies to a specific functional context. All managers must inherit from `ncaManager`.

TODO: Mention managers need to always exist as members in the root block.

TODO: Figure out how to specify manager roles and mention that they are fixed.

TODO: Add section for the device manager here

## Subscription manager

The `ncaSubscriptionManager` is a special manager which handles clients subscribing to events.
Subscribing is the way in which events can be consumed as notifications through a supported control protocol.

Subscribing to an event is done by calling the AddSubscription method add passing in the event data described by an `ncaEvent` type.

```typescript
[element("3m1")]
ncaMethodResult AddSubscription(
    ncaEvent event// the event to which the controller is subscribing
);
```

```typescript
interface ncaEvent{ // NCA event - unique combination of emitter OID and Event ID
    attribute ncaOid emitterOid; 
    attribute ncaEventID eventId; 
};

// CLASS ELEMENT ID
interface ncaElementID {
    attribute ncaUint16 level;
    attribute ncaUint16 index;
};

typedef ncaElementID ncaEventID;
```

Unsubscribing to an event is done by calling the RemoveSubscription method add passing in the event data described by an `ncaEvent` type.

```typescript
[element("3m2")]
ncaMethodResult RemoveSubscription(
    ncaEvent event
);
```

## Class manager

- Class manager description
- Class discovery mechanism

TODO: List all the other managers in the webIDL in a table
