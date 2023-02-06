# Managers

Managers are special classes which collate information which pertains to the entire device. Each manager class applies to a specific functional context. All managers must inherit from `NcManager`.

All managers MUST always exist as members in the root block and have a fixed role.

The roles for the managers defined by the framework are defined using the `control-class extension` as a third argument.

Example:

```typescript
[control-class("1.3.1", "1.0.0", "DeviceManager")] interface NcDeviceManager: NcManager
```

## Device manager

The device manager contains basic device information and statuses.

| **Property Name** | **Datatype**                   | **Readonly** | **Description**                                                         |
| ----------------- | ------------------------------ | ------------ | ------------------------------------------------------------------------|
| ncVersion         | NcVersionCode                  | Yes          | Version of NC this device is compatible with                            |
| manufacturer      | NcString                       | Yes          | Manufacturer descriptor                                                 |
| product           | NcString                       | Yes          | Product descriptor                                                      |
| serialNumber      | NcString                       | Yes          | Manufacturer's serial number                                            |
| userInventoryCode | NcString                       | No           | Asset tracking identifier (user specified)                              |
| deviceName        | NcString                       | No           | Name of this device in the application. Instance name, not product name |
| deviceRole        | NcString                       | No           | Role of this device in the application                                  |
| operationalState  | NcDeviceOperationalState       | Yes          | Device operational state                                                |
| resetCause        | NcResetCause                   | Yes          | Reason for most recent reset                                            |
| message           | NcString?                      | Yes          | Arbitrary message from the device to controllers                        |

Where the following types are defined:

```typescript
enum NcResetCause {
    "Unknown",              // 0 Last reset cause is unknown.
    "PowerOn",              // 1 Last reset was caused by device power-on.
    "InternalError",        // 2 Last reset was caused by an internal error.
    "Upgrade",              // 3 Last reset was caused by a software or firmware upgrade.
    "ControllerRequest",    // 4 Last reset was caused by a controller request.
    "ManualReset"           // 5 Last reset was caused by a manual request from the front panel of the device.
};

enum NcDeviceGenericState {
    "NormalOperation", // 0 Device is operating normally.
    "Initializing", // 1 Device is starting  or restarting.
    "Updating", // 2 Device is performing a software or firmware update.
};

interface NcDeviceOperationalState {
    attribute NcDeviceGenericState generic;
    attribute NcString? deviceSpecificDetails;
};
```

## Subscription manager

The `NcSubscriptionManager` is a special manager which handles clients subscribing to events.
Subscribing is the way in which events can be consumed as notifications through a supported control protocol.

Subscribing to an event is done by calling the AddSubscription method and passing in the desired object id.

```typescript
[element("3m1")]
NcMethodResult AddSubscription(NcOid oid); // Will subscribe to changes from all of the properties on the specified oid
```

Unsubscribing to an event is done by calling the RemoveSubscription method and passing in the desired object id.

```typescript
[element("3m2")]
NcMethodResult RemoveSubscription(NcOid oid); // Will unsubscribe to changes from all of the properties on the specified oid
```

## Class manager

The `NcClassManager` is a special manager which handles class and type discovery.

The manager has two properties:

* controlClasses (lists all classes in the device using the `NcClassDescriptor` type)
* datatypes (lists all data types in the device using the `NcDatatypeDescriptor` type)

Where `NcClassDescriptor` is:

```typescript
interface NcDescriptor {
    attribute NcString? description; // optional user facing description
};

interface NcClassDescriptor: NcDescriptor {
    attribute sequence<NcPropertyDescriptor> properties; / 0-n property descriptors
    attribute sequence<NcMethodDescriptor> methods; // 0-n method descriptors.
    attribute sequence<NcEventDescriptor> events; // 0-n event descriptors.
};
```

and `NcDatatypeDescriptor` is:

```typescript
interface NcDatatypeDescriptor: NcDescriptor {
    attribute NcName name; // datatype name
    attribute NcDatatypeType type; // Primitive, Typedef, Struct, Enum
    attribute NcParameterConstraint? constraints; // optional constraints on top of the underlying data type
};

interface NcDatatypeDescriptorPrimitive: NcDatatypeDescriptor {
    //type will be Primitive
};

interface NcDatatypeDescriptorTypeDef: NcDatatypeDescriptor {
    //type will be Typedef
    attribute NcName content; // original typedef datatype name
    attribute NcBoolean isSequence  // TRUE iff type is a typedef sequence of another type
};

interface NcDatatypeDescriptorStruct: NcDatatypeDescriptor {
    //type will be Struct
    attribute sequence<NcFieldDescriptor> content; // one item descriptor per field of the struct
    attribute NcName? parentType; // name of the parent type if any or null if it has no parent
};

interface NcDatatypeDescriptorEnum: NcDatatypeDescriptor {
    //type will be Enum
    attribute sequence<NcEnumItemDescriptor> content; // one item descriptor per enum option
};
```

The descriptor for an individual control class may be retrieved using the `GetControlClass` method (`[element("3m1")]`) and passing the identity (type `NcClassIdentity`) and allElements (if all inherited elements should be included - type `NcBoolean`) as arguments. The method has a response of type `NcMethodResultClassDescriptor`.

```typescript
interface NcClassIdentity {
    attribute NcClassId id;
    attribute NcVersionCode version;
}

interface NcMethodResultClassDescriptor : NcMethodResult { // class descriptors result
    attribute NcClassDescriptor value;
};
```

The descriptor for an individual data type may be retrieved using the `GetDatatype` method (`[element("3m2")]`) and passing the name (type `NcName`) and allDefs (if all component datatype should be included - type `NcBoolean`) as arguments. The method has a response of type `NcMethodResultDatatypeDescriptor`.

```typescript
interface NcMethodResultDatatypeDescriptor : NcMethodResult { // dataype descriptors result
    attribute NcDatatypeDescriptor value;
};
```

## Other managers

| **Name**             | **Description**                                                                 |
| -------------------- | --------------------------------------------------------------------------------|
| NcFirmwareManager    | Manager handling device firmware operations                                     |
| NcDeviceTimeManager  | Manager handling device's internal clock(s) and its reference                   |
