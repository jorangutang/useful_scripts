#!/bin/bash
# this script deploys a pod to a Kubernetes cluster forwards a port to your localhost, eg if you want to access a db on app-int:5432, then you will see it at localhost:5432

name=$1
command=$2

if [ -z "$command" ]; then
    echo "<name> on|off"
    exit 1
fi

case $name in
    "clusterDB-namespace-dev")
        target="database.something-something-nn-db.rds.amazonaws.com"
	port=5432
        ;;
    "cluster-App-namespace-int")
        target="application-eu-central-1.aws.cloud.bmw"
    port=1521
        ;;
    *)
esac

case $command in
    "on")
        echo "Setting up forward to ${target}:${port}"
        kubectl run --image=hpello/tcp-proxy tunnel-name-$name -- $target $port
        sleep 3
        kubectl port-forward tunnel-name-$name $port
        ;;
    "off")
        echo "Shutting down forward to ${name}"
        kubectl delete pod tunnel-name-$name
        ;;
    *)
        echo "Invalid command"
        exit 1
        ;;
esac
