#!/bin/bash

script_path=$(cd `dirname $0` && pwd)
cd $script_path
# 引入conf文件
. ./conf

cp -r $compile_path/output ..
cd ../output
tar -czvf ../output.tar.gz ./
rm -rf ./*
rm -rf ./.[!.]*
cp ../output.tar.gz ./
rm -rf ../output.tar.gz
