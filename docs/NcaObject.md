# NcaObject

NcaObject is the base abstract class from which all other NCA classes must inherit from.

The properties of NcaObject are listed in the following table.

| **Property Name** | **Datatype**                   | **Readonly** | **Description**                                                       |
| ----------------- | ------------------------------ | ------------ | ----------------------------------------------------------------------|
| classId           | ncaClassID                     | Yes          | sequence of numeric class identifiers or authority keys               |
| classVersion      | ncaVersionCode                 | Yes          | class version represented according to Semantic versioning guidelines |
| oid               | ncaOid                         | Yes          | unique object id                                                      |
| constantOid       | ncaBoolean                     | Yes          | flag to indicate if the oid is constant or not                        |
| owner             | ncaOid                         | Yes          | unique object id of the parent                                        |
| role              | ncaRole                        | Yes          | unique role of the object within the containing block                 |
| userLabel         | ncaString                      | No           | user definable label                                                  |
| lockable          | ncaBoolean                     | Yes          | flag to indicate if the object can be locked                          |
| lockState         | ncaLockState                   | Yes          | current lock state of the object                                      |
| touchpoints       | sequence<ncaTouchpoint>        | Yes          | sequence of touchpoint (see Touchpoints section for details)          |

The `role` is a structural identifier which MUST be persisted across restarts. The role path of an element can be constructed of its role and the roles of all its parents. The role path can then be used to target a particular section of the control model tree or to retrieve the object ids again after a restart.

Object ids (`oid` property) may be constant across system restarts in which case they MUST be signaled using the `constandOid` property by settings its value to `true`.

## Generic getter and setter

NcaObject offers two generic methods for retrieving and setting a property on an object.

The get method (`[element("1m1")]`) accepts `ncaPropertyId` (which is a pointer for `ncaElementID`) as an arguments and returns `ncaMethodResultPropertyValue`.

```typescript
// CLASS ELEMENT ID  
interface ncaElementID {
    attribute ncaUint16 level;
    attribute ncaUint16 index;
};

typedef ncaElementID ncaPropertyID;
```

`ncaMethodResultPropertyValue` inherits from `ncaMethodResult` but can return any value type depending on the underlying property type.

```typescript
interface ncaMethodResultPropertyValue : ncaMethodResult { // property-value result
    attribute any value;
}
```

The set method (`[element("1m2")]`) accepts `ncaPropertyId` and any value (type depends on the underlying property type) as arguments. The return type is the base `ncaMethodResult`.

## PropertyChanged event

NcaObject offers a PropertyChanged event `[element("1e1")]` which MUST trigger anytime a property on the object is changed.
The event data is of type `ncaPropertyChangedEventData` which MUST include the property id, property value and the change type.

```typescript
interface ncaPropertyChangedEventData {
    attribute ncaPropertyID propertyId; // ID of changed property
    attribute ncaPropertyChangeType changeType; // Mainly for maps & sets
    attribute any propertyValue; // Property-type specific 
};

enum ncaPropertyChangeType {// Type of property change
    "currentChanged", // 0 Scalar property - current value changed
    "minChanged", // 1 Scalar property - min allowed value changed
    "maxChanged", // 2 Scalar property - max allowed value change
    "itemAdded", // 3 Set or map - item(s) added
    "itemChanged", // 4 Set or map - item(s) changed
    "itemDeleted" // 5 Set or map - item(s) deleted
};
```

Events can only be consumed as notifications when subscribed to in the SubscriptionManager. See the [Managers](Managers.md) section.

## Working with collections inside an ncaObject

Collection types are defined as webIDL sequences of a specific type.
There are generic methods for getting, setting, adding and deleting items inside a collection property as part of `ncaObject`.

Getting a collection item is done through the `getCollectionItem` method ([element("1m4")]) by specifying the property identifier (`ncaPropertyId`) and the index as arguments.
The result is of type `ncaMethodResultPropertyValue`.

Setting a collection item is done through the `setCollectionItem` method ([element("1m5")]) by specifying the property identifier (`ncaPropertyId`), the index and the value as arguments.
The result is of type `ncaMethodResult`.

Adding an item to a collection is done through the `addCollectionItem` method ([element("1m6")]) by specifying the property identifier (`ncaPropertyId`) and the value as arguments.
The result is of type `ncaMethodResultId32` which contains the index where the value was added.

Removing an item from a collection is done through the `removeCollectionItem` method ([element("1m7")]) by specifying the property identifier (`ncaPropertyId`) and the index as arguments.
The result is of type `ncaMethodResult`.

## Touchpoints

Touchpoints represent the way in which a control model object may expose identity mappings across other contexts.
All `ncaObject` may have touchpoints.

The `ncaTouchpoint` class specifies a namespace and resources.

```typescript
interface ncaTouchpoint{
    attribute ncaString contextNamespace;
    attribute ncaTouchpointResource resources;
};
```

The `ncaTouchpointResource` class MUST specify a resourceType and an id.

```typescript
interface ncaTouchpointResource{
    attribute ncaString resourceType;
    attribute any id;
};
```

For NMOS namespaces there are derived types.

```typescript
// IS-04 registrable entities
interface ncaTouchpointNmos : ncaTouchpoint{
    // ContextNamespace is inherited from ncaTouchpoint.
    attribute ncaTouchpointResourceNmos resources;
};

interface ncaTouchpointResourceNmos : ncaTouchpointResource{
    // ResourceType is inherited from ncaTouchpoint. 
    attribute ncaString id; // override 
};

// IS-08 inputs or outputs
interface ncaTouchpointResourceNmos_is_08 : ncaTouchpointResourceNmos{
    // resourceType is inherited from ncaTouchpointResource
    // id is inherited from ncaTouchpointResourceNmos
    attribute ncaString ioId; // IS-08 input or output ID
};
```

For general NMOS contexts (IS-04, IS-05 and IS-07) the `ncaTouchpointNmos` class MUST be used which has a resource of type `ncaTouchpointResourceNmos`. This allows specifying the UUID of the underlying NMOS resource.

For IS-08 this is further derived to use a resource of type `ncaTouchpointResourceNmos_is_08`. This allows linking to a UUID and an input or output id.

Architectural information about the touchpoints concept is available in the architecture document under the [NCA-NMOS identity mapping](https://specs.amwa.tv/ms-05-01/branches/v1.0-dev/docs/Identification.html#nca-nmos-identity-mapping) section.
