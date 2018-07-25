## Configuring a server worker (`hello_worker.json`)

This configuration file tells SpatialOS how to start a server worker and how it should interact with the world. It includes configuration for the type of the worker, and for entities the worker should receive updates for.

### Configuration file

The file may be called by any name but should have the following structure:
```json
{
  "workerType": "HelloWorker",
  "attributeSet": {
    "attributes": [
      "greetings"
    ]
  },
  "entity_interest": {
    "range_entity_interest": {
      "radius": 2
    }
  },
  "componentDelivery": {
    "default": "RELIABLE_ORDERED",
    "checkout_all_initially": true
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
| `workerType` | Required | Used to identify this worker type elsewhere in your project. |
| `attributeSet` | Optional | Describes the worker's capabilities. The attribute set has analogous semantics to the [previous version's `worker_attribute_set`](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#worker-attribute-sets). |
| `entityInterest` | Optional | Specifies the entities to subscribe to in addition to the ones the worker is authoritative over. The semantics are analogous to the [`entity_interest` field in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#entity-interest). |
| `streamingQuery` | Optional | Specifies the streaming queries the bridge will subscribe to. Analogous to [`streaming_query` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#streaming-queries). |
| `componentDelivery` | Optional | Specifies the delivery settings for the worker's components. Analogous to [`component_delivery` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#component-delivery). |
| `componentSettings` | Optional | Defines component specific settings. Analogous to [`component_settings` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#component-settings). |
| `permissions` | Optional | Specifies the worker's entity permissions. Analogous to [`permissions` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/permissions), with a difference that the permissions property here is a single permission object rather than an array. |
| `launchConfiguration` | Required | Describes how the worker can be launched both locally and in the cloud. It contains two fields: <br> <br> - `localDeployment`, which specifies how to start the worker from a pre-built binary file on the local machine. <br> <br>  - `cloudDeployment`, which specifies how to start the worker from the deployment assembly that has been uploaded.


#### Local deployment configuration

There must be a configuration for each platform the worker will be run on.

This is an example excerpt of a `localDeployment` section from the main config file:
```json
      "macos": {
        "localBuildDirectory": "bin/x64/ReleaseMacOS",
        "command": ...,
        "arguments": [
          ...
        ]
      },
      "linux": {
        "localBuildDirectory": "bin/x64/ReleaseLinux",
        "command": ...,
        "arguments": [
          ...
        ]
      },
      "windows": {
        "localBuildDirectory": "bin/x64/ReleaseWindows",
        "command": ...,
        "arguments": [
          ...
        ]
      }
```

The platform name can be one of `macos`, `linux` or `windows`. Each of these can have the following fields:

| Field | Required/Optional | Description | 
| :------------- | :------------- | :------- |
| `localBuildDirectory` | Required | The directory containing the binary to be executed. |
| `command` | Required | The base command to be executed to start the worker. |
| `arguments` | Required | A list of arguments to provide to the base command. The arguments can contain the same placeholder strings as specified in the previous version of configuration, which are interpolated by SpatialOS before the worker is launched. See the [worker launch configuration](https://docs.improbable.io/reference/latest/shared/worker-configuration/launch-configuration) documentation for more information. |

#### Cloud deployment configuration
The cloud deployment configuration specifies how to launch the worker in the cloud. It's the same as the local deployment configuration at the moment but will include additional fields in the future, allowing you to specify where the worker binaries are uploaded.