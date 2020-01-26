project (goreflect)

#Dependency to add simple Go support to CMake
include(${CMAKE_SOURCE_DIR}/cmake/GolangSimple.cmake)

#Your favorite go tool definition
GO_GET(gobuster github.com/OJ/gobuster)

#Dependency for goreflect to allow parsing of a command line string
GO_GET(gsq github.com/kballard/go-shellquote)

#Our Go static library, result is linkable using GCC
ADD_GO_INSTALLABLE_PROGRAM(goreflect_prog
                           goreflect.go  # our lightweigth wrapper around gobuster
                           gobuster gsq) # everything else is a dependency


#Standard C shared library using metasploits version of the reflective loader code
add_library(goreflect SHARED "reflectivedll/ReflectiveDll.c" "reflectivedll/ReflectiveLoader.c" "reflectivedll/ReflectiveLoader.h" "reflectivedll/ReflectiveDLLInjection.h")
target_include_directories(goreflect PUBLIC ${CMAKE_BINARY_DIR})
target_compile_definitions(goreflect PUBLIC GF_EXPORTS REFLECTIVEDLLINJECTION_VIA_LOADREMOTELIBRARYR REFLECTIVEDLLINJECTION_CUSTOM_DLLMAIN)

#Linking all our dependencies as static, including our go program.  Results in no dependancies
target_link_libraries(goreflect ${CMAKE_BINARY_DIR}/libgoreflect_prog.lib -static-libgcc -static-libstdc++ -static -lpthread )
