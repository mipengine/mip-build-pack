/**
 * @file 去掉版本号，并生成map
 */

'use strict';

let fs = require('fs');
let exec = require('child_process').execSync;
let path = require('path');

const FILE_VERSION_REG = /-(\d+\.){2}\d+/g;
const DIR_VERSION_REG = /\/(\d+\.){2}\d+\//;
const DEPS_FILE_REG = /deps\/[\w-]+\.js$/;

let version = process.argv[2] || 'v1';

let filesMap = {};

function getFiles(dir, callback) {
    fs.readdirSync(dir).forEach(file => {
        let pathname = path.join(dir, file);
        let stat = fs.statSync(pathname);
        if (stat.isDirectory()) {
            getFiles(pathname, callback);
        } else {
            callback(pathname);
        }
    });
}

function mkdirp(dirPath) {
    let paths = dirPath.split(path.sep);
    for (let i = 0; i < paths.length; i++) {
        let realPath = paths.slice(0, i + 1).join('/');
        if (!fs.existsSync(realPath) || !fs.statSync(realPath).isDirectory()) {
            fs.mkdirSync(realPath);
        }
    }
}

getFiles(`cache/${version}`, filePath => {
    let noVersionPath;
    // 除了deps文件，其它文件都需要替换版本
    if (!DEPS_FILE_REG.test(filePath)) {
        noVersionPath = filePath.replace(FILE_VERSION_REG, '').replace(DIR_VERSION_REG, '/');
    } else {
        noVersionPath = filePath;
    }
    noVersionPath = noVersionPath.replace(/^cache\//, '');
    filesMap[noVersionPath] = filePath;
    let dirPath = path.dirname(noVersionPath);

    if (!fs.existsSync(dirPath)) {
        mkdirp(dirPath);
    }
    fs.writeFileSync(noVersionPath, fs.readFileSync(filePath));
});

fs.writeFileSync('./map.json', JSON.stringify(filesMap));
