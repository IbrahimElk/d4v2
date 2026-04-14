include(ExternalProject)

set(GLUCOSE_BIPE_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/bipe/3rdParty/glucose-3.0")

set(GLUCOSE_BUILD_TARGET libst)
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(GLUCOSE_BUILD_TARGET libd)
endif()

ExternalProject_Add(glucose_bipe
    SOURCE_DIR "${GLUCOSE_BIPE_ROOT}/core"
    CONFIGURE_COMMAND ""
    BUILD_COMMAND make ${GLUCOSE_BUILD_TARGET}
    BUILD_IN_SOURCE TRUE
    INSTALL_COMMAND ""
)

add_subdirectory(${CMAKE_SOURCE_DIR}/3rdParty/bipe/)
