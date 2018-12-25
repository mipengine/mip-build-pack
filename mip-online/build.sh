#!/bin/bash
echo "start mip package";
cd `dirname $0`
pwd
echo "pull mip-online";
git pull
# 如果编译目录不存在，创建目录并更新github
sh src/create.sh
# 编译
sh src/compile.sh
# 复制备份目录
sh src/backcode.sh
echo "end mip package";