## Configuring a client worker (`client_worker.json`)

This configuration file tells SpatialOS how a client worker should interact with the world. It includes configuration for the worker type, and how SpatialOS should decide which entities and entity information are sent to the worker.

### Configuration file

The file may be called by any name but should have the following structure:
```json
{
  "workerType": "InteractiveClient",
  "attributeSet": {
    "attributes": [
      "client"
    ]
  },
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
    "all": {}
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
| `permissions` | Optional | Specifies the worker's entity permissions. Analogous to [`permissions` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/permissions). |