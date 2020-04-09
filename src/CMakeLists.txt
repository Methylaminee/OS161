cmake_minimum_required(VERSION 3.13)
project(os161)
set(CMAKE_C_COMPILER /tools/bin/ CACHE PATH "")
set(CMAKE_CXX_COMPILER /tools/bin/ CACHE PATH "")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=gnu99")

include_directories(kern/include)
include_directories(kern/compile/FirstOS/includelinks)
include_directories(kern/compile)

include_directories(userland/include)

file(GLOB_RECURSE INCLUDE_DIRECTORIES "${PROJECT_SOURCE_DIR}/*.h")
file(GLOB_RECURSE SOURCE_FILES "${PROJECT_SOURCE_DIR}/*.c")

add_executable(os161 ${INCLUDE_DIRECTORIES} ${SOURCE_FILES})