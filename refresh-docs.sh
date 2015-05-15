updateDoc() {
  git clone "https://github.com/iron/${1}.git";

  cd $1;

  cargo doc
  mkdir tmp
  mv target/doc/search-index.js new-search-index.js
  cp -Rf target/doc/* ../../doc
  cp ../../doc/search-index.js old-search-index.js
  ../../../merge-search-indices/target/release/merge-search-indices && mv merged-search-index.js ../../doc/search-index.js || mv old-search-index.js ../../doc/search-index.js

  cd -;
}

git clone https://github.com/iron/iron.github.io.git
cd iron.github.io

rm -rf doc/*
touch doc/search-index.js

mkdir tmp;
cd tmp;

updateDoc iron;
updateDoc urlencoded;
updateDoc static;
updateDoc body-parser;
updateDoc router;
updateDoc persistent;
updateDoc mount;
updateDoc logger;
updateDoc session;
updateDoc cookie;

cd ..
rm -rf tmp
