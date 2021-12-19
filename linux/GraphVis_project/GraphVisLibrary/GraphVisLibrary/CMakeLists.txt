project(GraphVisLibrary CXX)

add_library(GraphVisLibrary SHARED
            src/GodotLibrary.cpp
            include/Controller.h
            src/Controller.cpp
            )

target_link_libraries(GraphVisLibrary PUBLIC godot-cpp)

target_include_directories(GraphVisLibrary
                           PUBLIC
                           $<INSTALL_INTERFACE:include>
                           $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
                           PRIVATE
                           ${CMAKE_CURRENT_SOURCE_DIR}/src
                           )

