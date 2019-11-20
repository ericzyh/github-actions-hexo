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

# generate&publish
npx hexo g
npx hexo d

# update files
INPUT_BRANCH=${INPUT_BRANCH:-master}

#if ${INPUT_IF_UPDATE_FILES}; then
    [ -z "${INPUT_GITHUB_TOKEN}" ] && {
        echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".'
        exit 1
    }
    remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${GITHUB_REPOSITORY}.git"
    if [ -z "$(git status --porcelain)" ]; then
        echo "nothing to update."
    else
        git commit -m "triggle by commit ${GITHUB_SHA}" -a
        git push "${remote_repo}" HEAD:${INPUT_BRANCH}
    fi
#fi
