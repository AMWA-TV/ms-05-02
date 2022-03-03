# Managers

Managers are special classes which collate information which pertains to the entire device. Each manager class applies to a specific functional context. All managers must inherit from `ncManager`.

All managers MUST always exist as members in the root block.

`TODO`: Figure out how to specify manager roles and mention that they are fixed.

## Device manager

The device manager contains basic device information and statuses.

| **Property Name** | **Datatype**                   | **Readonly** | **Description**                                                         |
| ----------------- | ------------------------------ | ------------ | ------------------------------------------------------------------------|
| ncVersion        | ncVersionCode                 | Yes          | Version of NCA this device is compatible with                           |
| manufacturer      | ncString                      | Yes          | Manufacturer descriptor                                                 |
| product           | ncString                      | Yes          | Product descriptor                                                      |
| serialNumber      | ncString                      | Yes          | Manufacturer's serial number                                            |
| userInventoryCode | ncString                      | Yes          | Asset tracking identifier (user specified)                              |
| deviceName        | ncString                      | Yes          | Name of this device in the application. Instance name, not product name |
| deviceRole        | ncString                      | No           | Role of this device in the application                                  |
| controlEnabled    | ncBoolean                     | Yes          | Indicates if this device is responsive to NCA commands                  |
| operationalState  | ncDeviceOperationalState      | Yes          | Device operational state                                                |
| resetCause        | ncResetCause                  | Yes          | Reason for most recent reset                                            |
| message           | ncString                      | Yes          | Arbitrary message from the device to controllers                        |

Where the following types are defined:

```typescript
enum ncResetCause {
    "powerOn", // 0 Last reset was caused by device power-on.
    "internalError", // 1 Last reset was caused by an internal error.
    "upgrade", // 2 Last reset was caused by a software or firmware upgrade.
    "controllerRequest" // 3 Last reset was caused by a controller request.
};

enum  ncDeviceGenericState {
    "normalOperation", // 0 Device is operating normally.
    "initializing", // 1 Device is starting  or restarting.
    "updating", // 2 Device is performing a software or firmware update.
};

interface ncDeviceOperationalState {
    attribute ncDeviceGenericState generic;
    attribute ncBlob detail;
};
```

## Subscription manager

The `ncSubscriptionManager` is a special manager which handles clients subscribing to events.
Subscribing is the way in which events can be consumed as notifications through a supported control protocol.

Subscribing to an event is done by calling the AddSubscription method add passing in the event data described by an `ncEvent` type.

```typescript
[element("3m1")]
ncMethodResult AddSubscription(
    ncEvent event// the event to which the controller is subscribing
);
```

```typescript
interface ncEvent{ // unique combination of emitter OID and Event ID
    attribute ncOid emitterOid; 
    attribute ncEventID eventId; 
};

// CLASS ELEMENT ID
interface ncElementID {
    attribute ncUint16 level;
    attribute ncUint16 index;
};

typedef ncElementID ncEventID;
```

Unsubscribing to an event is done by calling the RemoveSubscription method add passing in the event data described by an `ncEvent` type.

```typescript
[element("3m2")]
ncMethodResult RemoveSubscription(
    ncEvent event
);
```

## Class manager

The `ncClassManager` is a special manager which handles class and type discovery.

The manager has two properties:

* controlClasses (lists all classes in the device using the `ncClassDescriptor` type)
* datatypes (lists all data types in the device using the `ncDatatypeDescriptor` type)

Where `ncClassDescriptor` is:

```typescript
interface ncClassDescriptor { // Descriptor of a class
    ncString   description; // non-programmatic description - may be empty
    sequence<ncPropertyDescriptor> properties; // 0-n property descriptors
    sequence<ncMethodDescriptor> methods; // 0-n method descriptors
    sequence<ncEventDescriptor> events; // 0-n event descriptors
};
```

and `ncDatatypeDescriptor` is:

```typescript
enum ncDatatypeType { // what sort of datatype this is
    "primitive", // 0 primitive, e.g. ncUint16
    "typedef", // 1 typedef, i,e. simple alias of another datatype
    "struct", // 2 data structure
    "enum", // 3 enumeration
    "null" // 4 null
};

interface ncDatatypeDescriptor {
    ncName name; // datatype name
    ncDatatypeType type; // primitive, typedef, struct, enum, or null
    (ncString  or ncName or sequence<ncFieldDescriptor> or sequence<ncEnumItemDescriptor> or null) content; // dataype content, see below
    
    //  Contents of property 'content':
    // type content
    // -----------------------------------------------------------------------------------------
    // primitive empty string
    // typedef name of referenced type
    // struct sequence<ncFieldDescriptor>, one item per field of the struct
    // enum sequence<ncEnumItemDescriptor>, one item per enum option
    // null null
    // -----------------------------------------------------------------------------------------
};
```

The descriptor for an individual control class may be retrieved using the `GetControlClass` method (`[element("3m1")]`) and passing the identity (type `ncClassIdentity`) and allElements (if all inherited elements should be included - type `ncBoolean`) as arguments. The method has a response of type `ncMethodResultClassDescriptors`.

```typescript
interface ncClassIdentity {
    attribute ncClassId id;
    attribute ncVersionCode version;
}

interface ncMethodResultClassDescriptors : ncMethodResult { // class descriptors result
    attribute sequence<ncClassDescriptor> descriptor;
};
```

The descriptor for an individual data type may be retrieved using the `GetDatatype` method (`[element("3m2")]`) and passing the name (type `ncName`) and allDefs (if all component datatype should be included - type `ncBoolean`) as arguments. The method has a response of type `ncMethodResultDatatypeDescriptors`.

```typescript
interface ncMethodResultDatatypeDescriptors : ncMethodResult { // dataype descriptors result
    attribute sequence<ncDatatypeDescriptor> value;
};
```

## Other managers

| **Name**             | **Description**                                                      |
| -------------------- | ---------------------------------------------------------------------|
| ncSecurityManager    | Manager handling security features inside the device                 |
| ncFirmwareManager    | Manager handling device firmware operations                          |
| ncDeviceTimeManager  | Manager handling device's internal clock(s) and its reference        |
