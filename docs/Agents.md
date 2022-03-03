# Agents

Agents are special classes which handle control or monitoring features for a particular specific device domain. All agents must inherit from `ncAgent`.

| **Name**                   | **Description**                                                                                                               |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------|
| ncObjectSequence           | Agent handling object sequences ordered by index                                                                              |
| ncWorkflowDataRecord       | Agent handling production workflow information associated with the contents and context of media signals                      |
| ncReceiverMonitor          | Agent attached to a stream receiver in order to convey status information (more details in [Feature sets](Feature%20sets.md)) |
| ncReceiverMonitorProtected | Derived receiver monitoring agent for SMPTE ST 2022-7-type receivers                                                          |
