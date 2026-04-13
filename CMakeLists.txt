cmake_minimum_required(VERSION 3.10)
project(md4 VERSION 0.1 LANGUAGES CXX)

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
endif()

# option(MD4_STATIC_LINK "Build with static linking" OFF)
option(MD4_ENABLE_PROFILING "Enable gprof profiling" OFF)
option(MD4_ENABLE_TESTS "Register CTest tests" OFF)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_EXTENSIONS OFF)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

file(GLOB_RECURSE MD4_SOURCES CONFIGURE_DEPENDS "src/*.cpp")
file(GLOB_RECURSE MD4_HEADERS CONFIGURE_DEPENDS "include/*.hpp")

# -----------------------------------------------
# DEPENDENCIES
# -----------------------------------------------

find_package(Boost       REQUIRED COMPONENTS program_options)

find_package(GMP         MODULE REQUIRED)
find_package(GMPXX       MODULE REQUIRED)
find_package(Flowcutter  MODULE REQUIRED)
find_package(Bipe        MODULE REQUIRED)
find_package(Glucose     MODULE REQUIRED)
find_package(Patoh       MODULE REQUIRED)

set(dependencies
    Boost::boost
    Boost::program_options
    GMP::gmp
    GMPXX::gmpxx
    bipe
    flowcutter
    glucose_d4
    Patoh::patoh
)

set(MD4_SUPPRESSED_WARNINGS
    -Wno-strict-aliasing
    -Wno-class-memaccess
    -Wno-format
    -Wno-misleading-indentation
    -Wno-literal-suffix
    -Wno-sign-compare
    -Wno-parentheses
    -Wno-restrict
)

# -----------------------------------------------
# LIBRARY D4
# -----------------------------------------------

add_library(d4 SHARED ${MD4_SOURCES} ${MD4_HEADERS})

target_include_directories(d4
    PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty
        ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/glucose-3.0
        ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/bipe
        ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/flowCutter
)

target_link_libraries(d4 PRIVATE ${dependencies})
target_compile_definitions(d4 PRIVATE NOMAIN)
target_compile_options(d4 PRIVATE -Wall ${MD4_SUPPRESSED_WARNINGS})

if(MD4_ENABLE_PROFILING)
    target_compile_options(d4 PRIVATE -pg)
    target_link_options(d4 PRIVATE -pg)
endif()

# -----------------------------------------------
# DEMO EXECUTABLES
# -----------------------------------------------

add_executable(d4_counter_bin
    demo/counter/src/Main.cpp
    demo/counter/src/CounterDemo.cpp
    demo/counter/src/ParseOption.cpp)

target_link_libraries(d4_counter_bin
    PRIVATE
        d4
        Boost::program_options
        GMP::gmp
)

add_executable(d4_compiler_bin
    demo/compiler/src/Main.cpp
    demo/compiler/src/CompilerDemo.cpp
    demo/compiler/src/ParseOption.cpp)

target_link_libraries(d4_compiler_bin 
    PRIVATE
        d4
        Boost::program_options 
        GMP::gmp
)

# -----------------------------------------------
# TESTING
# -----------------------------------------------

if(MD4_ENABLE_TESTS)
    enable_testing()
    include(cmake/Testing.cmake)
endif()

# -----------------------------------------------
# INSTALLATION AND EXPORT
# -----------------------------------------------

include(GNUInstallDirs)

install(TARGETS d4
    EXPORT md4Targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(DIRECTORY include/
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/md4
)

install(EXPORT md4Targets
    FILE md4Targets.cmake
    NAMESPACE md4::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/md4
)

include(CMakePackageConfigHelpers)

configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/md4Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/md4Config.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/md4
)

write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/md4ConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/md4Config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/md4ConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/md4
)
