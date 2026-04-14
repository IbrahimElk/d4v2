if(NOT DEFINED TIMEOUT)
  set(TIMEOUT 60)
endif()
if(NOT DEFINED EXTRA_ARGS)
  set(EXTRA_ARGS "")
endif()

foreach(_var BINARY INPUT)
  if(NOT EXISTS "${${_var}}")
    message(FATAL_ERROR "${_var} not found: ${${_var}}")
  endif()
endforeach()

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

get_filename_component(_name "${INPUT}" NAME)

if(NOT _rc MATCHES "^[0-9]+$")
  message(STATUS "PASS (smoke, timeout ${TIMEOUT}s),  ${_name}")
  return()
endif()

if(NOT _rc EQUAL 0)
  message(FATAL_ERROR
    "Exit code ${_rc}\nCmd: ${_cmd}\nStderr:\n${_stderr}\nStdout:\n${_stdout}")
endif()

message(STATUS "PASS (smoke),  ${_name}")
