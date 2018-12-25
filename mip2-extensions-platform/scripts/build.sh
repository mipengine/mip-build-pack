#!/bin/bash
echo "start mip2-extensions-platform package";
script_path=$(cd `dirname $0` && pwd)
cd $script_path
# 站长组件
EXTENSIONS_URL=https://github.com/mipengine/mip2-extensions-platform.git
# public path
PUBLIC_PATH=https://c.mipcdn.com/static/v2
version=v2
sitesDir=sites
# 工作目录
compile_path=../mip_platform_extensions_deploy
# 输出目录
output=../output
# 创建编译目录
rm -rf $compile_path
mkdir -p $compile_path
# 创建 output
rm -rf $output
mkdir -p $output/$version
cd $compile_path

# 下载extensions项目
rm -rf extensions
git clone $EXTENSIONS_URL extensions
# 编译 extensions
cd extensions
git pull origin master

echo "========= commit log (latest 5) ==========="
echo `git log --decorate -5`

if  [ ! -d "sites" ] ;then
    echo "git clone failed !! sites dir not found"
    exit 1
fi

# install dependencies for each site
for sitePath in $sitesDir/*
do
    if [ -d $sitePath ]
    then
        site=`basename $sitePath`
        cd $sitesDir/$site
        npm install --production
        cd ../..
    fi
done
# build each site in parallel
node $script_path/build-site.js
if [ $? -ne 0 ]; then
    echo "build failed"
    exit 1
else
    echo "build succeed"
fi
# 编译产物移动到 output/v2
cp -r dist/* ../../output/$version/
cd ../../output

tar -czvf ../output.tar.gz ./
rm -rf ../output/*
mv ../output.tar.gz ../output
# 清理工作目录
rm -rf ../mip_platform_extensions_deploy
echo "end mip-platform-extensions package"