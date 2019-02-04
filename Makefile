REPO ?= dfherr/postgres
TAG  ?= 11.1

all: build push

build: Dockerfile
	docker build --rm -t $(REPO):$(TAG) .
	docker tag $(REPO):$(TAG) $(REPO):latest

push:
	docker push $(REPO):$(TAG)
	docker push $(REPO):latest
