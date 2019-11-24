# This is about deployment of airship components using airskiff on single node kubeadm cluster.

Follow the below steps to setup kubeadm based single node cluster and to install airskiff on top of it with just the airship components.

All the shell scripts needed for the setup are available in this repo.

The setup is successfully tested on Ubuntu 16.04 LTS - Xenial on an AWS instance,  I expect it to work without any issues similarly on Ubuntu 18 as well.


    Step1: Execute the script kubeadm-setup.sh to setup a singlenode k8s cluster

    Step2: Create a readable directory and follow the rest of the steps. 
    Clone the treasuremap repo:
    git clone https://opendev.org/airship/treasuremap.git

    Step3: Place the shell script dependencies.sh in the root of treasuremap directory cloned in the above step and execute it there
    Execute the dependencies.sh to clone the needed repos of armada, deckhand, shipyard

    Step4: Extra Commands executed apart from the scripts:
    The below commands are to be executed before executing airskiff.sh

    helm init --wait
    helm version

    kubectl get serviceaccount -n kube-system
    kubectl create serviceaccount -n kube-system tiller
    kubectl get clusterrole -n kube-system
    kubectl get clusterrole cluster-admin -o yaml -n kube-system
    kubectl get clusterrolebinding -n kube-system
    kubectl create clusterrolebinding tiller-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
    kubectl --namespace kube-system patch deploy tiller-deploy -p '{"spec":{"template":{"spec":{"serviceAccount":"tiller"}}}}'
    kubectl --namespace kube-system get deploy tiller-deploy -o yaml
    kubectl label nodes --all --overwrite ucp-control-plane=enabled
    kubectl label nodes --all openstack-control-plane=enabled
    sudo apt install nfs-kernel-server

    Step5: Place the shell script airskiff.sh in the root of treasuremap directory and execute it there.
