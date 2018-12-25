const path = require('path');
const fs = require('fs');
const execa = require('execa');
const async = require('async');
const extensionsDir = path.resolve(__dirname, '../mip_platform_extensions_deploy/extensions');
const projects = fs.readdirSync(path.join(extensionsDir, 'sites')).filter(file =>
    fs.statSync(path.join(extensionsDir, 'sites', file)).isDirectory()
);
if (projects.length < 1) {
    console.log('ERR: No mip site found');
    return;
}
const build = function (proj, done) {
    let src = path.join(extensionsDir, 'sites', proj);
    let dist = path.join(extensionsDir, 'dist', proj);
    let publicPath = 'https://c.mipcdn.com/static/v2/' + proj;
    let options = ['build', '--dir', src, '--output', dist, '--asset', publicPath, '--clean'];

    execa('mip2', options)
        .then(res => {
            done();
        })
        .catch(err => {
            console.log(err);
            process.exit(1);
        });
};
console.log('Building... Please wait');
async.each(projects, build, err => {
    if (err) {
        console.log(err);
    }
    else {
        console.log('All sites has been build successfully!');
    }
});