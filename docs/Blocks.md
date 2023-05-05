# Blocks

`NcBlock` is a container class for other classes or blocks.

The top most block in a device control tree is called a `root block` and MUST always have an oId of `1` and a role of `root`.

The control class model for NcBlock is listed in the [Framework](Framework.md#ncblock).

The role path of an element can be constructed from its role and the roles of all its parents. The role path can then be used to target a particular section of the control model tree or to retrieve the object ids again after a restart.

## Ports and signal paths

Blocks MAY also model how nested member classes are interconnected using [ports](Framework.md#ncport) and [signal paths](Framework.md#ncsignalpath).

More information on ports and signal paths can be found in [MS-05-01 Signal paths](https://specs.amwa.tv/ms-05-01/branches/v1.0-dev/docs/Device_Model.html#signal-paths).

## Tree discovery

Blocks enable device model discovery by offering the descriptors of their contained members in the `members` property which holds a collection of type [NcBlockMemberDescriptor](Framework.md#ncblockmemberdescriptor).

## Search methods

All blocks also offer some search methods for convenience:

* FindMembersByPath (`[element("2m2")]`) - retrieve descriptors for members filtered using a relative role path sequence of roles. The relative path to search for MUST not include the role of the block targeted by oid
* FindMembersByRole (`[element("2m3")]`) - retrieve descriptors for members filtered by the role property
* FindMembersByClassId (`[element("2m4")]`) - retrieve descriptors for members filtered by a given class id
