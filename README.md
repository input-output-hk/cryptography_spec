# Cryptography Handbook
This document forms the IOG Cryptography Handbook, which aims to provide a go-to for engineers having
to make a choice on which implementations to use for given cryptographic primitives.
This document contains a specification of all the cryptographic primitives being used in production,
or in testing phase, and at least a reference to the ongoing efforts of other cryptographic primitives.

One can find the book here https://input-output-hk.github.io/cryptography_spec/

This is an ongoing process, and we will extend this effort to several other projects.

## Build and run the book

To build and run the website locally, one first needs to install mdbook. You can follow the instructions in the [official site](https://rust-lang.github.io/mdBook/guide/installation.html)

Then, to serve the website locally and run it in the default browser, run
```shell
mdbook serve --open
```

