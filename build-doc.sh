if [ "$TRAVIS_BRANCH" = 'master' ] && [ "$TRAVIS_PULL_REQUEST" = 'false' ] && [ "$TRAVIS_RUST_VERSION" = 'nightly' ]; then
  # Fetch the docs
  git clone https://github.com/iron/iron.github.io.git docs
  
  # TODO: Custom stylings

  # Doc the crate and its dependencies
  cargo doc --all-features
  mkdir tmp
  mv target/doc/search-index.js new-search-index.js
  cp docs/doc/search-index.js old-search-index.js
  # Update the docs
  cp -Rf target/doc/* docs/doc
  # Update the search indices
  curl -L -O https://raw.githubusercontent.com/iron-bot/build-doc/master/merge-search-indices/target/release/merge-search-indices
  chmod +x merge-search-indices
  ./merge-search-indices && mv merged-search-index.js docs/doc/search-index.js

  cd docs && git add --all
  git config user.name "iron-bot"
  git config user.email "ironframework@gmail.com"
  git commit -m "(docs-autogen) ${TRAVIS_REPO_SLUG}."
  git push -q "https://${TOKEN}:x-oauth-basic@github.com/iron/iron.github.io.git" master
fi
