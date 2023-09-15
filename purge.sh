#!/bin/bash
{
    minikube delete --profile fakeprovider
} || {}
find . -name "terraform.tfstate" -type f -delete
find . -name "terraform.tfstate.backup" -type f -delete
