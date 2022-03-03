# Concepts

The webIDL definitions are available [here](idl/NC-Framework.webidl).

The definitions include datatypes and classes which include properties, methods and events.

Here are some examples:

Object id datatype

```typescript
typedef ncUint32 ncOid;
```

Element id datatype

```typescript
interface ncElementID {
    attribute ncUint16 level;
    attribute ncUint16 index;
};
```

Properties, methods and events inside a class are uniquely identified using the element webIDL extension:

* properties - `[element("_p_")]`
* methods - `[element("_m_")]`
* events - `[element("_e_")]`

Here are some examples from the `ncObject` class:

```typescript
[control-class("1",1)] interface ncObject {

    // PROPERTIES

    [element("1p1")]  static readonly attribute ncClassID classId;
    [element("1p2")]  static readonly attribute ncVersionCode classVersion;
    [element("1p3")]  readonly attribute ncOid oid;
    [element("1p4")]  readonly attribute ncBoolean constantOid;
    [element("1p5")]  readonly attribute ncOid owner;
    [element("1p6")]  readonly attribute ncRole role;
    [element("1p7")]  attribute ncString userLabel;
    ...
    
    // GENERIC GET/SET METHODS

    [element("1m1")]  ncMethodResultPropertyValue get(ncPropertyId Id);
    [element("1m2")]  ncMethodResult set(ncPropertyID id, any Value);
    ...

    // Optional lock methods
    [element("1m8")]  ncMethodResult lockWait(
        ncOid target,
        ncLockStatus requestedLockStatus,
        ncTimeInterval timeout
    );

    [element("1m9")]  ncMethodResult abortWaits(ncOid target);

    // EVENTS
    [element("1e1")] [event] void PropertyChanged(ncPropertyChangedEventData eventData);
};
```

Optional properties and method arguments are signaled via the `[optional]` token in front of an attribute or in front of the method argument.

Examples:

```typescript
[optional] attribute any value;
```

```typescript
[element("9m9")]  ncMethodResult someMethod(ncPropertyID id, optional any Value);
```

Readonly properties are signaled using the `readonly` token as specified in the webIDL standard.

Nullable types are signaled using the `?` marker at the end of the type as specified in the webIDL standard.

Example:

```typescript
[control-class("1.99",1)] interface someClass {
    [element("2p55")]  attribute someType? someProperty;
    [element("2m20")]  someReturnType someMethod(someArgType? argument);
};
```

All methods must return a class which inherits from `ncMethodResult` and provide a status and an optional errorMessage.

```typescript
interface ncMethodResult {// Base datatype
    attribute ncMethodStatus status;
    attribute ncString errorMessage;
};
```

`ncMethodStatus` is an enumeration:

```typescript
enum ncMethodStatus {// Method result status values
    "ok", // 0  It worked. 
    "protocolVersionError", // 1  Control PDU had incompatible protocol version code 
    "deviceError", // 2  Something went wrong
    ...
};
```

Derived `ncMethodResult` types may also return values or possibly further custom statuses.

```typescript
interface ncMethodResultOID : ncMethodResult { // object ID result
    attribute ncOid value;
};
```
