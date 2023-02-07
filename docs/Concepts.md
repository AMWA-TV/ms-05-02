# Concepts

The Web IDL definitions are available [here](../idl/NC-Framework.webidl).

The definitions include datatypes and classes which include properties, methods and events.

Here are some examples:

Object id datatype

```typescript
typedef NcUint32 NcOid;
```

Element id datatype

```typescript
interface NcElementID {
    attribute NcUint16 level;
    attribute NcUint16 index;
};
```

Properties, methods and events inside a class are uniquely identified using the element Web IDL extension:

* properties - `[element("_p_")]`
* methods - `[element("_m_")]`
* events - `[element("_e_")]`

Here are some examples from the `NcObject` class:

```typescript
[control-class("1", "1.0.0")] interface NcObject {

    // PROPERTIES

    [element("1p1")]  static readonly attribute NcClassID classId;
    [element("1p2")]  static readonly attribute NcVersionCode classVersion;
    [element("1p3")]         readonly attribute NcOid oid;
    [element("1p4")]         readonly attribute NcBoolean constantOid;
    [element("1p5")]         readonly attribute NcOid? owner;
    [element("1p6")]         readonly attribute NcRole role;
    [element("1p7")]                  attribute NcString? userLabel;
    ...
    
    // GENERIC GET/SET METHODS

    [element("1m1")]  NcMethodResultPropertyValue Get(NcElementId id);
    [element("1m2")]  NcMethodResult Set(NcElementId id, any? value);
    ...

    // EVENTS
    [element("1e1")] [event] void PropertyChanged(NcPropertyChangedEventData eventData);
};
```

Readonly properties are signaled using the `readonly` token as specified in the Web IDL standard.

Nullable types are signaled using the `?` marker at the end of the type as specified in the Web IDL standard.

Example:

```typescript
[control-class("1.99", "1.0.0")] interface SomeClass {
    [element("2p55")]  attribute SomeType? someProperty;
    [element("2m20")]  SomeReturnType SomeMethod(SomeArgType? argument);
};
```

All methods MUST return a datatype which inherits from `NcMethodResult` and provide a status.

```typescript
interface NcMethodResult {// Base datatype
    attribute NcMethodStatus status;
};
```

`NcMethodStatus` is an enumeration:

```typescript
enum NcMethodStatus {
    "Ok",   // 200 - Method call was successful
    ...
};
```

When a method call encounters an error the return MUST be `NcMethodResultError` or a derived datatype.

```typescript
// Error result - to be used when the method call encounters an error
interface NcMethodResultError: NcMethodResult {
    attribute   NcString    errorMessage;
};
```

Derived `NcMethodResult` types may also return values or possibly further custom statuses.

```typescript
interface NcMethodResultBoolean : ncMethodResult { // boolean result
    attribute NcBoolean value;
};
```
