cmake_minimum_required(VERSION 3.16)
project(md4 VERSION 0.1 LANGUAGES CXX)


set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type")

option(MD4_STATIC_LINK "Build with static linking" OFF)
option(MD4_ENABLE_PROFILING "Enable gprof profiling" OFF)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED TRUE)
set(CMAKE_CXX_EXTENSIONS OFF)

file(GLOB_RECURSE MD4_SOURCES CONFIGURE_DEPENDS "src/*.cpp")
file(GLOB_RECURSE MD4_HEADERS CONFIGURE_DEPENDS "include/*.hpp")

add_library(d4 ${MD4_SOURCES} ${MD4_HEADERS})
add_library(MD4::d4 ALIAS d4)

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

set(Boost_USE_STATIC_LIBS ON)
find_package(Boost REQUIRED)
target_link_libraries(d4 PRIVATE Boost::boost)

set(MD4_THIRDPARTY_LIBS
    ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/kahypar/build/lib/libkahypar.a
    ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/flowCutter/libflowCutter.a
    ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/bipe/build/libbipe.a
    ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/bipe/3rdParty/glucose-3.0/core/libglucose.a
    ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/patoh/libpatoh.a
    ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/glucose-3.0/core/lib_glucose.a
)

find_library(ZLIB_LIBRARY z REQUIRED)
find_library(GMP_LIBRARY gmp REQUIRED)
find_library(GMPXX_LIBRARY gmpxx REQUIRED)

target_compile_definitions(d4 PRIVATE NOMAIN)

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

target_compile_options(d4 PRIVATE -Wall ${MD4_SUPPRESSED_WARNINGS})

if(MD4_STATIC_LINK)
    target_link_options(d4 PRIVATE -static)
endif()

if(MD4_ENABLE_PROFILING)
    target_compile_options(d4 PRIVATE -pg)
    target_link_options(d4 PRIVATE -pg)
endif()

target_link_libraries(d4
    PRIVATE
        ${ZLIB_LIBRARY}
        ${GMPXX_LIBRARY}
        ${GMP_LIBRARY}
        ${MD4_THIRDPARTY_LIBS}
)

include(GNUInstallDirs)

install(TARGETS d4
    EXPORT MD4Targets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(DIRECTORY include/
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/md4
)

install(EXPORT MD4Targets
    FILE MD4Targets.cmake
    NAMESPACE MD4::
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/md4
)

include(CMakePackageConfigHelpers)

configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/MD4Config.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/MD4Config.cmake
    INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/md4
)

write_basic_package_version_file(
    ${CMAKE_CURRENT_BINARY_DIR}/MD4ConfigVersion.cmake
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY SameMajorVersion
)

install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/MD4Config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/MD4ConfigVersion.cmake
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/md4
)
