# Feature sets

Feature sets are classes which express models required for a specific functionality.
Devices implementing functionality described as a feature set MUST make use of these classes and models.

## NcReceiverMonitor

The `NcReceiverMonitor` worker is described as a feature set. Is is required for expressing connection and payload statuses for an attached stream receiver.
The attached stream receiver is described using the touchpoints mechanism detailed in the [NcObject](NcObject.md#touchpoints) section.

The `NcReceiverMonitor` class contains the following properties:

| **Property Name**       | **Datatype**                   | **Readonly** | **Description**                                                       |
| ----------------------- | ------------------------------ | ------------ | ----------------------------------------------------------------------|
| connectionStatus        | NcConnectionStatus             | Yes          | Connection status (see type below)                                    |
| connectionStatusMessage | NcString                       | Yes          | Connection status further text information                            |
| payloadStatus           | NcPayloadStatus                | Yes          | Payload status (see type below)                                       |
| payloadStatusMessage    | NcString                       | Yes          | Payload status further text information                               |

Where the required types are defines as:

```typescript
enum NcConnectionStatus { // Connection status
    "Undefined", // 0 This is the value when there is no receiver
    "Connected", // 1 Connected to a stream
    "Disconnected", // 2 Not connected to a stream
    "ConnectionError" // 3 Connected but broken
};

interface NcPayloadStatus { // Received payload status
    "Undefined", // 0 This is the value when there's no connection.
    "PayloadOK", // 1 Payload type is one we know about and the PDU is well-formed
    "PayloadFormatUnsupported", // 2 Payload is not one we know about
    "PayloadError", // 3 Some kind of error has occurred
};
```

Receiver monitors MUST maintain their 1 to 1 relationship between their role and the touchpoint receiver entity they monitor.

A derived receiver monitor for SMPT ST 2022-7 type receivers also exists as `NcReceiverMonitorProtected`.

This adds a further `NcBoolean` status `signalProtectionStatus` to indicate if the signal protection is enabled.
