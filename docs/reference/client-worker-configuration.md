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
  "streamingQuery": {
    ...
  },
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
    "macos": {...},
    "linux": {...}
  }
}
```

| Field | Required/Optional | Description | 
| :------------- | :------------- | :------- |
| `workerType` | Required | Used to identify this worker type elsewhere in your project. |
|`layer`| Optional | The name of the simulation layer of this worker, used to determine the load balancing strategy. For more information, see [introduction to layers](https://docs.improbable.io/reference/latest/shared/worker-configuration/layers#introduction-to-layers).|
| `entityInterest` | Optional | Specifies the entities to subscribe to in addition to the ones the worker is authoritative over. The semantics are analogous to the [`entity_interest` field in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#entity-interest). |
| `streamingQuery` | Optional | Specifies the streaming queries the bridge will subscribe to. Analogous to [`streaming_query` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#streaming-queries). |
| `componentDelivery` | Optional | Specifies the delivery settings for the worker's components. Analogous to [`component_delivery` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#component-delivery). |
| `componentSettings` | Optional | Defines component specific settings. Analogous to [`component_settings` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#component-settings). |
| `permissions` | Optional | Specifies the worker's entity permissions. Analogous to [`permissions` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/permissions). |
| `permissions` | Optional | Specifies the worker's entity permissions. Analogous to [`permissions` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/permissions). |
| `uploadConfiguration` | Optional | Specifies, for each platform, the client worker's build directory via `localBuildDirectory`. When provided, the `spatial cloud upload` CLI command will upload given client worker enabling it to be used with the [Launcher](https://docs.improbable.io/reference/latest/shared/operate/launcher#the-launcher). |