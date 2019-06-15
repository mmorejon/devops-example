setup:
	kubectl --kubeconfig example-kubeconfig.yaml apply -f services/helm
	helm --kubeconfig example-kubeconfig.yaml init --upgrade --service-account tiller

install:
	helm --kubeconfig example-kubeconfig.yaml version

	helm --kubeconfig example-kubeconfig.yaml upgrade \
		--install \
		kube-state-metrics \
		--namespace kube-system \
		--version 1.6.4 \
		stable/kube-state-metrics

	helm --kubeconfig example-kubeconfig.yaml upgrade \
		--install \
		nginx-ingres \
		-f services/nginx/values.yaml \
		--namespace kube-system \
		--version 1.6.17 \
		stable/nginx-ingress

	helm --kubeconfig example-kubeconfig.yaml upgrade \
		--install \
		jenkins \
		-f services/jenkins/values.yaml \
		--namespace services \
		--version 1.2.2 \
		stable/jenkins

status:
	watch "kubectl --kubeconfig example-kubeconfig.yaml get nodes && \
		echo && kubectl --kubeconfig example-kubeconfig.yaml get pods --all-namespaces"

delete:
	helm --kubeconfig example-kubeconfig.yaml delete --purge nginx-ingres
	helm --kubeconfig example-kubeconfig.yaml delete --purge jenkins

clean:
