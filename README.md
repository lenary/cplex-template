cplex-example
-------------

An example of using [CPLEX](https://www.ibm.com/analytics/data-science/prescriptive-analytics/cplex-optimizer) and
[Google Test](https://github.com/google/googletest/tree/master/googletest) to run MIP experiments from C++.

## Instructions

1. Download this repository, delete the `.git` directory and `git init`
1. Run `cmake --build gtest` to build Google Test
1. Install CPLEX, noting down the install directory,
   something like `/opt/IBM/ILOG/CPLEX_Studio<VERSION>`
1. Rename project in `CMakeFiles.txt`
1. Create a `build` dir not within this directory, `cd` to it.
1. Run `cmake --build ../<this directory> -DCPLEX_STUDIO_DIR=<cplex install path> -DCPLEX_SYSTEM=<system>`
   where `<system>` is `x86-64_linux` for Linux and `x86-64_osx` for Mac.
1. You're done with setup. Develop in this directory, add experiments/libraries
   using functions in `src/CMakeLists.txt`. Build and run these in the `build` directory
   using `make <target name>`.
1. You can run all the experiments using `make test` I think.
1. You can probably put your own information in `README.md`
