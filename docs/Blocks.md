# Blocks

`ncBlock` is a container class for other classes or blocks. Due to the generic nature of `ncBlock` it is recommended not to create derived block classes but instead always instantiate `ncBlock`.

The top most block in the device tree is called a `root block` and must always have an oId of `1`.

Blocks have the following properties (inherited properties from `ncObject` are not shown here):

| **Property Name** | **Datatype**                   | **Readonly** | **Description**                                                                    |
| ----------------- | ------------------------------ | ------------ | -----------------------------------------------------------------------------------|
| enabled           | ncBoolean                      | Yes          | Indicates id the block is functional                                               |
| specId            | ncString                       | Yes          | Global ID of blockspec that defines this block                                     |
| specVersion       | ncVersionCode                  | Yes          | Version code of blockspec that defines this block                                  |
| parentSpecId      | ncString                       | Yes          | Global ID of parent of blockspec that defines this block                           |
| parentSpecVersion | ncVersionCode                  | Yes          | Version code of parent of blockspec that defines this block                        |
| specDescription   | ncString                       | Yes          | Description of blockSpec that defines this block                                   |
| isDynamic         | ncBoolean                      | Yes          | Indicates if the contents of the block can change (members, ports or signal paths) |
| isModified        | ncBoolean                      | Yes          | Indicates if the contents of the block have changed since the last restart         |
| members           | sequence\<ncOid\>                | Yes          | Oids of this block's members                                                       |
| ports             | sequence\<ncPort\>               | Yes          | This block's ports                                                                 |
| signalPaths       | sequence\<ncSignalPath\>         | Yes          | This block's signal paths                                                          |

Where the following data types are defined:

```typescript
typedef ncName ncRole;

typedef sequence(ncName) ncRolePath;

enum ncIoDirection { // Input and/or output
    "undefined", // 0 Flow direction is not defined
    "input", // 1 Samples flow into owning object
    "output", // 2 Samples flow out of owning object
    "bidirectional" // 3 For possible future use
};

interface ncPort {
    attribute ncRole role; // Unique within owning object
    attribute ncIoDirection direction; // Input (sink) or output (source) port
    attribute ncRolePath clockPath; // Rolepath of this port's sample clock or empty if none
};

interface ncSignalPath {
    attribute ncName role; // Unique within owning object
    attribute ncRole source; // path origin
    attribute ncRole sink; // path terminus
);
```

More information on ports and signal paths can be found in the architecture specification [NMOS Control Architecture (NC-Architecture)](https://specs.amwa.tv/ms-05-01/branches/v1.0-dev/docs/Device_Model.html#signal-paths).

Blockspecs are defined in the [NMOS Control Blockspecs (NC-Blockspecs)](https://specs.amwa.tv/ms-05-03/) specification.

## Tree discovery

Blocks enable device tree discovery by offering enumeration methods.

Descriptors for all the nested members can be retrieved with the `getMemberDescriptors` method (`[element("2m1")]`), which expected an `ncBoolean` recurse argument and returns a response of type `ncMethodResultBlockMemberDescriptors`.

```typescript
interface ncBlockMemberDescriptor{
    attribute ncRole role; // Role of member in its containing block
    attribute ncOid oid; // OID of member
    attribute ncBoolean constantOid // TRUE iff member's OID is hardwired into device 
    attribute ncClassIdentity identity; // Class ID & version of member
    attribute ncLabel userLabel; // User label
    attribute ncOid owner; // Containing block's OID

    attribute sequence<ncPropertyConstraint> constraints // Constraints on this member or, for a block, its members.
};

interface ncMethodResultBlockMemberDescriptors : ncMethodResult { // block member descriptors result
    attribute sequence<ncBlockMemberDescriptor> value;
};
```

## Search methods

All blocks also offer some search methods for convenience:

* findMembersByRole (`[element("2m3")]`) - retrieve descriptors for members filtered by the role property
* findMembersByUserLabel (`[element("2m4")]`) - retrieve descriptors for members filtered by the user label property
* findMembersByPath (`[element("2m5")]`) - retrieve descriptors for members filtered using a role path sequence of roles
