which ack || brew install ack;

updateDoc() {
  git clone "https://github.com/iron/${1}.git";

  cd $1;

  cargo build;
  cargo test;

  cratename=`ack -m1 'name.*\"(.*)\"$' Cargo.toml --output='$1'`
  ls target/debug/deps/liblog-*.rlib | xargs -I % rustdoc -L ./target/debug/deps --extern log=% -o ../../doc src/lib.rs --crate-name="$cratename" --html-in-header ../../head.html --html-before-content ../../header.html --html-after-content ../../footer.html

  cd -;
}

git clone https://github.com/iron/iron.github.com.git
cd iron.github.com

rm -rf doc

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

# Update iron again to update the indices
updateDoc iron;

cd ..
rm -rf tmp
