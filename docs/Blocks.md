# Blocks

`NcBlock` is a container class for other classes or blocks. Due to the generic nature of `NcBlock` it is recommended not to create derived block classes but instead always instantiate `NcBlock`.

The top most block in the device tree is called a `root block` and must always have an oId of `1` and a role of `root`.

Blocks have the following properties (inherited properties from `NcObject` are not shown here):

| **Property Name** | **Datatype**                        | **Readonly** | **Description**                                                                    |
| ----------------- | ----------------------------------- | ------------ | -----------------------------------------------------------------------------------|
| isRoot            | NcBoolean                           | Yes          | Indicates if the block is the root block                                           |
| specId            | NcString                            | Yes          | Global ID of blockspec that defines this block                                     |
| specVersion       | NcVersionCode                       | Yes          | Version code of blockspec that defines this block                                  |
| specDescription   | NcString                            | Yes          | Description of blockSpec that defines this block                                   |
| parentSpecId      | NcString                            | Yes          | Global ID of parent of blockspec that defines this block                           |
| parentSpecVersion | NcVersionCode                       | Yes          | Version code of parent of blockspec that defines this block                        |
| isDynamic         | NcBoolean                           | Yes          | Indicates if the contents of the block can change (members, ports or signal paths) |
| isModified        | NcBoolean                           | Yes          | Indicates if the contents of the block have changed since the last restart         |
| enabled           | NcBoolean                           | Yes          | Indicates if the block is functional                                               |
| members           | sequence\<NcBlockMemberDescriptor\> | Yes          | Oids of this block's members                                                       |
| ports             | sequence\<NcPort\>?                 | Yes          | This block's ports                                                                 |
| signalPaths       | sequence\<NcSignalPath\>?           | Yes          | This block's signal paths                                                          |

Where the following data types are defined:

```typescript
typedef NcString NcName;

typedef sequence<NcString>  NcRolePath;

enum NcIoDirection { // Input and/or output
    "Undefined", // 0 Flow direction is not defined
    "Input", // 1 Samples flow into owning object
    "Output", // 2 Samples flow out of owning object
    "Bidirectional" // 3 For possible future use
};

interface NcPort {
    attribute NcString      role;       // Unique within owning object
    attribute NcIoDirection direction;  // Input (sink) or output (source) port
    attribute NcRolePath?   clockPath;  // Rolepath of this port's sample clock or null if none
};

interface NcSignalPath {
    attribute   NcString        role;   // Unique identifier of this signal path in this block
    attribute   NcString?       label;  // Optional label
    attribute   NcPortReference source;
    attribute   NcPortReference sink;
};
```

More information on ports and signal paths can be found in [MS-05-01](https://specs.amwa.tv/ms-05-01) under the `Device Model\Signal paths` section.

Blockspecs are defined in [MS-05-03 NMOS Control Block Specifications](https://specs.amwa.tv/ms-05-03).

## Tree discovery

Blocks enable device tree discovery by offering the descriptors of their contained members in the `members` property.

```typescript
interface NcBlockMemberDescriptor {
    attribute NcString role; // Role of member in its containing block
    attribute NcOid oid; // OID of member
    attribute NcBoolean constantOid // TRUE iff member's OID is hardwired into device 
    attribute NcClassIdentity identity; // Class ID & version of member
    attribute NcString? userLabel; // User label
    attribute NcOid owner; // Containing block's OID
    attribute sequence<NcPropertyConstraints>? constraints // Constraints on this member or, for a block, its members.
};
```

## Search methods

All blocks also offer some search methods for convenience:

* FindMembersByPath (`[element("2m2")]`) - retrieve descriptors for members filtered using a role path sequence of roles
* FindMembersByRole (`[element("2m3")]`) - retrieve descriptors for members filtered by the role property
