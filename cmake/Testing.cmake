set(TEST_RUNNER "${CMAKE_SOURCE_DIR}/cmake/run_counter_test.cmake")
set(SMOKE_RUNNER "${CMAKE_SOURCE_DIR}/cmake/run_smoke_test.cmake")
set(TEST_DATA_DIR "${CMAKE_SOURCE_DIR}/assets")
set(DEFAULT_TIMEOUT 60)

if(CMAKE_BUILD_TYPE STREQUAL "Release")
  message(WARNING
    "MD4_ENABLE_TESTS is ON but CMAKE_BUILD_TYPE is Release.\n"
    "Assertions are disabled, tests will not catch assertion violations.\n"
    "Consider using the 'dev' preset:  cmake --preset dev")
endif()

function(md4_add_counter_test _name _target _input _sol)
  cmake_parse_arguments(ARG "" "TIMEOUT" "EXTRA_ARGS;LABELS" ${ARGN})
  if(NOT ARG_TIMEOUT)
    set(ARG_TIMEOUT ${DEFAULT_TIMEOUT})
  endif()

  add_test(
    NAME "${_name}"
    COMMAND ${CMAKE_COMMAND}
      "-DBINARY=$<TARGET_FILE:${_target}>"
      "-DINPUT=${_input}"
      "-DSOL_FILE=${_sol}"
      "-DEXTRA_ARGS=${ARG_EXTRA_ARGS}"
      "-DTIMEOUT=${ARG_TIMEOUT}"
      -P "${TEST_RUNNER}"
  )
  set_tests_properties("${_name}" PROPERTIES TIMEOUT ${ARG_TIMEOUT})
  if(ARG_LABELS)
    set_tests_properties("${_name}" PROPERTIES LABELS "${ARG_LABELS}")
  endif()
endfunction()

function(md4_add_smoke_test _name _target _input)
  cmake_parse_arguments(ARG "" "TIMEOUT" "EXTRA_ARGS;LABELS" ${ARGN})
  if(NOT ARG_TIMEOUT)
    set(ARG_TIMEOUT ${DEFAULT_TIMEOUT})
  endif()

  add_test(
    NAME "${_name}"
    COMMAND ${CMAKE_COMMAND}
      "-DBINARY=$<TARGET_FILE:${_target}>"
      "-DINPUT=${_input}"
      "-DEXTRA_ARGS=${ARG_EXTRA_ARGS}"
      "-DTIMEOUT=${ARG_TIMEOUT}"
      -P ${SMOKE_RUNNER}
  )
  set_tests_properties("${_name}" PROPERTIES TIMEOUT ${ARG_TIMEOUT})
  if(ARG_LABELS)
    set_tests_properties("${_name}" PROPERTIES LABELS "${ARG_LABELS}")
  endif()
endfunction()


# ------------------------------------------------------------------
# MODEL COUNTING
# CNF with known solutions
# ------------------------------------------------------------------

file(GLOB _cnf_files "${TEST_DATA_DIR}/cnfs/counting/*.cnf")
foreach(_cnf IN LISTS _cnf_files)
  get_filename_component(_stem "${_cnf}" NAME_WE)
  set(_sol "${TEST_DATA_DIR}/cnfs/counting/${_stem}.sol")
  if(EXISTS "${_sol}")
    md4_add_counter_test(
      "counting/${_stem}"  d4_counter_bin
      "${_cnf}" "${_sol}"
      LABELS counting cnf)
  endif()
endforeach()

# ------------------------------------------------------------------
# MODEL COUNTING
# Weighted CNFs with known solutions
# ------------------------------------------------------------------

file(GLOB _wcnf_files "${TEST_DATA_DIR}/cnfs/weighted/*wcnf")
foreach(_wcnf IN LISTS _wcnf_files)
  get_filename_component(_stem "${_wcnf}" NAME_WE)
  set(_sol "${TEST_DATA_DIR}/cnfs/weighted/${_stem}.sol")
  if(EXISTS "${_sol}")
    md4_add_counter_test(
      "counting_weighted/${_stem}"  d4_counter_bin
      "${_wcnf}" "${_sol}"
      LABELS counting weighted)
  endif()
endforeach()

# ------------------------------------------------------------------
# SMOKE
# CNFs without known solutions (verify no crash)
# ------------------------------------------------------------------

file(GLOB _smoke_cnfs "${TEST_DATA_DIR}/cnfs/smoke/*.cnf")
foreach(_cnf IN LISTS _smoke_cnfs)
  get_filename_component(_stem "${_cnf}" NAME_WE)
  md4_add_smoke_test(
    "smoke_cnf/${_stem}"  d4_counter_bin  "${_cnf}"
    LABELS smoke cnf)
endforeach()

set(_slow_circuits
  dnf_countries_proofs_countries_s3
  dnf_countries_proofs_countries_s3_smaller
  noisy_or_200
  noisy_or_250
  noisy_or_500
  noisy_or_1000
  verilog_jpsety_arbiter
  verilog_jpsety_c1355
  verilog_jpsety_c1908
  verilog_jpsety_c3540
  verilog_jpsety_c499
  verilog_jpsety_c5315
  verilog_jpsety_c6288
  verilog_jpsety_c7552
  verilog_jpsety_c880
  verilog_jpsety_div
  verilog_jpsety_log2
  verilog_jpsety_max
  verilog_jpsety_multiplier
  verilog_jpsety_sin
  verilog_jpsety_sqrt
  verilog_jpsety_voter
)

# ------------------------------------------------------------------
# SMOKE
# Circuit inputs
# ------------------------------------------------------------------

file(GLOB _circuit_files "${TEST_DATA_DIR}/circuits/*.bc")
foreach(_circ IN LISTS _circuit_files)
  get_filename_component(_stem "${_circ}" NAME_WE)
  # md4_add_smoke_test(
  #   "smoke_circuit/${_stem}"  d4_compiler_bin  "${_circ}"
  #   EXTRA_ARGS "--input-type;circuit"
  #   LABELS smoke circuit
  #   TIMEOUT 120)
  if("${_stem}" IN_LIST _slow_circuits)
    md4_add_smoke_test(
      "smoke_circuit/${_stem}"  d4_compiler_bin  "${_circ}"
      EXTRA_ARGS "--input-type;circuit"
      LABELS smoke circuit slow
      TIMEOUT 3600)
  else()
    md4_add_smoke_test(
      "smoke_circuit/${_stem}"  d4_compiler_bin  "${_circ}"
      EXTRA_ARGS "--input-type;circuit"
      LABELS smoke circuit
      TIMEOUT 120)
  endif()
endforeach()

# ------------------------------------------------------------------
# SMOKE
# Compiler on projected CNF
# ------------------------------------------------------------------

file(GLOB _proj_files "${TEST_DATA_DIR}/cnfs/projected/*.cnf")
foreach(_proj IN LISTS _proj_files)
  get_filename_component(_stem "${_proj}" NAME_WE)
  md4_add_smoke_test(
    "smoke_compiler/${_stem}"  d4_compiler_bin  "${_proj}"
    LABELS smoke compiler projected)
endforeach()
