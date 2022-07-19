# IDL Coding conventions

## Contents of this section

- [IDL Coding conventions](#idl-coding-conventions)
  - [Contents of this section](#contents-of-this-section)
  - [Language](#language)
  - [File structure](#file-structure)
  - [Framework source](#framework-source)
    - [**Modules**](#modules)
      - [**Module nesting**](#module-nesting)
      - [**Module order**](#module-order)
    - [**Framework root module**](#framework-root-module)
  - [Final framework](#final-framework)
  - [Framework coding elements](#framework-coding-elements)
    - [**Interfaces**](#interfaces)
    - [**Inheritance**](#inheritance)
    - [**Extended attributes**](#extended-attributes)
      - [**The `[control-class(...)]` extended attribute**](#the-control-class-extended-attribute)
      - [**The `[element(...)]` extended attribute**](#the-element-extended-attribute)
      - [**The `[event]` extended attribute**](#the-event-extended-attribute)
      - [**The `[primitive]` extended attribute**](#the-primitive-extended-attribute)
    - [**Typedefs**](#typedefs)
    - [**Primitives**](#primitives)
    - [**Comments**](#comments)
      - [**Web IDL comments***](#web-idl-comments)
      - [**Macro comments**](#macro-comments)
    - [**Blank lines**](#blank-lines)
  - [Control class definitions](#control-class-definitions)
  - [Datatype definitions](#datatype-definitions)
  - [Naming and capitalization](#naming-and-capitalization)
  - [Miscellaneous conventions](#miscellaneous-conventions)

## Language

NC-Framework is coded in **Web IDL**, with a little help from the **pyexpander** macro processor.

The specification consists of a number of parts. Each part is called a *specification module* or, in context, just *module*.  Each module is a pyexpander macro. The body of each macro is Web IDL text.

The official specification of Web IDL is [**here**](https://WebIDL.spec.whatwg.org). The home site of pyexpander is [**here**](https://pyexpander.sourceforge.io).

## File structure

At present, the entire Framework is contained in a single file, but future development work may divide it into a set of smaller files. This file, or the set of them, is called the **framework source**. The current file is [here](../idl/NC-Framework.webidl).

The **final framework** is a single, pure Web IDL file with no pyexpander artifacts that contains the entire framework definition. It is generated by running pyexpander against the framework source.

The framework source is the primary object of discussion, development, education, and standardization going forward. Final framework files will be generated by users from time to time, as needed for code and documentation generation, and by framework authors for specification validation and other purposes.

## Framework source

### **Modules**

A framework source file contains one or more modules. Each module is a pyexpander macro containing Web IDL code, like this:

```bash
$macro(Foo)
... Web IDL statements ...
$endmacro
```

... where `module-name` is a c-style identifier. `module-name` not enclosed in string delimiters.

A module macro is invoked by prefixing its name with `$`, e.g.

```bash
$Foo
```

#### **Module nesting**

A module can be nested inside another module by invoking its macro in the containing module. For example, a module `bar` would be nested inside a module `foo` as follows:

```bash
$macro(Bar)
    ... webDL statements ...
$endmacro
...
$macro(Foo)
    ... Web IDL statements ...
    $Bar
    ... Web IDL statements ...
$endmacro
```

#### **Module order**

Pyexpander allows forward referencing of macro names, so there are no constraints on the order of module definitions in the source.  The order is chosen for easiest readability.

### **Framework root module**

The ***Framework root module*** is a module that links all the framework source modules together to make a unified whole. It invokes all the separate module macros in all the framework source files.

Here is a snippet from the current framework root:

```bash
    $HeaderComments()
    $CoreDatatypes()
    $BlockDatatypes()
    $BaseClasses()
    $Block()
    $CoreAgents()
    $Managers()
    ...
```

There is exactly one Framework root module for the entire framework.

## Final framework

A final framework file can be generated by running pyexpander on the concatenation of all the framework source files, one of which must include the Framework root module. The order of files in the concatenation is insignificant.

At present, there is only one framework source file. It contains all the module definitions, and includes the source root. Multiple source files may come to exist in the future, as NCA's control repertoire evolves.

## Framework coding elements

### **Interfaces**

The core construct of the Framework is the Web IDL **interface** definition. Interface definitions are used to define both Framework control classes and Framework datatypes.

Here's a basic Web IDL interface definition:

```typescript
    interface RGB {
        attribute unrestrictedfloat R;
        attribute unrestrictedfloat G;
        attribute unrestrictedfloat B;
    };
```

This defines an interface datatype named `RGB` with three attributes (aka properties) `R`, `G`, and `B`, each of which is a floating-point number.

More complex interface definitions include definitions of methods. The Framework's use of these is described in [Control Class Definitions](#control-class-definitions) below.

### **Inheritance**

Inheritance is expressed this way:

```typescript
    interface y : x {
        ...
    }
```

This defines an interface **y** that is a subclass of interface **x**.

### **Extended attributes**

**Extended attributes** are extensions to basic Web IDL. An extended attribute is a *prefix* option on a Web IDL statement:

```typescript
    [extended-attribute] <Web IDL statement>
```

Extended attribute syntax rules are defined by the Web IDL specification. The Web IDL specification itself defines a few extended attributes, but the main purpose of extended attributes is to allow applications to add custom Web IDL extensions of their own.

NCA defines several important extended attributes, as described next.

#### **The `[control-class(...)]` extended attribute**

Every NCA control class definition is prefixed by the `[control-class(...)]` extended attribute. Syntax is:

```bash
    control-class(classID, classVersion, staticRole)
```

where:

- **classID** is an NCA class ID expressed as a string of the form `i(1),i(2),...,i(N)`
- **classVersion** is a semantic version code expressed as a string of the form `v(1).v(2).v(3)`
- **staticRole** is the static role all instances of this class must use. This is currently only the case for managers so it may be omitted for other control classes.

For example:

NcGain

```bash
    [control-class("1.2.1.1.1", "1.0.0")]
```

NcDeviceManager

```bash
    [control-class("1.3.1", "1.0.0", "DeviceManager")]
```

#### **The `[element(...)]` extended attribute**

Every property, method, or event declaration of every control class is prefixed by the `[element(.,..)]` attribute. Syntax is:

```typescript
    [element(elementID)]
```

where **element*id** is a delimited string of the form `nTm`, where
    - `n` is the definition level of the class in the class tree.
    - 'm' is the ordinal of the definition within the class.

For example, here is the element definition for the `setPoint` property of `NcGain`:

```typescript
    [element("5p1")] attribute NcDB setPoint;
```

#### **The `[event]` extended attribute**

The `[event]` extended attribute is added to identify a class method definition as an event. For example, here is the definition of the `PropertyChanged` event in the root class `NcObject`:

```typescript
    [element("1e1")] [event] void PropertyChanged(NcPropertyChangedEventData eventData)
```

#### **The `[primitive]` extended attribute**

The `[primitive]` extended attribute is added to a `typedef` statement that defines an NCA primitive type. See [Typedefs](#typedefs) and [Primitives](#primitives) for details.

### **Typedefs**

Web IDL supports aliasing of types using the familiar **typedef** construct. For example, here is the definition of a datatype `NcDB` that expresses a value in decibels as a Web IDL built-in datatype `unrestrictedfloat`:

```typescript
    typedef unrestrictedfloat  ncDB      // Floating-point decibels
```

By convention, typedefs in NCA may only be one level of indirection away from built-in types. For example, this typedef, while legal in Web IDL, would not be allowed in NCA:

```typescript
    typedef ncDB ncMyDB                 // A custom kind of DB
```

...because it is two levels of indirection away from the built-in type ```unrestrictedfloat``.

### **Primitives**

NCA defines its own set of primitive datatypes as aliases of built-in Web IDL datatypes. Their definitions are in the specification module `PrimitiveDatatypes`. The complete list is as follows:

```typescript
    [primitive] typedef boolean             NcBoolean;
    [primitive] typedef byte                NcInt8;
    [primitive] typedef short               NcInt16;
    [primitive] typedef long                NcInt32;
    [primitive] typedef longlong            NcInt64;
    [primitive] typedef octet               NcUint8;
    [primitive] typedef unsignedshort       NcUint16;
    [primitive] typedef unsignedlong        NcUint32;
    [primitive] typedef unsignedlonglong    NcUint64;
    [primitive] typedef unrestrictedfloat   NcFloat32;
    [primitive] typedef unrestricteddouble  NcFloat64;
    [primitive] typedef bytestring          NcString;   // UTF-8
    [primitive] typedef any                 NcBlob;
    [primitive] typedef any                 NcBlobFixedLen;
```

Note the presence of the `[primitive]` extended attribute.

Except for these primitive definitions, Framework code always uses the NCA datatypes, not the built-in datatypes.

### **Comments**

#### **Web IDL comments***

Web IDL supports c-style single-line comments:

```typescript
<WebIDL-code-line> // <comment-text> <end-of-line>
```

and c-style multiline comments:

```typescript
/*  <comment-text>
    <comment-text>
    ...
*/
```

pyexpander treats all such comments as normal source code text, so they're simply copied into the output file.

#### **Macro comments**

Any line beginning with **$#** is treated as a macro comment by pyexpander. Such lines are **not** copied into the output file.

### **Blank lines**

Pyexpander faithfully copies blank lines to its output file. This behavior causes the output file to have a number of spurious blank lines. A Windows vbScript utility is available to delete these lines. It's in the file **\<where\>**.

## Control class definitions

NCA Control classes are defined as Web IDL interfaces with properties, methods, and events. The extended attributes described above add NCA-specific metadata.

Here is a complete example, ***excerpted*** from the definition of the NCA base class **NcObject**:

```typescript
    [control-class("1", "1.0.0")] interface NcObjectExcerpt {

        //  Excerpted from definition of NcObject

        [element("1p1")]  static readonly attribute NcClassId       classId;
        [element("1p2")]  static readonly attribute NcVersionCode   classVersion;
        [element("1p3")]         readonly attribute NcOid           oid;
        
        // Generic Get/Set methods used by this class and all subclasses

        [element("1m1")]  NcMethodResultPropertyValue Get(NcPropertyId id);
        [element("1m2")]  NcMethodResult Set(NcPropertyId id, any value);

        // Event
        [element("1e1")] [event] void PropertyChanged(NcPropertyChangedEventData eventData);
    };
};
```

Because **NcObject** is the base class, all other control classes MUST be directly or indirectly derived from it.

## Datatype definitions

Simple NCA datatypes are defined as typedefs. Complex datatypes (i.e. structures) are defined as Web IDL interfaces with properties only - no methods or events. No NCA-specific metadata is required. The RGB interface definition given above is a valid complex datatype definition. Here it is again, except with NCA primitive datatypes instead of built-in Web IDL datatypes used for the properties - this is correct NCA style:

```typescript
    interface RGB {
        attribute NcFloat32 R;
        attribute NcFloat32 G;
        attribute NcFloat32 B;
    };
```

## Naming and capitalization

1. Standard NCA class and datatype names MUST begin with **`Nc`**.
1. Capitalization:
    1. Class and datatype names MUST be in **`CamelCase`**.
    1. Property names MUST be in **`dromedaryCase`**.
    1. Method and event names MUST be in **`CamelCase`**.
    1. Module macro names MUST be in **`CamelCase`**.

## Miscellaneous conventions

1. The standard Web IDL keyword **readonly** MUST be used to identify a readonly property.

1. The standard Web IDL keyword **static** MUST be used to identify a property whose value is the same for every instance of an interface.

1. In an attribute definition, the standard Web IDL practice of appending a question-mark "**?**" to the datatype name MUST be used to specify that the attribute is optional.

1. All methods MUST return a value of datatype `NcMethodResult` or a child of `NcMethodResult`.

1. All events MUST return no value, and have a single parameter that specifies the payload of the notification message emitted when the event is triggered.