cmake_minimum_required(VERSION 3.13)
project(aws-c)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/aws-c-common/cmake)
include(AwsFindPackage)
set(IN_SOURCE_BUILD ON)

add_subdirectory(aws-c-common)
if(UNIX AND NOT APPLE)
    # don't build tests for s2n or aws-lc
    set(BUILD_TESTING_PREV ${BUILD_TESTING})
    set(BUILD_TESTING OFF)

    if(NOT USE_OPENSSL)
        # s2n-tls uses libcrypto during its configuration, so we need to prebuild aws-lc.
        include(AwsPrebuildDependency)
        aws_prebuild_dependency(
            DEPENDENCY_NAME AWSLC
            SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/aws-lc
            CMAKE_ARGUMENTS "-DBUILD_LIBSSL=OFF;-DBUILD_TESTING=OFF;-DDISABLE_GO=ON;-DDISABLE_PERL=ON"
        )
    endif()

    set(UNSAFE_TREAT_WARNINGS_AS_ERRORS OFF) # disable warnings-as-errors when building s2n
    add_subdirectory(s2n)

    set(BUILD_TESTING ${BUILD_TESTING_PREV})
endif()
add_subdirectory(aws-c-cal)
add_subdirectory(aws-c-io)
add_subdirectory(aws-checksums)
add_subdirectory(aws-c-compression)
add_subdirectory(aws-c-event-stream)
add_subdirectory(aws-c-http)
add_subdirectory(aws-c-sdkutils)
add_subdirectory(aws-c-auth)
add_subdirectory(aws-c-mqtt)
add_subdirectory(aws-c-s3)
add_subdirectory(aws-c-iot)
