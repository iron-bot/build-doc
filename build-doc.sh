if [ "$TRAVIS_BRANCH" = 'master' ] && [ "$TRAVIS_PULL_REQUEST" = 'false' ]; then
  git clone https://github.com/iron/iron.github.io.git docs
  curl https://raw.githubusercontent.com/iron/iron.github.io/master/head.html > head.html
  curl https://raw.githubusercontent.com/iron/iron.github.io/master/header.html > header.html
  curl https://raw.githubusercontent.com/iron/iron.github.io/master/footer.html > footer.html
  # Log is included in the toolchain for rustdoc, so we must override it to use our own
  ls target/debug/deps/liblog-*.rlib | xargs -I % rustdoc -L ./target/debug/deps --extern log=% -o ./docs/doc src/lib.rs --html-in-header ./head.html --html-before-content ./header.html --html-after-content ./footer.html
  cd docs && git add --all
  git config user.name "iron-bot"
  git config user.email "ironframework@gmail.com"
  git commit -m "(docs-autogen) ${TRAVIS_REPO_SLUG}."
  git push -q "https://${TOKEN}:x-oauth-basic@github.com/iron/iron.github.io.git" master
fi
