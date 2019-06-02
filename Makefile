setup:
	kubectl --kubeconfig example-kubeconfig.yaml apply -f cluster/helm
	helm --kubeconfig example-kubeconfig.yaml init --service-account tiller

install:
	helm --kubeconfig example-kubeconfig.yaml version

	helm --kubeconfig example-kubeconfig.yaml upgrade \
		--install \
		kube-state-metrics \
		--namespace kube-system \
		stable/kube-state-metrics

	helm --kubeconfig example-kubeconfig.yaml upgrade \
		--install \
		nginx-ingres \
		-f cluster/nginx/values.yaml \
		--namespace kube-system \
		stable/nginx-ingress

	helm --kubeconfig example-kubeconfig.yaml upgrade \
		--install \
		jenkins \
		-f cluster/jenkins/values.yaml \
		--namespace services \
		stable/jenkins

status:
	watch "kubectl --kubeconfig example-kubeconfig.yaml get nodes && \
		echo && kubectl --kubeconfig example-kubeconfig.yaml get pods --all-namespaces"

delete:
	helm --kubeconfig example-kubeconfig.yaml delete --purge nginx-ingres
	helm --kubeconfig example-kubeconfig.yaml delete --purge jenkins

clean:
