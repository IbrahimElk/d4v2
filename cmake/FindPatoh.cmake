set(PATOH_SUBDIR "${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}")
set(PATOH_PRFX   "${CMAKE_CURRENT_SOURCE_DIR}/3rdParty")

if(APPLE)
    set(PATOH_ROOT_DIR "${PATOH_PRFX}/patoh_mac/build/${PATOH_SUBDIR}")
else()
    set(PATOH_ROOT_DIR "${PATOH_PRFX}/patoh/build/${PATOH_SUBDIR}")
endif()

find_path(PATOH_INCLUDE_DIR
    NAMES patoh.h
    HINTS "${PATOH_PRFX}/patoh"
    NO_DEFAULT_PATH
)

find_library(PATOH_LIBRARY
    NAMES patoh
    HINTS "${PATOH_ROOT_DIR}"
    NO_DEFAULT_PATH
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Patoh
    REQUIRED_VARS PATOH_INCLUDE_DIR PATOH_LIBRARY
)

if(Patoh_FOUND)
    add_library(Patoh::patoh STATIC IMPORTED)
    set_target_properties(Patoh::patoh PROPERTIES
        IMPORTED_LOCATION "${PATOH_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${PATOH_INCLUDE_DIR}"
    )
endif()
