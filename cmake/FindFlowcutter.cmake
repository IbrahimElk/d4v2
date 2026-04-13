include(ExternalProject)

ExternalProject_Add(flowcutter_build
    SOURCE_DIR ${CMAKE_SOURCE_DIR}/3rdParty/flowCutter/
    CONFIGURE_COMMAND ""
    BUILD_COMMAND make
    BUILD_IN_SOURCE TRUE
    INSTALL_COMMAND ""
)

add_library(flowcutter STATIC IMPORTED GLOBAL)
set_target_properties(flowcutter PROPERTIES
    IMPORTED_LOCATION
        ${CMAKE_SOURCE_DIR}/3rdParty/flowCutter/libflowCutter.a
    # INTERFACE_INCLUDE_DIRECTORIES
    #     ${CMAKE_SOURCE_DIR}/include/flowcutter
)
