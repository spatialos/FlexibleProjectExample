## Configuring a server worker (`hello_worker.json`)

This configuration file tells SpatialOS how to start a server worker and how it should interact with the world. It includes configuration for the type of the worker, and for entities the worker should receive updates for.

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
| `launchConfiguration` | Required | Describes how to launch the worker both locally and in the cloud. It contains two fields: <br><br> - `localDeployment`, which specifies how to start the worker from a pre-built binary file on your local machine. <br><br>  - `cloudDeployment`, which specifies how to start the worker from the uploaded deployment assembly. |


#### Local deployment configuration

There must be a configuration for each platform the worker will be run on.

This is an example excerpt of a `localDeployment` section from the main config file:
```json
      "windows": {
        "localBuildDirectory": "bin/x64/ReleaseWindows",
        "command": "...",
        "arguments": [
          "..."
        ]
      },
      "macos": {
        "localBuildDirectory": "bin/x64/ReleaseMacOS",
        "command": "...",
        "arguments": [
          "..."
        ]
      },
      "linux": {
        "localBuildDirectory": "bin/x64/ReleaseLinux",
        "command": "...",
        "arguments": [
          "..."
        ]
      }
```

The platform name can be one of `windows`, `macos` or `linux`. Each of these can have the following fields:

| Field | Required/Optional | Description | 
| :------------- | :------------- | :------- |
| `localBuildDirectory` | Required | The directory containing the binary to be executed. <br><br> **Note:** Your built-out worker must be self-contained in the `localBuildDirectory` and all files that your worker might depend on while running must be in this folder. Files outside this folder will not be uploaded to the cloud as part of your project assembly. |
| `command` | Required | The base command to be executed to start the worker. |
| `arguments` | Required | A list of arguments to provide to the base command. The arguments can contain placeholder strings, like `{IMPROBABLE_RECEPTIONIST_HOST}`, which are interpolated by SpatialOS when the worker is launched. For a full list of supported placeholder strings, see our documentation on [worker launch configurations](https://docs.improbable.io/reference/latest/shared/worker-configuration/launch-configuration). |

#### Cloud deployment configuration
The cloud deployment configuration specifies how to launch the worker in the cloud. It's the same as the local deployment configuration at the moment, with the following exceptions:
- A zip file containing the directory specified in `localBuildDirectory` will be uploaded to the cloud.
- We'll add additional fields in the future, allowing you to specify where the worker binaries are uploaded.

Note: It rarely makes sense to specify a cloud deployment configuration for any platform other than `linux`, since workers are run in an Linux environment in the cloud.
