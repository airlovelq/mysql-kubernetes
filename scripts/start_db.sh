bash scripts/.env.sh

kubectl apply -f conf/db_storage.yml
kubectl apply -f conf/db_deployment.yml
kubectl apply -f conf/db_service.yml

sleep 60

DB_PODNAME=$(kubectl get pod | grep mysql-dc)
DB_PODNAME=${DB_PODNAME:0:26}

kubectl exec $DB_PODNAME -- mysql -uroot -pmysqlpasswd -h127.0.0.1 -P3306 -e "CREATE USER 'mysqluser'@'%' IDENTIFIED BY 'mysqlpasswd';"
kubectl exec $DB_PODNAME -- mysql -uroot -pmysqlpasswd -h127.0.0.1 -P3306 -e "CREATE DATABASE mysqluser;"
kubectl exec $DB_PODNAME -- mysql -uroot -pmysqlpasswd -h127.0.0.1 -P3306 -e "GRANT ALL ON mysqluser.* TO 'mysqluser'@'%';"