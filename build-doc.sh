if [ "$TRAVIS_BRANCH" = 'master' ] && [ "$TRAVIS_PULL_REQUEST" = 'false' ]; then
  git clone https://github.com/iron/iron.github.io.git docs
  curl https://raw.githubusercontent.com/iron/iron.github.io/master/head.html > head.html
  curl https://raw.githubusercontent.com/iron/iron.github.io/master/header.html > header.html
  curl https://raw.githubusercontent.com/iron/iron.github.io/master/footer.html > footer.html
  rustdoc -L ./target/deps -o ./docs/doc src/lib.rs --html-in-header ./head.html --html-before-content ./header.html --html-after-content ./footer.html
  cd docs && git add --all
  git config user.name "iron-bot"
  git config user.email "ironframework@gmail.com"
  git commit -m "(docs-autogen) ${TRAVIS_REPO_SLUG}."
  git push -q "https://${TOKEN}:x-oauth-basic@github.com/iron/iron.github.io.git" master
fi
