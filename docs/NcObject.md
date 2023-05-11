# NcObject

NcObject is the base abstract control class for any control class in the control model. Any other control class MUST be derived directly or indirectly from this class.

The control class model for NcObject is listed in the [Framework](Framework.md#ncobject).

The `role` is a structural identifier which MUST be persisted across restarts.

Object ids (`oid` property) MUST uniquely identity objects in the device model.

Once an object in the device model is allocated an object id, it MUST not change until the device undergoes a reboot.

Object ids MAY be constant across system restarts in which case they MUST be signaled using the `constandOid` property by settings its value to `true`.

## Generic getter and setter

NcObject offers two generic methods for retrieving and setting a property on an object.

- The Get method (`[element("1m1")]`) accepts [NcPropertyId](Framework.md#ncpropertyid) as an argument and returns [NcMethodResultPropertyValue](Framework.md#ncmethodresultpropertyvalue).
- The Set method (`[element("1m2")]`) accepts [NcPropertyId](Framework.md#ncpropertyid) and any value (type depends on the underlying property type) as arguments. The return type is the base [NcMethodResult](Framework.md#ncmethodresult).

## PropertyChanged event

NcObject offers a PropertyChanged event `[element("1e1")]` which MUST trigger anytime a property on the object is changed.
The event data is of type [NcPropertyChangedEventData](Framework.md#ncpropertychangedeventdata).

Events can only be consumed as notifications when subscribed to. Subscriptions and their implementation are protocol-specific. For more details refer to [IS-12 NMOS Control Protocol](https://specs.amwa.tv/is-12/branches/v1.0-dev/docs/Protocol_messaging.html).

## Working with collections inside an NcObject

There are generic methods for getting, setting, adding and deleting items inside a collection property as part of `NcObject`.

Getting a collection item is done through the `GetSequenceItem` method (\[element("1m3")\]) by specifying the property identifier [NcPropertyId](Framework.md#ncpropertyid) and the index as arguments.
The result is of type [NcMethodResultPropertyValue](Framework.md#ncmethodresultpropertyvalue).

Setting a collection item is done through the `SetSequenceItem` method (\[element("1m4")\]) by specifying the property identifier [NcPropertyId](Framework.md#ncpropertyid), the index and the value as arguments.
The result is of type [NcMethodResult](Framework.md#ncmethodresult).

Adding an item to a collection is done through the `AddSequenceItem` method (\[element("1m5")\]) by specifying the property identifier [NcPropertyId](Framework.md#ncpropertyid) and the value as arguments.
The result is of type [NcMethodResultId](Framework.md#ncmethodresultid) which contains the index where the value was added.

Removing an item from a collection is done through the `RemoveSequenceItem` method (\[element("1m6")\]) by specifying the property identifier [NcPropertyId](Framework.md#ncpropertyid) and the index as arguments.
The result is of type [NcMethodResult](Framework.md#ncmethodresult).

## Touchpoints

Touchpoints represent the way in which a control model object may expose identity mappings across other contexts.
All `NcObject` MAY have touchpoints.

The [NcTouchpoint](Framework.md#nctouchpoint) datatype specifies a namespace and a resource of type [NcTouchpointResource](Framework.md#nctouchpointresource).

For general NMOS contexts (IS-04, IS-05 and IS-07) the [NcTouchpointNmos](Framework.md#nctouchpointnmos) datatype MUST be used which has a resource of type [NcTouchpointResourceNmos](Framework.md#nctouchpointresourcenmos). This allows specifying the UUID of the underlying NMOS resource.

For IS-08 Audio Channel Mapping the [NcTouchpointResourceNmosChannelMapping](Framework.md#nctouchpointresourcenmoschannelmapping) datatype MUST be used which allows linking to a UUID and an input or output id.

Architectural information about the touchpoints concept is available in [MS-05-01 Identification](https://specs.amwa.tv/ms-05-01/branches/v1.0-dev/docs/Identification.html#nca-nmos-identity-mapping).
