#Mekhi Garcia date: 07/14/2025
#!/bin/bash 

#set variables 
hostname=$(hostname)
host_name=$(hostnamectl)
ip_address=$(hostname -I | awk '{print $1}')
uptime=$(uptime -p)
kernel_version=$(uname -r)

#display the current user hostname 
    echo "Current user hostname is: $hostname"
#display additional system info 
    echo "Gathering additional user and host info: $host_name"
#display the user ip address and extract using awk
    echo "ip address of user is: $ip_address"
#display the  uptime of the system
    echo "the system uptime is: $uptime"
#display the Kernel version of the system
    echo "the system kernel version is: $kernel_version"

#set disk usage threshold
  threshold=90
#do a check on disk and usage
disk_usage=$(df -h | awk 'print $5}')

#script logic to send alert if usage is over 90%
if [ "$disk_usage" -ge "$threshold" ]; then
  echo "disk usage exceeding maximum $threshold: $disk_usage"
  echo "Disk Usage exceed threshold of 90% please address now" 
#  echo "Alert triggered disk: $disk_usage exceeding: $threshold"
else
   echo "storage health optimal"
fi
#logged on user and no pw users section 
#check if user is sudoer
current_users=$(who)
no_pwusers=$(sudo cat /etc/shadow | grep "!")
#logic to determine if user is root 
    echo "Users currently logged on: $current_users"
    echo "Current audit on empty passwords: $no_pwusers"
#top memory consumers
top_mem=$(ps aux --sort rss | head -11)
top_mem1=$(top -b -n 1)
echo "The current top memory use is: $top_mem"

#set values as essential services 
journ_stat=$(sudo systemctl status systemd-journald)
audit_stat=$(sudo systemctl status auditd)
cron_stat=$(sudo systemctl status cron)
ufw_stat=$(sudo systemctl status ufw)

#Display the status Check
echo "$journ_stat"
echo "$audit_stat"
echo "$cron_stat"
echo "$ufw_stat"
echo "Status Check Completed"
