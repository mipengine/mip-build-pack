#!/bin/bash
script_path=$(cd `dirname $0` && pwd)
tar_name=output.tar.gz
mip_version=v1
platform_dir=mip-extensions-platform
output=output
# 编译&打包
function compileMip()
{
    $script_path/node_modules/mip-extension-optimizer/bin/main -o $script_path/$mip_version $script_path/$platform_dir/
    # 清除版本号文件夹
    clearVersionDir

    npm i
    BUILD_TAG=v1-platform npm run build
    cd ..
    mkdir -p $output/$mip_version/
    cp -r ./$mip_version/* ./$output/$mip_version/

    cd $output
    # 打包成输出约定的output包
    tar -czf ../$tar_name ./
    cd ..
    rm -rf ./$output/*
    # 移动到输出文件夹
    mv $script_path/$tar_name $script_path/$output
    echo 'compile done.'
}
# 清除版本号文件夹
function clearVersionDir()
{
    for extNames in $script_path/$mip_version/*
    do
        if [ -d $extNames ]
        then
            for files in $extNames/*
            do
                if [ -d $files ]
                then
                    cp -r $files/* $(cd $files && cd .. && pwd)
                    rm -rf $files
                fi
            done
        fi
    done
}
# 环境准备
function envInit()
{
    npm i
    # 删除原有git仓库
    [ -d $platform_dir ] && rm -rf $platform_dir
    # 删除 mip-sw 仓库

    # 删除原有输出文件夹
    [ -d output ] && rm -rf $output
    mkdir -p $script_path/output
    # clone最新仓库
    git clone https://mip-platform:mip-platform2bd@github.com/mipengine/mip-extensions-platform.git $platform_dir
    if [ ! -d $platform_dir ]; then
        echo 'git clone $platform_dir failed!'
        exit 1
    fi
    echo 'init done.'
}

function cleanTemp()
{
    rm -rf $script_path/$mip_version
    rm -rf $script_path/$platform_dir

    rm -rf $script_path/node_modules
    echo 'clean done.'
}
envInit
compileMip
cleanTemp
echo 'compile successfully.'
exit 0
