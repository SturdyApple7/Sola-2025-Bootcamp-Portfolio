#Mekhi Garcia date: 07/14/2025
#!/bin/bash 
timestamp=$(date | awk '{print $2 " " $3 " " $4" " $7}')
reportfile="$HOME/Desktop/report_$timestamp.txt"

{
# set variables 
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

#set location for parsing recent authentication logs 
failed_passwd=$(sudo grep "Failed password" /var/log/auth.log)
failed_passwdcount=$(sudo grep "Failed password" /var/log/auth.log | wc -l)

#display the failed attempts 
echo "Displaying failed password attempts: $failed_passwd" 
echo "Failed attemps count: $failed_passwdcount"
#generate audit report of failed logins
failed_login=$(sudo aureport -au -i --failed)
echo "Failed Authentication: $failed_login"
echo "Authentication check completed"
echo "end of script"

} | tee $reportfile