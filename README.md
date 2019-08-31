# Helm-Chart

A generic helm chart to use and adapt for any application

## Getting Started

Before using the helm chart, have the following installed and set up on your machine.

* Kubectl

Verify **kubectl** configuration and check that you have access to your cluster.

* Helm

Know what is a helm chart and how it works.

### Generate Templates & Rollout Deployments

**Modify templates/deployment.yaml & Makefile by replacing <your-namespace> with your namespace you wish to deploy to.**

**Specify the deployment names and their config names in deployment-names.txt and config-names.txt respectively. If you don't specify any configs, a default config (set in values.yaml) will be applied to all deployments.**

Generate and deploy in one shot.

```
make deployment
```

Generate helm templates.

```
make generate
```

Create and push deployments to Rancher.
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
