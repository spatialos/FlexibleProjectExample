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
  "loadBalancing": {},
  "snapshot": {
    "takeSnapshotIntervalSeconds": "600",
    "startDeploymentFromSnapshotFile": "snapshots/default.snapshot"
  },
  "workerFlags": [
    {
      "workerType": "worker1",
      "flags": [
        {
          "name": "flag1",
          "value": "value1"
        }
      ]
    }
  ]
}
```

| Field | Required/Optional | Description | 
| :------------- | :------------- | :------- |
| `dimensionsInWorldUnits` | Required | Describes how big the world should be. "x" and "z" parameters must both be greater than 0. |
| `loadBalancing` | Required | Currently not supported and should be defined as an empty object `{}`. In the near future, this will specify how to distribute workers across the world, similarly to the [current load balancing configuration](https://docs.improbable.io/reference/latest/shared/worker-configuration/loadbalancer-config). |
| `snapshot` | Optional | Specifies which snapshot file to start the deployment from and how often to take a snapshot while the deployment is running. <br><br> It contains two optional fields: `takeSnapshotIntervalSeconds` (optional) and `startDeploymentFromSnapshotFile` (optional). |
| `workerFlags` | Optional | Specifies any additional flags to pass to workers. Each element contains two fields: `workerType` (required) and `flags` (required). |