# Introduction
``` warning
This document is WORK IN PROGRESS. While the document
has this warning, check with your local cryptographer
whether the final solution is correct for your 
particular use case.
```

This document forms the IOG Cryptography Handbook, which aims to provide a go-to for engineers having 
to make a choice on which implementations to use for given cryptographic primitives.
This document contains a specification of all the cryptographic primitives being used in production,
or in testing phase, and at least a reference to the ongoing efforts of other cryptographic primitives.

The target audience for the Handbook is everyone working on a project associated with an IOG product, 
or within the Cardano ecosystem. This is also the set of target contributors for the Handbook! Anyone 
can submit a change proposal as a PR (see ['Contributing'](#contributing)).

# Purpose
The purpose of this handbook is both descriptive and to list existing implementations:

* Firstly, it lists particular implementations for given cryptographic primitives that are being 
used, or have been reviewed, by IOG matter experts. 
* Secondly, it describes the cryptographic primitives in detail (or points interested reader to 
further material), to allow engineers to choose alternative implementation which are compatible
with the primitives used by IOG. 

# Goals

The goals of the Handbook are to:

* Provide a place to record all cryptographic libraries being used in IOG projects.
* Present a sufficient level of detail of the cryptographic primitives to allow engineers
  to make independent decisions without having to contact matter experts or look into 
  the source code.
* Encourage consistency across the organization in order to minimize cognitive overheads 
  from unnecessary differences.
* Avoid implementing of primitives that already exist and/or are being used in IOG.
* List common mistakes when handling with these type of libraries.

# Non-goals

The following are explicitly not goals of the Handbook:

* The recommended libraries are by no means flawless. As in any piece of software, the libraries
  hereby listed can have bugs. 
* Provide an exhaustive list of all available implementations in all languages. We only have a limited
  number of cryptographers, and this list will grow as we look into existing implementation of used
  primitives. 

The Handbook is very new and will gradually acquire more content over time. We hope to 
improve all of this over time!

# Contributing
If a project needs a particular primitive, which is not present in this document, the mechanism
to include is simple. Add an issue to the 
[repo](https://github.com/input-output-hk/cryptography_spec), specifying why such a
primitive is of interest, and how it would be used. To make the discussion more effective,
it is also of interest to link references to the specification, or available implementations.

