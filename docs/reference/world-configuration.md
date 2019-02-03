## Configuring the world (`world.json`)

This configuration file tells SpatialOS what kind of world to launch with, including the size and the load balancing properties. You can pass this file as a parameter to any launch command, so you should use it to configure any different types of deployments you may want to start.

### Configuration file

The file may be called by any name but should have the following structure:

```json
{
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
  ]
}
```

| Field | Required/Optional | Description | 
| :------------- | :------------- | :------- |
| `dimensionsInWorldUnits` | Required | Describes how big the world should be. "x" and "z" parameters must both be greater than 0. |
| `loadBalancing` | Required | The new load balancing configuration as documented in [load balancing with layers](https://docs.improbable.io/reference/latest/shared/worker-configuration/load-balancer-config-2#load-balancing-with-layers). |
| `snapshot` | Optional | Specifies which snapshot file to start the deployment from and how often to take a snapshot while the deployment is running. <br><br> It contains two optional fields: `takeSnapshotIntervalSeconds` (optional) and `startDeploymentFromSnapshotFile` (optional). |
| `workerFlags` | Optional | Specifies any additional flags to pass to workers. Each element contains two fields: `workerType` (required) and `flags` (required). |