# unofficial-webview2 cmake config
# Auto-generated from Microsoft.Web.WebView2 NuGet package
cmake_minimum_required(VERSION 3.15)

if(NOT TARGET unofficial::webview2::webview2)
  add_library(unofficial::webview2::webview2 INTERFACE IMPORTED)

  # Find headers and libs relative to this file
  get_filename_component(_wv2_dir "${CMAKE_CURRENT_LIST_DIR}/../../.." ABSOLUTE)
  
  set(_wv2_include "${_wv2_dir}/include")
  set(_wv2_lib     "${_wv2_dir}/lib/WebView2LoaderStatic.lib")
  
  if(NOT EXISTS "${_wv2_include}/WebView2.h")
    message(FATAL_ERROR "WebView2.h not found at ${_wv2_include}")
  endif()
  
  target_include_directories(unofficial::webview2::webview2 INTERFACE "${_wv2_include}")
  
  if(EXISTS "${_wv2_lib}")
    target_link_libraries(unofficial::webview2::webview2 INTERFACE "${_wv2_lib}")
  else()
    # Fallback to import lib
    file(GLOB _wv2_import_lib "${_wv2_dir}/lib/*.lib")
    if(_wv2_import_lib)
      target_link_libraries(unofficial::webview2::webview2 INTERFACE "${_wv2_import_lib}")
    endif()
  endif()
endif()
