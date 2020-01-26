
set(GOPATH "${CMAKE_CURRENT_BINARY_DIR}/go")
file(MAKE_DIRECTORY ${GOPATH})

message ("Compiler ${CMAKE_CXX_COMPILER}")

function(GO_GET TARG)
  add_custom_target(${TARG} ${CMAKE_COMMAND} -E env GOPATH=${GOPATH} GOOS=${GOOS} GOARCH=${GOARCH} go get ${ARGN})
endfunction(GO_GET)

function(ADD_GO_INSTALLABLE_PROGRAM NAME MAIN_SRC)
  get_filename_component(MAIN_SRC_ABS ${MAIN_SRC} ABSOLUTE)
  add_custom_target(${NAME})
  add_custom_command(TARGET ${NAME}
                    COMMAND ${CMAKE_COMMAND} -E env CXX=${CMAKE_CXX_COMPILER} CC=${CMAKE_C_COMPILER} CGO_ENABLED=1 GOPATH=${GOPATH} GOOS=${GOOS} GOARCH=${GOARCH} go build
                    -o "${CMAKE_CURRENT_BINARY_DIR}/lib${NAME}.lib" -buildmode=c-archive -ldflags=-s -ldflags=-w
                    ${CMAKE_GO_FLAGS} ${MAIN_SRC}
                    WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
                    DEPENDS ${MAIN_SRC_ABS})
  foreach(DEP ${ARGN})
    add_dependencies(${NAME} ${DEP})
  endforeach()
  
  add_custom_target(${NAME}_all ALL DEPENDS ${NAME})
endfunction(ADD_GO_INSTALLABLE_PROGRAM)
