#!/usr/bin/expect

#使用第一个参数 
set server_ip [lindex $argv 0] 
#后面的也可以用参数[lindex $argv n] 
set server_user [lindex $argv 1]
set server_pswd [lindex $argv 2]
set server_port [lindex $argv 3] 
set project_name  [lindex $argv 4]
set commod_sript  ./auto_deploy.sh $project_name

set time 30
spawn ssh $server_user@$server_ip -p $server_port $commod_sript
expect {
   "*yes/no"
        {
          send "yes\r";
          exp_continue
        }
   "*password:"
       {
          send "$server_pswd\r"
       }
  }
expect "*$"
#send "./auto_deploy.sh $project"
expect "*$"
send "exit\r"
#interact
expect eof
