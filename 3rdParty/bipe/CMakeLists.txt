cmake_minimum_required(VERSION 3.10)
project(bipe VERSION 0.1 LANGUAGES CXX)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

option(MD4_ENABLE_PROFILING "Enable gprof profiling" OFF)
option(MD4_ENABLE_TESTS "Register CTest tests" OFF)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_EXTENSIONS OFF)

file(GLOB_RECURSE SOURCES CONFIGURE_DEPENDS "./src/**.cpp")
file(GLOB_RECURSE INCLUDES CONFIGURE_DEPENDS "./include/**.hpp")

# -----------------------------------------------
# DEPENDENCIES
# -----------------------------------------------

set(DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/glucose-3.0/core/libglucose.a)

# -----------------------------------------------
# LIBRARY BIPE
# -----------------------------------------------

add_library(bipe ${SOURCES})

target_include_directories(bipe
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include/bipe>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/
        ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/glucose-3.0/
)

set(BIPE_SUPPRESSED_WARNINGS
        -Wno-class-memaccess
        -Wno-format
        -Wno-misleading-indentation
        -Wno-literal-suffix
        -Wno-sign-compare
        -Wno-parentheses
)

target_link_libraries(bipe PRIVATE ${DEPENDENCY})
target_compile_definitions(bipe PRIVATE NOMAIN)
target_compile_options(bipe PRIVATE -Wall ${BIPE_SUPPRESSED_WARNINGS})

if(MD4_ENABLE_PROFILING)
    target_compile_options(bipe PRIVATE -pg)
    target_link_options(bipe PRIVATE -pg)
endif()

# -----------------------------------------------
# INSTALLATION AND EXPORT
# -----------------------------------------------

install(TARGETS bipe EXPORT md4Targets DESTINATION lib)
install(FILES ${HEADERS} DESTINATION include/${CMAKE_PROJECT_NAME})

file(GLOB cmake_generated ${CMAKE_CURRENT_SOURCE_DIR}/srcBipe/*~)
foreach(file ${cmake_generated})
  if (EXISTS ${file})
     file(REMOVE_RECURSE ${file})
  endif()
endforeach(file)
