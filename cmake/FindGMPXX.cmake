find_path(GMPXX_INCLUDE_DIR NAMES gmpxx.h)
find_library(GMPXX_LIBRARY NAMES gmpxx)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GMPXX
    REQUIRED_VARS
    GMPXX_INCLUDE_DIR
    GMPXX_LIBRARY
)

if(GMPXX_FOUND AND NOT TARGET GMPXX::gmpxx)
    add_library(GMPXX::gmpxx STATIC IMPORTED)
    set_target_properties(GMPXX::gmpxx PROPERTIES
        IMPORTED_LOCATION "${GMPXX_LIBRARY}"
        INTERFACE_INCLUDE_DIRECTORIES "${GMPXX_INCLUDE_DIR}"
    )
endif()
