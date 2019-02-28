## Configuring a client-worker (`client_worker.json`)

This file specifies the configuration parameters of a client-worker.

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
    "entity_creation": {
        "allow": true
    },
    "entity_deletion": {
        "allow": true
    },
    "entity_query": {
        "allow": true
    }
  },
  "uploadConfiguration": {
    ...
  },
  "loginRateLimit": {
    "duration": "1h20m30s",
    "requestsPerDuration": 100 
  },
  "connectionCapacityLimit": {
    "maxCapacity": 1000
  }
}
```

| Field | Required/Optional | Description | 
| :------------- | :------------- | :------- |
| `workerType` | Required | Used to identify this worker type elsewhere in your project. <br><br> **Note:** A `workerType` must be unique project-wide. The `workerType` specified in this field must also match the `workerType` that your worker instance reports in its `ConnectionParameters` when connecting to a deployment. For more information, see the [API reference](https://docs.improbable.io/reference/latest/csharpsdk/api-reference#improbable-worker-connectionparameters-class). |
|`layer`| Required | The name of the simulation layer of this worker type, used to determine the load balancing strategy. For more information, see [the layers documentation](https://docs.improbable.io/reference/latest/shared/worker-configuration/layers). |
| `entityInterest` | Optional | Specifies the entities to subscribe to in addition to the ones the worker is authoritative over. The semantics are analogous to the [`entity_interest` field in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#entity-interest). |
| `streamingQuery` | Optional | Specifies the streaming queries the bridge will subscribe to. Analogous to [`streaming_query` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#streaming-queries). |
| `componentDelivery` | Optional | Specifies the delivery settings for the worker's components. Analogous to [`component_delivery` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#component-delivery). |
| `componentSettings` | Optional | Defines component specific settings. Analogous to [`component_settings` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/bridge-config#component-settings). |
| `permissions` | Optional | Specifies the worker's entity permissions. Analogous to [`permissions` in the previous configuration version](https://docs.improbable.io/reference/latest/shared/worker-configuration/permissions), with the difference that the permissions property here is a single permission object rather than an array. |
| `uploadConfiguration` | Optional | Describes how to start the worker. If provided, the `spatial alpha cloud upload` CLI command uploads the built-out client-worker executable, enabling you to use it with the [Launcher](https://docs.improbable.io/reference/latest/shared/operate/launcher#the-launcher). See below for more information. |
| `loginRateLimit` | Optional | Defines an upper limit for the frequency at which worker instances of this worker type are allowed to connect to a single deployment. It contains two fields: <br> - `duration`: time window of the login rate limit to be specified as a string in the form of `<x>h<y>m<z>s`, e.g. `1h30s` <br> - `requestsPerDuration`: Maximum number of worker instances that is allowed to connect during the given duration <br><br> For more information, see [Worker connection limits](https://docs.improbable.io/reference/latest/shared/worker-configuration/worker-rate-limit-capacity). |
| `connectionCapacityLimit` | Optional | Defines an upper limit for how many worker instances of this worker type may be simultaneously connected to a single deplyoment. It has a single field (`maxCapacity`) for specifying the maximum number of connected worker instances. <br><br> For more information, see [Worker connection limits](https://docs.improbable.io/reference/latest/shared/worker-configuration/worker-rate-limit-capacity). |

#### Upload configuration

The upload configuration specifies how to start a client-worker instance with the [Launcher](https://docs.improbable.io/reference/latest/shared/operate/launcher#the-launcher). Below is an example excerpt:
```json
      "windows": {
        "localBuildDirectory": "bin/x64/ReleaseWindows",
        "launcherCommand": "MyWorker.exe",
        "launcherArguments": [
          "${IMPROBABLE_RECEPTIONIST_HOST}",
          "${IMPROBABLE_RECEPTIONIST_PORT}",
          "${IMPROBABLE_WORKER_ID}",
          "--my_additional_flag=true"
        ]
      },
      "macos": {
        "localBuildDirectory": "bin/x64/ReleaseMacOS",
        "launcherCommand": "MyWorker.app",
        "launcherArguments": [
          "${IMPROBABLE_RECEPTIONIST_HOST}",
          "${IMPROBABLE_RECEPTIONIST_PORT}",
          "${IMPROBABLE_WORKER_ID}",
          "--my_additional_flag=true"
        ]
      }
```

There must be a configuration for each platform the worker will be run on. The platform name can be one of `windows` or `macos`. Each of these can have the following fields:

| Field | Required/Optional | Description | 
| :------------- | :------------- | :------- |
| `localBuildDirectory` | Required | The directory containing the binary to be executed. <br><br> **Note:** Your built-out worker must be self-contained in the `localBuildDirectory` and all files that your worker might depend on while running must be in this folder. Files outside this folder will not be uploaded to the cloud as part of your project assembly. |
| `launcherCommand` | Optional | The base command to be executed to start a client-worker when using the [Launcher](https://docs.improbable.io/reference/latest/shared/operate/launcher#the-launcher). <br><br> **Note:** To use the launcher with this client-worker, the `workerType` has to be `LauncherClient`. |
| `launcherArguments` | Optional | A list of arguments to provide to the `launcherCommand` when Launcher is starting the client. The arguments can contain placeholder strings, like `${IMPROBABLE_LOGIN_TOKEN}`, which are interpolated by SpatialOS when the client is launched. The allowed placeholders are: <br><br>- `${IMPROBABLE_PROJECT_NAME}` - the project name that the client should log in to. <br>- `${IMPROBABLE_DEPLOYMENT_NAME}` - the deployment name that the client should log in to. <br>- `${IMPROBABLE_LOGIN_TOKEN}` - the login token that should be used to log in to the deployment. <br>- `${IMPROBABLE_PLAYER_IDENTITY_TOKEN}` - the player identity token that should be used to log in to the deployment. <br>- `${IMPROBABLE_LOCATOR_HOSTNAME}` - the hostname of the Locator, which should be used to log in. <br>- `${IMPROBABLE_API_URL}` - the URL of Improbable API services, if the client requires to use it. |
