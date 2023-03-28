#!/bin/bash
#script launch&args = ./sync_logs.sh cron-min cron-hour cron-DOM cron-MONTH cron-DOW /source/path/ remote_username remote_host /remote/path/to/sync_file

if [$IS-CRON_RSYNC-ON!=1]                                                                           #if cronjob was never created before - create it
then
  set IS-CRON_RSYNC-ON=1
  export IS-CRON_RSYNC-ON
  echo "$1 $2 $3 $4 $5 $PWD$0 $6 $7 $8 $9 > /dev/null" > tee -a /etc/crontab.d/$USER
fi

log_dir=${6}
remote_username=${7}
remote_host=${8}
remote_log_dir=${9}

for i in {1..$10}; do                                                                                #create files
  echo "lol smth ${i}" > "${log_dir}tmp-file-${i}.log"
done

rsync -z --update "${log_dir}" ${remote_username}@${remote_host}:${remote_log_dir}                   #sync files

ssh ${remote_username}@${remote_host} find ${remote_log_dir} -type f -name "*.log" -mtime +7 -delete #manage files on remote machine
