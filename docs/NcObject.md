# NcObject

NcObject is the base abstract class from which all other NCA classes must inherit from.

The properties of NcObject are listed in the following table.

| **Property Name** | **Datatype**                   | **Readonly** | **Description**                                                       |
| ----------------- | ------------------------------ | ------------ | ----------------------------------------------------------------------|
| classId           | ncClassID                      | Yes          | sequence of numeric class identifiers or authority keys               |
| classVersion      | ncVersionCode                  | Yes          | class version represented according to Semantic versioning guidelines |
| oid               | ncOid                          | Yes          | unique object id                                                      |
| constantOid       | ncBoolean                      | Yes          | flag to indicate if the oid is constant or not                        |
| owner             | ncOid                          | Yes          | unique object id of the parent                                        |
| role              | ncRole                         | Yes          | unique role of the object within the containing block                 |
| userLabel         | ncString                       | No           | user definable label                                                  |
| lockable          | ncBoolean                      | Yes          | flag to indicate if the object can be locked                          |
| lockState         | ncLockState                    | No           | current lock state of the object                                      |
| touchpoints       | sequence<ncTouchpoint>         | Yes          | sequence of touchpoint (see Touchpoints section for details)          |

The `role` is a structural identifier which MUST be persisted across restarts. The role path of an element can be constructed of its role and the roles of all its parents. The role path can then be used to target a particular section of the control model tree or to retrieve the object ids again after a restart.

Object ids (`oid` property) may be constant across system restarts in which case they MUST be signaled using the `constandOid` property by settings its value to `true`.

## Generic getter and setter

NcObject offers two generic methods for retrieving and setting a property on an object.

The get method (`[element("1m1")]`) accepts `ncPropertyId` (which is a pointer for `ncElementID`) as an arguments and returns `ncMethodResultPropertyValue`.

```typescript
// CLASS ELEMENT ID  
interface ncElementID {
    attribute ncUint16 level;
    attribute ncUint16 index;
};

typedef ncElementID ncPropertyID;
```

`ncMethodResultPropertyValue` inherits from `ncMethodResult` but can return any value type depending on the underlying property type.

```typescript
interface ncMethodResultPropertyValue : ncMethodResult { // property-value result
    attribute any value;
}
```

The set method (`[element("1m2")]`) accepts `ncPropertyId` and any value (type depends on the underlying property type) as arguments. The return type is the base `ncMethodResult`.

## PropertyChanged event

NcObject offers a PropertyChanged event `[element("1e1")]` which MUST trigger anytime a property on the object is changed.
The event data is of type `ncPropertyChangedEventData` which MUST include the property id, property value and the change type.

```typescript
interface ncPropertyChangedEventData {
    attribute ncPropertyID propertyId; // ID of changed property
    attribute ncPropertyChangeType changeType; // Mainly for maps & sets
    attribute any propertyValue; // Property-type specific 
};

enum ncPropertyChangeType {// Type of property change
    "currentChanged", // 0 Scalar property - current value changed
    "minChanged", // 1 Scalar property - min allowed value changed
    "maxChanged", // 2 Scalar property - max allowed value change
    "itemAdded", // 3 Set or map - item(s) added
    "itemChanged", // 4 Set or map - item(s) changed
    "itemDeleted" // 5 Set or map - item(s) deleted
};
```

Events can only be consumed as notifications when subscribed to in the SubscriptionManager. See the [Managers](Managers.md) section.

## Working with collections inside an ncObject

Collection types are defined as webIDL sequences of a specific type.
There are generic methods for getting, setting, adding and deleting items inside a collection property as part of `ncObject`.

Getting a collection item is done through the `getCollectionItem` method (\[element("1m4")\]) by specifying the property identifier (`ncPropertyId`) and the index as arguments.
The result is of type `ncMethodResultPropertyValue`.

Setting a collection item is done through the `setCollectionItem` method (\[element("1m5")\]) by specifying the property identifier (`ncPropertyId`), the index and the value as arguments.
The result is of type `ncMethodResult`.

Adding an item to a collection is done through the `addCollectionItem` method (\[element("1m6")\]) by specifying the property identifier (`ncPropertyId`) and the value as arguments.
The result is of type `ncMethodResultId32` which contains the index where the value was added.

Removing an item from a collection is done through the `removeCollectionItem` method (\[element("1m7")\]) by specifying the property identifier (`ncPropertyId`) and the index as arguments.
The result is of type `ncMethodResult`.

## Touchpoints

Touchpoints represent the way in which a control model object may expose identity mappings across other contexts.
All `ncObject` may have touchpoints.

The `ncTouchpoint` class specifies a namespace and resources.

```typescript
interface ncTouchpoint{
    attribute ncString contextNamespace;
    attribute ncTouchpointResource resources;
};
```

The `ncTouchpointResource` class MUST specify a resourceType and an id.

```typescript
interface ncTouchpointResource{
    attribute ncString resourceType;
    attribute any id;
};
```

For NMOS namespaces there are derived types.

```typescript
// IS-04 registrable entities
interface ncTouchpointNmos : ncTouchpoint{
    // ContextNamespace is inherited from ncTouchpoint.
    attribute ncTouchpointResourceNmos resources;
};

interface ncTouchpointResourceNmos : ncTouchpointResource{
    // ResourceType is inherited from ncTouchpoint. 
    attribute ncString id; // override 
};

// IS-08 inputs or outputs
interface ncTouchpointResourceNmos_is_08 : ncTouchpointResourceNmos{
    // resourceType is inherited from ncTouchpointResource
    // id is inherited from ncTouchpointResourceNmos
    attribute ncString ioId; // IS-08 input or output ID
};
```

For general NMOS contexts (IS-04, IS-05 and IS-07) the `ncTouchpointNmos` class MUST be used which has a resource of type `ncTouchpointResourceNmos`. This allows specifying the UUID of the underlying NMOS resource.

For IS-08 this is further derived to use a resource of type `ncTouchpointResourceNmos_is_08`. This allows linking to a UUID and an input or output id.

Architectural information about the touchpoints concept is available in the architecture document under the [NCA-NMOS identity mapping](https://specs.amwa.tv/ms-05-01/branches/v1.0-dev/docs/Identification.html#nca-nmos-identity-mapping) section.
