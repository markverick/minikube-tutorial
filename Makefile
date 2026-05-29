.PHONY: start build deploy status port-forward test logs clean stop delete

IMAGE := minikube-demo:1.0

start:
	minikube start

build:
	minikube image build -t $(IMAGE) ./app

deploy:
	kubectl apply -k k8s

status:
	kubectl get all

port-forward:
	kubectl port-forward service/minikube-demo 8080:80

test:
	curl http://localhost:8080
	curl http://localhost:8080/healthz

logs:
	kubectl logs deployment/minikube-demo

clean:
	kubectl delete -k k8s

stop:
	minikube stop

delete:
	minikube delete
