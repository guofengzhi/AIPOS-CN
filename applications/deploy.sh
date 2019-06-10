#!/bin/bash
#默认变量值
TOMCAT_HOME="/home/posota/app/apache-tomcat-7.0.81"
TOMCAT_PORT=8080
PROJECT="$1"
#参数检验./deploy.sh <projectname> [tomcat port] [tomcat home dir]
if [ $# -lt 1 ]; then
  echo "you must use like this : ./deploy.sh <projectname> [tomcat port] [tomcat home dir]"  
  exit
fi
echo "before " $TOMCAT_HOME $TOMCAT_PORT 
if [ -n "$2" ]; then
   TOMCAT_PORT=$2
fi
if [ -n "$3" ]; then
   TOMCAT_HOME="$3"
fi
echo "after " $TOMCAT_HOME $TOMCAT_PORT

"$TOMCAT_HOME"/bin/shutdown.sh
echo "stoping  tomcat......"
sleep 20


#根据端口查找tomcatpid,可能有多个,循环中判断
tomcat_pid=`netstat -anp | grep $TOMCAT_PORT | awk '{printf $7}' | cut -d "/" -f 1`
echo "current :" $tomcat_pid
while [ -n "$tomcat_pid" ]
do
 sleep 5
 #进一步筛选
 tomcat_pid=`ps -ef | grep $tomcat_pid |grep $TOMCAT_HOME | grep -v 'grep\|tail\|more\|bash\|less'| awk '{print $2}'`
 echo "scan tomcat pid :" $tomcat_pid
 if [ -n "$tomcat_pid" ]; then
   echo "kill tomcat :" $tomcat_pid
   kill -9 $tomcat_pid
 fi
done
echo "tomcat is stoped start deploy project....."
#备份路径
echo "start backup project ...."
BAK_DIR=$HOME/war/bak/$PROJECT/`date +%Y%m%d`
mkdir -p "$BAK_DIR"
cp "$TOMCAT_HOME"/webapps/$PROJECT.war "$BAK_DIR"/"$PROJECT"_`date +%H%M%S`.war
echo "end backup project ......"
echo "start backup upload forder"
BAK_DIR_UPLOAD=$HOME/war/bakUpload/$PROJECT/`date +%Y%m%d`

mkdir -p "$BAK_DIR_UPLOAD"
cp -rf "$TOMCAT_HOME"/webapps/$PROJECT/WEB-INF/upload "$BAK_DIR_UPLOAD"/upload
echo "end backup upload forder"

#publish project
echo "scan no tomcat pid,$PROJECT publishing"
rm -rf "$TOMCAT_HOME"/webapps/$PROJECT
rm -rf "$TOMCAT_HOME"/webapps/$PROJECT.war
cp $HOME/war/$PROJECT.war "$TOMCAT_HOME"/webapps/$PROJECT.war

#remove tmp
rm -rf $HOME/war/$PROJECT.war
#start tomcat
"$TOMCAT_HOME"/bin/startup.sh
sleep 10

cp -rf  "$BAK_DIR_UPLOAD"/upload "$TOMCAT_HOME"/webapps/$PROJECT/WEB-INF/upload
echo "tomcat is starting,please try to access $PROJECT conslone url"
