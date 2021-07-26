#!/bin/sh

# Set environment
[ ! -z "$CLUSTER" ] && kubectl config use-context $CLUSTER

# Set namespace
[ ! -z "$CLUSTER" ] && [ ! -z "$NAMESPACE" ] && kubectl config set-context $(kubectl config current-context) --namespace $NAMESPACE

# This will exec the CMD from your Dockerfile, i.e. "npm start"
exec "$@"
