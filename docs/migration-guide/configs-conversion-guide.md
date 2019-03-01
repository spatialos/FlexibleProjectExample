# Converting project configuration files
This page explains how to convert the various configuration files of the [structured project layout (SPL)](https://docs.improbable.io/reference/latest/shared/reference/project-structure) to equivalent configuration files in the flexible project layout (FPL).

**Note:** This guide only addresses parts of the process of migrating an existing SpatialOS project from the SPL to the FPL. Please refer to our [Migration guide](migration-guide-master-page.md) for a summary of all migration steps.

## Converting the worker configuration file
[Reference documentation for the SPL format](https://docs.improbable.io/reference/latest/shared/worker-configuration/worker-configuration)<br/>
[Reference documentation for the FPL format (client-workers)](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/client-worker-configuration.md)<br/>
[Reference documentation for the FPL format (server-workers)](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/server-worker-configuration.md)

**Note:** In the FPL, we use different types of worker configuration files to describe [client-workers](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/client-worker-configuration.md) and [server-workers](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/server-worker-configuration.md). This is different from the SPL where you described all workers using a shared [worker configuration](https://docs.improbable.io/reference/latest/shared/worker-configuration/worker-configuration) format. Before you convert a worker configuration file from SPL to FPL, you need to decide whether your worker is a client-worker or a server-worker.

Below is a summary of how to populate the fields of an FPL worker configuration file based on the state of your existing SPL project:

| FPL format | SPL format |
| --- | --- |
| `workerType` | Part of the name of your worker configuration file, i.e. `spatialos.<my-worker-type>.worker.json` |
| `layer` | In your worker configuration file, the `bridge.worker_attribute_set.attributes` field |
| `entityInterest` | `bridge.entity_interest` field in your worker configuration file |
| `streamingQuery` | `bridge.streaming_query` field in your worker configuration file |
| `componentDelivery` | `bridge.component_delivery` field in your worker configuration file |
| `componentSettings` | `bridge.component_settings` field in your worker configuration file |
| `permissions` | Similar to the `workers.<my-worker-type>.permissions` field in your [launch configuration file](https://docs.improbable.io/reference/latest/shared/reference/file-formats/launch-config#launch-configuration-file), with the difference that the permissions property here is a single [permission object](https://docs.improbable.io/reference/latest/shared/worker-configuration/permissions#worker-permissions) rather than an array |
| `uploadConfiguration.<platform>.localBuildDirectory` (client-worker only) | No equivalent - refer to [the documentation](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/client-worker-configuration.md) for information on how to populate this field |
| `launchConfiguration.<platform>.localBuildDirectory` (server-worker only) | No equivalent - refer to [the documentation](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/client-worker-configuration.md) for information on how to populate this field |
| `launchConfiguration.<localDeployment, cloudDeployment>.<platform>.<command, arguments>` (server-worker only) | `managed.<platform>.<command, arguments>` field in your worker configuration file |

**Notes:**
- The `build` field in the SPL worker configuration file is obsolete and does not have an equivalent in the FPL. In the FPL, you fully manage the build process of a worker. For more information, see [Building a worker executable in the FPL](../build-process/worker-build-process.md).
- The `external` field in the SPL worker configuration file is obsolete and does not have an equivalent in the FPL. In the FPL, you need to start a worker manually instead of using `spatial local worker launch`.

## Converting the launch configuration file
[Reference documentation for the SPL format](https://docs.improbable.io/reference/latest/shared/reference/file-formats/launch-config#launch-configuration-file)<br/>
[Reference documentation for the FPL format](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/launch-configuration.md)

**Note:** If you want to use the [Platform SDK](https://docs.improbable.io/reference/latest/platform-sdk/introduction), you should **not** convert your launch configuration file into FPL format. The Platform SDK currently only works with SPL format launch configuration files.

Below is a summary of how to populate the fields of an FPL launch configuration file based on the state of your existing SPL project:

| FPL format | SPL format |
| --- | --- |
| `template` | `template` field in your launch configuration file |
| `dimensionsInWorldUnits.<x, z>` | `world.dimensions.<xMeters, zMeters>` field in your launch configuration file |
| `loadBalancing` | `load_balancing` field in your launch configuration file |
| `snapshot` | No equivalent - refer to [the documentation](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/deployment-launch-configuration.md) for information on how to populate this field |
| `takeSnapshotIntervalSeconds` | `world.snapshots.snapshot_write_period_seconds` field in your launch configuration file |
| `startDeploymentFromSnapshotFile`| No equivalent - refer to [the documentation](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/deployment-launch-configuration.md) for information on how to populate this field |
| `workerFlags.<elem>.<workerType, flags>` | `workers.<elem>.<worker_type, flags>` field in your launch configuration file |
| `streamingQueryInterval` | `world.streaming_query_interval` field in your launch configuration file |
| `runtimeFlags` | `world.legacy_flag` field in your launch configuration file |

**Notes:**
- The `world.legacy_javaparams` field in the SPL launch configuration file is obsolete and does not have an equivalent in the FPL.
- The `world.chunk_edge_length_meters` field in SPL launch configuration file is obsolete and does not have an equivalent in the FPL. In the FPL, this parameter has a fixed value of 100. You might need to adapt the [entity interest](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#entity-interest) configuration of your workers to account for the change in this value when you migrate a project from the SPL to the FPL.

## Converting the project definition file
[Reference documentation for the SPL format](https://docs.improbable.io/reference/latest/shared/reference/file-formats/spatialos-json#project-definition-file-spatialos-json)<br/>
[Reference documentation for the FPL format](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/project-configuration.md)

**Note:** The project definition file is called “project configuration file” in the FPL.

Below is a summary of how to populate the fields of an FPL project configuration file based on the state of your existing SPL project:

| FPL format | SPL format |
| --- | --- |
| `configurationVersion` | No equivalent - refer to [the documentation](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/project-configuration.md) for information on how to populate this field |
| `projectName` | `name` field in your project definition file |
| `schemaDescriptor` | No equivalent - refer to [the documentation](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/project-configuration.md) for information on how to populate this field |
| `clientWorkers` | No equivalent - refer to [the documentation](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/project-configuration.md) for information on how to populate this field |
| `serverWorkers` | No equivalent - refer to [the documentation](https://github.com/spatialos/FlexibleProjectExample/blob/master/docs/reference/project-configuration.md) for information on how to populate this field |

**Notes:**
- The `project_version` field in the SPL project definition file is obsolete and does not have an equivalent in the FPL. Please keep track of your project/built versions separately.
- The `sdk_version` field in the SPL project definition file is obsolete and does not have an equivalent in the FPL. There is no clearly defined SDK version for an FPL project anymore. For more information, please see [Choose an SDK version](../build-process/worker-build-process.md#choose-an-sdk-version).
- The `dependencies` field in the SPL project definition file is obsolete and does not have an equivalent in the FPL. You need to manage your dependencies manually as part of your build process. For more information, please see [Download the relevant worker SDK libraries](../build-process/worker-build-process.md#download-the-relevant-worker-sdk-libraries).
