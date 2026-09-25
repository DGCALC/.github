

message("CMake DGCALC project")

if (DEFINED PROJECT_BUILD_TYPE AND NOT "${PROJECT_BUILD_TYPE}" STREQUAL "")
    set(CMAKE_BUILD_TYPE ${PROJECT_BUILD_TYPE} CACHE STRING "Build type")
else()
    set(CMAKE_BUILD_TYPE Debug CACHE STRING "Build type")
endif()
set(CMAKE_CXX_FLAGS_RELEASE "-Ofast -DNDEBUG" CACHE STRING "Release build flags" FORCE)
set(CMAKE_C_FLAGS_RELEASE "-Ofast -DNDEBUG" CACHE STRING "Release build flags" FORCE)
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g" CACHE STRING "Debug build flags" FORCE)
set(CMAKE_C_FLAGS_DEBUG "-O0 -g" CACHE STRING "Debug build flags" FORCE)

include($ENV{DGCALC_HOME}/src/dgcalc.definitions.cmake)
include($ENV{DGCALC_HOME}/src/dgcalc.accel.1.cmake)


