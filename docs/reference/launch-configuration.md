## Configuring a deployment to be launched (`deployment.json`)

This file contains the configuration parameters for starting a deployment. You can specify it in the [`launch_config`] field of a [project configuration](project-configuration.md) or pass it to `spatial alpha local launch` or `spatial alpha cloud launch` via the `--launch_config` flag.

### Configuration file

The file may be called by any name but should have the following structure:

```json
{
  "template": "...",
  "dimensionsInWorldUnits": {
    "x": 100,
    "z": 100
  },
  "loadBalancing": {
    "layerConfigurations": [
      {
        "layer": "...",
        "hexGrid": {
          "numWorkers": ...
        }
      }
    ]
  },
  "snapshot": {
    "takeSnapshotIntervalSeconds": "600",
    "startDeploymentFromSnapshotFile": "snapshots/default.snapshot"
  },
  "workerFlags": [
    {
      "workerType": "...",
      "flags": [
        {
          "name": "...",
          "value": "..."
        }
      ]
    }
  ],
  "streamingQueryInterval": 4,
  "runtimeFlags": [
    {
      "name": "...",
      "value": "..."
    }
  ]   
}
```

| Field | Required/Optional | Description | 
| :------------- | :------------- | :------- |
| `template` | Required | Defines the compute resources your deployment needs (its ‘topology’). See [deployment templates](https://docs.improbable.io/reference/latest/shared/reference/file-formats/launch-config#templates) for more details. |
| `dimensionsInWorldUnits` | Required | Describes how big the world should be. "x" and "z" parameters must both be greater than 0. |
| `loadBalancing` | Required | The new load balancing configuration as documented in [load balancing with layers](https://docs.improbable.io/reference/latest/shared/worker-configuration/load-balancing). |
| `snapshot` | Optional | Specifies which snapshot file to start the deployment from and how often to take a snapshot while the deployment is running. <br><br> It contains two optional fields: `takeSnapshotIntervalSeconds` (optional) and `startDeploymentFromSnapshotFile` (optional). |
| `workerFlags` | Optional | Specifies global configuration parameters of a deployment that worker instances can read. Each element contains two fields: `workerType` (required) and `flags` (required). See [worker flags](https://docs.improbable.io/reference/latest/shared/worker-configuration/worker-flags) for more information. |
| `streamingQueryInterval` | Optional | Period in seconds between successive streaming query updates. The default value is `4` seconds. |
| `runtimeFlags` | Optional | The Runtime flags that can control advanced runtime features. Equivalent to [legacy flags](https://docs.improbable.io/reference/latest/shared/reference/file-formats/launch-config#legacy-flags).|
