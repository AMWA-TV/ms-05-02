# AMWA MS-05-02 NMOS Control Framework

The NMOS Control framework is a collection of class and datatype models and supporting documentation.
It serves as the foundation for building devices, components and control and monitoring features in a standard and reusable fashion.

This specification relies on previous familiarity with the following related specifications:

- [MS-05-01 NMOS Control Architecture](https://specs.amwa.tv/ms-05-01)
- [IS-12 NMOS Control Protocol](https://specs.amwa.tv/is-12)

The aggregated collection of control class and datatype models is published in the [Framework](Framework.md) with specific functionality published separately as [Feature sets](Feature%20sets.md).

Models of both classes and datatypes published either in the [Framework](Framework.md) or in one of the [Feature sets](Feature%20sets.md) are __standard__ models and MUST have their names prefixed with `Nc`.

Device models can contain [non-standard](Framework.md#ncclassid) classes by deriving standard classes. The main use case is to allow vendors to model vendor specific functionality in their device implementations. Non-standard models MUST NOT have their names prefixed with `Nc`.
