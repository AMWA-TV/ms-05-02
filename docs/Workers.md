# Workers

Workers are special classes which handle control or monitoring features for a particular specific device domain. All workers must inherit from `NcWorker`.

Signal workers are special workers which have ports and affect the signal paths within the device.

| **Name**                   | **Type**                                  | **Description**                                                                                           |
| -------------------------- | ------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| NcIdentBeacon              | NcWorker                                  | Worker used to identify a device by toggling the beacon active state                                      |
| NcReceiverMonitor          | NcWorker                                  | Worker attached to a stream receiver in order to convey status information                                |
| NcReceiverMonitorProtected | NcWorker                                  | Derived receiver monitor for SMPTE ST 2022-7-type receivers                                               |
| NcWorkflowDataRecord       | NcWorker                                  | Worker handling production workflow information associated with the contents and context of media signals |
| NcGain                     | NcActuator (derived from NcSignalWorker)  | Signal worker handling gain control                                                                       |
| NcSwitch                   | NcActuator (derived from NcSignalWorker)  | Signal worker handling n-position switch functionality                                                    |
| NcLevelSensor              | NcSensor (derived from NcSignalWorker)    | Signal worker measuring db level                                                                          |
