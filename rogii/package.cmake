if(TARGET angle::glesv2 AND TARGET angle::egl)
    return()
endif()

add_library(angle::glesv2 SHARED IMPORTED)

set_target_properties(
    angle::glesv2
    PROPERTIES
        IMPORTED_LOCATION
            "${CMAKE_CURRENT_LIST_DIR}/bin/release/libGLESv2.dll"
        IMPORTED_LOCATION_DEBUG
            "${CMAKE_CURRENT_LIST_DIR}/bin/debug/libGLESv2d.dll"
        IMPORTED_IMPLIB
            "${CMAKE_CURRENT_LIST_DIR}/bin/release/libGLESv2.dll.lib"
        IMPORTED_IMPLIB_DEBUG
            "${CMAKE_CURRENT_LIST_DIR}/bin/debug/libGLESv2d.dll.lib"
        INTERFACE_INCLUDE_DIRECTORIES
            "${CMAKE_CURRENT_LIST_DIR}/include"
)

set(
    COMPONENT_NAMES

    CNPM_RUNTIME_Angle_GLESv2
)

foreach(COMPONENT_NAME ${COMPONENT_NAMES})
    install(FILES
            ${CMAKE_CURRENT_LIST_DIR}/bin/debug/third_party_zlib.dll
        CONFIGURATIONS
            Debug
        DESTINATION
            .
        COMPONENT
            ${COMPONENT_NAME}
        EXCLUDE_FROM_ALL
    )
    install(FILES
            ${CMAKE_CURRENT_LIST_DIR}/bin/release/third_party_zlib.dll
        CONFIGURATIONS
            Release RelWithDebInfo
        DESTINATION
            .
        COMPONENT
            ${COMPONENT_NAME}
        EXCLUDE_FROM_ALL
    )

    install(
        FILES
            $<TARGET_FILE:angle::glesv2>
        DESTINATION
            .
        COMPONENT
            ${COMPONENT_NAME}
        EXCLUDE_FROM_ALL
    )
endforeach()

add_library(angle::egl SHARED IMPORTED)

set_target_properties(
    angle::egl
    PROPERTIES
        IMPORTED_LOCATION
            "${CMAKE_CURRENT_LIST_DIR}/bin/release/libEGL.dll"
        IMPORTED_LOCATION_DEBUG
            "${CMAKE_CURRENT_LIST_DIR}/bin/debug/libEGLd.dll"
        IMPORTED_IMPLIB
            "${CMAKE_CURRENT_LIST_DIR}/bin/release/libEGL.dll.lib"
        IMPORTED_IMPLIB_DEBUG
            "${CMAKE_CURRENT_LIST_DIR}/bin/debug/libEGLd.dll.lib"
        INTERFACE_INCLUDE_DIRECTORIES
            "${CMAKE_CURRENT_LIST_DIR}/include"
)

set(
    COMPONENT_NAMES

    CNPM_RUNTIME_Angle_EGL
    CNPM_RUNTIME_Angle
    CNPM_RUNTIME
)

foreach(COMPONENT_NAME ${COMPONENT_NAMES})
    install(FILES
            ${CMAKE_CURRENT_LIST_DIR}/bin/debug/third_party_zlib.dll
        CONFIGURATIONS
            Debug
        DESTINATION
            .
        COMPONENT
            ${COMPONENT_NAME}
        EXCLUDE_FROM_ALL
    )
    install(FILES
            ${CMAKE_CURRENT_LIST_DIR}/bin/release/third_party_zlib.dll
        CONFIGURATIONS
            Release RelWithDebInfo
        DESTINATION
            .
        COMPONENT
            ${COMPONENT_NAME}
        EXCLUDE_FROM_ALL
    )

    install(
        FILES
            $<TARGET_FILE:angle::glesv2>
            $<TARGET_FILE:angle::egl>
        DESTINATION
            .
        COMPONENT
            ${COMPONENT_NAME}
        EXCLUDE_FROM_ALL
    )
endforeach()
