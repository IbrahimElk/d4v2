include(ExternalProject)

set(GLUCOSE_D4_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/glucose-3.0")
set(GLUCOSE_D4_CORE "${GLUCOSE_D4_ROOT}/core")
set(GLUCOSE_D4_LIB  "${GLUCOSE_D4_CORE}/lib.a")

set(GLUCOSE_BUILD_TARGET libst)
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(GLUCOSE_BUILD_TARGET libd)
endif()

ExternalProject_Add(glucose_d4_external
    SOURCE_DIR "${GLUCOSE_D4_ROOT}/core"
    CONFIGURE_COMMAND ""
    BUILD_COMMAND make ${GLUCOSE_BUILD_TARGET}
    BUILD_IN_SOURCE TRUE
    INSTALL_COMMAND ""
)

add_library(glucose_d4 STATIC IMPORTED GLOBAL)
set_target_properties(glucose_d4 PROPERTIES
    IMPORTED_LOCATION "${GLUCOSE_D4_LIB}"
    INTERFACE_INCLUDE_DIRECTORIES "${GLUCOSE_D4_ROOT}"
)
add_dependencies(glucose_d4 glucose_d4_external)
