cmake_minimum_required(VERSION 3.21)
project(pocketbook-sdk-qt6 CXX)

if(NOT POCKETBOOK_TOOLCHAIN_LOADED)
  message(FATAL_ERROR
    "Configure inside the builder image, which points CMAKE_TOOLCHAIN_FILE at its own copy, or "
    "pass -DCMAKE_TOOLCHAIN_FILE=<this repo>/cmake/pocketbook.toolchain.cmake. Everything here "
    "cross-compiles for the device; there is no host build.")
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
include(PocketBookQt)
include(PocketBookSDK)
include(PocketBookApp)

option(POCKETBOOK_BUILD_EXAMPLE "Build the kitchen sink example app"
       ${PROJECT_IS_TOP_LEVEL})
if(POCKETBOOK_BUILD_EXAMPLE)
  add_subdirectory(example)
endif()
