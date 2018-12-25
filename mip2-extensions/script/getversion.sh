#!/bin/bash
cd `dirname $0`
if  [ ! -n "$1" ] ;then
    echo "Require a project name"
    exit 0
fi
# 需要取版本的项目
project=$1
if [ "$project" = "mip" ]; then
    reg="MIP_TAG:[^\s]+"
else
    reg="EXTENSION_TAG:[^\s]+"
fi
version=`cat ../changelog | grep -o -E $reg | head -n 1 | awk -F ':' '{print $2}'`
echo $version
