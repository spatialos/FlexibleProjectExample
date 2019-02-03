## Configuring a client worker (`client_worker.json`)

This configuration file tells SpatialOS how a client worker should interact with the world. It includes configuration for the worker type, and how SpatialOS should decide which entities and entity information are sent to the worker.

### Configuration file

The file may be called by any name but should have the following structure:
```json
{
  "workerType": "InteractiveClient",
  "layer": "client",  
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
  "uploadConfiguration": {
    "windows": {
      "localBuildDirectory": "C:\project\bin\windows"
    },
    "macos": {
      ...
    },
    "linux": {
      ...
    }
  }
}
```

| Field | Required/Optional | Description | 
| :------------- | :------------- | :------- |
| `workerType` | Required | Used to identify this worker type elsewhere in your project. <br><br> **Note:** A `workerType` must be unique project-wide. The `workerType` specified in this field must also match the `workerType` that your worker instance reports in its `ConnectionParameters` when connecting to a deployment. For more information, see the [API reference](https://docs.improbable.io/reference/latest/csharpsdk/api-reference#improbable-worker-connectionparameters-class). |
|`layer`| Optional | The name of the simulation layer of this worker type, used to determine the load balancing strategy. For more information, see [Layers](https://docs.improbable.io/reference/latest/shared/worker-configuration/layers). |
| `entityInterest` | Optional | Specifies the entities to subscribe to in addition to the ones the worker is authoritative over. The semantics are analogous to the [`entity_interest` field in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#entity-interest). |
| `streamingQuery` | Optional | Specifies the streaming queries the bridge will subscribe to. Analogous to [`streaming_query` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#streaming-queries). |
| `componentDelivery` | Optional | Specifies the delivery settings for the worker's components. Analogous to [`component_delivery` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#component-delivery). |
| `componentSettings` | Optional | Defines component specific settings. Analogous to [`component_settings` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#component-settings). |
| `permissions` | Optional | Specifies the worker's entity permissions. Analogous to [`permissions` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/permissions). |
| `uploadConfiguration` | Optional | Specifies the client worker's build directory for each platform. If provided, the `spatial alpha cloud upload` CLI command uploads the given client worker, enabling you to use it with the [Launcher](https://docs.improbable.io/reference/latest/shared/operate/launcher#the-launcher). <br><br> It contains three optional fields (`windows`, `macos`, `linux`) which each contain one required `localBuildDirectory` string field. The `localBuildDirectory` field specifies the directory containing the worker binary to be executed. <br><br> **Note:** Your built-out worker must be self-contained in the `localBuildDirectory` and all files that your worker might depend on while running must be in this folder. Files outside this folder will not be uploaded to the cloud as part of your project assembly. |
