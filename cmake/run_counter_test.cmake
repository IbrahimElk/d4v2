if(NOT DEFINED TIMEOUT)
  set(TIMEOUT 60)
endif()
if(NOT DEFINED MATCH_KEY)
  set(MATCH_KEY "s ")
endif()
if(NOT DEFINED EXTRA_ARGS)
  set(EXTRA_ARGS "")
endif()

foreach(_var BINARY INPUT SOL_FILE)
  if(NOT EXISTS "${${_var}}")
    message(FATAL_ERROR "${_var} not found: ${${_var}}")
  endif()
endforeach()

# read expected answer
file(STRINGS "${SOL_FILE}" _expected_lines)
set(_expected "")
foreach(_line IN LISTS _expected_lines)
  string(FIND "${_line}" "${MATCH_KEY}" _pos)
  if(_pos EQUAL 0 AND _expected STREQUAL "")
    string(LENGTH "${MATCH_KEY}" _prefix_len)
    string(SUBSTRING "${_line}" ${_prefix_len} -1 _expected)
    string(STRIP "${_expected}" _expected)
  endif()
endforeach()

if(_expected STREQUAL "")
  message(FATAL_ERROR "No '${MATCH_KEY}' line in ${SOL_FILE}")
endif()

# run binary
set(_cmd "${BINARY}" "-i" "${INPUT}")
foreach(_arg IN LISTS EXTRA_ARGS)
  list(APPEND _cmd "${_arg}")
endforeach()

execute_process(
  COMMAND ${_cmd}
  TIMEOUT ${TIMEOUT}
  OUTPUT_VARIABLE _stdout
  ERROR_VARIABLE  _stderr
  RESULT_VARIABLE _rc
)

if(NOT _rc EQUAL 0)
  message(FATAL_ERROR
    "Exit code ${_rc}\nCmd: ${_cmd}\nStderr:\n${_stderr}")
endif()

# extract actual answer using regex
if(_stdout MATCHES "(^|[\r\n]) *${MATCH_KEY} *([^\r\n]+)")
  set(_actual "${CMAKE_MATCH_2}")
  string(STRIP "${_actual}" _actual)
else()
  message(FATAL_ERROR
    "No '${MATCH_KEY}' line in output.\nCmd: ${_cmd}\nStdout:\n${_stdout}")
endif()

if(_actual STREQUAL "")
  message(FATAL_ERROR
    "No '${MATCH_KEY}' line in output.\nCmd: ${_cmd}\nStdout:\n${_stdout}")
endif()

# compare
function(_normalize_number _in _out_var)
  set(_v "${_in}")
  if(_v MATCHES "^-?[0-9]+\\.[0-9]+$")
    string(REGEX REPLACE "0+$" "" _v "${_v}")
    string(REGEX REPLACE "\\.$" "" _v "${_v}")
  endif()
  set(${_out_var} "${_v}" PARENT_SCOPE)
endfunction()

_normalize_number("${_expected}" _expected_norm)
_normalize_number("${_actual}"   _actual_norm)

if(NOT _actual_norm STREQUAL _expected_norm)
  message(FATAL_ERROR
    "MISMATCH on ${INPUT}\n"
    "  expected: ${_expected}  (normalized: ${_expected_norm})\n"
    "  actual:   ${_actual}    (normalized: ${_actual_norm})")
endif()

message(STATUS "PASS,  ${INPUT}: ${MATCH_KEY}${_actual}")
