# unofficial-webview2 cmake config
# Installed from Microsoft.Web.WebView2 NuGet package

cmake_minimum_required(VERSION 3.15)

if(TARGET unofficial::webview2::webview2)
  return()
endif()

# This file lives at: <install_root>/share/unofficial-webview2/
get_filename_component(_WV2_SHARE_DIR "${CMAKE_CURRENT_LIST_DIR}" ABSOLUTE)
get_filename_component(_WV2_TRIPLET_DIR "${_WV2_SHARE_DIR}/../.." ABSOLUTE)

set(_WV2_INCLUDE_DIR "${_WV2_TRIPLET_DIR}/include")
set(_WV2_LIB_STATIC  "${_WV2_TRIPLET_DIR}/lib/WebView2LoaderStatic.lib")

if(NOT EXISTS "${_WV2_INCLUDE_DIR}/WebView2.h")
  message(FATAL_ERROR
    "unofficial-webview2: WebView2.h not found at ${_WV2_INCLUDE_DIR}\n"
    "  Install root: ${_WV2_TRIPLET_DIR}")
endif()

add_library(unofficial::webview2::webview2 INTERFACE IMPORTED GLOBAL)

target_include_directories(unofficial::webview2::webview2 INTERFACE
  "${_WV2_INCLUDE_DIR}"
)

if(EXISTS "${_WV2_LIB_STATIC}")
  target_link_libraries(unofficial::webview2::webview2 INTERFACE
    "${_WV2_LIB_STATIC}"
  )
else()
  # Fallback: find any .lib in the lib directory
  file(GLOB _WV2_LIBS "${_WV2_TRIPLET_DIR}/lib/WebView2*.lib")
  if(_WV2_LIBS)
    list(GET _WV2_LIBS 0 _WV2_FIRST_LIB)
    target_link_libraries(unofficial::webview2::webview2 INTERFACE "${_WV2_FIRST_LIB}")
    message(STATUS "unofficial-webview2: using fallback lib ${_WV2_FIRST_LIB}")
  else()
    message(WARNING "unofficial-webview2: no lib found, linking headers only")
  endif()
endif()

message(STATUS "unofficial-webview2 found: ${_WV2_INCLUDE_DIR}")
