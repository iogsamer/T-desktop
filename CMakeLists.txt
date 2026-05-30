cmake_minimum_required(VERSION 3.16)

project(darkflix VERSION "5.0.21")

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")

option(DEBUG_LOG "Allow debug logs" ON)

# Locate MPV
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    # 64-bit architecture
    set(MPV_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/deps/libmpv/x86_64/include")
    set(MPV_LIBRARY "${CMAKE_CURRENT_SOURCE_DIR}/deps/libmpv/x86_64/mpv.lib")
    set(MPV_DLL "${CMAKE_CURRENT_SOURCE_DIR}/deps/libmpv/x86_64/libmpv-2.dll")

    set(DISCORD_LIB "${CMAKE_CURRENT_SOURCE_DIR}/deps/discord-rpc/win64-static/lib/discord-rpc.lib")
    set(DISCORD_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/deps/discord-rpc/win64-static/include")
else()
    # 32-bit architecture
    set(MPV_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/deps/libmpv/i686/include")
    set(MPV_LIBRARY "${CMAKE_CURRENT_SOURCE_DIR}/deps/libmpv/i686/mpv.lib")
    set(MPV_DLL "${CMAKE_CURRENT_SOURCE_DIR}/deps/libmpv/i686/libmpv-2.dll")

    set(DISCORD_LIB "${CMAKE_CURRENT_SOURCE_DIR}/deps/discord-rpc/win32-static/lib/discord-rpc.lib")
    set(DISCORD_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/deps/discord-rpc/win32-static/include")
endif()

include_directories(${DISCORD_INCLUDE_DIR})
include_directories(${MPV_INCLUDE_DIR})

find_package(OpenSSL REQUIRED)
find_package(CURL REQUIRED)
find_package(nlohmann_json CONFIG REQUIRED)
# WebView2 — try vcpkg, then fall back to manually-installed NuGet SDK
find_package(unofficial-webview2 CONFIG QUIET)
if(NOT TARGET unofficial::webview2::webview2)
  # Search in common locations (vcpkg installed dir, side-by-side, env)
  set(_WV2_CANDIDATES
    "${VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}"
    "${VCPKG_INSTALLED_DIR}/x64-windows-static"
    "${VCPKG_INSTALLED_DIR}/x86-windows-static"
    "$ENV{GITHUB_WORKSPACE}/vcpkg/installed/x64-windows-static"
    "$ENV{GITHUB_WORKSPACE}/vcpkg/installed/x86-windows-static"
  )
  foreach(_WV2_DIR IN LISTS _WV2_CANDIDATES)
    if(EXISTS "${_WV2_DIR}/include/WebView2.h")
      add_library(unofficial::webview2::webview2 INTERFACE IMPORTED GLOBAL)
      target_include_directories(unofficial::webview2::webview2 INTERFACE
        "${_WV2_DIR}/include")
      foreach(_LIB WebView2LoaderStatic.lib WebView2Loader.lib)
        if(EXISTS "${_WV2_DIR}/lib/${_LIB}")
          target_link_libraries(unofficial::webview2::webview2 INTERFACE
            "${_WV2_DIR}/lib/${_LIB}")
          break()
        endif()
      endforeach()
      message(STATUS "unofficial-webview2: found at ${_WV2_DIR}")
      break()
    endif()
  endforeach()
  if(NOT TARGET unofficial::webview2::webview2)
    message(FATAL_ERROR
      "unofficial-webview2 not found.\n"
      "Install via: vcpkg install unofficial-webview2:x64-windows-static\n"
      "or NuGet: nuget install Microsoft.Web.WebView2")
  endif()
endif()

set(SOURCES
        src/main.cpp
        stremio.rc
        src/core/globals.h
        src/core/globals.cpp
        src/utils/helpers.h
        src/utils/helpers.cpp
        src/utils/config.h
        src/utils/config.cpp
        src/utils/crashlog.h
        src/utils/crashlog.cpp
        src/mpv/player.h
        src/mpv/player.cpp
        src/node/server.cpp
        src/node/server.h
        src/tray/tray.h
        src/tray/tray.cpp
        src/ui/splash.h
        src/ui/splash.cpp
        src/updater/updater.cpp
        src/updater/updater.h
        src/webview/webview.h
        src/webview/webview.cpp
        src/ui/mainwindow.h
        src/ui/mainwindow.cpp
        src/resource.h
        src/utils/extensions.cpp
        src/utils/extensions.h
        src/utils/discord.cpp
        src/utils/discord.h
)

add_executable(${PROJECT_NAME} WIN32 ${SOURCES})


target_link_libraries(${PROJECT_NAME} PRIVATE
        gdiplus.lib
        dwmapi.lib
        Shcore.lib
        Msimg32.lib
        winhttp.lib
        shlwapi.lib
        nlohmann_json::nlohmann_json
        unofficial::webview2::webview2
        OpenSSL::SSL
        OpenSSL::Crypto
        CURL::libcurl
        ${MPV_LIBRARY}
        ${DISCORD_LIB}
)

target_compile_definitions(${PROJECT_NAME} PRIVATE DEBUG_LOG)

# Copy MPV DLL
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${MPV_DLL}"
        $<TARGET_FILE_DIR:${PROJECT_NAME}>
)
# ── Copy DarkFlix Auth Server package ────────────────────────────
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CMAKE_SOURCE_DIR}/packages/darkflix-auth"
        "$<TARGET_FILE_DIR:${PROJECT_NAME}>/packages/darkflix-auth"
    COMMENT "Deploying darkflix-auth package..."
)
