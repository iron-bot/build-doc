#![feature(collections)]

use std::path::Path;
use std::fs::File;
use std::io::{Read, Write};
use std::collections::HashMap;
use std::collections::hash_map::Values;

struct Index {
    key: String,
    content: String
}

fn main() {
    let old_indices = get_indices("./old-search-index.js");
    let new_indices = get_indices("./new-search-index.js");

    let mut old_iter = old_indices.iter();
    let mut new_iter = new_indices.iter();

    let mut merged_indices = HashMap::new();
    loop {
        match old_iter.next() {
            Some(index) => { let _ = merged_indices.insert(index.key.clone(), index.content.clone()); },
            None => break
        }
    }
    loop {
        match new_iter.next() {
        // New indices will overwrite old indices
            Some(index) =>  { let _ = merged_indices.insert(index.key.clone(), index.content.clone()); },
            None => break
        }
    }

    set_indices("./merged-search-index.js", merged_indices.values());
}

fn get_indices<P: AsRef<Path>>(path: P) -> Vec<Index> {
    let mut file = match File::open(path) {
        Ok(f) => f,
        Err(_) => return Vec::new() // Non-existent file => no indices
    };
    let mut buf = String::new();

    match file.read_to_string(&mut buf) {
        Ok(_) => (),
        Err(_) => panic!("Failed to read file")
    };

    let lines = buf.split('\n');
    lines
        .filter(|l| l.find('[').is_some())
        .map(|l| {
            let key_start = l.find('[').unwrap();
            let key_end = l.find(']').unwrap();
            let key = unsafe {
                l.slice_unchecked(key_start, key_end)
            };
            Index{ key: String::from_str(key), content: String::from_str(&l) }
        })
        .collect()
}

fn set_indices<'a, P: AsRef<Path>>(path: P, mut indices: Values<'a, String, String>) {
    let mut file = match File::create(path) {
        Ok(f) => f,
        Err(_) => panic!("Failed to open file for write")
    };

    let _ = writeln!(file, "var searchIndex = {{}};");
    loop {
        match indices.next() {
            Some(index) => { let _ = writeln!(file, "{}", index); },
            None => { break }
        }
    }
    let _ = writeln!(file, "initSearch(searchIndex);");
}
