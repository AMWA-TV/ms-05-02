# NcObject

NcObject is the base abstract class from which all other NCA classes must inherit from.

The properties of NcObject are listed in the following table.

| **Property Name** | **Datatype**                   | **Readonly** | **Description**                                                       |
| ----------------- | ------------------------------ | ------------ | ----------------------------------------------------------------------|
| classId           | NcClassID                      | Yes          | sequence of numeric class identifiers or authority keys               |
| classVersion      | NcVersionCode                  | Yes          | class version represented according to Semantic versioning guidelines |
| oid               | NcOid                          | Yes          | unique object id                                                      |
| constantOid       | NcBoolean                      | Yes          | flag to indicate if the oid is constant or not                        |
| owner             | NcOid                          | Yes          | unique object id of the parent                                        |
| role              | NcRole                         | Yes          | unique role of the object within the containing block                 |
| userLabel         | NcString                       | No           | user definable label                                                  |
| touchpoints       | sequence<NcTouchpoint>         | Yes          | sequence of touchpoint (see Touchpoints section for details)          |

The `role` is a structural identifier which MUST be persisted across restarts. The role path of an element can be constructed from its role and the roles of all its parents. The role path can then be used to target a particular section of the control model tree or to retrieve the object ids again after a restart.

Object ids (`oid` property) may be constant across system restarts in which case they MUST be signaled using the `constandOid` property by settings its value to `true`.

## Generic getter and setter

NcObject offers two generic methods for retrieving and setting a property on an object.

The Get method (`[element("1m1")]`) accepts `NcElementId` as an argument and returns `NcMethodResultPropertyValue`.

```typescript
// Class element id which contains the level and index
interface NcElementId {
    attribute NcUint16 level;
    attribute NcUint16 index;
};
```

`NcMethodResultPropertyValue` inherits from `NcMethodResult` but can return any value type depending on the underlying property type.

```typescript
interface NcMethodResultPropertyValue : NcMethodResult { // property-value result
    attribute any? value;
}
```

The Set method (`[element("1m2")]`) accepts `NcElementId` and any value (type depends on the underlying property type) as arguments. The return type is the base `NcMethodResult`.

## PropertyChanged event

NcObject offers a PropertyChanged event `[element("1e1")]` which MUST trigger anytime a property on the object is changed.
The event data is of type `NcPropertyChangedEventData` which MUST include the property id, value and the change type. If the property is a sequence, then the event will also include the index of the item in the sequence which was the subject of the change.

```typescript
interface NcPropertyChangedEventData {
    attribute NcElementId           propertyId;         // ID of changed property
    attribute NcPropertyChangeType  changeType;         // Information regarding the change type
    attribute any?                  value;              // Property-type specific
    attribute NcId32?               sequenceItemIndex;  // Index of sequence item if the property is a sequence
};

// Type of property change
enum NcPropertyChangeType {
    "ValueChanged",         // 0 current value changed
    "SequenceItemAdded",    // 1 sequence item added
    "SequenceItemChanged",  // 2 sequence item changed
    "SequenceItemRemoved"   // 3 sequence item removed
};
```

Events can only be consumed as notifications when subscribed to in the SubscriptionManager. See the [Managers](Managers.md) section.

## Working with collections inside an NcObject

Collection types are defined as Web IDL sequences of a specific type.
There are generic methods for getting, setting, adding and deleting items inside a collection property as part of `NcObject`.

Getting a collection item is done through the `GetSequenceItem` method (\[element("1m3")\]) by specifying the property identifier (`NcElementId`) and the index as arguments.
The result is of type `NcMethodResultPropertyValue`.

Setting a collection item is done through the `SetSequenceItem` method (\[element("1m4")\]) by specifying the property identifier (`NcElementId`), the index and the value as arguments.
The result is of type `NcMethodResult`.

Adding an item to a collection is done through the `AddSequenceItem` method (\[element("1m5")\]) by specifying the property identifier (`NcElementId`) and the value as arguments.
The result is of type `NcMethodResultId32` which contains the index where the value was added.

Removing an item from a collection is done through the `RemoveSequenceItem` method (\[element("1m6")\]) by specifying the property identifier (`NcElementId`) and the index as arguments.
The result is of type `NcMethodResult`.

## Touchpoints

Touchpoints represent the way in which a control model object may expose identity mappings across other contexts.
All `NcObject` may have touchpoints.

The `NcTouchpoint` class specifies a namespace and a resource.

```typescript
interface NcTouchpoint{
    attribute NcString contextNamespace;
    attribute NcTouchpointResource resource;
};
```

The `NcTouchpointResource` class MUST specify a resourceType and an id.

```typescript
interface NcTouchpointResource{
    attribute NcString resourceType;
    attribute any id;
};
```

For NMOS namespaces there are derived types and the `contextNamespace` values can only be `x-nmos` or `x-nmos/channelmapping`.

```typescript
// IS-04 registrable entities
interface NcTouchpointNmos : NcTouchpoint{
    // contextNamespace is inherited from NcTouchpoint and can only be x-nmos or x-nmos/channelmapping
    attribute NcTouchpointResourceNmos resource;
};

interface NcTouchpointResourceNmos : NcTouchpointResource{
    // resourceType is inherited from NcTouchpointResource and can only be: node, device, source, flow, sender, receiver
    attribute NcUUID id; // override 
};

// IS-08 inputs or outputs
interface NcTouchpointResourceNmos_is_08 : NcTouchpointResourceNmos{
    // resourceType is inherited from NcTouchpointResource and can only be: input, output
    // id is inherited from NcTouchpointResourceNmos
    attribute NcString ioId; // IS-08 input or output ID
};
```

For general NMOS contexts (IS-04, IS-05 and IS-07) the `NcTouchpointNmos` class MUST be used which has a resource of type `NcTouchpointResourceNmos`. This allows specifying the UUID of the underlying NMOS resource.

`Note`: The `resourceType` in this case can only be: node, device, source, flow, sender or receiver.

For IS-08 this is further derived to use a resource of type `NcTouchpointResourceNmos_is_08`. This allows linking to a UUID and an input or output id.

`Note`: The `resourceType` in this case can only be: input or output.

Architectural information about the touchpoints concept is available in [MS-05-01](https://specs.amwa.tv/ms-05-01) under the `Identification\NCA-NMOS identity mapping` section.
