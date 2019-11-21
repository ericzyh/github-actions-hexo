#!/bin/sh
set -e

# setup key
mkdir -p /root/.ssh/
echo "${INPUT_DEPLOYKEY}" >/root/.ssh/id_rsa
echo "${INPUT_DEPLOYKEY}"
echo "${INPUT_USERNAME}"
echo "${{ secrets.GITHUB_TOKEN }}"
exit
chmod 600 /root/.ssh/id_rsa
ssh-keyscan -t rsa github.com >>/root/.ssh/known_hosts

git config --global user.name "${INPUT_USERNAME}"
git config --global user.email "${INPUT_EMAIL}"

# setup hexo env
npm install hexo-cli
npm install

mkdir /workspace

cd /workspace 

npx hexo init

rm -fr source
  
git clone https://${GITHUB_ACTOR}:${INPUT_DEPLOYKEY}@github.com/${GITHUB_REPOSITORY} source

git clone https://${GITHUB_ACTOR}:${INPUT_DEPLOYKEY}@github.com/${GITHUB_ACTOR}/${GITHUB_ACTOR}.github.io.git public 
 
# generate&publish
npx hexo g
npx hexo d

cd public

git add .

git commit -m "up"

git push
