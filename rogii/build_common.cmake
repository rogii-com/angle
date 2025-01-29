if(UNIX)
    message(
        FATAL_ERROR
        "UNIX build not supported"
    )
endif()

if(
    NOT DEFINED ROOT
    OR NOT DEFINED ARCH
)
    message(
        FATAL_ERROR
        "Assert: ROOT = ${ROOT}; ARCH = ${ARCH}"
    )
endif()

set(
    BUILD
    0
)

if(DEFINED ENV{BUILD_NUMBER})
    set(
        BUILD
        $ENV{BUILD_NUMBER}
    )
endif()

set(
    TAG
    ""
)

if(DEFINED ENV{TAG})
    set(
        TAG
        "$ENV{TAG}"
    )
else()
    find_package(
        Git
    )

    if(Git_FOUND)
        execute_process(
            COMMAND
                ${GIT_EXECUTABLE} rev-parse --short HEAD
            OUTPUT_VARIABLE
                TAG
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        set(
            TAG
            "_${TAG}"
        )
    endif()
endif()

include(
    "${CMAKE_CURRENT_LIST_DIR}/version.cmake"
)

set(
    BUILD_PATH
    "${CMAKE_CURRENT_LIST_DIR}/../build"
)

set(
    PACKAGE_NAME
    "angle-${ROGII_PKG_VERSION}-${ARCH}-${BUILD}${TAG}"
)

set(
    CMAKE_INSTALL_PREFIX
    ${ROOT}/${PACKAGE_NAME}
)


message("${CMAKE_CURRENT_LIST_DIR}")

if(WIN32)
        execute_process(
    COMMAND
        .\\rogii\\run_build.bat
    WORKING_DIRECTORY
    "${CMAKE_SOURCE_DIR}")
endif()
return()
list(APPEND BUILDTYPES release debug)
foreach(build IN LISTS BUILDTYPES )
    file(GLOB SKIA_FILES "${CMAKE_SOURCE_DIR}/out/${build}/*skia*")

    file(COPY ${SKIA_FILES} DESTINATION "${CMAKE_INSTALL_PREFIX}/bin/${build}/" FILES_MATCHING PATTERN "*.dll" PATTERN "*.pdb")
    file(COPY ${SKIA_FILES} DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/${build}/" FILES_MATCHING PATTERN "*.lib" PATTERN "*.so")

endforeach()  


file(
    COPY
        "${CMAKE_SOURCE_DIR}/include"
    DESTINATION
        "${CMAKE_INSTALL_PREFIX}"
)

file(
    COPY
        "${CMAKE_CURRENT_LIST_DIR}/package.cmake"
    DESTINATION
        "${CMAKE_INSTALL_PREFIX}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -E tar cf "${PACKAGE_NAME}.7z" --format=7zip -- "${PACKAGE_NAME}"
    WORKING_DIRECTORY
        "${ROOT}"
)
