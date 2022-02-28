//	NC-Framework

$macro(HeaderComments)
	//  ----------------------------------------------------------------------------------
	//	NC-Framework classes and datatypes
	//
	//	Contains definitions of:
	//		-	core classes and datatypes needed throughout NCA
	//		- 	specific classes and datatypes needed by particular NCA feature sets.
	//
	//	This file must be preprocessed with the 'pyexpand' macro processor to yield a complete
	//	WebIDL file.  
	//
	//	With this scheme, an NCC module is defined as follows:
	//
	//		$macro(myModule)
	//			... WebIDL statements ...
	//		$endmacro
	//
	//		$myModule()
	//
	//	pyexpand is a single-pass processor, so forward references are not allowed.
	//	Thus, this file defines all the elemental submodules first.  The code
	//	that generates the fully expanded NCCF definition is at the end of the file.
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

		[primitive] typedef boolean				ncaBoolean;
		[primitive] typedef byte				ncaInt8;
		[primitive] typedef short				ncaInt16;
		[primitive] typedef long				ncaInt32;
		[primitive] typedef longlong			ncaInt64;
		[primitive] typedef octet				ncaUint8;
		[primitive] typedef unsignedshort		ncaUint16;
		[primitive] typedef unsignedlong		ncaUint32;
		[primitive] typedef unsignedlonglong	ncaUint64;
		[primitive] typedef unrestrictedfloat	ncaFloat32;
		[primitive] typedef unrestricteddouble	ncaFloat64;
		[primitive] typedef bytestring			ncaString;		// UTF-8 
		[primitive] typedef any					ncaBlob;
		[primitive] typedef any					ncaBlobFixedLen;
$endmacro
$macro(IdentifiersClass)
	//  ----------------------------------------------------------------------------------
	//	I d e n t i f i e r s C l a s s
	//	
	//  An NCA control class is uniquely identified by the concatenation of its definition 
	//	indices, in combination with a revision number.  A definition index is basically
	//	an index of a class within its inheritance level of the class tree.  
	//
	//	For further explanation, please refer to NC-Architecture.
	//
	//	In the control model, the concatenated set of definition indices is called a Class ID; 
	//	the corresponding NCC datatype is 'ncaClassId'.
	//
	// 	The combination of a Class ID and a revision number <v> is called a Class Identifier;
	//	the corresponding NCC datatype is 'ncaClassIdentifier'.
	//
	//	In this specification, a class identifier will be coded as 'i1.i2. ...,v'\'
	//
	//	where 
	//		'i1', 'i2', etc. are the definition index values, i.e. the Class ID.
	//		'v' is the class revision number
	//	e.g.
	//		- class ID of rev 1 of ncaObject 	= '1,1'
	//		- class ID of rev 1 of ncaBlock 	= '1.3,1'
	//		- class ID of rev 2 of ncaWorker 	= '1.1,2'
	//		- class ID of rev 1 of ncaGain 		= '1.1.3,1'	
	//
	//	NCA allows the definition of proprietary classes that inherit from standard classes.
	//	Proprietary Class IDs embed an IEEE OUI or CID to avoid value clashes among
	//	multiple organizations. 
	//
	//  ----------------------------------------------------------------------------------

	//	Unique 24-bit organization ID: 
	//	IEEE public Company ID (public CID) or
	//	IEEE Organizational Unique Identifier (OUI).
	//
	typedef [length(3)] ncaBlobFixedLen			ncaOrganizationId;
	
	// Authority key.  Used to identify proprietary classes. 
	// Negative 32-bit integer, constructed by prepending FFh
	// onto the 24-bit organization ID. 
	
	interface ncaClassAuthorityKey {
		attribute ncaInt8	 					sentinel;		// Always -1 = FFh
		attribute ncaOrganizationId 			organizationId; // Three bytes
	 };
	 
	// Class ID field.  Either a definition index or an authority key.
	//
	// An authority key shall be inserted in the class ID sequence immediately
	// after the definition index of the class from which a proprietary class inherits,
	// i.e. at the point where the proprietary class or class subtree
	// connects into the class structure.
	//
	// Negative values are reserved for authority keys and possible other constructs
	// in the future.  A zero value is never valid.
	
		typedef (ncaInt32 or ncaClassAuthorityKey) 	ncaClassIdField;
		
	// Class ID
	
	typedef sequence<ncaClassIdField>			ncaClassId;
	
$endmacro
$macro(VersionCode)
	//  ----------------------------------------------------------------------------------
	// 	V e r s i o n C o d e
	//
	//	Semantic version code, compliant with https://semver.org
	//
	//  ----------------------------------------------------------------------------------
	
	// Part of.preRelease and .build fields of version code.
	typedef ncaString							ncaVcPart		// only ASCII alphanumerics and hyphens [0-9A-Za-z-]; must be nonempty.
	
	// The actual version code
	interface ncaVersionCode { 			
		attribute ncaUint16 					major;			// Major version not necessarily backwards compatible
		attribute ncaUint16 					minor;			// New functionality, backwards compatible
		attribute ncaUint16						patch;			// Correction to faulty behavior
		[optional] attribute ncaVcPart			preRelease;		// "-" followed by dot-separated ncaVcParts
		[optional] attribute ncaVcPart			build;			// "+" followed by dot-separated ncaVcParts
	};
	
	// Class Identity
	interface ncaClassIdentity {
		attribute ncaClassId					id;
		attribute ncaVersionCode				version;
	};
$endmacro
$macro(Identifiers)
		//  ----------------------------------------------------------------------------------
		//	I d e n t i f i e r s
		//  ----------------------------------------------------------------------------------
		
		// Programmatically significant name
		typedef ncaString			ncaName;		// alphanumerics + underscore, no spaces
		
		// Control session ID 
		typedef ncaSessionID		ncaUint32;
		
		// Role of an element in context 
		typedef ncaName				ncaRole;				
		
		// CLASS ID 
		$IdentifiersClass()

		// OBJECT ID 
		typedef ncaUint32			ncaOid;
				
		// OBJECT ROLE PATH
		//		Array of roles, starting from the role of ncaRoot,
		//		ending with role of object in question.
		
		 typedef sequence(ncaName)	ncaRolePath; 
			
		// CLASS ELEMENT ID  
		interface ncaElementID {
			attribute ncaUint16		level;			
			attribute ncaUint16		index;	
		};
		 
		typedef ncaElementID		ncaPropertyID;	
		typedef ncaElementID		ncaMethodID;			
		typedef ncaElementID		ncaEventID;			
						
		// MULTIPURPOSE INTERNAL HANDLES 
		typedef Uint16				ncaId32;				
		typedef Uint32				ncaID32;			
		
		// OTHER 
		typedef ncaString			ncaUri;	
		typedef ncaUint16			ncaVersionCode;
$endmacro
$macro(PortDatatypes)
		//  ----------------------------------------------------------------------------------
		//	P o r t D a t a t y p e s
		//  ----------------------------------------------------------------------------------
								
		interface ncaPortReference {					// Device-unique port identifier
			attribute ncaRolePath		owner;			// Rolepath of owning object
			attribute ncaRole			role;			// Unique within owning object
		};
		
		interface ncaPort { 						
			attribute ncaRole			role;			// Unique within owning object
			attribute ncaIoDirection	direction;		// Input (sink) or output (source) port
			attribute ncaRolePath		clockPath;		// Rolepath of this port's sample clock or empty if none
		};
		
		interface ncaSignalPath {
			attribute ncaName			role;			// Unique within owning object
			attribute ncaRole			source;			// path origin
			attribute ncaRole			sink;			// path terminus
		)
$endmacro
$macro(TouchpointDatatypes)
		//  ----------------------------------------------------------------------------------
		//	T o u c h p o i n t D a t a t y p e s
		//
		//	Datatypes of Touchpoint mechanism for interfacing with other
		//	control architectures
		//  ----------------------------------------------------------------------------------
		
		// Abstract base classes  
	 
		interface ncaTouchpoint{			
			attribute ncaString				contextNamespace;
			attribute ncaTouchpointResource	resources;
		};
		
		interface ncaTouchpointResource{	
			attribute ncaString			resourceType;   
			attribute any				id; 									// Subclasses will override 
		};
	 
		// NMOS-specific subclasses 
		
		// IS-04 registrable entities
		interface ncaTouchpointNmos : ncaTouchpoint{		
			// ContextNamespace is inherited from ncaTouchpoint.
			attribute ncaTouchpointResourceNmos		resources;
		};
		
		interface ncaTouchpointResourceNmos : ncaTouchpointResource{
			// ResourceType is inherited from ncaTouchpoint. 
			attribute ncaString			id; 									// override 
		};
		
		// IS-08 inputs or outputs
		interface ncaTouchpointResourceNmos_is_08 : ncaTouchpointResourceNmos{
			// resourceType is inherited from ncaTouchpointResource
			// id is inherited from ncaTouchpointResourceNmos
			attribute ncaString			ioId;								// IS-08 input or output ID
		};
$endmacro
$macro(EventAndSubscriptionDatatypes)

	//  ----------------------------------------------------------------------------------
	//	E v e n t A n d S u b s c r i p t i o n D a t a t y p e s
	//  ----------------------------------------------------------------------------------
	
	interface ncaEvent{										//	NCA event - unique combination of emitter OID and Event ID
		attribute ncaOid				emitterOid; 
		attribute ncaEventID			eventId; 
	 };
	 	 
	interface ncaPropertyChangedEventData {					//	Payload of property-changed event		 
		attribute ncaPropertyID			propertyId;			// 	ID of changed property
		attribute ncaPropertyChangeType	changeType;			// 	Mainly for maps & sets
		attribute any					propertyValue;		// 	Property-type specific 
	 };
	
	interface ncaSynchronizeStateEventData {				// For NcaSubscriptionManager.SynchronizeState event
		attribute  sequence<ncaOid> changedObjectsIds;		// OIDs of objects changed while subscriptions were disabled.
	};	
	
	enum ncaPropertyChangeType {							// Type of property change
		"currentChanged",										// 0 Scalar property - current value changed
		"minChanged",											// 1 Scalar property - min allowed value changed
		"maxChanged",											// 2 Scalar property - max allowed value change
		"itemAdded",											// 3 Set or map - item(s) added
		"itemChanged",											// 4 Set or map - item(s) changed
		"itemDeleted"											// 5 Set or map - item(s) deleted
	};	
$endmacro

$macro(TimeDatatypes)
	//  ----------------------------------------------------------------------------------
	//	T i m e   D a t a t y p e s
	//  ----------------------------------------------------------------------------------
	
	TBD
$endmacro
$macro(ApplicationDatatypes)

	//  ----------------------------------------------------------------------------------
	//	A p p l i c a t i o n    D a t a t y p e s
	//  ----------------------------------------------------------------------------------
	
	// Decibel-related datatypes
	
	typedef ncaFloat32 		ncaDb			// A ratio expressed in dB.
	typedef	ncaDB			ncaDbv			// dB ref 1 Volt - used only for analogue signals
	typedef ncaDB			ncaDbu			// dB ref 0.774 Volt - used only for analogue signals
	typedef	ncaDB			ncaDbfs			// dB ref device maximum internal digital sample value
	typedef ncaDB			ncaDbz			// dB ref nominal device operating level
	struct ncaDBr {							// dB relative to given reference
		attribute ncaDB 	value;			// the dBr value
		attribute ncaDBz	ref;			// the reference level
	};
$endmacro
$macro(ModelDatatypes)
	//  ----------------------------------------------------------------------------------
	//	M o d e l   D a t a t y p e s
	//	
	//	Datatypes that describe the elements of control classes and datatypes
	//  ----------------------------------------------------------------------------------
	
	enum ncaDatatypeType {		// what sort of datatype this is
		"primitive",				// 0	primitive, e.g. ncaUint16
		"typedef",					// 1	typedef, i,e. simple alias of another datatype				
		"struct",					// 2	data structure	
		"enum",						// 3	enumeration
		"null"						// 4	null
	};
	
	interface ncaDatatypeDescriptor {
		ncaName								name;			// datatype name
		ncaDatatypeType						type;			// primitive, typedef, struct, enum, or null
		(ncaString  or ncaName or sequence<ncaFieldDescriptor> or sequence<ncaEnumItemDescriptor> or null) content; // dataype content, see below
		
		//  Contents of property 'content':
		//
		//		type		content
		//	-----------------------------------------------------------------------------------------
		//		primitive	empty string
		//		typedef		name of referenced type
		//		struct		sequence<ncaFieldDescriptor>, one item per field of the struct	
		// 	 	enum		sequence<ncaEnumItemDescriptor>, one item per enum option
		//		null		null
		//	-----------------------------------------------------------------------------------------	
	};
	
	interface ncaPropertyDescriptor {					// Descriptor of a class property
		ncaPropertyId						id;				// element ID of property
		ncaName								name;			// name of property
		ncaName								typeName;		// name of property's datatype
		ncaBoolean							readOnly;		// TRUE iff property is read-only
		ncaBoolean							persistent;		// TRUE iff property value survives power-on reset
		ncaBoolean							required;		// TRUE iff property must be implemented
	};
	
	interface ncaFieldDescriptor {						// Descriptor of a field of a struct
		ncaName								name;			// name of field
		ncaName								typeName;		// name of field's datatype
	};
	
	interface ncaEnumItemDescriptor {					// Descriptor of an enum option
		ncaName								name;			// name of option
		ncaUint16							index;			// index value of option (starts at zero)
	};

	interface ncaParameterDescriptor {					// Descriptor of a method parameter
		ncaName								name;			// name of parameter
		ncaName								typeName;		// name of parameter's datatype
		ncaBoolean							required;		// TRUE iff parameter is required
	};
	
	interface ncaMethodDescriptor {						// Descriptor of a method's API
		ncaMethodId							id;				// element ID of method
		ncaName								name;			// name of method
		ncaName								resultDatatype;	// name of method result's datatype
		sequence<ncaParameterDescriptor>	parameters;		// 0-n parameter descriptors
	};
	
	interface ncaEventDescriptor {						// Descriptor of an event
		ncaEventId							id;				// element ID of event
		ncaName								name;			// event's name
		ncaName								eventDatatype;	// name of event data's datatype
	};
	
	interface ncaClassDescriptor {						// Descriptor of a class
		ncaString							description;	// non-programmatic description - may be empty
		sequence<ncaPropertyDescriptor> 	properties;		// 0-n property descriptors
		sequence<ncaMethodDescriptor>		methods;		// 0-n method descriptors
		sequence<ncaEventDescriptor>		events;			// 0-n event descriptors
	};
$endmacro
$macro(PropertyConstraintDatatypes)
	//  ----------------------------------------------------------------------------------
	//	P r o p e r t y C o n s t r a i n t D a t a t y p e s
	//
	//	Used in block membmer descriptors - see #BlockDatatypes 
	//  ----------------------------------------------------------------------------------

	interface ncaPropertyConstraintBase {
		[optional] 	attribute 		ncaRolePath	path;	// relative path to member (null or omitted => current member)
		attribute	ncaPropertyId	propertyId;			// ID  of property being constrained
		[optional]	attribute 	any	value;				// Set property to this value
	}

	interface ncaPropertyConstraintNumber 	: ncaPropertyConstraintBase{
		[optional]	attribute 	any		maximum;		// not less than this
		[optional]	attribute 	any		minimum;		// not more than this
		[optional]	attribute 	any		step;			// stepsize
	}	
	
	interface ncaPropertyConstraintString 	: ncaPropertyConstraintBase {
	}
	
	interface ncaPropertyConstraintBoolean 	: ncaPropertyConstraintBase {
	}
	
	interface ncaPropertyConstraintOther	: ncaPropertyConstraintBase {
	}
	
	typedef 
		(ncaPropertyConstraintNumber or
		ncaPropertyConstraintString	or
		ncaPropertyConstraintBoolean or
		ncaPropertyConstraintOther)			ncaPropertyConstraint;

$endmacro
$macro(BlockDatatypes)
	//  ----------------------------------------------------------------------------------
	//	B l o c k D a t a t y p e s
	//
	//	Datatypes for ncaBlock
	//  ----------------------------------------------------------------------------------
	
	// Object name path
	// 		Ordered list of block object names ending with name of object in question.
	// 		Object in question may be a block or an application object.
	// 		Absolute paths begin with root block name, which is always null.
	// 		Relative paths begin with name of first-level nested block inside current one.
		
	// Signal path descriptor 
	
	interface ncaSignalPath { 
		attribute	ncaRole				role;			// Role of this signal path in this block
		attribute	ncaLabel			Label;			// Implementation-defined
		attribute	ncaPortReference	source;	
		attribute	ncaPortReference	sink;		
	};
		
	// Block member descriptor
	
	interface ncaBlockMemberDescriptor{ 
		attribute 	ncaRole				role;			// Role of member in its containing block
		attribute	ncaOid				oid;			// OID of member
		attribute	ncaBoolean			constantOid;	// TRUE iff member's OID is hardwired into device 
		attribute	ncaClassIdentity	identity;		// Class ID & version of member
		attribute	ncaLabel			userLabel;		// User label
		attribute 	ncaOid				owner;			// Containing block's OID
		
		// Constraints:
		// A constraint is applied to this member using a constraints object with constraints.path empty or omitted.
		// If this member is a block, a constraint may be applied to one of its members by setting constraints.path
		// to the path of the target member relative to this member.  For example, if this member is a block that 
		// contains an ncaGain object whose role property is "gainTrim", then the constraint.path value in this
		// context would be simply "gainTrim".  More complex path values will arise only when applying constraints to
		// elements in multiply nested blocks.
		//
		// Note that constraints may be multiply applied.  A blockspec 'X' may specify a particular constraint for one of
		// members' properties, but then when X is nested inside another block 'Y', Y may further constrain the
		// same property.  In such cases, the person or program using the blockspec in question must resolve the
		// multiple constraints into a single constraint that represents the intersection of all of them.  When the
		// given constraint values do not allow such resolution, it is a blockspec coding error.
	
		attribute	sequence<ncaPropertyConstraint> constraints	// Constraints on this member or, for a block, its members.
	};
		
	// Block descriptor
	
	interface ncaBlockDescriptor{
		attribute   ncaRole			role;			// Role of block in its containing block
		attribute	ncaOid			oid;			// OID of block 
		attribute 	ncaBlockSpecID	BlockSpecID;	// ID of BlockSpec this block implements
		attribute 	ncaOid			owner;			// Containing block's OID
	};
	
	// Block search result flags.  This bitset defines which attributes
	// are to be returned by block 'Find' operations.
		
$endmacro
$macro(ManagementDatatypes)
	//  ----------------------------------------------------------------------------------
	//	M a n a g e m e n t D a t a t y p e s
	//  ----------------------------------------------------------------------------------

	interface Manufacturer {		//	Manufacturer desciptor
		attribute ncaString			name 					// Manufacturer's name
		attribute ncaOrganizationID	organizationID			// IEEE OUI or CID of manufacturer
		attribute ncaURI			website					// URL of the manufacturer's website
		attribute ncaString			businessContact			// Contact information for business issues
		attribute ncaString			technicalContact		// Contact information for technical issues
	};
	
	interface Product {				// Product descriptor
		attribute ncaString			name					// Product name
		attribute ncaString			key						// Manufacturer's unique key to product - model number, SKU, etc
		attribute ncaString			revisionLevel			// Manufacturer's product revision level code
		attribute ncaString			brandName				// Brand name under which product is sold
		attribute ncaUuid			uuid					// Unique UUID of product (not product instance)
		attribute ncaString			description				// Text description of product
	};
	
	enum ncaResetCause {
		"powerOn",					// 0 Last reset was caused by device power-on.
		"internalError",			// 1 Last reset was caused by an internal error.
		"upgrade",					// 2 Last reset was caused by a software or firmware upgrade.
		"controllerRequest"			// 3 Last reset was caused by a controller request.
	};
	
	enum  ncaDeviceGenericState {
		"normalOperation",			// 0 Device is operating normally.
		"initializing",				// 1 Device is starting  or restarting.
		"updating",					// 2 Device is performing a software or firmware update.
	};

	interface ncaDeviceOperationalState {
		attribute ncaDeviceGenericState generic;
		attribute ncaBlob detail;
	};
$endmacro
$macro(AgentDatatypes)
	//  ----------------------------------------------------------------------------------
	//	A g e n t D a t a t y p e s
	//  ----------------------------------------------------------------------------------
	
	enum ncaConnectionStatus {					// Connection status	
		"Undefined",								// 0	This is the value when there is no receiver.	
		"Connected",								// 1	Connected to a stream
		"Disconnected",								// 2	Not connected to a stream
		"ConnectionError"							// 3	Connected but broken
	};
	
	interface ncaPayloadStatus {				// Received payload status
		"Undefined",								// 0	This is the value when there's no connection.
		"PayloadOK",								// 1	Payload type is one we know about and the PDU is well-formed
		"PayloadFormatUnsupported",					// 2	Payload is not one we know about
		"PayloadError",								// 3	Some kind of error has occurred
	};
	

$endmacro
$macro(MethodResultDatatypes) 
	//  ----------------------------------------------------------------------------------
	//	M e t h o d R e s u l t D a t a t y p e s
	//
	//	in alphabetical order by datatype name
	//  ----------------------------------------------------------------------------------

	enum ncaMethodStatus {					// Method result status values 			
		"ok",									// 0  It worked. 
		"protocolVersionError",					// 1  Control PDU had incompatible protocol version code 
		"deviceError",							// 2  Something went wrong
		"readonly",								// 3  Attempt to change read-only value
		"locked",								// 4  Addressed object is locked by another controller session 
		"badCommandFormat",						// 5  Badly-formed command PDU 
		"badOid",								// 6  Command addresses a nonexistent object 
		"parameterError",						// 7  Method parameter has invalid format 
		"parameterOutOfRange",					// 8  Method parameter has out-of-range value 
		"notImplemented",						// 9  Addressed method is not implemented by the addressed object 
		"invalidRequest",						// 10 Requested method call is invalid in current operating context 
		"processingFailed",						// 11 Device did not succeed in executing the addressed method 
		"badMethodID",							// 12 Command addresses a method that is not in the addressed object 
		"partiallySucceeded",					// 13 Addressed method began executing but stopped before completing 
		"timeout",								// 14 Method call did not finish within the allotted time 
		"bufferOverflow",						// 15 Something was too big 
		"omittedProperty"						// 16 Command referenced an optional property that is not instantiated in the referenced object.
	};	
	
	interface ncaMethodResult {				// Base datatype
		attribute ncaMethodStatus status;
		attribute ncaString errorMessage;
	};
	interface ncaMethodResultBlockDescriptors : 	ncaMethodResult {	// block descriptors result
		attribute sequence<ncaBlockrDescriptor> value;
	};
	interface ncaMethodResultBlockMemberDescriptors : ncaMethodResult {	// block member descriptors result
		attribute sequence<ncaBlockMemberDescriptor> value;
	};
	interface ncaMethodResultBlockSpecInfo		 : 	ncaMethodResult {	// BlockSpec info result
		attribute ncaString 		id;										// BlockSpec's global ID
		attribute ncaVersionCode	versionCode;							// Blockspec's version code
		attribute ncaString 		parentId;								// Parent blockSpec's global  ID
		attribute ncaVersionCode	parentVersionCode;						// Parent blockspec's version code
		attribute ncaString			description;							// Simple description of blockSpec
	};
	interface ncaMethodResultBoolean : 				ncaMethodResult {	// single boolean result
		attribute ncaBoolean value;	
	};
	interface ncaMethodResultClassDescriptors : 	ncaMethodResult {	// class descriptors result
		attribute sequence<ncaClassDescriptor> descriptor;
	};
	interface ncaMethodResultClassId : 				ncaMethodResult {	// classId result
		attribute	ncaClassID id;
	};
	interface ncaMethodResultClassIdentity : 		ncaMethodResult {	// classIdentity result
		attribute	ncaClassIdentity identity;	
	};
	interface ncaMethodResultClassVersion : 		ncaMethodResult {	// classVersion result
		attribute	ncaVersionCode version;	
	};
	interface ncaMethodResultDatatype : 			ncaMethodResult {	// NTP time result
		attribute ncaDatatype datatype;
	};
	interface ncaMethodResultDatatypeDescriptors : 	ncaMethodResult {	// dataype descriptors result
		attribute sequence<ncaDatatypeDescriptor> value;
	};
	interface ncaMethodResultFirmwareComponent : 	ncaMethodResult {	// component descriptor result
		attribute ncafirmwareComponent component;
	};
	interface ncaMethodResultId32 : 				ncaMethodResult {	// Id32 result
		attribute ncaId32 index;	
	};	
	interface ncaMethodResultObjectIdPath :			ncaMethodResult {	// object path result
		attribute ncaObjectIDPath value;	
	};
	interface ncaMethodResultObjectNamePath :		ncaMethodResult {	// object path result
		attribute ncaRolePath value;	
	};
	interface ncaMethodResultObjectSequence : 		ncaMethodResult {	// object-sequence result
		attribute sequence<ObjectSequenceItem> items;
	};
	interface ncaMethodResultObjectSequenceItem : 	ncaMethodResult {	// object-sequence item result
		attribute sequence<ObjectSequenceItem> items;
	};
	interface ncaMethodResultOID : 					ncaMethodResult {	// object ID result
		attribute ncaOid value;	
	};
	interface ncaMethodResultOIDs : 				ncaMethodResult {	// OIDs result
		attribute sequence<ncaOid> value	
	};	
	interface ncaMethodResultPorts : 				ncaMethodResult {	// ports result
		attribute sequence<ncaPort> value;
	};
	interface ncaMethodResultPropertyValue :		ncaMethodResult {	// property-value result
		attribute any value;
	}
	interface ncaMethodResultReceiverStatus : ncaMethodResult {	
		attribute ncaConnectionStatus 		connectionStatus;
		attribute ncaPayloadStatus			payloadStatus;
	};
	interface ncaMethodResultSessionID :			ncaMethodResult {	// session ID result
		attribute ncaSessionID SessionID;
	};
	interface ncaMethodResultSignalPath : 			ncaMethodResult {	// signal path result
		attribute ncaSignalPath value;
	};	
	interface ncaMethodResultSignalPaths : 			ncaMethodResult {	// signal paths result
		attribute sequence<ncaSignalPath> value;
	};
	interface ncaMethodResultString : 				ncaMethodResult {	// single string result
		attribute ncaString value;	
	};	
	interface ncaMethodResultTimeInterval : 		ncaMethodResult {	// time interval result
		attribute ncaTimeInterval value;	
	};
	interface ncaMethodResultTimeNtp : 				ncaMethodResult {	// NTP time result
		attribute ncaTimeNtp time;
	};
	interface ncaMethodResultTimePtp : 				ncaMethodResult {	// PTP time result
		attribute ncaTimePtp time;
	};
	interface ncaMethodResultTouchpoints : 			ncaMethodResult {	// touchpoints result
		attribute sequence<ncaTouchpoint> value;
	};
$endmacro
$macro(CoreDatatypes)

	//  ----------------------------------------------------------------------------------
	//	C o r e   D a t a t y p e s
	//  ----------------------------------------------------------------------------------
	
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
	$AgentDatatypes()
	$MethodResultDatatypes()
	
	enum ncaLockState {						// Concurrency lock states. 
		"noLock",								// 0 object is not locked 
		"lockNoWrite",							// 1 object may be queried but not modified 
		"lockNoReadWrite",						// 2 object may neither be queried nor modified
	};
	
	enum ncaIoDirection {					// Input and/or output
		"undefined",							// 0 Flow direction is not defined
		"input",								// 1 Samples flow into owning object
		"output",								// 2 Samples flow out of owning object
		"bidirectional"							// 3 For possible future use
	};
	
	enum ncaStringComparisonType {			// String comparison options
		"exact",					 			// 0 exact case-sensitive compare
		"substring",							// 1 "starts with" - case-sensitive
		"contains",								// 2 search string anywhere in target - case-sensitive
		"exactCaseInsensitive",					// 3 exact case-insensitive compare
		"substringCaseInsensitive",				// 4 "starts with" - case-insensitive
		"containsCaseInsensitive" 				// 5 search string anywhere in target - case-insensitive
	};	

	typedef ncaString		ncaLabel;		// Non-programmatic label
	
	interface ncaFirmwareComponent {		// Firmware component descripor
		attribute	ncaName				name;				// Concise name
		attribute	ncaVersionCode		version;			// Version code
		attribute	ncastring			description;		// non-programmatic description 
	};
		
$endmacro

$macro(BaseClasses)
	//  ----------------------------------------------------------------------------------
	//	B a s e C l a s s e s
	//
	//	Class ncaObject, base classes for major class categories, and associated datatypes
	//  ----------------------------------------------------------------------------------
	
	[control-class("1",1)] interface ncaObject{	

		//	Abstract base class for entire NCC class structure
	
		[element("1p1")]  static attribute ncaClassID 		classId;
		[element("1p2")]  static attribute ncaVersionCode	classVersion;
		[element("1p3")]  attribute ncaOid				oid;
		[element("1p4")]  attribute ncaBoolean			constantOid;		// TRUE iff OID is hardwired into device 
		[element("1p5")]  attribute ncaOid				owner;				// OID of containing block
		[element("1p6")]  readonly attribute ncaRole	role;				// role of obj in containing block
		[element("1p7")]  attribute	ncaString			userLabel;			// Scribble strip 		
		[element("1p8")]  readonly attribute ncaBoolean	lockable;
		[element("1p9")]  attribute ncaLockState		lockState;
		[element("1p10")] attribute sequence<ncaTouchpoint> touchpoints;
		
		// GENERIC GET/SET METHODS
	
		[element("1m1")]  ncaMethodResultPropertyValue	get(ncaPropertyId Id);											// Get property value
		[element("1m2")]  ncaMethodResult				set(ncaPropertyID id, any Value);								// Set property value
		[element("1m3")]  ncaMethodResult				clear(ncaPropertyID id);										// Sets property to initial value
		[element("1m4")]  ncaMethodResultPropertyValue	getCollectionItem(ncaPropertyId Id, ncaId32 Index);					// Get collection item
		[element("1m5")]  ncaMethodResult				setCollectionItem(ncaPropertyId Id, ncaId32 Index, any Value);	// Set collection item
		[element("1m6")]  ncaMethodResultId32			addCollectionItem(ncaPropertyId Id, any Value);					// Add item to collection
		[element("1m7")]  ncaMethodResult				removeCollectionItem(ncaPropertyId, ncaId32 Index);				// Delete collection item
	
		[element("1e1")] 	[event] void PropertyChanged(ncaPropertyChangedEventData eventData);
	};
	[control-class("1.2",1)] interface ncaWorker : ncaObject{

		// Worker base class

		[element("2p1")]  attribute ncaBoolean			enabled;			// TRUE iff worker is enabled
		[element("2p2")]  attribute sequence<ncaPort>	ports;				// The worker's signal ports
		[element("2p3")]  readonly attribute ncaTimeInterval latency;		// Processing latency of this object (optional)
		
	};
	[control-class("1.2.1",1)] interface ncaActuator : ncaWorker {
	
		// Actuator base class
		
	};
	[control-class("1.2.2",1)] interface ncaSensor : ncaWorker {

		// Sensor base class

	};
	[control-class("1.4",1)] interface ncaAgent : ncaObject {
	
		// Agent base class
		
	};
$endmacro
$macro(Block)
	//  ----------------------------------------------------------------------------------
	//	B l o c k
	//
	//	Container for NCA objects
	//  ------------------------------------------------------------------
	//	Notes:	Leaving out dynamic object configuration features for now.
	//					Leaving out parameter storage ("preset") features for now.
	//					Leaving out dataset features for now.
	//	- jb
	//  ----------------------------------------------------------------------------------
	
	[control-class("1.1",1)] interface ncaBlock : ncaObject {
		[element("2p1")]  attribute	ncaBoolean					enabled;			// TRUE iff block is functional
		[element("2p2")]  attribute	ncaString 					userLabel;			// user-settable label 			
		[element("2p3")]  readonly attribute	ncaString		specId;				// Global ID of blockSpec that defines this block
		[element("2p4")]  readonly attribute	ncaVersionCode	specVersion;		// Version code of blockSpec that defines this block
		[element("2p3")]  readonly attribute	ncaString		parentSpecId;		// Global ID of parent of blockSpec that defines this block
		[element("2p4")]  readonly attribute	ncaVersionCode	parentSpecVersion;	// Version code of parent of blockSpec that defines this block
		[element("2p5")]  readonly attribute	ncaString		specDescription;	// Description of blockSpec that defines this block
		[element("2p6")]  readonly attribute	ncaBoolean		isDynamic;			// TRUE iff dynamic block
		[element("2p7")]  readonly attribute	ncaBoolean		isModified;			// TRUE iff block contents modified since last reset
		[element("2p8")]  attribute	sequence<ncaOid> 			members; 			// OIDs of this block's members 
		[element("2p9")]  attribute	sequence<ncaPort>			ports;				// this block's ports
		[element("2p10")] attribute	sequence<ncaSignalPath>		signalPaths; 		// this block's signal paths  
 
		// BLOCK ENUMERATION METHODS 
		
		[element("2m1")]  ncaMethodResultBlockMemberDescriptors	getMemberDescriptors(ncaBoolean recurse);	// gets descriptors of members of the block
		[element("2m2")]  ncaMethodResultBlockDescriptors		getNestedBlocks();					// like GetMembers but returns only nested blocks
		
		// BLOCK SEARCH METHODS 
		
		[element("2m3")] 
			ncaMethodResultBlockMemberDescriptors		
			findMembersByRole(									// finds members with given role name or fragment
				ncaRole role, 									// role text to search for
				ncaStringComparisonType nameComparisonType,		// type of string comparison to use
				ncaClassId classId,								// if nonnull, finds only members with this class ID
				ncaBoolean recurse,								// TRUE to search nested blocks
			);
		[element("2m4")] 
			ncaMethodResultBlockMemberDescriptors		
			findMembersByUserLabel(								// finds members with given user label or fragment
				ncaString userLabel, 							// label text to search for
				ncaStringComparisonType nameComparisonType,		// type of string comparison to use	
				ncaClassId classId,								// if nonnull, finds only members with this class ID
				ncaBoolean recurse,								// TRUE to search nested blocks
																);
		[element("2m5")]
			ncaMethodResultBlockMemberDescriptors
			findMembersByPath(									// finds member(s) by path
				ncaRolePath path, 								// path to search for
			);
		};
$endmacro
$macro(CoreAgents)
	//  ----------------------------------------------------------------------------------
	//	C o r e A g e n t s
	//  ----------------------------------------------------------------------------------
	[control-class("1.4.1",1)] interface ncaObjectSequence : ncaAgent { 	
	
		//	Object sequence agent
	
		[element("3p1")]	sequence<ncaObjectSequenceItem>		items 								// The sequence, ordered by 'index' property
	};
	
	interface ObjectSequenceItem {						// Object-sequence list item
	
	// 	Object sequence item.  
	//	Sequences are ordered by value of 'index' property.
	
		attribute ncaUint16 	index;					// ordinal
		attribute ncaOid		oid;					// object ID
		attribute ncaRolePath	path;					// object path
	};
$endmacro


$macro(WorkflowDataCore)
	//  ----------------------------------------------------------------------------------
	//	W o r k f l o w D a t a C o r e
	//  ----------------------------------------------------------------------------------
	
	TBD - JB has made recommendations for changing this feature 2021.10.01
	
	[control-class("1.6",1)] interface WorkflowDataRecord : ncaAgent {
	
	//	Workflow data record base class
	
		[element("2p1"]	 attribute ncaProductionDataRecordType	type;
		[element("2p2"]	 attribute ncaProductionDataRecordID	id;
		
		// Additional properties and methods will be defined by subclasses.
	};
	
	enum ncaWorkflowDataRecordType {
		"blob",						// 0 binary large object, format undefined
		"as10Header",	   			// 1 AMWA AS-10	header
		"as10Shim"					// 2 AMWA AS-10 shim
	};
$endmacro
$macro(Managers)
	// -----------------------------------------------------------------------------
	//
	// Manager classes
	//
	// -----------------------------------------------------------------------------

	[control-class("1.7",1)]    interface Manager : ncaObject {
	
		// Manager base class
    };
	
	[control-class("1.7.1",1)]  interface ncaDeviceManager : ncaManager {
		
		//	Device manager class
		//	Contains basic device information and status.
		
		[element("3p1")]  readonly attribute 	ncaVersionCode		ncaVersion				// Version of NCA this dev uses						<Mandatory>
		[element("3p2")]  readonly attribute	ncaString		manufacturer				// Manufacturer descriptor							<Mandatory>
		[element("3p3")]  readonly attribute	ncaString			product					// Product descriptor								<Mandatory>
		[element("3p4")]  readonly attribute 	ncaString			serialNumber			// Mfr's serial number of dev						<Mandatory>
		[element("3p5")]  attribute				ncaString			userInventoryCode		// Asset tracking identifier (user specified)
		[element("3p6")]  attribute				ncaString			deviceName				// Name of this device in the application. Instance name, not product name. 
		[element("3p7")]  attribute				ncaString			deviceRole				// Role of this device in the application.
		[element("3p8")]  attribute				ncaBoolean			controlEnabled			// TRUE iff this dev is responsive to NCA commands
		[element("3p9")]  readonly attribute	ncaDeviceOperationalState	operationalState	// Device operational state						<Mandatory>
		[element("3p10")] readonly attribute 	ncaResetCause		resetCause				// Reason for most recent reset						<Mandatory>
		[element("3p11")] readonly attribute 	ncaString			message					// Arbitrary message from dev to controller			<Mandatory>
	};
	
	[control-class("1.7.2",1)]  interface ncaSecurityManager : ncaManager {
		
		//	Security manager class
		TBD
	};
	
	[control-class("1.7.3",1)]  interface ncaClassManager : ncaManager {
	
		//	Class manager class
		//  Returns definitions of control classes and datatypes
		//	that are used in the device.
		
		[element("3p1")]  readonly attribute 	sequence<ncaClassDescriptor>	controlClasses;
		[element("3p2")]  readonly attribute 	sequence<ncaDatatypeDescriptor>	datatypes;
		
		// Methods to retrieve a single class or type descriptor
		
		[element("3m1")]  
		ncaMethodResultClassDescriptors GetControlClass(	// Get a single class descriptor
			ncaClassIdentity identity, 							// class ID & version
			ncaBoolean allElements								// TRUE to include inherited class elements
		);
			
		[element("3m2")]  
		ncaMethodResultDatatypeDescriptors GetDatatype(		// Get descriptor of datatype and maybe its component datatypes
			ncaName name, 										// name of datatype
			ncaBoolean allDefs									// TRUE to include descriptors of component datatypes
		);
		
		// Methods to retrieve all the class and type descriptors used by a given block or nest of blocks
		
		[element("3m3")]  
		ncaMethodResultClassDescriptors GetControlClasses(	// Get descriptors of classes used by block(s)
			ncaRolePath blockPath, 									// path to block 
			ncaBoolean recurseBlocks, 							// TRUE to recurse contained blocks
			ncaBoolean allElements								// TRUE to include inherited class elements
		);	
				
		[element("3m4")] 
		ncaMethodResultDataTypes GetDataTypes(				// Get descriptors of datatypes used by blocks(s)
			ncaRolePath blockPath, 									// path to block 
			ncaBoolean recurseBlocks, 							// TRUE to recurse contained blocks
			ncaBoolean allDefs									// TRUE to include descriptors of referenced datatypes
		);
	};
	
	[control-class("1.7.4",1)]  interface ncaFirmwareManager : ncaManager {
		
		//	Firmware / software manager ::: Reports versions of components
		
		[element("3p1")]  readonly attribute	sequence<ncafirmwareComponent> 		Components;			// List of firmware component descriptors
		
$#		[element("3m1")]  attribute	ncaMethodResultFirmwareComponent 	GetComponent();
	};
	
	[control-class("1.7.5",1)]  interface ncaSubscriptionManager : ncaManager {
	
		// Subscription manager
		
		[element("3m1")]  ncaMethodResult 		
			AddSubscription(
				ncaEvent event											// the event to which the controller is subscribing
		);
		[element("3m2")]
			ncaMethodResult	
			RemoveSubscription(
				ncaEvent 					event
		);
		[element("3m3")]
			ncaMethodResult		
			addPropertyChangeSubscription(
				ncaOid						emitter,					// ID of object where property is
				ncaPropertyID 				property					// ID of the property
		);
		[element("3m4")]
			ncaMethodResult
			removePropertyChangeSubscription(
				ncaOid			emitter,								// ID of object where property is
				ncaPropertyID 	property								// ID of the property
		);
	};

	[control-class("1.7.6",1)]  interface ncaPowerManager : ncaManager {
		[element("3p1")]  readonly attribute ncaPowerState 		state;
		[element("3p2")]  readonly attribute sequence<ncaOid>	powerSupplyOids;			// OIDs of available ncaPowerSupply objects
		[element("3p3")]  attribute sequence<ncaOid>			activePowerSupplyOids;		// OIDs of active ncaPowerSupply objects
		[element("3p4")]  attribute ncaBoolean					autoState;					// TRUE if current state was invoked automatically
		[element("3p5")]  readonly attribute ncaPowerState		targetState					// Power state to which the device is transitioning, or None.
	
		[element("3m1")]  ncaMethodResult			exchangePowerSupplies(
			ncaOid 			oldPsu,
			ncaOid 			newPsu,
			ncaBoolean		powerOffOld
		);
	};
	
	[control-class("1.7.8",1)]  interface ncaDeviceTimeManager :	ncaManager {	
		//
		//	controls device's internal clock(s) and its reference.
		//
		[element("3p1")]  readonly attribute ncaTimePtp			deviceTimePtp;				// Current device time
		[element("3p2")]  readonly attribute sequence<ncaOid>	timeSources;				// OIDs of available NcaTimeSource objects
		[element("3p3")]  attribute	ncaOid						currentDeviceTimeSource;	// OID of current NcaTimeSource object
		[element("3p4")]  attribute	ncaTimeNtp					deviceTimeNtp;				// Legacy, might not be needed
	};
	
	[control-class("1.7.10",1)] interface ncaLockManager : ncaManager {
		
		// Lock manager.  Implements lockWait.
		
		[element("3m1")]  ncaMethodResult lockWait(
			ncaOid target, 												// OID of object to be (un)locked
			ncaLockStatus requestedLockStatus, 							// Type of lock requested, or unlock
			ncaTimeInterval												// Method fails if wait exceeds this.  0=forever
		);
		[element("3m2")]  ncaMethodResult	abortWaits(ncaOid target);	// Abort all this session's waits on given target
	};	
$endmacro

$macro(FeatureSet001)	$#	 General control & monitoring

	// -----------------------------------------------------------------------------
	//
	// Feature set 001 - General control & monitoring
	//
	// -----------------------------------------------------------------------------
	
	[control-class("1.2.1.1",1)]  interface ncaGain : ncaActuator {
	
		//	Simple gain control
		
		[element("4p1")]  attribute ncaDB 			setPoint;
	};
	
	[control-class("1.2.1.2",1)]  interface ncaSwitch : ncaWorker {
	
		// n-position switch with a name for each position
		
		[element("4p1")]  attribute ncaUint16		setpoint;		// current switch position
		[element("4p2")]  attribute ncaBitset		pointEnabled;	// map of which positions are enabled
		[element("4p3")]  attribute sequence(ncaString) labels;		// list of position labels
	};
		
	[control-class("1.2.1.3",1)]  interface ncaIdentificationActuator {
	
		// Identification actuator - sets some kind of physical indicator on the device
		
		[element("4p1")]  attribute ncaBoolean		active;			// TRUE iff indicator is active
	};
		
	[control-class("1.2.2.1",1)]  interface ncaLevelSensor {
		
		// Simple level sensor that reads in DB
		
		[element("4p1")]	ncaDB					reading;
	};
	
	[control-class("1.2.1.2",1)]  interface ncaStateSensor {
	
		// State sensor - returns an index into an array of state names.
		
		[element("4p1")]  attribute ncaUint16 			reading;
		[element("4p2")]  attribute sequence(ncaString)	stateNames;
	};
	
	[control-class("1.2.2.3",1)]  interface ncaIdentificationSensor {
		
		// 	Identification sensor - raises an event when the user activates some kind of
		//	this-is-me control on the device.
		
		[element("4e1")] [event] void Identify(ncaEventData);
	};

$endmacro
$macro(FeatureSet002)	$#	 NMOS receiver Monitoring

	// -----------------------------------------------------------------------------
	//
	// Feature set 002 - NMOS receiver Monitoring
	//
	// Related datatypes are in package 'AgentDatatypes'
	//
	// -----------------------------------------------------------------------------
	
	[control-class("1.4.1",1)] interface ncaReceiverMonitor : ncaAgent {
	
		// Receiver monitoring agent.
		// For attaching to specific receivers, uses the Touchpoint mechanism inherited from ncaObject.
		
		[element("3p1")]  readonly attribute ncaConnectionStatus	connectionStatus
		[element("3p2")]  readonly attribute ncaString				connectionStatusMessage;		// Arbitrary text message
		[element("3p3")]  readonly attribute ncaPayloadStatus		payloadStatus;
		[element("3p4")]  readonly attribute ncaString				payloadStatusMessage;			// Arbitrary text message
	
		[element("3m1")]  ncaMethodResultReceiverStatus				GetStatus();					// connection status + payload status in one call
		
		//	NOTIFICATIONS:
		//
		// 	This class inherits the property-changed event from ncaObject.
		//	That event is the primary means by which controllers will learn
		//	of receiver status changes.  The Get(...) methods listed above
		//	should not be used for polling receiver status. Instead, controllers
		//	should subscribe to the appropriate property-changed event(s).
	};

	[control-class("1.4.1.1",1)] interface ncaReceiverMonitorProtected :: ncaReceiverMonitor {
	
		// Derived receiver monitoring agent class for SMPTE ST 2022-7-type receivers.
		
		[element("4p1")]  readonly attribute ncaBoolean				signalProtectionStatus;
	};
$endmacro

$macro(FeatureSet003)	$#	 Audio control & monitoring

	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 003 - Audio control & monitoring
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	
$endmacro
$macro(FeatureSet004)	$#	 Video control & monitoring

	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 004 - Video control & monitoring
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	
$endmacro
$macro(FeatureSet005)	$#	 Control aggregation

	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 005 - Control aggregation
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	
$endmacro
$macro(FeatureSet006)	$#	 Matrixing

	//  ----------------------------------------------------------------------------------
	//
	//	Feature set 006 - Matrixing
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	
		[control-class("1.3",1)] interface ncaMatrix {
			TBD
		};
$endmacro
$macro(FeatureSet007)	$#	 Datasets

	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 007 - Datasets
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	
$endmacro
$macro(FeatureSet008)	$#	 Logging

	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 8 - Logging
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	
$endmacro
$macro(FeatureSet009)	$#	 Media file storage & playout

	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 009 - Media file storage & playout
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	
$endmacro
$macro(FeatureSet010)	$#	 Command sets & prestored programs

	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 010 - Command sets & prestored programs
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	
$endmacro
$macro(FeatureSet011)	$#	 Prestored control parameters

	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 011 - Prestored control parameters
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	
$endmacro

$macro(FeatureSet012)	$#	 Connection management

	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 012 - Connection management
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	
$endmacro
$macro(FeatureSet013)	$#	 Dynamic device configuration

	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 013 - Dynamic device configuration
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	
$endmacro
$macro(FeatureSet014)	$#	 Access control

	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 014 - Access control
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	
$endmacro
$macro(FeatureSet015)	$#	 Spatial media control

	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 015 - Spatial media control
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	
$endmacro
$macro(FeatureSet016)	$#	 Power supply management

	//  ----------------------------------------------------------------------------------
	//	
	//	Feature set 016 - Power supply management
	//	Placeholder for work to be done in the future
	//
	//  ----------------------------------------------------------------------------------
	
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
	$CoreAgents()
	$WorkflowDataCore()
	$Managers()
	
	$FeatureSet001()	$#	 General control & monitoring
	$FeatureSet002()	$#	 NMOS endpoint monitoring
$#	 Other feature sets should be included here as they get designed.
	
// ============================================================================
// END OF NC-Framework	
// ============================================================================
