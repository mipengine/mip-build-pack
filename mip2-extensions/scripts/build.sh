#!/bin/bash
echo "start mip2-extensions package";

script_path=$(cd `dirname $0` && pwd)
cd $script_path

# 官方组件
EXTENSIONS_URL=https://github.com/mipengine/mip2-extensions.git
# public path
PUBLIC_PATH=https://c.mipcdn.com/static/v2

version=v2

# 工作目录
compile_path=../mip2_extensions_deploy
# 输出目录
output=../output
# 创建编译目录
rm -rf $compile_path && mkdir -p $compile_path
# 创建 output
rm -rf $output && mkdir -p $output/$version
cd $compile_path

# 下载extensions项目
if [ ! -d "extensions" ]; then
    git clone $EXTENSIONS_URL extensions
fi

# 编译 extensions
cd extensions
extensions_version=`sh $script_path/getversion.sh extensions`

{
    git checkout $extensions_version
} || {
    exit 1
}

npm i
rm -rf dist
echo "mip2 cli version: "
echo `../../node_modules/mip2/bin/mip2 -V`
../../node_modules/mip2/bin/mip2-build --asset $PUBLIC_PATH -i
cd ..
# 编译产物移动到 output/v2
cp -r extensions/dist/* ../output/$version/
cd ../output

tar -czvf ../output.tar.gz ./
rm -rf ../output/*
mv ../output.tar.gz ../output
# 清理工作目录
rm -rf ../mip2_extensions_deploy
echo "end mip2 extensions package";