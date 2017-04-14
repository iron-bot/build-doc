#!/bin/bash
set -xe

if [ "$TRAVIS_BRANCH" = 'master' ] && [ "$TRAVIS_PULL_REQUEST" = 'false' ] && [ "$TRAVIS_RUST_VERSION" = 'nightly' ]; then
  # Fetch the docs
  git clone https://github.com/iron/iron.github.io.git docs

  DOC_NAME="${TRAVIS_REPO_SLUG##*/}"

  cd docs/doc/
  rm -rf $DOC_NAME
  mkdir $DOC_NAME
  cd $DOC_NAME
  echo "<meta http-equiv=refresh content='0; URL=https://docs.rs/$DOC_NAME'>" > index.html

  git add --all
  git config user.name "iron-bot"
  git config user.email "ironframework@gmail.com"
  git commit -m "(docs-autogen) ${TRAVIS_REPO_SLUG}."
  git push -q "https://${TOKEN}:x-oauth-basic@github.com/iron/iron.github.io.git" master
fi
