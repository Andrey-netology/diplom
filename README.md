
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

- устанавливаем менеджер пакетов HELM: 

$ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
$ chmod 700 get_helm.sh
$ ./get_helm.sh

- добавляем необходимые репозитории: 

helm repo add jenkins https://charts.jenkins.io
helm repo update

- устанавливаем jenkins (values-override.yaml - подставляю свой файл кунфигурации jenkins):
 
helm install --name jenkins --namespace jenkins -f jenkins/values-override.yaml stable/jenkins

Получается в файл конфигурации прописывается запуск CI/CD для Dockerfile, который находится в registry. 
(К сожалению я тут несправился, не получилось сделать файл конфигурации который выполняет данный функционал.....)


При создании однотипных ресурсов в терраформе (ВМ) не стоит копипастить - тут необходимо использовать специальный модуль, читал мануил по Terraform не смог его найти (думаю найду но на это понадобится время, боюсь не успею в срок....) 


