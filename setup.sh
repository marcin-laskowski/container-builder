#!/bin/bash


export PROJECT=developer=269501
export ZONE=europe-west3-a
export CLUSTER=gke-deploy-cluster

# confirm authentication
gcloud auth list

# setup your config
gcloud config set project $PROJECT
gcloud config set compute/zone $ZONE

# enable APIs
gcloud services enable container.googleapis.com \
    containerregistry.googleapis.com \
    cloudbuild.googleapis.com \
    sourcerepo.googleapis.com

# create cluster
gcloud container clusters create ${CLUSTER} \
    --zone=${ZONE} \
    --scopes "https://www.googleapis.com/auth/projecthosting,storage-rw"

# give cloud build rights to the cluster
export PROJECT_NUMBER="$(gcloud projects describe \
    $(gcloud config get-value core/project -q) --format='get(projectNumber)')"

gcloud projects add-iam-policy-binding ${PROJECT} \
    --member=serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com \
    --role=roles/container.developer
