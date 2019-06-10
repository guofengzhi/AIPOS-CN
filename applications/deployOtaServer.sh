#!/bin/bash
#默认变量值
OTASERVER_HOME="/home/posota/otaserver"
OTASERVER_PORT=8080
PROJECT="$1"
#参数检验./deploy.sh <projectname> [otaserver port] [otaserver home dir]
if [ $# -lt 1 ]; then
  echo "you must use like this : ./deploy.sh <projectname> [otaserver port] [otaserver home dir]"  
  exit
fi
echo "before " $OTASERVER_HOME $OTASERVER_PORT 
if [ -n "$2" ]; then
   OTASERVER_PORT=$2
fi
if [ -n "$3" ]; then
   OTASERVER_HOME="$3"
fi

echo "stoped otaserver"

"$OTASERVER_HOME"/bin/stop.sh
echo "stoping  otaserver ......"
sleep 5

echo "otaserver is stoped start deploy project....."
#备份路径
echo "start backup project ...."
BAK_DIR=$HOME/deploy/jar/bak/$PROJECT/`date +%Y%m%d`
mkdir -p "$BAK_DIR"
cp "$OTASERVER_HOME"/$PROJECT-*.jar "$BAK_DIR"/"$PROJECT"_`date +%H%M%S`.jar
echo "end backup project ......"


#publish project
echo "OtaServer ,$PROJECT publishing"
if [ ! -f "$HOME/deploy/jar/$PROJECT-*.jar " ]; then
  echo "There is no jar file Please upload need deploy file ......"
  exit
fi
rm -rf "$OTASERVER_HOME"/BOOT-INF/
rm -rf "$OTASERVER_HOME"/$PROJECT-*.jar
cp $HOME/deploy/jar/$PROJECT-*.jar "$OTASERVER_HOME"/$PROJECT-*.jar
echo "Deploy Otaserver ............"
"$OTASERVER_HOME"/bin/deploy.sh $OTASERVER_HOME

echo "Deployed finished otaserver starting otaserver"
#remove tmp
rm -rf $HOME/deploy/jar/$PROJECT-*.jar
#start otaserver
"$OTASERVER_HOME"/bin/run.sh
sleep 10


echo "otaserver is starting,please try to access $PROJECT conslone url"
