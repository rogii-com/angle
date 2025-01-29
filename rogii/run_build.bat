SETLOCAL EnableDelayedExpansion

git clone --depth=1 --no-tags --single-branch https://chromium.googlesource.com/chromium/tools/depot_tools.git
set PATH=%CD%\depot_tools;%PATH%


set DEPOT_TOOLS_WIN_TOOLCHAIN=0

set win_vc=!VCINSTALLDIR:\=\\!
set win_toolchain_version=!VSCMD_ARG_VCVARS_VER!
set win_sdk=!WindowsSdkDir:\=\\!
set win_sdk_version=!VSCMD_ARG_winsdk!



@REM python.exe scripts\bootstrap.py 
@REM gclient sync -f -D -R

for /f "delims=|" %%f in ('dir /b rogii\patches') do call git apply %cd%\rogii\patches\%%f

if exist out (
    rmdir /Q /S out
)
FOR  %%D IN (release debug) DO (
    ECHO Build %%D

    mkdir out\%%D
    (
    ECHO is_official_build=false
    ECHO is_component_build=true
    ECHO is_clang=false
    ECHO use_custom_libcxx=false
    ECHO angle_build_all=false
    ECHO angle_has_frame_capture=false
    ECHO angle_enable_null=false
    ECHO angle_enable_vulkan=false
    ECHO angle_build_vulkan_system_info=false
    ECHO angle_shared_libvulkan=false
    ECHO angle_build_tests=false
    ECHO angle_enable_gl_null=false
    ECHO angle_has_astc_encoder=false
    ECHO angle_has_histograms=false
    ECHO angle_has_rapidjson=false
    ECHO archive_seed_corpus=false
    ECHO build_angle_deqp_tests=false
    ECHO is_high_end_android=false
    ECHO register_fuzztests_in_test_suites=false
    ECHO toolkit_views=false
    ECHO use_aura=false
    ECHO use_android_unwinder_v2=false
    ECHO use_blink=false
    ECHO angle_enable_d3d9=false
    ECHO is_java_debug=false
    ECHO jsoncpp_no_deprecated_declarations=false
    ECHO use_custom_libcxx_for_host=false
    ECHO win_vc = "%win_vc%"
    ECHO win_toolchain_version =  "%win_toolchain_version%"
    ECHO win_sdk = "%win_sdk%"
    ECHO win_sdk_version = "%win_sdk_version%"
    ) > out\%%D\args.gn

    IF "%%D" == "debug" (
        (
        ECHO is_debug=true
        ECHO angle_debug_layers_enabled=true
        ECHO extra_cflags=["/MDd"]
        ) >> out\%%D\args.gn
    ) ELSE (
        (
        ECHO is_debug=false
        ECHO extra_cflags=["/MD"]
        ) >> out\%%D\args.gn
    )

    bin\gn gen out\%%D
    ninja -C out\%%D libEGL libGLESv2
)