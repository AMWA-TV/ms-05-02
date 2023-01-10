//	NC-Framework

$macro(HeaderComments)
	//  ----------------------------------------------------------------------------------
	//	NC-Framework classes and datatypes
	//
	//	Contains definitions of:
	//		-	core classes and datatypes needed
	//		- 	specific classes and datatypes needed by particular feature sets.
	//
	//	This file must be preprocessed with the 'pyexpand' macro processor to yield a complete
	//	Web IDL file.
	//
	//	With this scheme, an NCC module is defined as follows:
	//
	//		$macro(myModule)
	//			... Web IDL statements ...
	//		$endmacro
	//
	//		$myModule()
	//
	//	pyexpand is a single-pass processor, so forward references are not allowed.
	//	Thus, this file defines all the elemental submodules first. The code
	//	that generates the fully expanded NC-Framework definition is at the end of the file.
	//
	//	A pyexpand comment - i.e. a string that is not copied to the output - begins
	//	with dollar-hash.  All characters from a dollar-hash symbol through the end of
	//	the line are ignored.
	//  ----------------------------------------------------------------------------------
$endmacro
$macro(PrimitiveDatatypes)
    //  ----------------------------------------------------------------------------------
    // 	P r i m i t i v e   D a t a t y p e s
    //  ----------------------------------------------------------------------------------

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
$endmacro
$macro(IdentifiersClass)
	//  ----------------------------------------------------------------------------------
	//	Class identifiers
	//	
	//  An control class is uniquely identified by the concatenation of its definition 
	//	indices, in combination with a version code. A definition index is basically
	//	an index of a class within its inheritance level of the class tree.
	//
	//	For further explanation, please refer to MS-05-01 (NC-Architecture).
	//
	//	In the control model, the concatenated set of definition indices is called a Class ID;
	//	the corresponding datatype is 'NcClassId'.
	//
	// 	The combination of a Class ID and a version code <v> is called the Class Identity;
	//	the corresponding datatype is 'NcClassIdentity'.
	//
	//	In this specification, class identity will be coded as 'i1.i2. ...,v
	//
	//	where 
	//		'i1', 'i2', etc. are the definition index values, i.e. the Class ID.
	//		'v' is the class version code (see 'NcVersionCode')
	//	e.g.
	//		- class ID of version 1 of NcObject = '1,1.0.0'
	//		- class ID of version 1 of NcBlock 	= '1.3,1.0.0'
	//		- class ID of version 2 of NcWorker = '1.1,2.0.0'
	//		- class ID of version 1 of NcGain 	= '1.1.3,1.0.0'
	//
	//	The framework allows the definition of proprietary classes that inherit from standard classes.
	//	Proprietary Class IDs embed an IEEE OUI or CID to avoid value clashes among
	//	multiple organizations. 
	//
	//  ----------------------------------------------------------------------------------

	//	Unique 24-bit organization ID: 
	//	IEEE public Company ID (public CID) or
	//	IEEE Organizational Unique Identifier (OUI).

	typedef NcInt32 NcOrganizationId;
	
	// NcClassId is a sequence of NCInt32 class ID fields.
	// A class ID sequence reflects the ancestry of the class being identified.
	//
	// A class ID field is either a definition index or an authority key.
	//
	// A definition index is an ordinal that starts at 1 for every inheritance level of the control
	// model class tree.

	//	e.g.
	//		[ 1, 1, 3, 5]

	// An authority key shall be inserted in the class ID sequence immediately
	// after the definition index of the class from which a proprietary class inherits,
	// i.e. at the point where the proprietary class or class subtree
	// connects into the class structure.

	// For organizations which own a unique CID or OUI the authority key MUST be a negative 32-bit integer, constructed by
	// prepending FFh onto the 24-bit organization identifier.
	//
	// For organizations which do not own a unique CID or OUI the authority key MUST be 0.
	// e.g.
	//		[ 1, 1, 3, 5, -132131, 1, 4, 5 ]
	// or
	//		[ 1, 1, 3, 5, 0, 1, 4, 5 ]
	
	typedef sequence<NcInt32>	NcClassId;
$endmacro
$macro(VersionCode)
	//  ----------------------------------------------------------------------------------
	// 	Version code
	//
	//	Semantic version code, compliant with https://semver.org
	//
	//  ----------------------------------------------------------------------------------
	
	typedef NcString	NcVersionCode //Version code in semantic versioning format
	
	interface NcClassIdentity {
		attribute NcClassId		id;
		attribute NcVersionCode	version;
	};
$endmacro
$macro(Identifiers)
	//  ----------------------------------------------------------------------------------
	//	Identifiers
	//  ----------------------------------------------------------------------------------

	typedef NcString	NcName;		// Programmatically significant name, alphanumerics + underscore, no spaces

	typedef NcString	NcUUID;		// UUID

	typedef NcUint32	NcOid;		// Object id

	typedef sequence<NcName>	NcNamePath; //Name path
		
	// Class element id which contains the level and index
	interface NcElementId {
		attribute NcUint16	level;
		attribute NcUint16	index;
	};

	// Multipurpose internal handles
	typedef NcUint16	NcId16;
	typedef NcUint32	NcId32;
$endmacro
$macro(PortDatatypes)
	//  ----------------------------------------------------------------------------------
	//	Port datatypes
	//  ----------------------------------------------------------------------------------

	// Device-unique port identifier
	interface NcPortReference {
		attribute NcNamePath	owner;	// Rolepath of owning object
		attribute NcName		role;	// Unique identifier of this port within the owning object
	};

	interface NcPort {
		attribute NcName		role;		// Unique within owning object
		attribute NcIoDirection	direction;	// Input (sink) or output (source) port
		attribute NcNamePath?	clockPath;	// Rolepath of this port's sample clock or null if none
	};

	// Signal path descriptor	
	interface NcSignalPath {
		attribute	NcName			role;	// Unique identifier of this signal path in this block
		attribute	NcString?		label;	// Optional label
		attribute	NcPortReference	source;
		attribute	NcPortReference	sink;
	};
$endmacro
$macro(TouchpointDatatypes)
	//  ----------------------------------------------------------------------------------
	//	Touchpoint datatypes
	//
	//	Datatypes of Touchpoint mechanism for interfacing with other contexts
	//  ----------------------------------------------------------------------------------

	// Abstract base classes
	interface NcTouchpoint {
		attribute NcString				contextNamespace;
		attribute NcTouchpointResource	resource;
	};

	interface NcTouchpointResource {
		attribute NcString	resourceType;
		attribute any		id; // Subclasses will override
	};

	// NMOS-specific subclasses

	// IS-04 registrable entities
	interface NcTouchpointNmos: NcTouchpoint {
		// contextNamespace is inherited from NcTouchpoint and can only be x-nmos or x-nmos/channelmapping
		attribute NcTouchpointResourceNmos	resource;
	};

	interface NcTouchpointResourceNmos: NcTouchpointResource {
		// resourceType is inherited from NcTouchpointResource and can only be: node, device, source, flow, sender, receiver
		attribute NcUUID	id; // Override
	};

	// IS-08 inputs or outputs
	interface NcTouchpointResourceNmos_is_08: NcTouchpointResourceNmos {
		// resourceType is inherited from NcTouchpointResource and can only be: input, output
		// id is inherited from NcTouchpointResourceNmos
		attribute NcString	ioId; // IS-08 input or output ID
	};
$endmacro
$macro(EventAndSubscriptionDatatypes)

    //  ----------------------------------------------------------------------------------
    //	Event and subscription datatypes
    //  ----------------------------------------------------------------------------------

    // Payload of property-changed event
    interface NcPropertyChangedEventData {
        attribute NcElementId           propertyId;         // ID of changed property
        attribute NcPropertyChangeType  changeType;         // Information regarding the change type
        attribute any?                  value;              // Property-type specific
        attribute NcId32?               sequenceItemIndex;  // Index of sequence item if the property is a sequence
    };

    // Type of property change
    enum NcPropertyChangeType {
        "ValueChanged",         // 0 current value changed
        "SequenceItemAdded",    // 1 sequence item added
        "SequenceItemChanged",  // 2 sequence item changed
        "SequenceItemRemoved"   // 3 sequence item removed
    };
$endmacro
$macro(TimeDatatypes)
	//  ----------------------------------------------------------------------------------
	//	Time datatypes
	//  ----------------------------------------------------------------------------------
	
	typedef NcFloat64	NcTimeInterval 	// Floating point seconds

	interface NcTime {				// Time in PTP-compatible format
		attribute NcBoolean	negative;			// TRUE iff time is negative (used for relative times)
		attribute NcUint64	seconds;			// 48 bits of seconds (rest of range is unused)
		attribute NcUint32	nanoseconds;		// 32 bits of nanoseconds
	};	
$endmacro
$macro(ApplicationDatatypes)

	//  ----------------------------------------------------------------------------------
	//	Application datatypes
	//  ----------------------------------------------------------------------------------
	
	// Decibel-related datatypes
	
	typedef NcFloat32	NcDB	// A ratio expressed in dB.
	typedef NcDB		NcDbv	// dB ref 1 Volt - used only for analogue signals
	typedef NcDB		NcDbu	// dB ref 0.774 Volt - used only for analogue signals
	typedef NcDB		NcDbfs	// dB ref device maximum internal digital sample value
	typedef NcDB		NcDbz	// dB ref nominal device operating level

	// dB relative to given reference
	struct NcDBr {
		attribute NcDB	value;	// the dBr value
		attribute NcDbz	ref;	// the reference level
	};
$endmacro
$macro(ModelDatatypes)
	//  ----------------------------------------------------------------------------------
	//	Model datatypes
	//	
	//	Datatypes that describe the elements of control classes and datatypes
	//  ----------------------------------------------------------------------------------
	
	enum NcDatatypeType {
		"Primitive",	// 0 primitive, e.g. NcUint16
		"Typedef",		// 1 typedef, i,e. simple alias of another datatype
		"Struct",		// 2 data structure
		"Enum"			// 3 enum datatype
	};

	interface NcDescriptor {
		attribute NcString?	description; // optional user facing description
	};

	interface NcDatatypeDescriptor: NcDescriptor {
		attribute NcName					name;			// datatype name
		attribute NcDatatypeType			type;			// Primitive, Typedef, Struct, Enum
		attribute NcParameterConstraint?	constraints;	// optional constraints on top of the underlying data type
	};
	
	interface NcDatatypeDescriptorPrimitive: NcDatatypeDescriptor {
		//type will be Primitive
	};

	interface NcDatatypeDescriptorTypeDef: NcDatatypeDescriptor {
		//type will be Typedef
		attribute NcName	content;	// original typedef datatype name
		attribute NcBoolean	isSequence  // TRUE iff type is a typedef sequence of another type
	};

	interface NcDatatypeDescriptorStruct: NcDatatypeDescriptor {
		//type will be Struct
		attribute sequence<NcFieldDescriptor>	content;	// one item descriptor per field of the struct
		attribute NcName?	parentType;	// name of the parent type if any or null if it has no parent
	};

	interface NcDatatypeDescriptorEnum: NcDatatypeDescriptor {
		//type will be Enum
		attribute sequence<NcEnumItemDescriptor>	content;	// one item descriptor per enum option
	};
	
	// Descriptor of a class property
	interface NcPropertyDescriptor: NcDescriptor {
		attribute NcElementId				id;				// element ID of property
		attribute NcName					name;			// name of property
		attribute NcName?					typeName;		// name of property's datatype. Can only ever be null if the type is any
		attribute NcBoolean					readOnly;		// TRUE iff property is read-only
		attribute NcBoolean					persistent;		// TRUE iff property value survives power-on reset
		attribute NcBoolean					isNullable;		// TRUE iff property is nullable
		attribute NcBoolean?				isSequence;		// TRUE iff property is a sequence. May be null if the type is any
		attribute NcParameterConstraint?	constraints;	// optional constraints on top of the underlying data type
	};
	
	// Descriptor of a field of a struct
	interface NcFieldDescriptor: NcDescriptor {
		attribute	NcName					name;			// name of field
		attribute	NcName?					typeName;		// name of field's datatype. Can only ever be null if the type is any
		attribute	NcBoolean				isNullable;		// TRUE iff the field is nullable
		attribute	NcBoolean?				isSequence;		// TRUE iff the field is a sequence. May be null if the type is any
		attribute	NcParameterConstraint?	constraints;	// optional constraints on top of the underlying data type
	};
	
	// Descriptor of an enum
	interface NcEnumItemDescriptor: NcDescriptor {
		attribute NcName		name;	// name of option
		attribute NcUint16	index;		// index value of option (starts at zero)
	};

	// Descriptor of a method parameter
	interface NcParameterDescriptor: NcDescriptor {
		attribute NcName					name;			// name of parameter
		attribute NcName?					typeName;		// name of parameter's datatype. Can only ever be null if the type is any
		attribute NcBoolean					isNullable;		// TRUE iff parameter is nullable
		attribute NcBoolean?				isSequence;		// TRUE iff the parameter is a sequence. May be null if the type is any
		attribute NcParameterConstraint?	constraints;	// optional constraints on top of the underlying data type
	};
	
	interface NcMethodDescriptor: NcDescriptor {
		attribute NcElementId						id;				// element ID of method
		attribute NcName							name;			// name of method
		attribute NcName							resultDatatype;	// name of method result's datatype
		attribute sequence<NcParameterDescriptor>	parameters;		// 0-n parameter descriptors
	};
	
	interface NcEventDescriptor: NcDescriptor {
		attribute NcElementId	id;				// element ID of event
		attribute NcName		name;			// event's name
		attribute NcName		eventDatatype;	// name of event data's datatype
	};
	
	interface NcClassDescriptor: NcDescriptor {
		attribute sequence<NcPropertyDescriptor>	properties;	// 0-n property descriptors
		attribute sequence<NcMethodDescriptor>		methods;	// 0-n method descriptors.
		attribute sequence<NcEventDescriptor>		events;		// 0-n event descriptors.
	};

	//Abstract parameter constraint class
	interface NcParameterConstraint {
		attribute any?	defaultValue;		// default value
	}

	interface NcParameterConstraintNumber: NcParameterConstraint {
		attribute any?	maximum;	// not less than this
		attribute any?	minimum;	// not more than this
		attribute any?	step;		// stepsize
	}
	
	interface NcParameterConstraintString: NcParameterConstraint {
		attribute NcUint32?	maxCharacters;	// maximum characters allowed
		attribute NcRegex?	pattern;		// regex pattern
	}
$endmacro
$macro(PropertyConstraintDatatypes)
	//  ----------------------------------------------------------------------------------
	//	Property constraint datatypes
	//
	//	Used in block member descriptors - see the BlockDatatypes module
	//  ----------------------------------------------------------------------------------

	typedef NcString	NcRegex; // regex pattern

	interface NcPropertyConstraint {
		attribute	NcNamePath?		path;			// relative path to member (null means current member)
		attribute	NcElementId	propertyId;		// ID of property being constrained
		attribute	any?			defaultValue;	// default value
	}

	interface NcPropertyConstraintFixed: NcPropertyConstraint {
		attribute	any?			value;		// signals a fixed value for this property
	}

	interface NcPropertyConstraintNumber: NcPropertyConstraint {
		attribute	any?	maximum;	// not less than this
		attribute	any?	minimum;	// not more than this
		attribute	any?	step;		// stepsize
	}
	
	interface NcPropertyConstraintString: NcPropertyConstraint {
		attribute	NcUint32?	maxCharacters;	// maximum characters allowed
		attribute	NcRegex?	pattern;		// regex pattern
	}

	interface NcPropertyConstraintEnum: NcPropertyConstraint {
		attribute	sequence<NcEnumItemDescriptor>	possibleValues;	// allowed values
	}
$endmacro
$macro(BlockDatatypes)
	//  ----------------------------------------------------------------------------------
	//	Block datatypes
	//
	//	Datatypes for NcBlock
	//  ----------------------------------------------------------------------------------
	
	// Object name path
	//		Ordered list of block object names ending with name of object in question.
	//		Object in question may be a block or an application object.
	//		Absolute paths begin with root block name, which is always null.
	//		Relative paths begin with name of first-level nested block inside current one.

	interface NcBlockMemberDescriptor: NcDescriptor {
		attribute	NcName			role;			// Role of member in its containing block
		attribute	NcOid			oid;			// OID of member
		attribute	NcBoolean		constantOid;	// TRUE iff member's OID is hardwired into device 
		attribute	NcClassIdentity	identity;		// Class ID & version of member
		attribute	NcString		userLabel;		// User label
		attribute	NcOid			owner;			// Containing block's OID
		
		// Constraints:
		// A constraint is applied to this member using a constraints object with constraints.path empty or omitted.
		// If this member is a block, a constraint may be applied to one of its members by setting constraints.path
		// to the path of the target member relative to this member.  For example, if this member is a block that 
		// contains an NcGain object whose role property is "gainTrim", then the constraint.path value in this
		// context would be simply "gainTrim".  More complex path values will arise only when applying constraints to
		// elements in multiply nested blocks.
		//
		// Note that constraints may be multiply applied.  A blockspec 'X' may specify a particular constraint for one of
		// members' properties, but then when X is nested inside another block 'Y', Y may further constrain the
		// same property.  In such cases, the person or program using the blockspec in question must resolve the
		// multiple constraints into a single constraint that represents the intersection of all of them.  When the
		// given constraint values do not allow such resolution, it is a blockspec coding error.
	
		attribute	sequence<NcPropertyConstraint>? constraints	// Constraints on this member or, for a block, its members.
	};

	interface NcBlockDescriptor: NcBlockMemberDescriptor {
  		attribute	NcString?	blockSpecId; // ID of BlockSpec this block implements
	};
$endmacro
$macro(ManagementDatatypes)
	//  ----------------------------------------------------------------------------------
	//	Management datatypes
	//  ----------------------------------------------------------------------------------

	typedef NcString	NcUri;

	//	Manufacturer desciptor
	interface NcManufacturer {
		attribute	NcString			name 			// Manufacturer's name
		attribute	NcOrganizationId?	organizationId	// IEEE OUI or CID of manufacturer
		attribute	NcUri?				website			// URL of the manufacturer's website
	};
	
	// Product descriptor
	interface NcProduct {
		attribute	NcString	name			// Product name
		attribute	NcString	key				// Manufacturer's unique key to product - model number, SKU, etc
		attribute	NcString	revisionLevel	// Manufacturer's product revision level code
		attribute	NcString?	brandName		// Brand name under which product is sold
		attribute	NcString?	uuid			// Unique UUID of product (not product instance)
		attribute	NcString?	description		// Text description of product
	};
	
	enum NcResetCause {
		"PowerOn",			// 0 Last reset was caused by device power-on.
		"InternalError",	// 1 Last reset was caused by an internal error.
		"Upgrade",			// 2 Last reset was caused by a software or firmware upgrade.
		"ControllerRequest"	// 3 Last reset was caused by a controller request.
	};
	
	enum NcDeviceGenericState {
		"NormalOperation",	// 0 Device is operating normally.
		"Initializing",		// 1 Device is starting  or restarting.
		"Updating",			// 2 Device is performing a software or firmware update.
	};

    interface NcDeviceOperationalState {
        attribute NcDeviceGenericState  generic;
        attribute NcString?             deviceSpecificDetails;  //Device implementation specific details
    };
$endmacro
$macro(MethodResultDatatypes) 
	//  ----------------------------------------------------------------------------------
	//  Method result datatypes
	//  ----------------------------------------------------------------------------------

	// NcMethodStatus follows the following ranges:

	// Informational statuses: 100 - 199
	// Succesful statuses: 200 - 299
	// Reserved range: 300 - 399
	// Client error statuses: 400 - 499
	// Server error statuses: 500 - 599

	enum NcMethodStatus {
		"Ok",                       // 200 - Method call was successful
		"BadCommandFormat",         // 400 - Badly-formed command
		"Unauthorized",             // 401 - Client is not authorized
		"BadOid",                   // 404 - Command addresses a nonexistent object
		"Readonly",                 // 405 - Attempt to change read-only state
		"InvalidRequest",           // 406 - Method call is invalid in current operating context
		"Conflict",                 // 409 - There is a conflict with the current state of the device
		"BufferOverflow",           // 413 - Something was too big
		"ParameterError",           // 417 - Method parameter does not meet expectations
		"Locked",                   // 423 - Addressed object is locked
		"DeviceError",              // 500 - Internal device error
		"MethodNotImplemented",     // 501 - Addressed method is not implemented by the addressed object
		"PropertyNotImplemented",   // 502 - Addressed property is not implemented by the addressed object
		"NotReady",                 // 503 - The device is not ready to handle any commands
		"Timeout",                  // 504 - Method call did not finish within the allotted time
		"ProtocolVersionError"      // 505 - Incompatible protocol version
	};
	
	// Base datatype
	interface NcMethodResult {
		attribute	NcMethodStatus	status;
		attribute	NcString?		errorMessage;
	};

	// property-value result used by generic getter on NcObject
	interface NcMethodResultPropertyValue: NcMethodResult {
		attribute	any?	value;
	}

	interface NcMethodResultBoolean: NcMethodResult {
		attribute	NcBoolean	value;
	};

	interface NcMethodResultString: NcMethodResult {
		attribute	NcString	value;
	};

	interface NcMethodResultInt16: NcMethodResult {
		attribute	NcInt16	value;
	};

	interface NcMethodResultInt32: NcMethodResult {
		attribute	NcInt32	value;
	};

	interface NcMethodResultInt64: NcMethodResult {
		attribute	NcInt64	value;
	};

	interface NcMethodResultUint16: NcMethodResult {
		attribute	NcUint16	value;
	};

	interface NcMethodResultUint32: NcMethodResult {
		attribute	NcUint32	value;
	};

	interface NcMethodResultUint64: NcMethodResult {
		attribute	NcUint64	value;
	};

	interface NcMethodResultFloat32: NcMethodResult {
		attribute	NcFloat32	value;
	};

	interface NcMethodResultFloat64: NcMethodResult {
		attribute	NcFloat64	value;
	};

	interface NcMethodResultBlockMemberDescriptors: NcMethodResult {
		attribute	sequence<NcBlockMemberDescriptor>	value;
	};

    interface NcMethodResultClassDescriptor: NcMethodResult {
        attribute   NcClassDescriptor   value;
    };

    interface NcMethodResultDatatypeDescriptor: NcMethodResult {
        attribute   NcDatatypeDescriptor    value;
    };

	interface NcMethodResultId32: NcMethodResult {
		attribute	NcId32	value;
	};

	interface NcMethodResultReceiverStatus: NcMethodResult {
		attribute	NcReceiverStatus	value;
	};
$endmacro
$macro(CoreDatatypes)

	//  ----------------------------------------------------------------------------------
	//	Core datatypes
	//  ----------------------------------------------------------------------------------
	
	$IdentifiersClass()
	$Identifiers()
	$VersionCode()
	$PortDatatypes()
	$TouchpointDatatypes()
	$EventAndSubscriptionDatatypes()
	$TimeDatatypes()
	$ApplicationDatatypes()
	$PropertyConstraintDatatypes()
	$BlockDatatypes()
	$ModelDatatypes()
	$ManagementDatatypes()
	$MethodResultDatatypes()
	
	// Input and/or output
	enum NcIoDirection {
		"Undefined",	// 0 Flow direction is not defined
		"Input",		// 1 Samples flow into owning object
		"Output",		// 2 Samples flow out of owning object
		"Bidirectional"	// 3 For possible future use
	};
	
	// String comparison options
	enum NcStringComparisonType {
		"Exact",					// 0 exact case-sensitive compare
		"Substring",				// 1 "starts with" - case-sensitive
		"Contains",					// 2 search string anywhere in target - case-sensitive
		"ExactCaseInsensitive",		// 3 exact case-insensitive compare
		"SubstringCaseInsensitive",	// 4 "starts with" - case-insensitive
		"ContainsCaseInsensitive"	// 5 search string anywhere in target - case-insensitive
	};	

	interface NcfirmwareComponent {
		attribute	NcName			name;			// Concise name
		attribute	NcVersionCode	version;		// Version code
		attribute	NcString?		description;	// optional non-programmatic description
	};
$endmacro
$macro(BaseClasses)
	//  ----------------------------------------------------------------------------------
	//	Base classes
	//
	//	Class NcObject, base classes for major class categories, and associated datatypes
	//  ----------------------------------------------------------------------------------
	
    [control-class("1", "1.0.0")] interface NcObject {

        // Abstract base class for entire class structure

        [element("1p1")]    static  readonly    attribute   NcClassId               classId;
        [element("1p2")]    static  readonly    attribute   NcVersionCode           classVersion;
        [element("1p3")]            readonly    attribute   NcOid                   oid;
        [element("1p4")]            readonly    attribute   NcBoolean               constantOid;    // TRUE iff OID is hardwired into device
        [element("1p5")]            readonly    attribute   NcOid?                  owner;          // OID of containing block. Can only ever be null for the root block
        [element("1p6")]            readonly    attribute   NcName                  role;           // role of obj in containing block
        [element("1p7")]                        attribute   NcString                userLabel;      // Scribble strip
        [element("1p8")]            readonly    attribute   sequence<NcTouchpoint>? touchpoints;
        
        // Generic Get/Set methods
        [element("1m1")]    NcMethodResultPropertyValue Get(NcElementId id);                                        // Get property value
        [element("1m2")]    NcMethodResult              Set(NcElementId id, any? value);                            // Set property value
        [element("1m3")]    NcMethodResultPropertyValue GetSequenceItem(NcElementId id, NcId32 index);              // Get sequence item
        [element("1m4")]    NcMethodResult              SetSequenceItem(NcElementId id, NcId32 index, any? value);  // Set sequence item
        [element("1m5")]    NcMethodResultId32          AddSequenceItem(NcElementId id, any? value);                // Add item to sequence
        [element("1m6")]    NcMethodResult              RemoveSequenceItem(NcElementId id, NcId32 index);           // Delete sequence item

        // Events
        [element("1e1")]    [event] void    PropertyChanged(NcPropertyChangedEventData eventData);
    };

	[control-class("1.2", "1.0.0")] interface NcWorker: NcObject {
	
		// Worker base class

		[element("2p1")]	attribute	NcBoolean	enabled;	// TRUE iff worker is enabled
	};
	
	[control-class("1.2.1", "1.0.0")] interface NcSignalWorker: NcWorker {

		// Signal worker base class
		[element("3p1")]				attribute	sequence<NcPort>	ports;		// The worker's signal ports
		[element("3p2")]	readonly	attribute	NcTimeInterval?		latency;	// Processing latency of this object (null if not defined)
	};

	[control-class("1.2.1.1", "1.0.0")] interface NcActuator: NcSignalWorker {
		// Actuator base class
	};

	[control-class("1.2.1.2", "1.0.0")] interface NcSensor: NcSignalWorker {
		// Sensor base class
	};
$endmacro
$macro(Block)
	//  ----------------------------------------------------------------------------------
	//	Block definitions
	//
	//	Container for NcObjects
	//	Members are identified by oid and role. An object in a hierarchy of nested blocks can be identified by its role path.
	//	A member's role path is a sequence of role values starting with the root block's role and ending with the member's role.
	//  ----------------------------------------------------------------------------------
	
	[control-class("1.1", "1.0.0")] interface NcBlock: NcObject {
		[element("2p1")]	readonly	attribute	NcBoolean							isRoot;				// TRUE if block is the root block
		[element("2p2")]	readonly	attribute	NcString?							specId;				// Global ID of blockSpec that defines this block
		[element("2p3")]	readonly	attribute	NcVersionCode?						specVersion;		// Version code of blockSpec that defines this block
		[element("2p4")]	readonly	attribute	NcString?							specDescription;	// Description of blockSpec that defines this block
		[element("2p5")]	readonly	attribute	NcString?							parentSpecId;		// Global ID of parent of blockSpec that defines this block
		[element("2p6")]	readonly	attribute	NcVersionCode?						parentSpecVersion;	// Version code of parent of blockSpec that defines this block
		[element("2p7")]	readonly	attribute	NcBoolean							isDynamic;			// TRUE if dynamic block
		[element("2p8")]	readonly	attribute	NcBoolean							isModified;			// TRUE if block contents modified since last reset
		[element("2p9")]	readonly	attribute	NcBoolean							enabled;			// TRUE if block is functional
		[element("2p10")]	readonly	attribute	sequence<NcBlockMemberDescriptor>	members;			// Descriptors of this block's members
		[element("2p11")]	readonly	attribute	sequence<NcPort>?					ports;				// this block's ports
		[element("2p12")]	readonly	attribute	sequence<NcSignalPath>?				signalPaths; 		// this block's signal paths
 
		// Block enumeration methods
		
		[element("2m1")]	NcMethodResultBlockMemberDescriptors	GetMemberDescriptors(NcBoolean recurse);	// gets descriptors of members of the block
		
		// BLOCK SEARCH METHODS

		// finds member(s) by path
		[element("2m2")]	NcMethodResultBlockMemberDescriptors	FindMembersByPath(
			NcNamePath path // path to search for
		); 
		
		// finds members with given role name or fragment
		[element("2m3")]	NcMethodResultBlockMemberDescriptors	FindMembersByRole(
			NcName role,								// role text to search for
			NcStringComparisonType nameComparisonType,	// type of string comparison to use
			NcClassId? classId,							// if non null, finds only members with this class ID
			NcBoolean recurse,							// TRUE to search nested blocks
		);
	};
$endmacro
$macro(Managers)
	//  -----------------------------------------------------------------------------
	// Manager classes
	// -----------------------------------------------------------------------------

	[control-class("1.3", "1.0.0")] interface NcManager: NcObject {
		// Manager base class
	};
	
    [control-class("1.3.1", "1.0.0", "DeviceManager")] interface NcDeviceManager: NcManager {
        
        //  Device manager class
        //  Contains basic device information and status.
        
        [element("3p1")]    readonly    attribute   NcVersionCode               ncVersion           // Version of nc this dev uses
        [element("3p2")]    readonly    attribute   NcManufacturer              manufacturer        // Manufacturer descriptor
        [element("3p3")]    readonly    attribute   NcProduct                   product             // Product descriptor
        [element("3p4")]    readonly    attribute   NcString                    serialNumber        // Mfr's serial number of dev
        [element("3p5")]                attribute   NcString                    userInventoryCode   // Asset tracking identifier (user specified)
        [element("3p6")]                attribute   NcString                    deviceName          // Name of this device in the application. Instance name, not product name.
        [element("3p7")]                attribute   NcString                    deviceRole          // Role of this device in the application.
        [element("3p8")]    readonly    attribute   NcDeviceOperationalState    operationalState    // Device operational state
        [element("3p9")]    readonly    attribute   NcResetCause                resetCause          // Reason for most recent reset
        [element("3p10")]   readonly    attribute   NcString?                   message             // Arbitrary message from dev to controller
    };
	
    [control-class("1.3.2", "1.0.0", "ClassManager")] interface NcClassManager: NcManager {
        
        //  Class manager class
        //  Returns definitions of control classes and datatypes that are used in the device.
        
        [element("3p1")]    readonly    attribute   sequence<NcClassDescriptor>     controlClasses;
        [element("3p2")]    readonly    attribute   sequence<NcDatatypeDescriptor>  datatypes;
        
        // Methods to retrieve a single class or type descriptor
        
        // Get a single class descriptor
        // Inherited class elements are always included
        [element("3m1")]    NcMethodResultClassDescriptor GetControlClass(
            NcClassIdentity identity   // class ID & version
        );

        // Get a single datatype descriptor
        [element("3m2")]    NcMethodResultDatatypeDescriptor GetDatatype(
            NcName name // name of datatype
        );
    };
	
	[control-class("1.3.3", "1.0.0","FirmwareManager")] interface NcFirmwareManager: NcManager {
		
		//	Firmware / software manager : Reports versions of components
		
		[element("3p1")]	readonly	attribute	sequence<NcfirmwareComponent>	components; // List of firmware component descriptors
	};
	
    [control-class("1.3.4", "1.0.0", "SubscriptionManager")] interface NcSubscriptionManager: NcManager {

        // Subscription manager
        
        [element("3m1")]    NcMethodResult  AddSubscription(NcOid oid);     // Will subscribe to changes from all of the properties on the specified oid
        [element("3m2")]    NcMethodResult  RemoveSubscription(NcOid oid);  // Will unsubscribe to changes from all of the properties on the specified oid
    };
	
	[control-class("1.3.5", "1.0.0", "DeviceTimeManager")] interface NcDeviceTimeManager: NcManager {
		//
		//	Controls device's internal clock(s) and its reference.
		//

		[element("3p1")]	readonly	attribute	NcTime			deviceTimePtp;				// Current device time
		[element("3p2")]	readonly	attribute	sequence<NcOid>	timeSources;				// OIDs of available NcTimeSource objects
		[element("3p3")]				attribute	NcOid			currentDeviceTimeSource;	// OID of current NcTimeSource object
	};
$endmacro
$macro(FeatureSet001)

	// -----------------------------------------------------------------------------
	// Feature set 001 - General control & monitoring
	// -----------------------------------------------------------------------------
	interface NcSwitchItem {
		attribute	NcBoolean	isEnabled;	// signals if the switch position is enabled
		attribute	NcString?	label;		// optional switch position label
	};

	[control-class("1.2.1.1.1", "1.0.0")] interface NcGain: NcActuator {
	
		//	Simple gain control
		[element("5p1")]	attribute	NcDB	setPoint;
	};
	
	[control-class("1.2.1.1.2", "1.0.0")] interface NcSwitch: NcActuator {
	
		// n-position switch with a label for each position
		
		[element("5p1")]	attribute	sequence<NcSwitchItem>	positions;	// list of switch positions
	};

	[control-class("1.2.1.1.3", "1.0.0")] interface NcIdentificationActuator: NcActuator {
	
		// Identification actuator - sets some kind of physical indicator on the device
		// If this property is set then it might activate a visual indicator on the device
		
		[element("5p1")]	attribute	NcBoolean	active;	// TRUE iff indicator is active
	};
		
	[control-class("1.2.1.2.1", "1.0.0")] interface NcLevelSensor: NcSensor {
		
		// Simple level sensor that reads in DB
		
		[element("5p1")]	attribute	NcDB	reading;
	};
	
	[control-class("1.2.1.2.2", "1.0.0")] interface NcStateSensor: NcSensor {
	
		// State sensor - returns an index into an array of state names.
		
		[element("5p1")]  attribute NcUint16 			reading;
		[element("5p2")]  attribute sequence<NcString>	stateNames;
	};
	
	[control-class("1.2.1.2.3", "1.0.0")] interface NcIdentificationSensor: NcSensor {
		
		// 	Identification sensor - raises an event when the user activates some kind of
		//	this-is-me control on the device. A common implementation is a device with an
		//	identification button which sets the active state below to true or false

		[element("5p1")]	readonly	attribute	NcBoolean	active;	// TRUE iff indicator is active
	};
$endmacro
$macro(FeatureSet002)

	// -----------------------------------------------------------------------------
	//
	// Feature set 002 - NMOS receiver Monitoring
	//
	// -----------------------------------------------------------------------------
	
	enum NcConnectionStatus {
		"Undefined",		// 0 This is the value when there is no receiver
		"Connected",		// 1 Connected to a stream
		"Disconnected",		// 2 Not connected to a stream
		"ConnectionError"	// 3 Connected but broken
	};
	
	enum NcPayloadStatus {
		"Undefined",				// 0 This is the value when there's no connection.
		"PayloadOK",				// 1 Payload type is one we know about and the PDU is well-formed
		"PayloadFormatUnsupported",	// 2 Payload is not one we know about
		"PayloadError",				// 3 Some kind of error has occurred
	};
	
	interface NcReceiverStatus {
		attribute	NcConnectionStatus	connectionStatus;
		attribute	NcPayloadStatus		payloadStatus;
	};
	
	[control-class("1.2.2", "1.0.0")] interface NcReceiverMonitor: NcWorker {
	
		// Receiver monitoring worker.
		// For attaching to specific receivers, uses the Touchpoint mechanism inherited from NcObject.
		
		[element("3p1")]	readonly attribute NcConnectionStatus	connectionStatus
		[element("3p2")]	readonly attribute NcString?			connectionStatusMessage;	// Arbitrary text message
		[element("3p3")]	readonly attribute NcPayloadStatus		payloadStatus;
		[element("3p4")]	readonly attribute NcString?			payloadStatusMessage;		// Arbitrary text message
	
		[element("3m1")]	NcMethodResultReceiverStatus	GetStatus(); // connection status + payload status in one call
		
		//	NOTIFICATIONS:
		//
		// 	This class inherits the property-changed event from NcObject.
		//	That event is the primary means by which controllers will learn
		//	of receiver status changes.  The Get(...) methods listed above
		//	should not be used for polling receiver status. Instead, controllers
		//	should subscribe to the appropriate property-changed event(s).
	};

	[control-class("1.2.2.1", "1.0.0")] interface NcReceiverMonitorProtected: NcReceiverMonitor {
	
		// Derived receiver monitoring worker class for SMPTE ST 2022-7-type receivers.
		
		[element("4p1")]	readonly	attribute	NcBoolean	signalProtectionStatus;
	};
$endmacro
$macro(FeatureSet003)
	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 003 - Audio control & monitoring
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
$endmacro
$macro(FeatureSet004)
	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 004 - Video control & monitoring
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
$endmacro
$macro(FeatureSet005)
	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 005 - Control aggregation
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
$endmacro
$macro(FeatureSet006)
	//  ----------------------------------------------------------------------------------
	//
	//	Feature set 006 - Matrixing
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	[control-class("1.2.1.3", "1.0.0")] interface NcMatrix: NcSignalWorker {
		
	};
$endmacro
$macro(FeatureSet007)
	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 007 - Datasets
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
$endmacro
$macro(FeatureSet008)
	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 8 - Logging
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
$endmacro
$macro(FeatureSet009)
	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 009 - Media file storage & playout
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
$endmacro
$macro(FeatureSet010)
	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 010 - Command sets & prestored programs
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
$endmacro
$macro(FeatureSet011)
	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 011 - Prestored control parameters
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
$endmacro
$macro(FeatureSet012)
	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 012 - Connection management
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
$endmacro
$macro(FeatureSet013)
	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 013 - Dynamic device configuration
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
$endmacro
$macro(FeatureSet014)
	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 014 - Access control
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
$endmacro
$macro(FeatureSet015)
	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 015 - Spatial media control
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
$endmacro
$macro(FeatureSet016)
	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 016 - Power supply management
	//	Placeholder for work to be done in the future
	//

	[control-class("1.3.8", "1.0.0","PowerManager")] interface NcPowerManager: NcManager {
		[element("3p1")]	readonly	attribute	NcDeviceGenericState 	state;
		[element("3p2")]	readonly	attribute	sequence<NcOid>			powerSupplyOids;		// OIDs of available NcPowerSupply objects
		[element("3p3")]	readonly	attribute	sequence<NcOid>			activePowerSupplyOids;	// OIDs of active NcPowerSupply objects
		[element("3p4")]	readonly	attribute	NcBoolean				autoState;				// TRUE if current state was invoked automatically
		[element("3p5")]	readonly	attribute	NcDeviceGenericState	targetState				// Power state to which the device is transitioning, or None.
	
		[element("3m1")]	NcMethodResult	ExchangePowerSupplies(
			NcOid		oldPsu,
			NcOid		newPsu,
			NcBoolean	powerOffOld
		);
	};

	//  ----------------------------------------------------------------------------------
$endmacro
$macro(FeatureSet017)

    // -----------------------------------------------------------------------------
    // Feature set 007 - Workflow Data
    // -----------------------------------------------------------------------------

    [control-class("1.2.3", "1.0.0")] interface NcWorkflowDataRecord: NcWorker {

        [element("3p1")]    attribute   NcProductionDataRecordType  type;
        [element("3p2")]    attribute   NsString                    id;
        
        // Additional properties and methods will be defined by subclasses.
    };

    enum NcProductionDataRecordType {
        "As10Header",   // 0 AMWA AS-10	header
        "As10Shim"      // 1 AMWA AS-10 shim
    };
$endmacro

$#
$# ============================================================================
$#
$# 	The actual control model formal specification is generated here.
$#
$#	To include an control class module in the specification, invoke its macro
$#	somewhere in the set below.
$#
$#	If a module is defined in the code above but not included in this set,
$#	it will not be part of the formal specification. 
$#
$# ============================================================================
$#
	$HeaderComments()
	$CoreDatatypes()
	$BlockDatatypes()
	$BaseClasses()
	$Block()
	$Managers()
	
	$FeatureSet001()	$#	 General control & monitoring
	$FeatureSet002()	$#	 NMOS endpoint monitoring
$#	 Other feature sets should be included here as they get designed.
	
// ============================================================================
// END OF NC-Framework	
// ============================================================================
