#!/bin/bash

script_path=$(cd `dirname $0` && pwd)

cd $script_path

# 引入conf文件
. ./conf

cd $compile_path

# 编译 mip
cd mip
mip_version=`sh $script_path/getversion.sh mip`
git pull origin master
git checkout $mip_version
npm i
rm -rf dist
npm run build
cd ..

# 编译 extensions
cd extensions
extensions_version=`sh $script_path/getversion.sh extensions`
git pull origin master
git checkout $extensions_version
npm i
rm -rf dist
npm run build
cd ..

# 编译生成的文件都是带小版本的，将带小版本的文件复制到cache/[大版本]目录下
version_path=output/cache/$version
mkdir -p $version_path
cp -r mip/dist/* $version_path
cp -r extensions/dist/* $version_path
cp -r mip-static/* output/

# 生成不包含version的文件和map.json
cd output
node double-files.js $version
find -name '*.md' | xargs rm
rm double-files.js
