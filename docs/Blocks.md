# Blocks

`NcBlock` is a container class for other classes or blocks.

The top most block in a device model is called a `root block` and MUST always have an oId of `1` and a role of `root`.

All device implementations MUST have a `root block` in their device model.

The control class model for NcBlock is listed in the [Framework](Framework.md#ncblock).

A object's role path is a sequence of role values starting with the root block's role, continuing with any containing blocks and ending with the object's role.

An object in a hierarchy of nested blocks MUST be uniquely identified by its role path which MUST be persisted across device reboots.

## Device model discovery

[Blocks](Framework.md#ncblock) enable device model discovery by offering the descriptors of their contained members in the `members` property which holds a collection of type [NcBlockMemberDescriptor](Framework.md#ncblockmemberdescriptor).

## Search methods

[Blocks](Framework.md#ncblock) are searchable by calling any of the following methods:

* FindMembersByPath - retrieve descriptors for members filtered using a relative role path sequence of roles. The relative path to search for MUST not include the role of the block targeted by oid
* FindMembersByRole - retrieve descriptors for members filtered by the role property
* FindMembersByClassId - retrieve descriptors for members filtered by a given class id
