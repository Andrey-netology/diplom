
1. Для разворачивание инфраструктуры необходимо сделать следующее.
Выполнить команды: 
- git clone https://github.com/Andrey-netology/diplom.git
- cd diplom
- terraform apply

2. Поднятие kubernetes.
Выполнить команды:
- git clone https://github.com/kubernetes-sigs/kubespray.git
- cd kubespray
- sudo pip3 install -r requirements.txt
- cp -rfp inventory/sample inventory/mycluster

3. Поднятие kubernetes. 
В папку kubespray/inventory/mycluster необходимо скопировать файл конфигурации inventory.ini

Данный файл находится тут:
https://github.com/Andrey-netology/diplom/blob/main/kuber_config/inventory.ini

4. Поднятие kubernetes.
Перейти в папку cd kubespray и выполнить команду: 
ansible-playbook -i inventory/mycluster/inventory.ini

5. Создание приложения. 
Выполнить команду ssh 192.168.10.34 (в дальниешем все команды выполнять на данном сервере) 
Полсе подключения выполнить следующи команды: 
- git clone https://github.com/Andrey-netology/diplom.git
- cd diplom
- kubectl create -f nginx.yaml
- kubectl create -f nginx-service.yaml

6. Мониторинг.
Выполнить команды:
- git clone https://github.com/prometheus-operator/kube-prometheus
- cd kube-prometheus
- kubectl apply --server-side -f manifests/setup
- kubectl wait \
	--for condition=Established \
	--all CustomResourceDefinition \
	--namespace=monitoring
- kubectl apply -f manifests/

7. Поднятие jenkins.
Выполнить команды:
- cd diplom 
- kubectl create namespace jenkins
- kubectl create -f jenkins.yaml --namespace jenkins
- kubectl create -f jenkins-service.yaml --namespace jenkins
