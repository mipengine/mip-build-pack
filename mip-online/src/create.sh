#!/bin/bash

script_path=$(cd `dirname $0` && pwd)
cd $script_path

# 引入conf文件
. ./conf

# 创建编译目录
if [ ! -d "$compile_path" ]; then
    mkdir -p $compile_path
fi

# 删除产品库 output
rm -rf ../output

# 创建产出目录
rm -rf $compile_path/output
mkdir $compile_path/output

# 把 double-files.js 复制到编译目录
# double-files.js 用于创建不含version的文件，并生成map.json
cp ./double-files.js $compile_path/output

cd $compile_path

# 下载MIP项目
if [ ! -d "mip" ]; then
    git clone https://github.com/mipengine/mip.git mip
fi

# 下载extensions项目
if [ ! -d "extensions" ]; then
    git clone https://github.com/mipengine/mip-extensions.git extensions
fi

# 下载 MIP 老版本文件
if [ ! -d "mip-static" ]; then
    git clone https://github.com/mipengine/mip-assets.git mip-static
fi

# 更新编译工具
npm up -g mip-extension-optimizer
