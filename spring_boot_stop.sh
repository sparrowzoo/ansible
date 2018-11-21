#!/bin/bash

PID=`ps -ef |grep $1| grep -v grep | awk '{ print $2 }'`
if [ -z "$PID" ]
then
    echo Application is already stopped
else
    echo "Stopping the $1 ..."
    kill -9 $PID > /dev/null 2> 1 &
fi