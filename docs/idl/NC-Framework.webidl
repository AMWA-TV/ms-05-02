//	NC-Framework

$macro(HeaderComments)
	//  ----------------------------------------------------------------------------------
	//	NC-Framework classes and datatypes
	//
	//	Contains definitions of:
	//		-	core classes and datatypes needed throughout nc
	//		- 	specific classes and datatypes needed by particular nc feature sets.
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

		[primitive] typedef boolean				 ncBoolean;
		[primitive] typedef byte				 ncInt8;
		[primitive] typedef short				 ncInt16;
		[primitive] typedef long				 ncInt32;
		[primitive] typedef longlong			 ncInt64;
		[primitive] typedef octet				 ncUint8;
		[primitive] typedef unsignedshort		 ncUint16;
		[primitive] typedef unsignedlong		 ncUint32;
		[primitive] typedef unsignedlonglong	 ncUint64;
		[primitive] typedef unrestrictedfloat	 ncFloat32;
		[primitive] typedef unrestricteddouble	 ncFloat64;
		[primitive] typedef bytestring			 ncString;		// UTF-8 
		[primitive] typedef any					 ncBlob;
		[primitive] typedef any					 ncBlobFixedLen;
$endmacro
$macro(IdentifiersClass)
	//  ----------------------------------------------------------------------------------
	//	I d e n t i f i e r s C l a s s
	//	
	//  An nc control class is uniquely identified by the concatenation of its definition 
	//	indices, in combination with a revision number.  A definition index is basically
	//	an index of a class within its inheritance level of the class tree.  
	//
	//	For further explanation, please refer to NC-Architecture.
	//
	//	In the control model, the concatenated set of definition indices is called a Class ID; 
	//	the corresponding NCC datatype is 'ncClassId'.
	//
	// 	The combination of a Class ID and a revision number <v> is called a Class Identifier;
	//	the corresponding NCC datatype is 'ncClassIdentifier'.
	//
	//	In this specification, a class identifier will be coded as 'i1.i2. ...,v'\'
	//
	//	where 
	//		'i1', 'i2', etc. are the definition index values, i.e. the Class ID.
	//		'v' is the class revision number
	//	e.g.
	//		- class ID of rev 1 of ncObject 	= '1,1'
	//		- class ID of rev 1 of ncBlock 	= '1.3,1'
	//		- class ID of rev 2 of ncWorker 	= '1.1,2'
	//		- class ID of rev 1 of ncGain 		= '1.1.3,1'	
	//
	//	 nc allows the definition of proprietary classes that inherit from standard classes.
	//	Proprietary Class IDs embed an IEEE OUI or CID to avoid value clashes among
	//	multiple organizations. 
	//
	//  ----------------------------------------------------------------------------------

	//	Unique 24-bit organization ID: 
	//	IEEE public Company ID (public CID) or
	//	IEEE Organizational Unique Identifier (OUI).
	//
	typedef [length(3)] ncBlobFixedLen			 ncOrganizationId;
	
	// Authority key.  Used to identify proprietary classes. 
	// Negative 32-bit integer, constructed by prepending FFh
	// onto the 24-bit organization ID. 
	
	interface ncClassAuthorityKey {
		attribute ncInt8	 					sentinel;		// Always -1 = FFh
		attribute ncOrganizationId 			organizationId; // Three bytes
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
	
	typedef (ncInt32 or ncClassAuthorityKey) 	 ncClassIdField;
		
	// Class ID
	
	typedef sequence<ncClassIdField>			 ncClassId;
	
$endmacro
$macro(VersionCode)
	//  ----------------------------------------------------------------------------------
	// 	V e r s i o n C o d e
	//
	//	Semantic version code, compliant with https://semver.org
	//
	//  ----------------------------------------------------------------------------------
	
	// The actual version code
	typedef ncString							 ncVersionCode //Version code in semantic versioning format
	
	// Class Identity
	interface ncClassIdentity {
		attribute ncClassId					id;
		attribute ncVersionCode				version;
	};
$endmacro
$macro(Identifiers)
		//  ----------------------------------------------------------------------------------
		//	I d e n t i f i e r s
		//  ----------------------------------------------------------------------------------
		
		// Programmatically significant name
		typedef ncString			 ncName;		// alphanumerics + underscore, no spaces
		
		// Control session ID 
		typedef ncSessionID		 ncUint32;
		
		// Role of an element in context 
		typedef ncName				 ncRole;				
		
		// CLASS ID 
		$IdentifiersClass()

		// OBJECT ID 
		typedef ncUint32			 ncOid;
				
		// OBJECT ROLE PATH
		//		Array of roles, starting from the role of ncRoot,
		//		ending with role of object in question.
		
		 typedef sequence(ncName)	 ncRolePath; 
			
		// CLASS ELEMENT ID  
		interface ncElementID {
			attribute ncUint16		level;			
			attribute ncUint16		index;	
		};
		 
		typedef ncElementID		 ncPropertyID;	
		typedef ncElementID		 ncMethodID;			
		typedef ncElementID		 ncEventID;			
						
		// MULTIPURPOSE INTERNAL HANDLES 
		typedef Uint16				 ncId32;				
		typedef Uint32				 ncID32;			
		
		// OTHER 
		typedef ncString			 ncUri;	
		typedef ncUint16			 ncVersionCode;
$endmacro
$macro(PortDatatypes)
		//  ----------------------------------------------------------------------------------
		//	P o r t D a t a t y p e s
		//  ----------------------------------------------------------------------------------
								
		interface ncPortReference {					// Device-unique port identifier
			attribute ncRolePath		owner;			// Rolepath of owning object
			attribute ncRole			role;			// Unique within owning object
		};
		
		interface ncPort { 						
			attribute ncRole			role;			// Unique within owning object
			attribute ncIoDirection	direction;		// Input (sink) or output (source) port
			attribute ncRolePath		clockPath;		// Rolepath of this port's sample clock or empty if none
		};
		
		interface ncSignalPath {
			attribute ncName			role;			// Unique within owning object
			attribute ncRole			source;			// path origin
			attribute ncRole			sink;			// path terminus
		);
$endmacro
$macro(TouchpointDatatypes)
		//  ----------------------------------------------------------------------------------
		//	T o u c h p o i n t D a t a t y p e s
		//
		//	Datatypes of Touchpoint mechanism for interfacing with other
		//	control architectures
		//  ----------------------------------------------------------------------------------
		
		// Abstract base classes  
	 
		interface ncTouchpoint{			
			attribute ncString				contextNamespace;
			attribute ncTouchpointResource	resources;
		};
		
		interface ncTouchpointResource{	
			attribute ncString			resourceType;   
			attribute any				id; 									// Subclasses will override 
		};
	 
		// NMOS-specific subclasses 
		
		// IS-04 registrable entities
		interface ncTouchpointNmos : ncTouchpoint{		
			// ContextNamespace is inherited from ncTouchpoint.
			attribute ncTouchpointResourceNmos		resources;
		};
		
		interface ncTouchpointResourceNmos : ncTouchpointResource{
			// ResourceType is inherited from ncTouchpoint. 
			attribute ncString			id; 									// override 
		};
		
		// IS-08 inputs or outputs
		interface ncTouchpointResourceNmos_is_08 : ncTouchpointResourceNmos{
			// resourceType is inherited from ncTouchpointResource
			// id is inherited from ncTouchpointResourceNmos
			attribute ncString			ioId;								// IS-08 input or output ID
		};
$endmacro
$macro(EventAndSubscriptionDatatypes)

	//  ----------------------------------------------------------------------------------
	//	E v e n t A n d S u b s c r i p t i o n D a t a t y p e s
	//  ----------------------------------------------------------------------------------
	
	interface ncEvent{										//	 nc event - unique combination of emitter OID and Event ID
		attribute ncOid				emitterOid; 
		attribute ncEventID			eventId; 
	 };
	 	 
	interface ncPropertyChangedEventData {					//	Payload of property-changed event		 
		attribute ncPropertyID			propertyId;			// 	ID of changed property
		attribute ncPropertyChangeType	changeType;			// 	Mainly for maps & sets
		attribute any					propertyValue;		// 	Property-type specific 
	 };
	
	interface ncSynchronizeStateEventData {				// For ncSubscriptionManager.SynchronizeState event
		attribute  sequence<ncOid> changedObjectsIds;		// OIDs of objects changed while subscriptions were disabled.
	};	
	
	enum ncPropertyChangeType {							// Type of property change
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
	
	typedef ncFloat64	ncTimeInterval // Floating point seconds
$endmacro
$macro(ApplicationDatatypes)

	//  ----------------------------------------------------------------------------------
	//	A p p l i c a t i o n    D a t a t y p e s
	//  ----------------------------------------------------------------------------------
	
	// Decibel-related datatypes
	
	typedef ncFloat32 		 ncDb			// A ratio expressed in dB.
	typedef	 ncDB			 ncDbv			// dB ref 1 Volt - used only for analogue signals
	typedef ncDB			 ncDbu			// dB ref 0.774 Volt - used only for analogue signals
	typedef	 ncDB			 ncDbfs			// dB ref device maximum internal digital sample value
	typedef ncDB			 ncDbz			// dB ref nominal device operating level
	struct ncDBr {							// dB relative to given reference
		attribute ncDB 	value;			// the dBr value
		attribute ncDBz	ref;			// the reference level
	};
$endmacro
$macro(ModelDatatypes)
	//  ----------------------------------------------------------------------------------
	//	M o d e l   D a t a t y p e s
	//	
	//	Datatypes that describe the elements of control classes and datatypes
	//  ----------------------------------------------------------------------------------
	
	enum ncDatatypeType {		// what sort of datatype this is
		"primitive",				// 0	primitive, e.g. ncUint16
		"typedef",					// 1	typedef, i,e. simple alias of another datatype				
		"struct",					// 2	data structure	
		"enum",						// 3	enumeration
		"null"						// 4	null
	};
	
	interface ncDatatypeDescriptor {
		 ncName								name;			// datatype name
		 ncDatatypeType						type;			// primitive, typedef, struct, enum, or null
		(ncString  or ncName or sequence<ncFieldDescriptor> or sequence<ncEnumItemDescriptor> or null) content; // dataype content, see below
		
		//  Contents of property 'content':
		//
		//		type		content
		//	-----------------------------------------------------------------------------------------
		//		primitive	empty string
		//		typedef		name of referenced type
		//		struct		sequence<ncFieldDescriptor>, one item per field of the struct	
		// 	 	enum		sequence<ncEnumItemDescriptor>, one item per enum option
		//		null		null
		//	-----------------------------------------------------------------------------------------	
	};
	
	interface ncPropertyDescriptor {					// Descriptor of a class property
		 ncPropertyId						id;				// element ID of property
		 ncName								name;			// name of property
		 ncName								typeName;		// name of property's datatype
		 ncBoolean							readOnly;		// TRUE iff property is read-only
		 ncBoolean							persistent;		// TRUE iff property value survives power-on reset
		 ncBoolean							required;		// TRUE iff property must be implemented
	};
	
	interface ncFieldDescriptor {						// Descriptor of a field of a struct
		 ncName								name;			// name of field
		 ncName								typeName;		// name of field's datatype
	};
	
	interface ncEnumItemDescriptor {					// Descriptor of an enum option
		 ncName								name;			// name of option
		 ncUint16							index;			// index value of option (starts at zero)
	};

	interface ncParameterDescriptor {					// Descriptor of a method parameter
		 ncName								name;			// name of parameter
		 ncName								typeName;		// name of parameter's datatype
		 ncBoolean							required;		// TRUE iff parameter is required
	};
	
	interface ncMethodDescriptor {						// Descriptor of a method's API
		 ncMethodId							id;				// element ID of method
		 ncName								name;			// name of method
		 ncName								resultDatatype;	// name of method result's datatype
		sequence<ncParameterDescriptor>	parameters;		// 0-n parameter descriptors
	};
	
	interface ncEventDescriptor {						// Descriptor of an event
		 ncEventId							id;				// element ID of event
		 ncName								name;			// event's name
		 ncName								eventDatatype;	// name of event data's datatype
	};
	
	interface ncClassDescriptor {						// Descriptor of a class
		ncString							description;	// non-programmatic description - may be empty
		sequence<ncPropertyDescriptor> 	properties;		// 0-n property descriptors
		sequence<ncMethodDescriptor>		methods;		// 0-n method descriptors
		sequence<ncEventDescriptor>		events;			// 0-n event descriptors
	};
$endmacro
$macro(PropertyConstraintDatatypes)
	//  ----------------------------------------------------------------------------------
	//	P r o p e r t y C o n s t r a i n t D a t a t y p e s
	//
	//	Used in block membmer descriptors - see #BlockDatatypes 
	//  ----------------------------------------------------------------------------------

	interface ncPropertyConstraintBase {
		[optional] 	attribute 		 ncRolePath	path;	// relative path to member (null or omitted => current member)
		attribute	 ncPropertyId	propertyId;			// ID  of property being constrained
		[optional]	attribute 	any	value;				// Set property to this value
	}

	interface ncPropertyConstraintNumber 	: ncPropertyConstraintBase{
		[optional]	attribute 	any		maximum;		// not less than this
		[optional]	attribute 	any		minimum;		// not more than this
		[optional]	attribute 	any		step;			// stepsize
	}	
	
	interface ncPropertyConstraintString 	: ncPropertyConstraintBase {
	}
	
	interface ncPropertyConstraintBoolean 	: ncPropertyConstraintBase {
	}
	
	interface ncPropertyConstraintOther	: ncPropertyConstraintBase {
	}
	
	typedef 
		(ncPropertyConstraintNumber or
		 ncPropertyConstraintString	or
		 ncPropertyConstraintBoolean or
		 ncPropertyConstraintOther)			 ncPropertyConstraint;

$endmacro
$macro(BlockDatatypes)
	//  ----------------------------------------------------------------------------------
	//	B l o c k D a t a t y p e s
	//
	//	Datatypes for ncBlock
	//  ----------------------------------------------------------------------------------
	
	// Object name path
	// 		Ordered list of block object names ending with name of object in question.
	// 		Object in question may be a block or an application object.
	// 		Absolute paths begin with root block name, which is always null.
	// 		Relative paths begin with name of first-level nested block inside current one.
		
	// Signal path descriptor 
	
	interface ncSignalPath { 
		attribute	 ncRole				role;			// Role of this signal path in this block
		attribute	 ncLabel			Label;			// Implementation-defined
		attribute	 ncPortReference	source;	
		attribute	 ncPortReference	sink;		
	};
		
	// Block member descriptor
	
	interface ncBlockMemberDescriptor{ 
		attribute 	 ncRole				role;			// Role of member in its containing block
		attribute	 ncOid				oid;			// OID of member
		attribute	 ncBoolean			constantOid;	// TRUE iff member's OID is hardwired into device 
		attribute	 ncClassIdentity	identity;		// Class ID & version of member
		attribute	 ncLabel			userLabel;		// User label
		attribute 	 ncOid				owner;			// Containing block's OID
		
		// Constraints:
		// A constraint is applied to this member using a constraints object with constraints.path empty or omitted.
		// If this member is a block, a constraint may be applied to one of its members by setting constraints.path
		// to the path of the target member relative to this member.  For example, if this member is a block that 
		// contains an ncGain object whose role property is "gainTrim", then the constraint.path value in this
		// context would be simply "gainTrim".  More complex path values will arise only when applying constraints to
		// elements in multiply nested blocks.
		//
		// Note that constraints may be multiply applied.  A blockspec 'X' may specify a particular constraint for one of
		// members' properties, but then when X is nested inside another block 'Y', Y may further constrain the
		// same property.  In such cases, the person or program using the blockspec in question must resolve the
		// multiple constraints into a single constraint that represents the intersection of all of them.  When the
		// given constraint values do not allow such resolution, it is a blockspec coding error.
	
		attribute	sequence<ncPropertyConstraint> constraints	// Constraints on this member or, for a block, its members.
	};
		
	// Block descriptor
	
	interface ncBlockDescriptor{
		attribute   ncRole			role;			// Role of block in its containing block
		attribute	 ncOid			oid;			// OID of block 
		attribute 	 ncBlockSpecID	BlockSpecID;	// ID of BlockSpec this block implements
		attribute 	 ncOid			owner;			// Containing block's OID
	};
	
	// Block search result flags.  This bitset defines which attributes
	// are to be returned by block 'Find' operations.
		
$endmacro
$macro(ManagementDatatypes)
	//  ----------------------------------------------------------------------------------
	//	M a n a g e m e n t D a t a t y p e s
	//  ----------------------------------------------------------------------------------

	interface Manufacturer {		//	Manufacturer desciptor
		attribute ncString			name 					// Manufacturer's name
		attribute ncOrganizationID	organizationID			// IEEE OUI or CID of manufacturer
		attribute ncURI			website					// URL of the manufacturer's website
		attribute ncString			businessContact			// Contact information for business issues
		attribute ncString			technicalContact		// Contact information for technical issues
	};
	
	interface Product {				// Product descriptor
		attribute ncString			name					// Product name
		attribute ncString			key						// Manufacturer's unique key to product - model number, SKU, etc
		attribute ncString			revisionLevel			// Manufacturer's product revision level code
		attribute ncString			brandName				// Brand name under which product is sold
		attribute ncUuid			uuid					// Unique UUID of product (not product instance)
		attribute ncString			description				// Text description of product
	};
	
	enum ncResetCause {
		"powerOn",					// 0 Last reset was caused by device power-on.
		"internalError",			// 1 Last reset was caused by an internal error.
		"upgrade",					// 2 Last reset was caused by a software or firmware upgrade.
		"controllerRequest"			// 3 Last reset was caused by a controller request.
	};
	
	enum  ncDeviceGenericState {
		"normalOperation",			// 0 Device is operating normally.
		"initializing",				// 1 Device is starting  or restarting.
		"updating",					// 2 Device is performing a software or firmware update.
	};

	interface ncDeviceOperationalState {
		attribute ncDeviceGenericState generic;
		attribute ncBlob deviceSpecificDetails; //Device implementation specific details
	};
$endmacro
$macro(AgentDatatypes)
	//  ----------------------------------------------------------------------------------
	//	A g e n t D a t a t y p e s
	//  ----------------------------------------------------------------------------------
	
	enum ncConnectionStatus {					// Connection status	
		"Undefined",								// 0	This is the value when there is no receiver
		"Connected",								// 1	Connected to a stream
		"Disconnected",								// 2	Not connected to a stream
		"ConnectionError"							// 3	Connected but broken
	};
	
	interface ncPayloadStatus {				// Received payload status
		"Undefined",								// 0	This is the value when there's no connection.
		"PayloadOK",								// 1	Payload type is one we know about and the PDU is well-formed
		"PayloadFormatUnsupported",					// 2	Payload is not one we know about
		"PayloadError",								// 3	Some kind of error has occurred
	};
	
	interface ncReceiverStatus {
		attribute ncConnectionStatus 		connectionStatus;
		attribute ncPayloadStatus			payloadStatus;
	};

$endmacro
$macro(MethodResultDatatypes) 
	//  ----------------------------------------------------------------------------------
	//	M e t h o d R e s u l t D a t a t y p e s
	//
	//	in alphabetical order by datatype name
	//  ----------------------------------------------------------------------------------

	enum ncMethodStatus {					// Method result status values 			
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
	
	interface ncMethodResult {				// Base datatype
		attribute ncMethodStatus status;
		attribute ncString errorMessage;
	};
	interface ncMethodResultBlockDescriptors : ncMethodResult {	// block descriptors result
		attribute sequence<ncBlockDescriptor> value;
	};
	interface ncMethodResultBlockMemberDescriptors : ncMethodResult {	// block member descriptors result
		attribute sequence<ncBlockMemberDescriptor> value;
	};	
	interface ncMethodResultBoolean : 				 ncMethodResult {	// single boolean result
		attribute ncBoolean value;	
	};
	interface ncMethodResultClassDescriptors : ncMethodResult {	// class descriptors result
		attribute sequence<ncClassDescriptor> value;
	};
	interface ncMethodResultClassId : 				 ncMethodResult {	// classId result
		attribute	 ncClassID value;
	};
	interface ncMethodResultClassIdentity : 		 ncMethodResult {	// classIdentity result
		attribute	 ncClassIdentity value;	
	};
	interface ncMethodResultClassVersion : 		 ncMethodResult {	// classVersion result
		attribute	 ncVersionCode value;	
	};
	interface ncMethodResultDatatype : 			 ncMethodResult {	// NTP time result
		attribute ncDatatype value;
	};
	interface ncMethodResultDatatypeDescriptors : 	 ncMethodResult {	// dataype descriptors result
		attribute sequence<ncDatatypeDescriptor> value;
	};
	interface ncMethodResultFirmwareComponent : 	 ncMethodResult {	// component descriptor result
		attribute ncfirmwareComponent value;
	};
	interface ncMethodResultId32 : 				 ncMethodResult {	// Id32 result
		attribute ncId32 value;	
	};	
	interface ncMethodResultObjectIdPath :			 ncMethodResult {	// object path result
		attribute ncObjectIDPath value;	
	};
	interface ncMethodResultObjectNamePath :		 ncMethodResult {	// object path result
		attribute ncRolePath value;	
	};
	interface ncMethodResultObjectSequence : 		 ncMethodResult {	// object-sequence result
		attribute sequence<ObjectSequenceItem> value;
	};
	interface ncMethodResultObjectSequenceItem : 	 ncMethodResult {	// object-sequence item result
		attribute sequence<ObjectSequenceItem> value;
	};
	interface ncMethodResultOID : 					 ncMethodResult {	// object ID result
		attribute ncOid value;	
	};
	interface ncMethodResultOIDs : 				 ncMethodResult {	// OIDs result
		attribute sequence<ncOid> value	
	};	
	interface ncMethodResultPorts : 				 ncMethodResult {	// ports result
		attribute sequence<ncPort> value;
	};
	interface ncMethodResultPropertyValue :		 ncMethodResult {	// property-value result
		attribute any value;
	}
	interface ncMethodResultReceiverStatus : ncMethodResult {	
		attribute ncReceiverStatus 		value;
	};
	interface ncMethodResultSessionID :			 ncMethodResult {	// session ID result
		attribute ncSessionID value;
	};
	interface ncMethodResultSignalPath : 			 ncMethodResult {	// signal path result
		attribute ncSignalPath value;
	};	
	interface ncMethodResultSignalPaths : 			 ncMethodResult {	// signal paths result
		attribute sequence<ncSignalPath> value;
	};
	interface ncMethodResultString : 				 ncMethodResult {	// single string result
		attribute ncString value;	
	};	
	interface ncMethodResultTimeInterval : 		 ncMethodResult {	// time interval result
		attribute ncTimeInterval value;	
	};
	interface ncMethodResultTimeNtp : 				 ncMethodResult {	// NTP time result
		attribute ncTimeNtp value;
	};
	interface ncMethodResultTimePtp : 				 ncMethodResult {	// PTP time result
		attribute ncTimePtp value;
	};
	interface ncMethodResultTouchpoints : 			 ncMethodResult {	// touchpoints result
		attribute sequence<ncTouchpoint> value;
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
	
	enum ncLockState {						// Concurrency lock states. 
		"noLock",								// 0 object is not locked 
		"lockNoWrite",							// 1 object may be queried but not modified 
		"lockNoReadWrite",						// 2 object may neither be queried nor modified
	};
	
	enum ncIoDirection {					// Input and/or output
		"undefined",							// 0 Flow direction is not defined
		"input",								// 1 Samples flow into owning object
		"output",								// 2 Samples flow out of owning object
		"bidirectional"							// 3 For possible future use
	};
	
	enum ncStringComparisonType {			// String comparison options
		"exact",					 			// 0 exact case-sensitive compare
		"substring",							// 1 "starts with" - case-sensitive
		"contains",								// 2 search string anywhere in target - case-sensitive
		"exactCaseInsensitive",					// 3 exact case-insensitive compare
		"substringCaseInsensitive",				// 4 "starts with" - case-insensitive
		"containsCaseInsensitive" 				// 5 search string anywhere in target - case-insensitive
	};	

	typedef ncString		 ncLabel;		// Non-programmatic label
	
	interface ncFirmwareComponent {		// Firmware component descripor
		attribute	 ncName				name;				// Concise name
		attribute	 ncVersionCode		version;			// Version code
		attribute	 ncstring			description;		// non-programmatic description 
	};
		
$endmacro

$macro(BaseClasses)
	//  ----------------------------------------------------------------------------------
	//	B a s e C l a s s e s
	//
	//	Class ncObject, base classes for major class categories, and associated datatypes
	//  ----------------------------------------------------------------------------------
	
	[control-class("1",1)] interface ncObject{

		//	Abstract base class for entire NCC class structure
	
		[element("1p1")]  static readonly attribute ncClassID 		classId;
		[element("1p2")]  static readonly attribute ncVersionCode	classVersion;
		[element("1p3")]  readonly attribute ncOid				oid;
		[element("1p4")]  readonly attribute ncBoolean			constantOid;		// TRUE iff OID is hardwired into device 
		[element("1p5")]  readonly attribute ncOid				owner;				// OID of containing block
		[element("1p6")]  readonly readonly attribute ncRole	role;				// role of obj in containing block
		[element("1p7")]  attribute	 ncString			userLabel;			// Scribble strip 		
		[element("1p8")]  readonly attribute ncBoolean	lockable;
		[element("1p9")]  attribute ncLockState		lockState;
		[element("1p10")] readonly attribute sequence<ncTouchpoint> touchpoints;
		
		// Generic GET/SET methods
	
		[element("1m1")]  ncMethodResultPropertyValue	get(ncPropertyId id);											// Get property value
		[element("1m2")]  ncMethodResult				set(ncPropertyID id, any value);								// Set property value
		[element("1m3")]  ncMethodResult				clear(ncPropertyID id);										// Sets property to initial value
		[element("1m4")]  ncMethodResultPropertyValue	getCollectionItem(ncPropertyId id, ncId32 index);					// Get collection item
		[element("1m5")]  ncMethodResult				setCollectionItem(ncPropertyId id, ncId32 index, any value);	// Set collection item
		[element("1m6")]  ncMethodResultId32			addCollectionItem(ncPropertyId id, any value);					// Add item to collection
		[element("1m7")]  ncMethodResult				removeCollectionItem(ncPropertyId id, ncId32 index);				// Delete collection item

		// Optional lock methods
		[element("1m8")]  ncMethodResult lockWait(
			 ncOid target, 												// OID of object to be (un)locked
			 ncLockStatus requestedLockStatus, 							// Type of lock requested, or unlock
			 ncTimeInterval timeout												// Method fails if wait exceeds this.  0=forever
		);

		[element("1m9")]  ncMethodResult	abortWaits(ncOid target);	// Abort all this session's waits on given target
	
		// Events
		[element("1e1")] 	[event] void PropertyChanged(ncPropertyChangedEventData eventData);
	};
	[control-class("1.2",1)] interface ncWorker : ncObject{

		// Worker base class

		[element("2p1")]  attribute ncBoolean			enabled;			// TRUE iff worker is enabled
		[element("2p2")]  attribute sequence<ncPort>	ports;				// The worker's signal ports
		[element("2p3")]  readonly attribute ncTimeInterval latency;		// Processing latency of this object (optional)
		
	};
	[control-class("1.2.1",1)] interface ncActuator : ncWorker {
	
		// Actuator base class
		
	};
	[control-class("1.2.2",1)] interface ncSensor : ncWorker {

		// Sensor base class

	};
	[control-class("1.4",1)] interface ncAgent : ncObject {
	
		// Agent base class
		
	};
$endmacro
$macro(Block)
	//  ----------------------------------------------------------------------------------
	//	B l o c k
	//
	//	Container for nc objects
	//  ----------------------------------------------------------------------------------
	
	[control-class("1.1",1)] interface ncBlock : ncObject {
		[element("2p1")]  readonly attribute	ncBoolean				enabled;			// TRUE if block is functional
		[element("2p2")]  readonly attribute	ncString				specId;				// Global ID of blockSpec that defines this block
		[element("2p3")]  readonly attribute	ncVersionCode			specVersion;		// Version code of blockSpec that defines this block
		[element("2p4")]  readonly attribute	ncString				parentSpecId;		// Global ID of parent of blockSpec that defines this block
		[element("2p5")]  readonly attribute	ncVersionCode			parentSpecVersion;	// Version code of parent of blockSpec that defines this block
		[element("2p6")]  readonly attribute	ncString				specDescription;	// Description of blockSpec that defines this block
		[element("2p7")]  readonly attribute	ncBoolean				isDynamic;			// TRUE if dynamic block
		[element("2p8")]  readonly attribute	ncBoolean				isModified;			// TRUE if block contents modified since last reset
		[element("2p9")]  readonly attribute	sequence<ncOid> 		members; 			// OIDs of this block's members 
		[element("2p10")] readonly attribute	sequence<ncPort>		ports;				// this block's ports
		[element("2p11")] readonly attribute	sequence<ncSignalPath>	signalPaths; 		// this block's signal paths
 
		// BLOCK ENUMERATION METHODS 
		
		[element("2m1")]  ncMethodResultBlockMemberDescriptors	getMemberDescriptors(ncBoolean recurse);	// gets descriptors of members of the block
		[element("2m2")]  ncMethodResultBlockDescriptors		getNestedBlocks();					// like GetMembers but returns only nested blocks
		
		// BLOCK SEARCH METHODS 
		
		[element("2m3")] 
			 ncMethodResultBlockMemberDescriptors		
			findMembersByRole(									// finds members with given role name or fragment
				 ncRole role, 									// role text to search for
				 ncStringComparisonType nameComparisonType,		// type of string comparison to use
				 ncClassId classId,								// if nonnull, finds only members with this class ID
				 ncBoolean recurse,								// TRUE to search nested blocks
			);
		[element("2m4")] 
			 ncMethodResultBlockMemberDescriptors		
			findMembersByUserLabel(								// finds members with given user label or fragment
				 ncString userLabel, 							// label text to search for
				 ncStringComparisonType nameComparisonType,		// type of string comparison to use	
				 ncClassId classId,								// if nonnull, finds only members with this class ID
				 ncBoolean recurse,								// TRUE to search nested blocks
																);
		[element("2m5")]
			 ncMethodResultBlockMemberDescriptors
			findMembersByPath(									// finds member(s) by path
				 ncRolePath path, 								// path to search for
			);
		};
$endmacro
$macro(CoreAgents)
	//  ----------------------------------------------------------------------------------
	//	C o r e A g e n t s
	//  ----------------------------------------------------------------------------------
	[control-class("1.4.1",1)] interface ncObjectSequence : ncAgent {
	
		//	Object sequence agent
	
		[element("3p1")]	sequence<ncObjectSequenceItem>		items 								// The sequence, ordered by 'index' property
	};
	
	interface ObjectSequenceItem {						// Object-sequence list item
	
	// 	Object sequence item.  
	//	Sequences are ordered by value of 'index' property.
	
		attribute ncUint16 	index;					// ordinal
		attribute ncOid		oid;					// object ID
		attribute ncRolePath	path;					// object path
	};
$endmacro


$macro(WorkflowDataCore)
	//  ----------------------------------------------------------------------------------
	//	W o r k f l o w D a t a C o r e
	//  ----------------------------------------------------------------------------------
	
	[control-class("1.6",1)] interface ncWorkflowDataRecord : ncAgent {
	
	//	Workflow data record base class
	
		[element("2p1"]	 attribute ncProductionDataRecordType	type;
		[element("2p2"]	 attribute ncProductionDataRecordID	id;
		
		// Additional properties and methods will be defined by subclasses.
	};
	
	enum ncWorkflowDataRecordType {
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

	[control-class("1.7",1)] interface Manager : ncObject {
	
		// Manager base class
    };
	
	[control-class("1.7.1",1)]  interface ncDeviceManager : ncManager {
		
		//	Device manager class
		//	Contains basic device information and status.
		
		[element("3p1")]  readonly attribute 	 ncVersionCode		 ncVersion				// Version of nc this dev uses						<Mandatory>
		[element("3p2")]  readonly attribute	 ncString		manufacturer				// Manufacturer descriptor							<Mandatory>
		[element("3p3")]  readonly attribute	 ncString			product					// Product descriptor								<Mandatory>
		[element("3p4")]  readonly attribute 	 ncString			serialNumber			// Mfr's serial number of dev						<Mandatory>
		[element("3p5")]  attribute				 ncString			userInventoryCode		// Asset tracking identifier (user specified)
		[element("3p6")]  attribute				 ncString			deviceName				// Name of this device in the application. Instance name, not product name. 
		[element("3p7")]  attribute				 ncString			deviceRole				// Role of this device in the application.
		[element("3p8")]  attribute				 ncBoolean			controlEnabled			// TRUE iff this dev is responsive to nc commands
		[element("3p9")]  readonly attribute	 ncDeviceOperationalState	operationalState	// Device operational state						<Mandatory>
		[element("3p10")] readonly attribute 	 ncResetCause		resetCause				// Reason for most recent reset						<Mandatory>
		[element("3p11")] readonly attribute 	 ncString			message					// Arbitrary message from dev to controller			<Mandatory>
	};
	
	[control-class("1.7.2",1)]  interface ncSecurityManager : ncManager {
		
		//	Security manager class
		TBD
	};
	
	[control-class("1.7.3",1)]  interface ncClassManager : ncManager {
	
		//	Class manager class
		//  Returns definitions of control classes and datatypes
		//	that are used in the device.
		
		[element("3p1")]  readonly attribute 	sequence<ncClassDescriptor>	controlClasses;
		[element("3p2")]  readonly attribute 	sequence<ncDatatypeDescriptor>	datatypes;
		
		// Methods to retrieve a single class or type descriptor
		
		[element("3m1")]  
		 ncMethodResultClassDescriptors GetControlClass(	// Get a single class descriptor
			 ncClassIdentity identity, 							// class ID & version
			 ncBoolean allElements								// TRUE to include inherited class elements
		);
			
		[element("3m2")]  
		 ncMethodResultDatatypeDescriptors GetDatatype(		// Get descriptor of datatype and maybe its component datatypes
			 ncName name, 										// name of datatype
			 ncBoolean allDefs									// TRUE to include descriptors of component datatypes
		);
		
		// Methods to retrieve all the class and type descriptors used by a given block or nest of blocks
		
		[element("3m3")]  
		 ncMethodResultClassDescriptors GetControlClasses(	// Get descriptors of classes used by block(s)
			 ncRolePath blockPath, 									// path to block 
			 ncBoolean recurseBlocks, 							// TRUE to recurse contained blocks
			 ncBoolean allElements								// TRUE to include inherited class elements
		);	
				
		[element("3m4")] 
		 ncMethodResultDatatypeDescriptors GetDataTypes(				// Get descriptors of datatypes used by blocks(s)
			 ncRolePath blockPath, 									// path to block 
			 ncBoolean recurseBlocks, 							// TRUE to recurse contained blocks
			 ncBoolean allDefs									// TRUE to include descriptors of referenced datatypes
		);
	};
	
	[control-class("1.7.4",1)]  interface ncFirmwareManager : ncManager {
		
		//	Firmware / software manager : Reports versions of components
		
		[element("3p1")]  readonly attribute	sequence<ncFirmwareComponent> 		Components;			// List of firmware component descriptors
		
		[element("3m1")]  attribute	 ncMethodResultFirmwareComponent 	GetComponent();
	};
	
	[control-class("1.7.5",1)]  interface ncSubscriptionManager : ncManager {
	
		// Subscription manager
		
		[element("3m1")]  ncMethodResult 		
			AddSubscription(
				 ncEvent event											// the event to which the controller is subscribing
		);
		[element("3m2")]
			 ncMethodResult	
			RemoveSubscription(
				 ncEvent 					event
		);
		[element("3m3")]
			 ncMethodResult		
			addPropertyChangeSubscription(
				 ncOid						emitter,					// ID of object where property is
				 ncPropertyID 				property					// ID of the property
		);
		[element("3m4")]
			 ncMethodResult
			removePropertyChangeSubscription(
				 ncOid			emitter,								// ID of object where property is
				 ncPropertyID 	property								// ID of the property
		);
	};

	[control-class("1.7.6",1)]  interface ncPowerManager : ncManager {
		[element("3p1")]  readonly attribute ncPowerState 		state;
		[element("3p2")]  readonly attribute sequence<ncOid>	powerSupplyOids;			// OIDs of available ncPowerSupply objects
		[element("3p3")]  attribute sequence<ncOid>			activePowerSupplyOids;		// OIDs of active ncPowerSupply objects
		[element("3p4")]  attribute ncBoolean					autoState;					// TRUE if current state was invoked automatically
		[element("3p5")]  readonly attribute ncPowerState		targetState					// Power state to which the device is transitioning, or None.
	
		[element("3m1")]  ncMethodResult			exchangePowerSupplies(
			 ncOid 			oldPsu,
			 ncOid 			newPsu,
			 ncBoolean		powerOffOld
		);
	};
	
	[control-class("1.7.8",1)]  interface ncDeviceTimeManager :	 ncManager {	
		//
		//	controls device's internal clock(s) and its reference.
		//
		[element("3p1")]  readonly attribute ncTimePtp			deviceTimePtp;				// Current device time
		[element("3p2")]  readonly attribute sequence<ncOid>	timeSources;				// OIDs of available ncTimeSource objects
		[element("3p3")]  attribute	 ncOid						currentDeviceTimeSource;	// OID of current ncTimeSource object
		[element("3p4")]  attribute	 ncTimeNtp					deviceTimeNtp;				// Legacy, might not be needed
	};	
$endmacro

$macro(FeatureSet001)

	// -----------------------------------------------------------------------------
	//
	// Feature set 001 - General control & monitoring
	//
	// -----------------------------------------------------------------------------
	
	[control-class("1.2.1.1",1)]  interface ncGain : ncActuator {
	
		//	Simple gain control
		
		[element("4p1")]  attribute ncDB 			setPoint;
	};
	
	[control-class("1.2.1.2",1)]  interface ncSwitch : ncWorker {
	
		// n-position switch with a name for each position
		
		[element("4p1")]  attribute ncUint16		setpoint;		// current switch position
		[element("4p2")]  attribute ncBitset		pointEnabled;	// map of which positions are enabled
		[element("4p3")]  attribute sequence<ncString> labels;		// list of position labels
	};
		
	[control-class("1.2.1.3",1)]  interface ncIdentificationActuator {
	
		// Identification actuator - sets some kind of physical indicator on the device
		
		[element("4p1")]  attribute ncBoolean		active;			// TRUE iff indicator is active
	};
		
	[control-class("1.2.2.1",1)]  interface ncLevelSensor {
		
		// Simple level sensor that reads in DB
		
		[element("4p1")]	 ncDB					reading;
	};
	
	[control-class("1.2.1.2",1)]  interface ncStateSensor {
	
		// State sensor - returns an index into an array of state names.
		
		[element("4p1")]  attribute ncUint16 			reading;
		[element("4p2")]  attribute sequence(ncString)	stateNames;
	};
	
	[control-class("1.2.2.3",1)]  interface ncIdentificationSensor {
		
		// 	Identification sensor - raises an event when the user activates some kind of
		//	this-is-me control on the device.
		
		[element("4e1")] [event] void Identify(ncEventData);
	};

$endmacro

$macro(FeatureSet002)

	// -----------------------------------------------------------------------------
	//
	// Feature set 002 - NMOS receiver Monitoring
	//
	// Related datatypes are in package 'AgentDatatypes'
	//
	// -----------------------------------------------------------------------------
	
	[control-class("1.4.1",1)] interface ncReceiverMonitor : ncAgent {
	
		// Receiver monitoring agent.
		// For attaching to specific receivers, uses the Touchpoint mechanism inherited from ncObject.
		
		[element("3p1")]  readonly attribute ncConnectionStatus	connectionStatus
		[element("3p2")]  readonly attribute ncString				connectionStatusMessage;		// Arbitrary text message
		[element("3p3")]  readonly attribute ncPayloadStatus		payloadStatus;
		[element("3p4")]  readonly attribute ncString				payloadStatusMessage;			// Arbitrary text message
	
		[element("3m1")]  ncMethodResultReceiverStatus				GetStatus();					// connection status + payload status in one call
		
		//	NOTIFICATIONS:
		//
		// 	This class inherits the property-changed event from ncObject.
		//	That event is the primary means by which controllers will learn
		//	of receiver status changes.  The Get(...) methods listed above
		//	should not be used for polling receiver status. Instead, controllers
		//	should subscribe to the appropriate property-changed event(s).
	};

	[control-class("1.4.1.1",1)] interface ncReceiverMonitorProtected : ncReceiverMonitor {
	
		// Derived receiver monitoring agent class for SMPTE ST 2022-7-type receivers.
		
		[element("4p1")]  readonly attribute ncBoolean				signalProtectionStatus;
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
	
		[control-class("1.3",1)] interface ncMatrix {
			TBD
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
