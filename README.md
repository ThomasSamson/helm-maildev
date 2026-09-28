# MailDev Helm Charts

Maintained fork of [pando85/helm-maildev](https://github.com/pando85/helm-maildev) (archived in 2023).

[Helm](https://helm.sh) repo for different charts related to MailDev which can be installed on [Kubernetes](https://kubernetes.io)

## Add Helm repository

To install the repo just run:

```bash
helm repo add maildev https://thomassamson.github.io/helm-maildev/
helm repo update
```

## Helm Charts

* [maildev](https://thomassamson.github.io/helm-maildev/)

  ```bash
  helm install my-release maildev/maildev
  ```
