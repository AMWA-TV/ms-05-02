# Framework

The framework contains core classes and datatypes.
Where the functionality of a device uses control classes and datatypes listed in this specification it MUST comply with the model definitions published.

<!-- TOC -->

- [Framework](#framework)
  - [Control classes](#control-classes)
    - [NcObject](#ncobject)
    - [NcBlock](#ncblock)
    - [Workers](#workers)
      - [NcWorker](#ncworker)
    - [Managers](#managers)
      - [NcManager](#ncmanager)
      - [NcDeviceManager](#ncdevicemanager)
      - [NcClassManager](#ncclassmanager)
  - [Datatypes](#datatypes)
    - [Primitives](#primitives)
    - [NcOrganizationId](#ncorganizationid)
    - [NcClassId](#ncclassid)
    - [NcVersionCode](#ncversioncode)
    - [NcName](#ncname)
    - [NcUuid](#ncuuid)
    - [NcOid](#ncoid)
    - [NcRolePath](#ncrolepath)
    - [NcElementId](#ncelementid)
    - [NcPropertyId](#ncpropertyid)
    - [NcMethodId](#ncmethodid)
    - [NcEventId](#nceventid)
    - [NcId](#ncid)
    - [NcTouchpoint](#nctouchpoint)
    - [NcTouchpointResource](#nctouchpointresource)
    - [NcTouchpointNmos](#nctouchpointnmos)
    - [NcTouchpointNmosChannelMapping](#nctouchpointnmoschannelmapping)
    - [NcTouchpointResourceNmos](#nctouchpointresourcenmos)
    - [NcTouchpointResourceNmosChannelMapping](#nctouchpointresourcenmoschannelmapping)
    - [NcPropertyChangedEventData](#ncpropertychangedeventdata)
    - [NcPropertyChangeType](#ncpropertychangetype)
    - [NcTimeInterval](#nctimeinterval)
    - [NcDatatypeType](#ncdatatypetype)
    - [NcDescriptor](#ncdescriptor)
    - [NcDatatypeDescriptor](#ncdatatypedescriptor)
    - [NcDatatypeDescriptorPrimitive](#ncdatatypedescriptorprimitive)
    - [NcDatatypeDescriptorTypeDef](#ncdatatypedescriptortypedef)
    - [NcDatatypeDescriptorStruct](#ncdatatypedescriptorstruct)
    - [NcDatatypeDescriptorEnum](#ncdatatypedescriptorenum)
    - [NcPropertyDescriptor](#ncpropertydescriptor)
    - [NcFieldDescriptor](#ncfielddescriptor)
    - [NcEnumItemDescriptor](#ncenumitemdescriptor)
    - [NcParameterDescriptor](#ncparameterdescriptor)
    - [NcMethodDescriptor](#ncmethoddescriptor)
    - [NcEventDescriptor](#nceventdescriptor)
    - [NcClassDescriptor](#ncclassdescriptor)
    - [NcParameterConstraints](#ncparameterconstraints)
    - [NcParameterConstraintsNumber](#ncparameterconstraintsnumber)
    - [NcParameterConstraintsString](#ncparameterconstraintsstring)
    - [NcRegex](#ncregex)
    - [NcPropertyConstraints](#ncpropertyconstraints)
    - [NcPropertyConstraintsNumber](#ncpropertyconstraintsnumber)
    - [NcPropertyConstraintsString](#ncpropertyconstraintsstring)
    - [NcBlockMemberDescriptor](#ncblockmemberdescriptor)
    - [NcUri](#ncuri)
    - [NcManufacturer](#ncmanufacturer)
    - [NcProduct](#ncproduct)
    - [NcResetCause](#ncresetcause)
    - [NcDeviceGenericState](#ncdevicegenericstate)
    - [NcDeviceOperationalState](#ncdeviceoperationalstate)
    - [NcMethodStatus](#ncmethodstatus)
    - [NcMethodResult](#ncmethodresult)
    - [NcMethodResultError](#ncmethodresulterror)
    - [NcMethodResultPropertyValue](#ncmethodresultpropertyvalue)
    - [NcMethodResultBlockMemberDescriptors](#ncmethodresultblockmemberdescriptors)
    - [NcMethodResultClassDescriptor](#ncmethodresultclassdescriptor)
    - [NcMethodResultDatatypeDescriptor](#ncmethodresultdatatypedescriptor)
    - [NcMethodResultId](#ncmethodresultid)

<!-- /TOC -->

## Control classes

Control class models are documented using WebIDL interfaces.

Every control class definition is prefixed by the `[control-class(...)]` extended attribute.

```typescript
    control-class(classID, staticRole)
```

where:

- `classID` is the class ID expressed as a string of the form `i(1).i(2).i(N)`
- `staticRole` is the static role all instances of this class must use. This is applicable only to singleton classes like managers and is omitted for other control classes

Every property, method, or event declaration of every control class is prefixed by the `[element(.,..)]` attribute.

```typescript
    [element(elementId)]
```

where **elementId** is a delimited string of the form `nTm`, where

- `n` is the definition level of the class in the class tree
- `T` is the elementId type key (p, m or e).
- `m` is the ordinal of the definition within the class

Every property, method or event MUST be uniquely identified in a control class using element ids.

The `[event]` extended attribute is added to identify events within class definitions.

Readonly properties are signaled using the `readonly` token.

Nullable types are signaled using the `?` marker at the end of the type name.

### NcObject

NcObject is the abstract base class for all classes in the control model.  
Further explanations and normative references are provided in the [NcObject](NcObject.md) section.

```typescript
// NcObject class descriptor
[control-class("1")] interface NcObject {
    [element("1p1")]    readonly    attribute    NcClassId    classId;    // Static value. All instances of the same class will have the same identity value
    [element("1p2")]    readonly    attribute    NcOid    oid;    // Object identifier
    [element("1p3")]    readonly    attribute    NcBoolean    constantOid;    // TRUE iff OID is hardwired into device
    [element("1p4")]    readonly    attribute    NcOid?    owner;    // OID of containing block. Can only ever be null for the root block
    [element("1p5")]    readonly    attribute    NcString    role;    // Role of object in the containing block
    [element("1p6")]                attribute    NcString?    userLabel;    // Scribble strip
    [element("1p7")]    readonly    attribute    sequence<NcTouchpoint>?    touchpoints;    // Touchpoints to other contexts
    [element("1p8")]    readonly    attribute    sequence<NcPropertyConstraints>?    runtimePropertyConstraints;    // Runtime property constraints

    // Get property value
    [element("1m1")]    NcMethodResultPropertyValue Get(
        NcPropertyId id    // Property id
    );

    // Set property value
    [element("1m2")]    NcMethodResult Set(
        NcPropertyId id,    // Property id
        any? value    // Property value
    );

    // Get sequence item
    [element("1m3")]    NcMethodResultPropertyValue GetSequenceItem(
        NcPropertyId id,    // Property id
        NcId index    // Index of item in the sequence
    );

    // Set sequence item value
    [element("1m4")]    NcMethodResult SetSequenceItem(
        NcPropertyId id,    // Property id
        NcId index,    // Index of item in the sequence
        any? value    // Value
    );

    // Add item to sequence
    [element("1m5")]    NcMethodResultId AddSequenceItem(
        NcPropertyId id,    // Property id
        any? value    // Value
    );

    // Delete sequence item
    [element("1m6")]    NcMethodResult RemoveSequenceItem(
        NcPropertyId id,    // Property id
        NcId index    // Index of item in the sequence
    );

    [element("1e1")]    [event]    void    PropertyChanged(NcPropertyChangedEventData PropertyChanged);    // Property changed event
};
```

### NcBlock

NcBlock is a control class which groups and organises other control classes as its members.  
Members are identified by oid and role. An object in a hierarchy of nested blocks can be identified by its role path.  
A member's role path is a sequence of role values starting with the root block's role and ending with the member's role.  
Further explanations are provided in a dedicated [Blocks](Blocks.md) section.

```typescript
// NcBlock class descriptor
[control-class("1.1")] interface NcBlock: NcObject {
    [element("2p1")]    readonly    attribute    NcBoolean    enabled;    // TRUE if block is functional
    [element("2p2")]    readonly    attribute    sequence<NcBlockMemberDescriptor>    members;    // Descriptors of this block's members

    // Gets descriptors of members of the block
    [element("2m1")]    NcMethodResultBlockMemberDescriptors GetMemberDescriptors(
        NcBoolean recurse    // If recurse is set to true, nested members can be retrieved
    );

    // Finds member(s) by path
    [element("2m2")]    NcMethodResultBlockMemberDescriptors FindMembersByPath(
        NcRolePath path    // Relative path to search for (MUST not include the role of the block targeted by oid)
    );

    // Finds members with given role name or fragment
    [element("2m3")]    NcMethodResultBlockMemberDescriptors FindMembersByRole(
        NcString role,    // Role text to search for
        NcBoolean caseSensitive,    // Signals if the comparison should be case sensitive
        NcBoolean matchWholeString,    // TRUE to only return exact matches
        NcBoolean recurse    // TRUE to search nested blocks
    );

    // Finds members with given class id
    [element("2m4")]    NcMethodResultBlockMemberDescriptors FindMembersByClassId(
        NcClassId id,    // Class id to search for
        NcBoolean includeDerived,    // If TRUE it will also include derived class descriptors
        NcBoolean recurse    // TRUE to search nested blocks
    );
};
```

### Workers

Further explanations and normative references are provided in the [Workers](Workers.md) section.

#### NcWorker

NcWorker is the base worker control class for any worker control class in the control model.

```typescript
// NcWorker class descriptor
[control-class("1.2")] interface NcWorker: NcObject {
    [element("2p1")]                attribute    NcBoolean    enabled;    // TRUE iff worker is enabled
};
```

### Managers

Further explanations are provided in a dedicated [Managers](Managers.md) section.

#### NcManager

NcManager is the base abstract manager control class for any manager control class in the control model. Manager control classes are singleton classes. Vendor specific managers MUST be directly or indirectly derived from this control class.

```typescript
// NcManager class descriptor
[control-class("1.3")] interface NcManager: NcObject {
};
```

#### NcDeviceManager

NcDeviceManager is the device manager control class which contains device information and status.

```typescript
// NcDeviceManager class descriptor
[control-class("1.3.1", "DeviceManager")] interface NcDeviceManager: NcManager {
    [element("3p1")]    readonly    attribute    NcVersionCode    ncVersion;    // Version of MS-05-02 that this device uses
    [element("3p2")]    readonly    attribute    NcManufacturer    manufacturer;    // Manufacturer descriptor
    [element("3p3")]    readonly    attribute    NcProduct    product;    // Product descriptor
    [element("3p4")]    readonly    attribute    NcString    serialNumber;    // Serial number
    [element("3p5")]                attribute    NcString?    userInventoryCode;    // Asset tracking identifier (user specified)
    [element("3p6")]                attribute    NcString?    deviceName;    // Name of this device in the application. Instance name, not product name.
    [element("3p7")]                attribute    NcString?    deviceRole;    // Role of this device in the application.
    [element("3p8")]    readonly    attribute    NcDeviceOperationalState    operationalState;    // Device operational state
    [element("3p9")]    readonly    attribute    NcResetCause    resetCause;    // Reason for most recent reset
    [element("3p10")]    readonly    attribute    NcString?    message;    // Arbitrary message from dev to controller
};
```

#### NcClassManager

NcClassManager is the class manager control class.

```typescript
// NcClassManager class descriptor
[control-class("1.3.2", "ClassManager")] interface NcClassManager: NcManager {
    [element("3p1")]    readonly    attribute    sequence<NcClassDescriptor>    controlClasses;    // Descriptions of all control classes in the device (descriptors do not contain inherited elements)
    [element("3p2")]    readonly    attribute    sequence<NcDatatypeDescriptor>    datatypes;    // Descriptions of all data types in the device (descriptors do not contain inherited elements)

    // Get a single class descriptor
    [element("3m1")]    NcMethodResultClassDescriptor GetControlClass(
        NcClassId identity,    // class ID
        NcBoolean includeInherited    // If set the descriptor would contain all inherited elements
    );

    // Get a single datatype descriptor
    [element("3m2")]    NcMethodResultDatatypeDescriptor GetDatatype(
        NcName name,    // name of datatype
        NcBoolean includeInherited    // If set the descriptor would contain all inherited elements
    );
};
```

## Datatypes

Control class models are documented using WebIDL interfaces.

The `[primitive]` extended attribute identifies primitive datatypes.

### Primitives

```typescript
    [primitive] typedef boolean             NcBoolean;
    [primitive] typedef short               NcInt16;
    [primitive] typedef long                NcInt32;
    [primitive] typedef longlong            NcInt64;
    [primitive] typedef unsignedshort       NcUint16;
    [primitive] typedef unsignedlong        NcUint32;
    [primitive] typedef unsignedlonglong    NcUint64;
    [primitive] typedef unrestrictedfloat   NcFloat32;
    [primitive] typedef unrestricteddouble  NcFloat64;
    [primitive] typedef bytestring          NcString; // UTF-8
```

### NcOrganizationId

Unique 24-bit organization ID:

- IEEE public Company ID (public CID) or
- IEEE Organizational Unique Identifier (OUI).

```typescript
typedef NcInt32    NcOrganizationId; // Unique 24-bit organization id
```

### NcClassId

NcClassId is a sequence of NcInt32 class ID fields.
A class ID sequence reflects the ancestry of the class being identified.

A class ID field is either a definition index or an authority key.
A definition index is an ordinal that starts at 1 for every inheritance level of the control model class tree for example `[ 1, 1, 3, 5]`.

The class id for all standard control classes defined by the framework MUST not contain authority keys.

Vendor specific control classes MUST contain at least one authority key.

An authority key is inserted in the class ID sequence immediately after the definition index of the class from which a vendor specific class inherits, i.e. at the point where the derived class or class subtree connects into the class structure.

For organizations which own a unique CID or OUI the authority key MUST be the organization identifier as an integer which MUST be negated.

For organizations which do not own a unique CID or OUI the authority key MUST be 0.
e.g.  
     `[ 1, 1, 3, 5, -132131, 1, 4, 5 ]`  
or  
     `[ 1, 1, 3, 5, 0, 1, 4, 5 ]`

Further information and examples provided in [MS-05-01: Appendix A](https://specs.amwa.tv/ms-05-01/branches/v1.0-dev/docs/Appendix_A_-_Class_ID_Format.html).

```typescript
typedef sequence<NcInt32>    NcClassId; // Sequence of class ID fields.
```

### NcVersionCode

```typescript
typedef NcString    NcVersionCode; // Version code in semantic versioning format
```

### NcName

```typescript
typedef NcString    NcName; // Programmatically significant name, alphanumerics + underscore, no spaces
```

### NcUuid

```typescript
typedef NcString    NcUuid; // UUID
```

### NcOid

```typescript
typedef NcUint32    NcOid; // Object id
```

### NcRolePath

Ordered list of roles ending with the role of object in question.  
The object in question may be a block or another object.

```typescript
typedef sequence<NcString>    NcRolePath; // Role path
```

### NcElementId

```typescript
// Class element id which contains the level and index
interface NcElementId {
    attribute NcUint16    level; // Level of the element
    attribute NcUint16    index; // Index of the element
};
```

### NcPropertyId

```typescript
// Property id which contains the level and index
interface NcPropertyId: NcElementId {
};
```

### NcMethodId

```typescript
// Method id which contains the level and index
interface NcMethodId: NcElementId {
};
```

### NcEventId

```typescript
// Event id which contains the level and index
interface NcEventId: NcElementId {
};
```

### NcId

```typescript
typedef NcUint32    NcId; // Identity handler
```

### NcTouchpoint

This model is used by the [NcObject](NcObject.md#touchpoints) class for identity mapping to other contexts.

```typescript
// Base touchpoint class
interface NcTouchpoint {
    attribute NcString    contextNamespace; // Context namespace
};
```

### NcTouchpointResource

```typescript
// Touchpoint resource class
interface NcTouchpointResource {
    attribute NcString    resourceType; // The type of the resource
};
```

### NcTouchpointNmos

```typescript
// Touchpoint class for NMOS resources
interface NcTouchpointNmos: NcTouchpoint {
    attribute NcTouchpointResourceNmos    resource; // Context NMOS resource
};
```

The `contextNamespace` attribute is inherited from NcTouchpoint and can only be `x-nmos`.

### NcTouchpointNmosChannelMapping

```typescript
// Touchpoint class for NMOS IS-08 resources
interface NcTouchpointNmosChannelMapping: NcTouchpoint {
    attribute NcTouchpointResourceNmosChannelMapping    resource; // Context Channel Mapping resource
};
```

The `contextNamespace` attribute is inherited from NcTouchpoint and can only be `x-nmos/channelmapping`

### NcTouchpointResourceNmos

```typescript
// Touchpoint resource class for NMOS resources
interface NcTouchpointResourceNmos: NcTouchpointResource {
    attribute NcUuid    id; // NMOS resource UUID
};
```

The `resourceType` attribute is inherited from NcTouchpointResource and can only be: `node, device, source, flow, sender, receiver`.

### NcTouchpointResourceNmosChannelMapping

```typescript
// Touchpoint resource class for NMOS resources
interface NcTouchpointResourceNmosChannelMapping: NcTouchpointResourceNmos {
    attribute NcString    ioId; // IS-08 Audio Channel Mapping input or output id
};
```

The `resourceType` attribute is inherited from NcTouchpointResource and can only be: `input, output`.

### NcPropertyChangedEventData

```typescript
// Payload of property-changed event
interface NcPropertyChangedEventData {
    attribute NcPropertyId    propertyId; // The id of the property that changed
    attribute NcPropertyChangeType    changeType; // Information regarding the change type
    attribute any?    value; // Property-type specific value
    attribute NcId?    sequenceItemIndex; // Index of sequence item if the property is a sequence
};
```

### NcPropertyChangeType

```typescript
// Type of property change
enum NcPropertyChangeType {
    "ValueChanged",        // 0 Current value changed
    "SequenceItemAdded",        // 1 Sequence item added
    "SequenceItemChanged",        // 2 Sequence item changed
    "SequenceItemRemoved"        // 3 Sequence item removed
};
```

### NcTimeInterval

```typescript
typedef NcInt64    NcTimeInterval; // Time interval described in nanoseconds
```

### NcDatatypeType

```typescript
// Datatype type
enum NcDatatypeType {
    "Primitive",        // 0 Primitive datatype
    "Typedef",        // 1 Simple alias of another datatype
    "Struct",        // 2 Data structure
    "Enum"        // 3 Enum datatype
};
```

### NcDescriptor

```typescript
// Base descriptor
interface NcDescriptor {
    attribute NcString?    description; // Optional user facing description
};
```

### NcDatatypeDescriptor

```typescript
// Base datatype descriptor
interface NcDatatypeDescriptor: NcDescriptor {
    attribute NcName    name; // Datatype name
    attribute NcDatatypeType    type; // Type: Primitive, Typedef, Struct, Enum
    attribute NcParameterConstraints?    constraints; // Optional constraints on top of the underlying data type
};
```

### NcDatatypeDescriptorPrimitive

```typescript
// Primitive datatype descriptor
interface NcDatatypeDescriptorPrimitive: NcDatatypeDescriptor {
};
```

The `type` attribute will be `Primitive`.

### NcDatatypeDescriptorTypeDef

```typescript
// Type def datatype descriptor
interface NcDatatypeDescriptorTypeDef: NcDatatypeDescriptor {
    attribute NcName    parentType; // Original typedef datatype name
    attribute NcBoolean    isSequence; // TRUE iff type is a typedef sequence of another type
};
```

The `type` attribute will be `Typedef`.

### NcDatatypeDescriptorStruct

```typescript
// Struct datatype descriptor
interface NcDatatypeDescriptorStruct: NcDatatypeDescriptor {
    attribute sequence<NcFieldDescriptor>    fields; // One item descriptor per field of the struct
    attribute NcName?    parentType; // Name of the parent type if any or null if it has no parent
};
```

The `type` attribute will be `Struct`.

### NcDatatypeDescriptorEnum

```typescript
// Enum datatype descriptor
interface NcDatatypeDescriptorEnum: NcDatatypeDescriptor {
    attribute sequence<NcEnumItemDescriptor>    items; // One item descriptor per enum option
};
```

The `type` attribute will be `Enum`.

### NcPropertyDescriptor

```typescript
// Descriptor of a class property
interface NcPropertyDescriptor: NcDescriptor {
    attribute NcPropertyId    id; // Property id with level and index
    attribute NcName    name; // Name of property
    attribute NcName?    typeName; // Name of property's datatype. Can only ever be null if the type is any
    attribute NcBoolean    isReadOnly; // TRUE iff property is read-only
    attribute NcBoolean    isPersistent; // TRUE iff property value survives power-on reset
    attribute NcBoolean    isNullable; // TRUE iff property is nullable
    attribute NcBoolean    isSequence; // TRUE iff property is a sequence
    attribute NcBoolean    isDeprecated; // TRUE iff property is marked as deprecated
    attribute NcBoolean    isConstant; // TRUE iff property is readonly and constant (its value is never expected to change)
    attribute NcParameterConstraints?    constraints; // Optional constraints on top of the underlying data type
};
```

### NcFieldDescriptor

```typescript
// Descriptor of a field of a struct
interface NcFieldDescriptor: NcDescriptor {
    attribute NcName    name; // Name of field
    attribute NcName?    typeName; // Name of field's datatype. Can only ever be null if the type is any
    attribute NcBoolean    isNullable; // TRUE iff field is nullable
    attribute NcBoolean    isSequence; // TRUE iff field is a sequence
    attribute NcParameterConstraints?    constraints; // Optional constraints on top of the underlying data type
};
```

### NcEnumItemDescriptor

```typescript
// Descriptor of an enum item
interface NcEnumItemDescriptor: NcDescriptor {
    attribute NcName    name; // Name of option
    attribute NcUint16    value; // Enum item numerical value
};
```

### NcParameterDescriptor

```typescript
// Descriptor of a method parameter
interface NcParameterDescriptor: NcDescriptor {
    attribute NcName    name; // Name of parameter
    attribute NcName?    typeName; // Name of parameter's datatype. Can only ever be null if the type is any
    attribute NcBoolean    isNullable; // TRUE iff property is nullable
    attribute NcBoolean    isSequence; // TRUE iff property is a sequence
    attribute NcParameterConstraints?    constraints; // Optional constraints on top of the underlying data type
};
```

### NcMethodDescriptor

```typescript
// Descriptor of a class method
interface NcMethodDescriptor: NcDescriptor {
    attribute NcMethodId    id; // Method id with level and index
    attribute NcName    name; // Name of method
    attribute NcName    resultDatatype; // Name of method result's datatype
    attribute sequence<NcParameterDescriptor>    parameters; // Parameter descriptors if any
    attribute NcBoolean    isDeprecated; // TRUE iff property is marked as deprecated
};
```

### NcEventDescriptor

```typescript
// Descriptor of a class event
interface NcEventDescriptor: NcDescriptor {
    attribute NcEventId    id; // Event id with level and index
    attribute NcName    name; // Name of event
    attribute NcName    eventDatatype; // Name of event data's datatype
    attribute NcBoolean    isDeprecated; // TRUE iff property is marked as deprecated
};
```

### NcClassDescriptor

```typescript
// Descriptor of a class
interface NcClassDescriptor: NcDescriptor {
    attribute NcClassId    identity; // Identity of the class
    attribute NcName    name; // Name of the class
    attribute NcString?    fixedRole; // Role if the class has fixed role (manager classes)
    attribute sequence<NcPropertyDescriptor>    properties; // Property descriptors
    attribute sequence<NcMethodDescriptor>    methods; // Method descriptors
    attribute sequence<NcEventDescriptor>    events; // Event descriptors
};
```

### NcParameterConstraints

```typescript
// Abstract parameter constraints class
interface NcParameterConstraints {
    attribute any?    defaultValue; // Default value
};
```

### NcParameterConstraintsNumber

```typescript
// Number parameter constraints class
interface NcParameterConstraintsNumber: NcParameterConstraints {
    attribute any?    maximum; // Optional maximum
    attribute any?    minimum; // Optional minimum
    attribute any?    step; // Optional step
};
```

### NcParameterConstraintsString

```typescript
// String parameter constraints class
interface NcParameterConstraintsString: NcParameterConstraints {
    attribute NcUint32?    maxCharacters; // Maximum characters allowed
    attribute NcRegex?    pattern; // Regex pattern
};
```

### NcRegex

```typescript
typedef NcString    NcRegex; // Regex pattern
```

### NcPropertyConstraints

```typescript
// Property constraints class
interface NcPropertyConstraints {
    attribute NcPropertyId    propertyId; // The id of the property being constrained
    attribute any?    defaultValue; // Optional default value
};
```

### NcPropertyConstraintsNumber

```typescript
// Number property constraints class
interface NcPropertyConstraintsNumber: NcPropertyConstraints {
    attribute any?    maximum; // Optional maximum
    attribute any?    minimum; // Optional minimum
    attribute any?    step; // Optional step
};
```

### NcPropertyConstraintsString

```typescript
// String property constraints class
interface NcPropertyConstraintsString: NcPropertyConstraints {
    attribute NcUint32?    maxCharacters; // Maximum characters allowed
    attribute NcRegex?    pattern; // Regex pattern
};
```

### NcBlockMemberDescriptor

```typescript
// Descriptor which is specific to a block member
interface NcBlockMemberDescriptor: NcDescriptor {
    attribute NcString    role; // Role of member in its containing block
    attribute NcOid    oid; // OID of member
    attribute NcBoolean    constantOid; // TRUE iff member's OID is hardwired into device
    attribute NcClassId    classId; // Class ID
    attribute NcString?    userLabel; // User label
    attribute NcOid    owner; // Containing block's OID
};
```

### NcUri

```typescript
typedef NcString    NcUri; // Uniform resource identifier
```

### NcManufacturer

```typescript
// Manufacturer descriptor
interface NcManufacturer {
    attribute NcString    name; // Manufacturer's name
    attribute NcOrganizationId?    organizationId; // IEEE OUI or CID of manufacturer
    attribute NcUri?    website; // URL of the manufacturer's website
};
```

### NcProduct

```typescript
// Product descriptor
interface NcProduct {
    attribute NcString    name; // Product name
    attribute NcString    key; // Manufacturer's unique key to product - model number, SKU, etc
    attribute NcString    revisionLevel; // Manufacturer's product revision level code
    attribute NcString?    brandName; // Brand name under which product is sold
    attribute NcUuid?    uuid; // Unique UUID of product (not product instance)
    attribute NcString?    description; // Text description of product
};
```

### NcResetCause

```typescript
// Reset cause enum
enum NcResetCause {
    "Unknown",        // 0 Unknown
    "PowerOn",        // 1 Power on
    "InternalError",        // 2 Internal error
    "Upgrade",        // 3 Upgrade
    "ControllerRequest",        // 4 Controller request
    "ManualReset"        // 5 Manual request from the front panel
};
```

### NcDeviceGenericState

```typescript
// Device generic operational state
enum NcDeviceGenericState {
    "Unknown",        // 0 Unknown
    "NormalOperation",        // 1 Normal operation
    "Initializing",        // 2 Device is initializing
    "Updating",        // 3 Device is performing a software or firmware update
    "LicensingError",        // 4 Device is experiencing a licensing error
    "InternalError"        // 5 Device is experiencing an internal error
};
```

### NcDeviceOperationalState

```typescript
// Device operational state
interface NcDeviceOperationalState {
    attribute NcDeviceGenericState    generic; // Generic operational state
    attribute NcString?    deviceSpecificDetails; // Specific device details
};
```

### NcMethodStatus

```typescript
// Method invokation status
enum NcMethodStatus {
    "Ok",        // 200 Method call was successful
    "PropertyDeprecated",        // 298 Method call was successful but targeted property is deprecated
    "MethodDeprecated",        // 299 Method call was successful but method is deprecated
    "BadCommandFormat",        // 400 Badly-formed command
    "Unauthorized",        // 401 Client is not authorized
    "BadOid",        // 404 Command addresses a nonexistent object
    "Readonly",        // 405 Attempt to change read-only state
    "InvalidRequest",        // 406 Method call is invalid in current operating context
    "Conflict",        // 409 There is a conflict with the current state of the device
    "BufferOverflow",        // 413 Something was too big
    "ParameterError",        // 417 Method parameter does not meet expectations
    "Locked",        // 423 Addressed object is locked
    "DeviceError",        // 500 Internal device error
    "MethodNotImplemented",        // 501 Addressed method is not implemented by the addressed object
    "PropertyNotImplemented",        // 502 Addressed property is not implemented by the addressed object
    "NotReady",        // 503 The device is not ready to handle any commands
    "Timeout",        // 504 Method call did not finish within the allotted time
    "ProtocolVersionError"        // 505 Incompatible protocol version
};
```

### NcMethodResult

All methods MUST return a datatype which inherits from NcMethodResult.  
When a method call encounters an error the return MUST be [NcMethodResultError](#ncmethodresulterror) or a derived datatype.

```typescript
// Base result of the invoked method
interface NcMethodResult {
    attribute NcMethodStatus    status; // Status for the invoked method
};
```

### NcMethodResultError

```typescript
// Error result - to be used when the method call encounters an error
interface NcMethodResultError: NcMethodResult {
    attribute NcString    errorMessage; // Error message
};
```

### NcMethodResultPropertyValue

NcMethodResultPropertyValue can hold any value type depending on the underlying property type.

```typescript
// Result when invoking the getter method associated with a property
interface NcMethodResultPropertyValue: NcMethodResult {
    attribute any?    value; // Getter method value for the associated property
};
```

### NcMethodResultBlockMemberDescriptors

```typescript
// Method result containing block member descriptors as the value
interface NcMethodResultBlockMemberDescriptors: NcMethodResult {
    attribute sequence<NcBlockMemberDescriptor>    value; // Block member descriptors method result value
};
```

### NcMethodResultClassDescriptor

```typescript
// Method result containing a class descriptor as the value
interface NcMethodResultClassDescriptor: NcMethodResult {
    attribute NcClassDescriptor    value; // Class descriptor method result value
};
```

### NcMethodResultDatatypeDescriptor

```typescript
// Method result containing a datatype descriptor as the value
interface NcMethodResultDatatypeDescriptor: NcMethodResult {
    attribute NcDatatypeDescriptor    value; // Datatype descriptor method result value
};
```

### NcMethodResultId

```typescript
// Id method result
interface NcMethodResultId: NcMethodResult {
    attribute NcId    value; // Id result value
};
```
