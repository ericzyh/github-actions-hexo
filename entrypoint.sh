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

mkdir /workspace

cd /workspace 

npx hexo init

rm -fr source/_posts
 

mv  ${GITHUB_WORKSPACE}/*  source/
git clone https://${GITHUB_ACTOR}:${INPUT_DEPLOYKEY}@github.com/${GITHUB_ACTOR}/${GITHUB_ACTOR}.github.io.git
mv ${GITHUB_ACTOR}.github.io public
rm node_modules/anymatch/README.md
# generate&publish
npx hexo g
npx hexo d

cd public

git commit -m "up"

git push
