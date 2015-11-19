# Upsource Repository Viewer
Upsource is Jetbrain's Git repository browser and code review tool. This project includes a Dockerfile and Kubernetes configuration to run it in Google's Compute Engine.

## Build it
1. Replace `<YOUR-PROJECT-ID>` in all files using
`sed -i 's/<YOUR-PROJECT-ID>/example-project-1/g' *`

2. Build the docker image with:
`docker build -t eu.gcr.io/<YOUR-PROJECT-ID>/upsource:<VERSION>`

## Deployment
The project can be deployed and run using Kubernetes eg. on GCE.

1. First create a container cluster on GCE:
`gcloud container --project "<YOUR-PROJECT-ID>" clusters create "upsource-cluster" --zone "europe-west1-c" --machine-type "n1-standard-1" --num-nodes "1"`

2. Create a persistent disk:
`gcloud compute --project "<YOUR-PROJECT-ID>" disks create "upsource-disk" --size "100" --zone "europe-west1-c" --description "Disk to persist upsource configuration and data." --type "pd-standard"`

  The startup script symlinks an existing conf directory from the disk. If the conf directory does not exist, it copies it over. If the disk is missing, it uses the ephemeral container's storage.

3. Fetch and update the cluster credentials:
`gcloud container clusters get-credentials --project "<YOUR-PROJECT-ID>" --zone europe-west1-c upsource-cluster`

4. Upload the upsource docker image to the kubernetes cluster:
`gcloud docker push eu.gcr.io/<YOUR-PROJECT-ID>/upsource:<version>`
Change the image name in upsource.controller.yaml according to your uploaded docker image.

4. Create a new namespace for the upsource:
`kubectl create -f upsource.namespace.yaml`

5. Create the controller and service:
`kubectl create -f upsource.service.yaml --namespace=upsource`
`kubectl create -f upsource.controller.yaml --namespace=upsource`

6. Check if the controller and service is running correctly.
`kubectl get pods --namespace=upsource`
`kubectl get services --namespace=upsource`

7. You can reach your upsource server to configure it under port 80.
