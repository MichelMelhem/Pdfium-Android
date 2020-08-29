cmake_minimum_required(VERSION 3.4.1)

add_library( pdfiumjni SHARED
             src/main/cpp/jni.cpp )

include_directories( src/main/cpp )

add_definitions( -DHAVE_PTHREADS )

# one day we will be possible to replace those lines with find_library(modpdfium-lib modpdfium)
add_library(modpdfium SHARED IMPORTED)
string(REPLACE "/android-pdfium/intermediates/cmake/release/obj/" "/libmodpdfium/intermediates/merged_jni_libs/release/out/" MODPDFIUM_TARGET "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/libmodpdfium.so")
include_directories(libmodpdfium/src/main/cpp/include)
set_target_properties(modpdfium PROPERTIES IMPORTED_LOCATION ${MODPDFIUM_TARGET})

find_library( log-lib log )

find_library( android-lib android )

find_library( jnigraphics-lib jnigraphics )

target_link_libraries( pdfiumjni ${log-lib} ${android-lib} ${jnigraphics-lib} modpdfium )
