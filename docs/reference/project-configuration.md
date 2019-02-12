## Configuring the project (`spatialos.json`)

This is the main configuration file for your project. It references the other configuration files that SpatialOS requires in order to run, and includes basic information about your project.

### Configuration file

The file must be called `spatialos.json` and must have the following structure:
```json
{
  "configurationVersion": "0.1",
  "projectName": "demo",
  "schemaDescriptor": "./schema_out/bin/schema.descriptor",
  "clientWorkers": [
    "../client/improbable/client_worker.json"
  ],
  "serverWorkers": [
    "../HelloWorker/hello_worker.json",
    "../DiceWorker/worker_config.json"
  ]
}
```

| Field | Required/Optional | Description | 
| :------------- | :------------- | :------- | 
| `configurationVersion`  | Required  | Specifies the version of the configuration file itself. This documentation is for configuration version `0.1` and this field should always be set to this value if you intend to use features described here. |
| `projectName`  | Required  | The name of the project assigned to you by Improbable. It's used in the Console and for deployments. It should be between 3 and 32 characters long and contain letters, numbers and underscores. |
| `schemaDescriptor` | Required | A relative (to the location of this file) or absolute path to the SpatialOS schema descriptor file. This is a binary file obtained by using the SpatialOS schema compiler on all of the project's `.schema` files. [`build.sh`](../../build.sh) provides an example on how to generate this file. <br><br> This file is required in order for the SpatialOS Runtime to understand the schema used by all the workers. |
| `clientWorkers` | Optional | A list of relative (to the location of this file) or absolute paths to client worker configuration files. See the [client worker config](client-worker-configuration.md) page for more details. |
| `serverWorkers` | Optional | A list of relative (to the location of this file) or absolute paths to server worker configuration files. See the [server worker config](server-worker-configuration.md) page for more details. |