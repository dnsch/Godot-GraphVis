cmake_minimum_required(VERSION 3.17)
project(MyLibrary)

option(ARCHITECTURE "x64 or x86 CPU Architecture" "x64")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${CMAKE_BUILD_TYPE}/${ARCHITECTURE}")
set(CMAKE_CXX_STANDARD 17) # Feel free to use whatever standard you want

add_subdirectory(godot-cpp)
add_subdirectory(GraphVisLibrary)
