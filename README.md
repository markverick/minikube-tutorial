# Minikube Quickstart

This repo walks through running a small web app on a local Kubernetes cluster with
minikube.

You will:

- start a local cluster
- build a container image
- deploy the app to Kubernetes
- call the app from your browser or terminal

The demo app is a tiny Python HTTP server that returns JSON.

## Install the Tools

You need three command-line tools:

- Docker, which runs containers
- kubectl, which talks to Kubernetes
- minikube, which creates a local Kubernetes cluster

### macOS

With Homebrew:

```sh
brew install --cask docker
brew install kubectl minikube
```

Open Docker Desktop once after installing it, then wait until it says Docker is
running.

### Windows

With PowerShell:

```powershell
winget install -e --id Docker.DockerDesktop
winget install -e --id Kubernetes.kubectl
winget install -e --id Kubernetes.minikube
```

Open Docker Desktop once after installing it, then wait until it says Docker is
running.

### Linux

Install Docker using the official instructions for your distribution:

- [Docker Desktop for Linux](https://docs.docker.com/desktop/setup/install/linux/)
- [Docker Engine for Linux](https://docs.docker.com/engine/install/)

For a typical 64-bit Linux machine, install kubectl and minikube with:

```sh
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64
```

If your computer uses a different CPU architecture, use the official install
pages linked below.

### Check the Install

```sh
docker --version
kubectl version --client
minikube version
```

Official install docs:

- [Docker Desktop](https://docs.docker.com/get-started/introduction/get-docker-desktop/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [minikube](https://minikube.sigs.k8s.io/docs/start/)

## 1. Start the Cluster

```sh
minikube start
```

Check that Kubernetes is running:

```sh
kubectl get nodes
```

The node should show `Ready`.

## 2. Build the App Image

Build the image directly inside minikube:

```sh
minikube image build -t minikube-demo:1.0 ./app
```

## 3. Deploy to Kubernetes

```sh
kubectl apply -k k8s
```

Check the pod:

```sh
kubectl get pods
```

Wait until the pod status is `Running`.

## 4. Open the App

Forward the Kubernetes Service to your computer:

```sh
kubectl port-forward service/minikube-demo 8080:80
```

In a second terminal, test the app:

```sh
curl http://localhost:8080
curl http://localhost:8080/healthz
```

The `/` endpoint should return something like:

```json
{
  "message": "Hello from minikube!",
  "pod": "minikube-demo-...",
  "path": "/"
}
```

Use `Ctrl+C` to stop port forwarding.

## Helpful Commands

```sh
kubectl get all
kubectl logs deployment/minikube-demo
kubectl describe pod -l app=minikube-demo
```

## Make a Change

After editing `app/server.py`, rebuild the image and restart the deployment:

```sh
minikube image build -t minikube-demo:1.0 ./app
kubectl rollout restart deployment/minikube-demo
```

## Clean Up

Remove the app from Kubernetes:

```sh
kubectl delete -k k8s
```

Stop the cluster:

```sh
minikube stop
```

Delete the cluster completely:

```sh
minikube delete
```

## Make Shortcuts

These commands wrap the same steps shown above:

```sh
make start
make build
make deploy
make test
make clean
```
