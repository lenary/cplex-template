# CMake version
cmake_minimum_required(VERSION 3.10 FATAL_ERROR)

# CHANGE: Project Options
project(cplex-template)

# Include Directory
include_directories(${PROJECT_SOURCE_DIR}/include)

# CMake Build Type
if (NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Debug" CACHE STRING "Choose the type of build")
    # Set the possible values of build type for cmake-gui
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
        "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

# C++ Standard: C++14
set(CMAKE_CXX_STANDARD 14)

# CPLEX Helper: target_cplex(TGT) for targets that require cplex
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
include(CPLEX)

# Google Test
enable_testing()
configure_file(CTestConfig.cmake.in CTestConfig.cmake @ONLY)
include (CTest)
set(GTEST_ROOT ${PROJECT_SOURCE_DIR}/gtest)
find_package(GTest REQUIRED)
include(GoogleTest)

# Experiment Executables: add_experiment(NAME Sources...) adds an experiment
function(add_experiment NAME)
    add_executable(${NAME} ${ARGN})

    # Experiments normally need CPLEX
    target_cplex(${NAME})

    # Experiments are GTest files
    target_include_directories(${NAME} PRIVATE ${GTEST_INCLUDE_DIRS})
    add_dependencies(${NAME} GTest::GTest GTest::Main)
    gtest_discover_tests(${NAME})
endfunction()

add_subdirectory(src)
