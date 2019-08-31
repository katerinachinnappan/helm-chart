SHELL := /bin/bash

# HELP
.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

.SILENT: generate
generate: ## generates deployment template
	declare -a nameslist ; \
	declare -a configlist ; \
	# read file content into the arrays ; \
	readarray -t nameslist <deployment-names.txt ; \
	readarray -t configlist <config-names.txt ; \
	nameslist_len=$${#nameslist[@]} ; \
	number=0 ; while [[ $$number -le $$nameslist_len-1 ]] && [[ $$number1 -le $$nameslist_len-1 ]]; do \
		# If config is not provided in argument, set default config from values.yaml for all deployments ; \
		if [ "${configlist}" == "" ] && [ "$${#configlist[@]}" -lt "1" ]; then \
			echo "empty" ; \
			helm template --name $${nameslist[$$number]} --namespace=<your-namespace> ./ > deployment_templates/$${nameslist[$$number]}-manifest.yaml ; \
		fi ;\
		# If provided only one config, apply it to all deployments ; \
		if [ "$${#configlist[@]}" ==  "1" ]; then \
			echo "1" ; \
			helm template --name $${nameslist[$$number]} --namespace=<your-namespace> --set volumes.configMap.specific=$${configlist[@]} ./ > deployment_templates/$${nameslist[$$number]}-manifest.yaml ; \
		fi ; \
		# If provided more than 1 configs, apply to deployments respectively ; \
		if [ "$${#configlist[@]}" -gt "1" ]; then \
			echo "more than 1" ; \
			helm template --name $${nameslist[$$number]} --namespace=<your-namespace> --set volumes.configMap.specific=$${configlist[$$number]} ./ > deployment_templates/$${nameslist[$$number]}-manifest.yaml ; \
		fi ; \
		((number = number + 1)) ; \
	done

.SILENT .PHONY: deploy
deploy: generate ## deploys specified deployments
	declare -a nameslist ; \
	readarray -t nameslist <deployment-names.txt ; \
	nameslist_len=$${#nameslist[@]} ; \
	number=0 ; while [[ $$number -le $$nameslist_len-1 ]]; do \
		kubectl apply -f ./deployment_templates/$${nameslist[$$number]}-manifest.yaml -n <your-namespace> ; \
		((number = number + 1)) ; \
	done

.SILENT: scale
scale: ## scale specified deployments
	declare -a nameslist ; \
	readarray -t nameslist <deployment-names.txt ; \
	nameslist_len=$${#nameslist[@]} ; \
	number=0 ; while [[ $$number -le $$nameslist_len-1 ]]; do \
		kubectl scale deployment.v1.apps/$${nameslist[$$number]} --namespace=<your-namespace> --replicas=$(PODS) ; \
		((number = number + 1)) ; \
	done

.SILENT .PHONY: remove
remove: ## remove specified deployments
	declare -a nameslist ; \
	readarray -t nameslist <deployment-names.txt ; \
	nameslist_len=$${#nameslist[@]} ; \
	number=0 ; while [[ $$number -le $$nameslist_len-1 ]]; do \
		kubectl delete deploy/$${nameslist[$$number]} --namespace=<your-namespace> ; \
		((number = number + 1)) ; \
	done

.SILENT .PHONY: deployment
deployment: generate deploy ## generate & deploy

.SILENT: cleanup
cleanup:
	rm deployment_templates/*



