# Managers

Managers are singleton (MUST only be instantiated once) classes which collate information that pertains to the entire device. Each manager class applies to a specific functional context.  
All managers MUST inherit from [NcManager](Framework.md#ncmanager).

All managers MUST always exist as members in the root block and have a fixed role.

The roles for the managers defined by the framework are defined using the `control-class extension` as a third argument.

Example:

```typescript
[control-class("1.3.1", "DeviceManager")] interface NcDeviceManager: NcManager
```

## Device manager

The device manager contains basic device information and statuses.

The control class model for NcDeviceManager is listed in the [Framework](Framework.md#ncdevicemanager).

A minimal device implementation MUST have a device manager in the root block.

## Class manager

The class manager is a manager which handles class and type discovery.

The control class model for NcClassManager is listed in the [Framework](Framework.md#ncclassmanager).

A minimal device implementation MUST have a class manager in the root block.

The manager has two properties:

* controlClasses (lists all class descriptors in the device using the [NcClassDescriptor](Framework.md#ncclassdescriptor) type - descriptors do not contain inherited elements)
* datatypes (lists all data type descriptors in the device using the [NcDatatypeDescriptor](Framework.md#ncdatatypedescriptor) type - descriptors do not contain inherited elements)

The descriptor for an individual control class can be retrieved using the `GetControlClass` method (`[element("3m1")]`) and passing the identity (type [NcClassId](Framework.md#ncclassid)) and includeInherited (if all inherited elements should be included - type [NcBoolean](Framework.md#primitives)) as arguments. The method has a response of type [NcMethodResultClassDescriptor](Framework.md#ncmethodresultclassdescriptor).

The descriptor for an individual data type can be retrieved using the `GetDatatype` method (`[element("3m2")]`) and passing the name (type [NcName](Framework.md#ncname)) and includeInherited (if all inherited elements should be included - type [NcBoolean](Framework.md#primitives)) as arguments. The method has a response of type [NcMethodResultDatatypeDescriptor](Framework.md#ncmethodresultdatatypedescriptor).

Where the device model instantiates a control class, its class descriptor MUST be made available through the properties and methods defined in the Class manager. Control class descriptors MUST correctly reflect any properties which have an immutable `readonly` state.

Where the device model makes use of a datatype, its datatype descriptor MUST be made available through the properties and methods defined in the class manager.
