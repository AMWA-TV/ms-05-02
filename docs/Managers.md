# Managers

Managers are special classes which collate information which pertains to the entire device. Each manager class applies to a specific functional context. All managers must inherit from `ncaManager`.

All managers MUST always exist as members in the root block.

`TODO`: Figure out how to specify manager roles and mention that they are fixed.

## Device manager

The device manager contains basic device information and statuses.

| **Property Name** | **Datatype**                   | **Readonly** | **Description**                                                         |
| ----------------- | ------------------------------ | ------------ | ------------------------------------------------------------------------|
| ncaVersion        | ncaVersionCode                 | Yes          | Version of NCA this device is compatible with                           |
| manufacturer      | ncaString                      | Yes          | Manufacturer descriptor                                                 |
| product           | ncaString                      | Yes          | Product descriptor                                                      |
| serialNumber      | ncaString                      | Yes          | Manufacturer's serial number                                            |
| userInventoryCode | ncaString                      | Yes          | Asset tracking identifier (user specified)                              |
| deviceName        | ncaString                      | Yes          | Name of this device in the application. Instance name, not product name |
| deviceRole        | ncaString                      | No           | Role of this device in the application                                  |
| controlEnabled    | ncaBoolean                     | Yes          | Indicates if this device is responsive to NCA commands                  |
| operationalState  | ncaDeviceOperationalState      | Yes          | Device operational state                                                |
| resetCause        | ncaResetCause                  | Yes          | Reason for most recent reset                                            |
| message           | ncaString                      | Yes          | Arbitrary message from the device to controllers                        |

Where the following types are defined:

```typescript
enum ncaResetCause {
    "powerOn", // 0 Last reset was caused by device power-on.
    "internalError", // 1 Last reset was caused by an internal error.
    "upgrade", // 2 Last reset was caused by a software or firmware upgrade.
    "controllerRequest" // 3 Last reset was caused by a controller request.
};

enum  ncaDeviceGenericState {
    "normalOperation", // 0 Device is operating normally.
    "initializing", // 1 Device is starting  or restarting.
    "updating", // 2 Device is performing a software or firmware update.
};

interface ncaDeviceOperationalState {
    attribute ncaDeviceGenericState generic;
    attribute ncaBlob detail;
};
```

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

The `ncaClassManager` is a special manager which handles class and type discovery.

The manager has two properties:

* controlClasses (lists all classes in the device using the `ncaClassDescriptor` type)
* datatypes (lists all data types in the device using the `ncaDatatypeDescriptor` type)

Where `ncaClassDescriptor` is:

```typescript
interface ncaClassDescriptor { // Descriptor of a class
    ncaString   description; // non-programmatic description - may be empty
    sequence<ncaPropertyDescriptor> properties; // 0-n property descriptors
    sequence<ncaMethodDescriptor> methods; // 0-n method descriptors
    sequence<ncaEventDescriptor> events; // 0-n event descriptors
};
```

and `ncaDatatypeDescriptor` is:

```typescript
enum ncaDatatypeType { // what sort of datatype this is
    "primitive", // 0 primitive, e.g. ncaUint16
    "typedef", // 1 typedef, i,e. simple alias of another datatype
    "struct", // 2 data structure
    "enum", // 3 enumeration
    "null" // 4 null
};

interface ncaDatatypeDescriptor {
    ncaName name; // datatype name
    ncaDatatypeType type; // primitive, typedef, struct, enum, or null
    (ncaString  or ncaName or sequence<ncaFieldDescriptor> or sequence<ncaEnumItemDescriptor> or null) content; // dataype content, see below
    
    //  Contents of property 'content':
    // type content
    // -----------------------------------------------------------------------------------------
    // primitive empty string
    // typedef name of referenced type
    // struct sequence<ncaFieldDescriptor>, one item per field of the struct
    // enum sequence<ncaEnumItemDescriptor>, one item per enum option
    // null null
    // -----------------------------------------------------------------------------------------
};
```

The descriptor for an individual control class may be retrieved using the `GetControlClass` method (`[element("3m1")]`) and passing the identity (type `ncaClassIdentity`) and allElements (if all inherited elements should be included - type `ncaBoolean`) as arguments. The method has a response of type `ncaMethodResultClassDescriptors`.

```typescript
interface ncaClassIdentity {
    attribute ncaClassId id;
    attribute ncaVersionCode version;
}

interface ncaMethodResultClassDescriptors : ncaMethodResult { // class descriptors result
    attribute sequence<ncaClassDescriptor> descriptor;
};
```

The descriptor for an individual data type may be retrieved using the `GetDatatype` method (`[element("3m2")]`) and passing the name (type `ncaName`) and allDefs (if all component datatype should be included - type `ncaBoolean`) as arguments. The method has a response of type `ncaMethodResultDatatypeDescriptors`.

```typescript
interface ncaMethodResultDatatypeDescriptors : ncaMethodResult { // dataype descriptors result
    attribute sequence<ncaDatatypeDescriptor> value;
};
```

## Other managers

| **Name**             | **Description**                                                       |
| -------------------- | ----------------------------------------------------------------------|
| ncaSecurityManager   | Manager handling security features inside the device                  |
| ncaFirmwareManager   | Manager handling device firmware operations                           |
| ncaDeviceTimeManager | Manager handling device's internal clock(s) and its reference         |
| ncaLockManager       | Manager handling lock features across the device                      |
