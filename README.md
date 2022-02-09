# Spec of cryptographic primitives

To facilitate the analysis of changes, we've included a diff strategy. If you are planning on making
changes, please follow these steps to create diff pdfs that will help reviewing changes. 

1. When you begin your new branch, you must commit to the current state. To this end, run
```shell
make init
```

2. Once you have made your changes and are ready to create the diff, run
```shell
make compile-diff
```

3. Finally, once your changes are ready to be merged, you should clean the diff files
```shell
make clean
```

Make sure you include the diff.pdf file in your PR so that it helps with the reviewing process. If
you encounter any problems following the above steps, please file an issue. We are always trying
to improve the usability. 