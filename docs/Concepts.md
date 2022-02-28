# Concepts

The webIDL definitions are available [here](idl/NC-Framework.webidl).

The definitions include datatypes and classes which include properties, methods and events.

Here are some examples:

Object id datatype

```typescript
typedef ncaUint32 ncaOid;
```

Element id datatype

```typescript
interface ncaElementID {
    attribute ncaUint16 level;
    attribute ncaUint16 index;
};
```

Properties, methods and events inside a class are uniquely identified using the element webIDL extension:

* properties - `[element("_p_")]`
* methods - `[element("_m_")]`
* events - `[element("_e_")]`

Here are some examples from the `ncaObject` class:

```typescript
[control-class("1",1)] interface ncaObject {

    // PROPERTIES

    [element("1p1")]  static attribute ncaClassID classId;
    [element("1p2")]  static attribute ncaVersionCode classVersion;
    [element("1p3")]  attribute ncaOid oid;
    [element("1p4")]  attribute ncaBoolean constantOid;
    [element("1p5")]  attribute ncaOid owner;
    [element("1p6")]  readonly attribute ncaRole role;
    [element("1p7")]  attribute ncaString userLabel;
    ...
    
    // GENERIC GET/SET METHODS

    [element("1m1")]  ncaMethodResultPropertyValue get(ncaPropertyId Id);
    [element("1m2")]  ncaMethodResult set(ncaPropertyID id, any Value);
    ...

    // EVENTS
    [element("1e1")] [event] void PropertyChanged(ncaPropertyChangedEventData eventData);
};
```

Optional properties and method arguments are signaled via the `[optional]` token in front of an attribute or in front of the method argument.

Examples:

```typescript
[optional] attribute any value;
```

```typescript
[element("9m9")]  ncaMethodResult someMethod(ncaPropertyID id, optional any Value);
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

All methods must return a class which inherits from `ncaMethodResult` and provide a status and an optional errorMessage.

```typescript
interface ncaMethodResult {// Base datatype
    attribute ncaMethodStatus status;
    attribute ncaString errorMessage;
};
```

`ncaMethodStatus` is an enumeration:

```typescript
enum ncaMethodStatus {// Method result status values
    "ok", // 0  It worked. 
    "protocolVersionError", // 1  Control PDU had incompatible protocol version code 
    "deviceError", // 2  Something went wrong
    ...
};
```

Derived `ncaMethodResult` types may also return values or possibly further custom statuses.

```typescript
interface ncaMethodResultOID : ncaMethodResult { // object ID result
    attribute ncaOid value;
};
```
