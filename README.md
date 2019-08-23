# Helm Chart

A helm chart which can be used and adjusted for any application.

## Getting Started

Before using the helm chart, have the following installed and set up on your machine.

* Kubectl

Verify **kubectl** configuration and check that you have access to your cluster.

### Generate Templates & Rollout Deployments

**Specify the deployment names and their config names in deployment-names.txt and config-names.txt respectively. If you don't specify any configs, a default config (set in values.yaml) will be applied to all deployments.**

Generate and deploy helm templates in one shot.

```
make deployment
```

Generate helm templates.

```
make generate
```

Create and push deployments.
```
make deploy
```

Scale deployments. Specify number of pods.
```
make scale PODS=3
```

Remove deployments.
```
make remove
```
