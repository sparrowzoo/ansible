#!/bin/bash
JAVA_OPTS=" -Xmx2g -Xms2g -Xmn300m -XX:PermSize=128m -XX:MaxPermSize=128m -Xss256k "
JAVA_OPTS=" $JAVA_OPTS -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=70 -XX:+PrintGCDateStamps -XX:+HeapDumpOnOutOfMemoryError "

PIDS=`ps -ef |grep $1| grep -v grep | awk '{ print $2 }'`
if [ -z "$PIDS" ]
then
    echo Application is already stopped
else
    echo "Stopping the $1 ..."
    for PID in $PIDS ; do

       if [[ "$$" == "$PID" ]]; then
            echo current pid $PID
       else
            if [[ -n "$!" &&  "$!" == "$PID" ]]; then
                echo parent pid $PID
            else
                echo kill $PID
                kill -9 $PID > /dev/null 2>&1
            fi
       fi
    done
fi
nohup $JAVA_HOME/bin/java $JAVA_OPTS -jar $1 >/data/start_error &