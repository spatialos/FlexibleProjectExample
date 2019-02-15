## Configuring a server-worker (`hello_worker.json`)

This file specifies the configuration parameters of a server-worker.

### Configuration file

The file may be called by any name but should have the following structure:
```json
{
  "workerType": "HelloWorker",
  "layer": "greetings",
  "entityInterest": {
    "rangeEntityInterest": {
      "radius": 2
    }
  },
  "streamingQuery": [
    ...
  ],
  "componentDelivery": {
    "default": "RELIABLE_ORDERED",
    "checkoutAllInitially": true
  },
  "componentSettings": {
    ...
  },
  "permissions": {
    ...
  },
  "launchConfiguration": {
    "localDeployment": {
      ...
    },
    "cloudDeployment": {
      ...
    }
  }
}
```

| Field | Required/Optional | Description | 
| :------------- | :------------- | :------- |
| `workerType` | Required | Used to identify this worker type elsewhere in your project. <br><br> **Note:** A `workerType` must be unique project-wide. The `workerType` specified in this field must also match the `workerType` that your worker instance reports in its `ConnectionParameters` when connecting to a deployment. For more information, see the [API reference](https://docs.improbable.io/reference/latest/csharpsdk/api-reference#improbable-worker-connectionparameters-class). |
|`layer`| Optional | The name of the simulation layer of this worker type, used to determine the load balancing strategy. For more information, see [the layers documentation](https://docs.improbable.io/reference/latest/shared/worker-configuration/layers). |
| `entityInterest` | Optional | Specifies the entities to subscribe to in addition to the ones the worker is authoritative over. The semantics are analogous to the [`entity_interest` field in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#entity-interest). |
| `streamingQuery` | Optional | Specifies the streaming queries the bridge will subscribe to. Analogous to [`streaming_query` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#streaming-queries). |
| `componentDelivery` | Optional | Specifies the delivery settings for the worker's components. Analogous to [`component_delivery` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#component-delivery). |
| `componentSettings` | Optional | Defines component specific settings. Analogous to [`component_settings` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#component-settings). |
| `permissions` | Optional | Specifies the worker's entity permissions. Analogous to [`permissions` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/permissions), with a difference that the permissions property here is a single permission object rather than an array. |
| `launchConfiguration` | Required | Describes how to start a worker instance. It contains two fields: <br> - `localDeployment`: Specifies how to start a worker instance locally. See below for more information. <br> - `cloudDeployment`: Specifies how to start a worker instance in the cloud. See below for more information. |

#### Local deployment configuration

The local deployment configuration specifies how to launch a server-worker instance locally. Below is an example excerpt:
```json
      "windows": {
        "localBuildDirectory": "bin/x64/ReleaseWindows",
        "command": "MyWorker.exe",
        "arguments": [
          "${IMPROBABLE_RECEPTIONIST_HOST}",
          "${IMPROBABLE_RECEPTIONIST_PORT}",
          "${IMPROBABLE_WORKER_ID}",
          "--my_additional_flag=true"
        ]
      },
      "macos": {
        "localBuildDirectory": "bin/x64/ReleaseMacOS",
        "command": "MyWorker.app",
        "arguments": [
          "${IMPROBABLE_RECEPTIONIST_HOST}",
          "${IMPROBABLE_RECEPTIONIST_PORT}",
          "${IMPROBABLE_WORKER_ID}",
          "--my_additional_flag=true"
        ]
      },
      "linux": {
        "localBuildDirectory": "bin/x64/ReleaseLinux",
        "command": "MyWorker",
        "arguments": [
          "${IMPROBABLE_RECEPTIONIST_HOST}",
          "${IMPROBABLE_RECEPTIONIST_PORT}",
          "${IMPROBABLE_WORKER_ID}",
          "--my_additional_flag=true"
        ]
      }
```

There must be a configuration for each platform the worker will be run on. The platform name can be one of `windows`, `macos` or `linux`. Each of these can have the following fields:

| Field | Required/Optional | Description | 
| :------------- | :------------- | :------- |
| `localBuildDirectory` | Required | The directory containing the binary to be executed. <br><br> **Note:** Your built-out worker must be self-contained in the `localBuildDirectory` and all files that your worker might depend on while running must be in this folder. Files outside this folder will not be uploaded to the cloud as part of your project assembly. |
| `command` | Required | The base command to be executed to start a worker instance. |
| `arguments` | Required | A list of arguments to provide to the base command. The arguments can contain placeholder strings, like `{IMPROBABLE_RECEPTIONIST_HOST}`, which are interpolated by SpatialOS when the worker is launched. For a full list of supported placeholder strings, see our documentation on [worker launch configurations](https://docs.improbable.io/reference/latest/shared/worker-configuration/launch-configuration). |

#### Cloud deployment configuration
The cloud deployment configuration specifies how to launch a server-worker instance in the cloud. It's the same as the local deployment configuration at the moment, with the following exceptions:
- A zip file containing the directory specified in `localBuildDirectory` will be uploaded to the cloud.
- We'll add additional fields in the future, allowing you to specify where the worker binaries are uploaded.

Note: We only support the `linux` platform for cloud deployment configurations because worker instances are always run in an Linux environment in the cloud.
