backupIntervalMin=$REMOTE_BACKUP_INTERVAL_SEC
echo "PID of this script:$$" >> backup_remote.log

echo > autobackup.conf <<EOF
remoteip:$REMOTE_IP
remoteuser:$REMOTE_USER
remotedir:$REMOTE_DIR
localip:$LOCAL_IP
localmysqluser:root
localmysqlpass:$MYSQL_ROOT_PASSWORD
EOF

a=$(date +%s)

while [ "1" = "1" ];do
  b=$(date +%s)
  declare -i c=$b-$a
  if [ "$c" -ge "$backupIntervalMin" ];then
    ./autobackup.sh 1
    a=$(date +%s)
  fi
  sleep 5
done
