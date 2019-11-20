#!/bin/sh
set -e

# setup key
mkdir -p /root/.ssh/
echo "${INPUT_DEPLOYKEY}" >/root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
ssh-keyscan -t rsa github.com >>/root/.ssh/known_hosts

git config --global user.name "${INPUT_USERNAME}"
git config --global user.email "${INPUT_EMAIL}"

# setup hexo env
npm install hexo-cli
npm install

mkdir workspace

cd workspace 

npx hexo init

rm -fr source/_posts

apt-get install rsync   #安装rsync

rsync -av --exclude  workspace ../   workspace/source/
 
 
git clone git@github.com:ericzyh/ericzyh.github.io.git

mv ericzyh.github.io.git public

# generate&publish
npx hexo g
npx hexo d

cd public

git commit -m "up"

git push
