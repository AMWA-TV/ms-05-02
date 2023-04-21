# Framework

The framework contains core classes and datatypes.
Where the functionality of a device uses control classes and datatypes it MUST comply with the model definitions in this specification.

<!-- TOC -->

- [Framework](#framework)
  - [Control classes](#control-classes)
    - [NcObject](#ncobject)
    - [NcBlock](#ncblock)
    - [NcWorker](#ncworker)
    - [NcSignalWorker](#ncsignalworker)
    - [NcActuator](#ncactuator)
    - [NcSensor](#ncsensor)
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
    - [NcIoDirection](#nciodirection)
    - [NcPortReference](#ncportreference)
    - [NcPort](#ncport)
    - [NcSignalPath](#ncsignalpath)
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
    - [NcPropertyConstraintsFixed](#ncpropertyconstraintsfixed)
    - [NcPropertyConstraintsNumber](#ncpropertyconstraintsnumber)
    - [NcPropertyConstraintsString](#ncpropertyconstraintsstring)
    - [NcPropertyConstraintsEnum](#ncpropertyconstraintsenum)
    - [NcBlockMemberDescriptor](#ncblockmemberdescriptor)
    - [NcBlockDescriptor](#ncblockdescriptor)
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

### NcObject

NcObject is the base abstract control class for any control class in the control model. Any other control class MUST be derived directly or indirectly from this class.

```webidl
// NcObject class descriptor
[control-class("1")] interface NcObject {
    [element("1p1")]    readonly    attribute    NcClassId    classId;    // Static value. All instances of the same class will have the same identity value
    [element("1p2")]    readonly    attribute    NcOid    oid;    // Object identifier
    [element("1p3")]    readonly    attribute    NcBoolean    constantOid;    // TRUE iff OID is hardwired into device
    [element("1p4")]    readonly    attribute    NcOid?    owner;    // OID of containing block. Can only ever be null for the root block
    [element("1p5")]    readonly    attribute    NcString    role;    // role of obj in containing block
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

```webidl
// NcBlock class descriptor
[control-class("1.1")] interface NcBlock: NcObject {
    [element("2p1")]    readonly    attribute    NcBoolean    isRoot;    // TRUE if block is the root block
    [element("2p2")]    readonly    attribute    NcString?    specId;    // Global ID of blockSpec that defines this block
    [element("2p3")]    readonly    attribute    NcVersionCode?    specVersion;    // Version code of blockSpec that defines this block
    [element("2p4")]    readonly    attribute    NcString?    specDescription;    // Description of blockSpec that defines this block
    [element("2p5")]    readonly    attribute    NcString?    parentSpecId;    // Global ID of parent of blockSpec that defines this block
    [element("2p6")]    readonly    attribute    NcVersionCode?    parentSpecVersion;    // Version code of parent of blockSpec that defines this block
    [element("2p7")]    readonly    attribute    NcBoolean    isDynamic;    // TRUE if dynamic block
    [element("2p8")]    readonly    attribute    NcBoolean    isModified;    // TRUE if block contents modified since last reset
    [element("2p9")]    readonly    attribute    NcBoolean    enabled;    // TRUE if block is functional
    [element("2p10")]    readonly    attribute    sequence<NcBlockMemberDescriptor>    members;    // Descriptors of this block's members
    [element("2p11")]    readonly    attribute    sequence<NcPort>?    ports;    // this block's ports
    [element("2p12")]    readonly    attribute    sequence<NcSignalPath>?    signalPaths;    // this block's signal paths

    // gets descriptors of members of the block
    [element("2m1")]    NcMethodResultBlockMemberDescriptors GetMemberDescriptors(
        NcBoolean recurse    // If recurse is set to true, nested members can be retrieved
    );

    // finds member(s) by path
    [element("2m2")]    NcMethodResultBlockMemberDescriptors FindMembersByPath(
        NcRolePath path    // relative path to search for (MUST not include the role of the block targeted by oid)
    );

    // finds members with given role name or fragment
    [element("2m3")]    NcMethodResultBlockMemberDescriptors FindMembersByRole(
        NcString role,    // role text to search for
        NcBoolean caseSensitive,    // signals if the comparison should be case sensitive
        NcBoolean matchWholeString,    // TRUE to only return exact matches
        NcBoolean recurse    // TRUE to search nested blocks
    );

    // finds members with given class id
    [element("2m4")]    NcMethodResultBlockMemberDescriptors FindMembersByClassId(
        NcClassId id,    // class id to search for
        NcBoolean includeDerived,    // If TRUE it will also include derived class descriptors
        NcBoolean recurse    // TRUE to search nested blocks
    );
};
```

### NcWorker

NcWorker is the base worker control class for any worker control class in the control model. Vendor specific workers MUST be directly or indirectly derived from this control class.

```webidl
// NcWorker class descriptor
[control-class("1.2")] interface NcWorker: NcObject {
    [element("2p1")]                attribute    NcBoolean    enabled;    // TRUE iff worker is enabled
};
```

### NcSignalWorker

NcSignalWorker is the base signal worker control class for any worker control class in the control model which manipulates signals. Vendor specific signal workers MUST be directly or indirectly derived from this control class.

```webidl
// NcSignalWorker class descriptor
[control-class("1.2.1")] interface NcSignalWorker: NcWorker {
    [element("3p1")]                attribute    sequence<NcPort>    ports;    // The worker's signal ports
    [element("3p2")]    readonly    attribute    NcTimeInterval?    latency;    // Processing latency of this object (null if not defined)
};
```

### NcActuator

NcActuator is the base actuator worker control class for any actuator control class in the control model. Vendor specific actuators SHOULD be directly or indirectly derived from this control class.

```webidl
// NcActuator class descriptor
[control-class("1.2.1.1")] interface NcActuator: NcSignalWorker {
};
```

### NcSensor

NcSensor is the base sensor worker control class for any sensor control class in the control model. Vendor specific sensors SHOULD be directly or indirectly derived from this control class.

```webidl
// NcSensor class descriptor
[control-class("1.2.1.2")] interface NcSensor: NcSignalWorker {
};
```

### NcManager

NcManager is the base abstract manager control class for any manager control class in the control model. Manager control classes are singleton classes. Vendor specific managers MUST be directly or indirectly derived from this control class.

```webidl
// NcManager class descriptor
[control-class("1.3")] interface NcManager: NcObject {
};
```

### NcDeviceManager

NcDeviceManager is the device manager control class which contains device information and status.

```webidl
// NcDeviceManager class descriptor
[control-class("1.3.1")] interface NcDeviceManager: NcManager {
    [element("3p1")]    readonly    attribute    NcVersionCode    ncVersion;    // Version of nc this dev uses
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

### NcClassManager

NcClassManager is the class manager control class.

```webidl
// NcClassManager class descriptor
[control-class("1.3.2")] interface NcClassManager: NcManager {
    [element("3p1")]    readonly    attribute    sequence<NcClassDescriptor>    controlClasses;    // Descriptions of all control classes in the device (descriptors do not contain inherited elements)
    [element("3p2")]    readonly    attribute    sequence<NcDatatypeDescriptor>    datatypes;    // Descriptions of all data types in the device (descriptors do not contain inherited elements)

    // Get a single class descriptor
    [element("3m1")]    NcMethodResultClassDescriptor GetControlClass(
        NcClassId identity,    // class ID
        NcBoolean includeInherited    // if set the descriptor would contain all inherited elements
    );

    // Get a single datatype descriptor
    [element("3m2")]    NcMethodResultDatatypeDescriptor GetDatatype(
        NcName name,    // name of datatype
        NcBoolean includeInherited    // if set the descriptor would contain all inherited elements
    );
};
```

## Datatypes

### Primitives

```webidl
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

```webidl
typedef NcInt32    NcOrganizationId; // Unique 24-bit organization ID
```

### NcClassId

NcClassId is a sequence of NCInt32 class ID fields.
A class ID sequence reflects the ancestry of the class being identified.

A class ID field is either a definition index or an authority key.
A definition index is an ordinal that starts at 1 for every inheritance level of the control model class tree for example `[ 1, 1, 3, 5]`.

An authority key shall be inserted in the class ID sequence immediately after the definition index of the class from which a proprietary class inherits,
i.e. at the point where the proprietary class or class subtree connects into the class structure.

For organizations which own a unique CID or OUI the authority key MUST be the organization identifier as an integer which MUST be negated.

For organizations which do not own a unique CID or OUI the authority key MUST be 0.
e.g.  
     `[ 1, 1, 3, 5, -132131, 1, 4, 5 ]`  
or  
     `[ 1, 1, 3, 5, 0, 1, 4, 5 ]`

```webidl
typedef sequence<NcInt32>    NcClassId; // Sequence of class ID fields.
```

### NcVersionCode

```webidl
typedef NcString    NcVersionCode; // Version code in semantic versioning format
```

### NcName

```webidl
typedef NcString    NcName; // Programmatically significant name, alphanumerics + underscore, no spaces
```

### NcUuid

```webidl
typedef NcString    NcUuid; // UUID
```

### NcOid

```webidl
typedef NcUint32    NcOid; // Object id
```

### NcRolePath

Ordered list of roles ending with the role of object in question.  
The object in question may be a block or another object.

```webidl
typedef sequence<NcString>    NcRolePath; // Role path
```

### NcElementId

```webidl
// Class element id which contains the level and index
interface NcElementId {
    attribute NcUint16    level; // Level of the element
    attribute NcUint16    index; // Index of the element
};
```

### NcPropertyId

```webidl
// Property id which contains the level and index
interface NcPropertyId: NcElementId {
};
```

### NcMethodId

```webidl
// Method id which contains the level and index
interface NcMethodId: NcElementId {
};
```

### NcEventId

```webidl
// Event id which contains the level and index
interface NcEventId: NcElementId {
};
```

### NcId

```webidl
typedef NcUint32    NcId; // Identity handler
```

### NcIoDirection

```webidl
// Input and/or output direction
enum NcIoDirection {
    "Undefined",        // 0 Not defined
    "Input",        // 1 Input direction
    "Output",        // 2 Output direction
    "Bidirectional"        // 3 Bidirectional
};
```

### NcPortReference

```webidl
// Device-unique port identifier
interface NcPortReference {
    attribute NcRolePath    owner; // Role path of owning object
    attribute NcString    role; // Unique role of this port within the owning object
};
```

### NcPort

```webidl
// Port class
interface NcPort {
    attribute NcString    role; // Unique within owning object
    attribute NcIoDirection    direction; // Input (sink) or output (source) port
    attribute NcRolePath?    clockPath; // Role path of this port's sample clock or null if none
};
```

### NcSignalPath

```webidl
// Signal path descriptor
interface NcSignalPath {
    attribute NcString    role; // Unique identifier of this signal path in this block
    attribute NcString?    label; // Optional label
    attribute NcPortReference    source; // Source reference
    attribute NcPortReference    sink; // Sink reference
};
```

### NcTouchpoint

```webidl
// Base touchpoint class
interface NcTouchpoint {
    attribute NcString    contextNamespace; // Context namespace
};
```

### NcTouchpointResource

```webidl
// Touchpoint resource class
interface NcTouchpointResource {
    attribute NcString    resourceType; // The type of the resource
};
```

### NcTouchpointNmos

```webidl
// Touchpoint class for NMOS resources
interface NcTouchpointNmos: NcTouchpoint {
    attribute NcTouchpointResourceNmos    resource; // Context NMOS resource
};
```

The `contextNamespace` attribute is inherited from NcTouchpoint and can only be `x-nmos`.

### NcTouchpointNmosChannelMapping

```webidl
// Touchpoint class for NMOS IS-08 resources
interface NcTouchpointNmosChannelMapping: NcTouchpoint {
    attribute NcTouchpointResourceNmosChannelMapping    resource; // Context Channel Mapping resource
};
```

The `contextNamespace` attribute is inherited from NcTouchpoint and can only be `x-nmos/channelmapping`

### NcTouchpointResourceNmos

```webidl
// Touchpoint resource class for NMOS resources
interface NcTouchpointResourceNmos: NcTouchpointResource {
    attribute NcUuid    id; // NMOS resource UUID
};
```

The `resourceType` attribute is inherited from NcTouchpointResource and can only be: `node, device, source, flow, sender, receiver`.

### NcTouchpointResourceNmosChannelMapping

```webidl
// Touchpoint resource class for NMOS resources
interface NcTouchpointResourceNmosChannelMapping: NcTouchpointResourceNmos {
    attribute NcString    ioId; // IS-08 Audio Channel Mapping input or output ID
};
```

The `resourceType` attribute is inherited from NcTouchpointResource and can only be: `input, output`.

### NcPropertyChangedEventData

```webidl
// Payload of property-changed event
interface NcPropertyChangedEventData {
    attribute NcPropertyId    propertyId; // ID of changed property
    attribute NcPropertyChangeType    changeType; // Information regarding the change type
    attribute any?    value; // Property-type specific value
    attribute NcId?    sequenceItemIndex; // Index of sequence item if the property is a sequence
};
```

### NcPropertyChangeType

```webidl
// Type of property change
enum NcPropertyChangeType {
    "ValueChanged",        // 0 Current value changed
    "SequenceItemAdded",        // 1 Sequence item added
    "SequenceItemChanged",        // 2 Sequence item changed
    "SequenceItemRemoved"        // 3 Sequence item removed
};
```

### NcTimeInterval

```webidl
typedef NcInt64    NcTimeInterval; // Time interval described in nanoseconds
```

### NcDatatypeType

```webidl
// Datatype type
enum NcDatatypeType {
    "Primitive",        // 0 Primitive datatype
    "Typedef",        // 1 Simple alias of another datatype
    "Struct",        // 2 Data structure
    "Enum"        // 3 Enum datatype
};
```

### NcDescriptor

```webidl
// Base descriptor
interface NcDescriptor {
    attribute NcString?    description; // Optional user facing description
};
```

### NcDatatypeDescriptor

```webidl
// Base datatype descriptor
interface NcDatatypeDescriptor: NcDescriptor {
    attribute NcName    name; // Datatype name
    attribute NcDatatypeType    type; // Type: Primitive, Typedef, Struct, Enum
    attribute NcParameterConstraints?    constraints; // Optional constraints on top of the underlying data type
};
```

### NcDatatypeDescriptorPrimitive

```webidl
// Primitive datatype descriptor
interface NcDatatypeDescriptorPrimitive: NcDatatypeDescriptor {
};
```

The `type` attribute will be `Primitive`.

### NcDatatypeDescriptorTypeDef

```webidl
// Type def datatype descriptor
interface NcDatatypeDescriptorTypeDef: NcDatatypeDescriptor {
    attribute NcName    parentType; // Original typedef datatype name
    attribute NcBoolean    isSequence; // TRUE iff type is a typedef sequence of another type
};
```

The `type` attribute will be `Typedef`.

### NcDatatypeDescriptorStruct

```webidl
// Struct datatype descriptor
interface NcDatatypeDescriptorStruct: NcDatatypeDescriptor {
    attribute sequence<NcFieldDescriptor>    fields; // One item descriptor per field of the struct
    attribute NcName?    parentType; // Name of the parent type if any or null if it has no parent
};
```

The `type` attribute will be `Struct`.

### NcDatatypeDescriptorEnum

```webidl
// Enum datatype descriptor
interface NcDatatypeDescriptorEnum: NcDatatypeDescriptor {
    attribute sequence<NcEnumItemDescriptor>    items; // One item descriptor per enum option
};
```

The `type` attribute will be `Enum`.

### NcPropertyDescriptor

```webidl
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

```webidl
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

```webidl
// Descriptor of an enum item
interface NcEnumItemDescriptor: NcDescriptor {
    attribute NcName    name; // Name of option
    attribute NcUint16    value; // Enum item numerical value
};
```

### NcParameterDescriptor

```webidl
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

```webidl
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

```webidl
// Descriptor of a class event
interface NcEventDescriptor: NcDescriptor {
    attribute NcEventId    id; // Event id with level and index
    attribute NcName    name; // Name of event
    attribute NcName    eventDatatype; // Name of event data's datatype
    attribute NcBoolean    isDeprecated; // TRUE iff property is marked as deprecated
};
```

### NcClassDescriptor

```webidl
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

```webidl
// Abstract parameter constraints class
interface NcParameterConstraints {
    attribute any?    defaultValue; // Default value
};
```

### NcParameterConstraintsNumber

```webidl
// Number parameter constraints class
interface NcParameterConstraintsNumber: NcParameterConstraints {
    attribute any?    maximum; // optional maximum
    attribute any?    minimum; // optional minimum
    attribute any?    step; // optional step
};
```

### NcParameterConstraintsString

```webidl
// String parameter constraints class
interface NcParameterConstraintsString: NcParameterConstraints {
    attribute NcUint32?    maxCharacters; // maximum characters allowed
    attribute NcRegex?    pattern; // regex pattern
};
```

### NcRegex

```webidl
typedef NcString    NcRegex; // Regex pattern
```

### NcPropertyConstraints

```webidl
// Property constraints class
interface NcPropertyConstraints {
    attribute NcRolePath?    path; // relative path to member (null means current member)
    attribute NcPropertyId    propertyId; // ID of property being constrained
    attribute any?    defaultValue; // optional default value
};
```

### NcPropertyConstraintsFixed

```webidl
// Fixed property constraints class
interface NcPropertyConstraintsFixed: NcPropertyConstraints {
    attribute any?    value; // Signals a fixed value for this property
};
```

### NcPropertyConstraintsNumber

```webidl
// Number property constraints class
interface NcPropertyConstraintsNumber: NcPropertyConstraints {
    attribute any?    maximum; // optional maximum
    attribute any?    minimum; // optional minimum
    attribute any?    step; // optional step
};
```

### NcPropertyConstraintsString

```webidl
// String property constraints class
interface NcPropertyConstraintsString: NcPropertyConstraints {
    attribute NcUint32?    maxCharacters; // maximum characters allowed
    attribute NcRegex?    pattern; // regex pattern
};
```

### NcPropertyConstraintsEnum

```webidl
// Enum property constraints class
interface NcPropertyConstraintsEnum: NcPropertyConstraints {
    attribute sequence<NcEnumItemDescriptor>    possibleValues; // Allowed values
};
```

### NcBlockMemberDescriptor

```webidl
// Descriptor which is specific to a block member which is not a block
interface NcBlockMemberDescriptor: NcDescriptor {
    attribute NcString    role; // Role of member in its containing block
    attribute NcOid    oid; // OID of member
    attribute NcBoolean    constantOid; // TRUE iff member's OID is hardwired into device
    attribute NcClassId    classId; // Class ID
    attribute NcString?    userLabel; // User label
    attribute NcOid    owner; // Containing block's OID
    attribute sequence<NcPropertyConstraints>?    constraints; // Constraints on this member or, for a block, its members
};
```

The `constraints` attribute on this descriptor represents the optional constraints which could be applied to the block or its members through the implementation of a blockspec.

### NcBlockDescriptor

```webidl
// Descriptor which is specific to a block
interface NcBlockDescriptor: NcBlockMemberDescriptor {
    attribute NcString?    blockSpecId; // ID of BlockSpec this block implements
};
```

### NcUri

```webidl
typedef NcString    NcUri; // Uniform resource identifier
```

### NcManufacturer

```webidl
// Manufacturer descriptor
interface NcManufacturer {
    attribute NcString    name; // Manufacturer's name
    attribute NcOrganizationId?    organizationId; // IEEE OUI or CID of manufacturer
    attribute NcUri?    website; // URL of the manufacturer's website
};
```

### NcProduct

```webidl
// Product descriptor
interface NcProduct {
    attribute NcString    name; // Product name
    attribute NcString    key; // Manufacturer's unique key to product - model number, SKU, etc
    attribute NcString    revisionLevel; // Manufacturer's product revision level code
    attribute NcString?    brandName; // Brand name under which product is sold
    attribute NcString?    uuid; // Unique UUID of product (not product instance)
    attribute NcString?    description; // Text description of product
};
```

### NcResetCause

```webidl
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

```webidl
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

```webidl
// Device operational state
interface NcDeviceOperationalState {
    attribute NcDeviceGenericState    generic; // Generic operational state
    attribute NcString?    deviceSpecificDetails; // Specific device details
};
```

### NcMethodStatus

```webidl
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

```webidl
// Base result of the invoked method
interface NcMethodResult {
    attribute NcMethodStatus    status; // Status for the invoked method
};
```

### NcMethodResultError

```webidl
// Error result - to be used when the method call encounters an error
interface NcMethodResultError: NcMethodResult {
    attribute NcString    errorMessage; // Optional error message
};
```

### NcMethodResultPropertyValue

```webidl
// Result when invoking the getter method associated with a property
interface NcMethodResultPropertyValue: NcMethodResult {
    attribute any?    value; // Getter method value for the associated property
};
```

### NcMethodResultBlockMemberDescriptors

```webidl
// Method result containing block member descriptors as the value
interface NcMethodResultBlockMemberDescriptors: NcMethodResult {
    attribute sequence<NcBlockMemberDescriptor>    value; // Block member descriptors method result value
};
```

### NcMethodResultClassDescriptor

```webidl
// Method result containing a class descriptor as the value
interface NcMethodResultClassDescriptor: NcMethodResult {
    attribute NcClassDescriptor    value; // Class descriptor method result value
};
```

### NcMethodResultDatatypeDescriptor

```webidl
// Method result containing a datatype descriptor as the value
interface NcMethodResultDatatypeDescriptor: NcMethodResult {
    attribute NcDatatypeDescriptor    value; // Datatype descriptor method result value
};
```

### NcMethodResultId

```webidl
// Id method result
interface NcMethodResultId: NcMethodResult {
    attribute NcId    value; // Id result value
};
```
