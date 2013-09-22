require 'formula'

class SagittariusScheme < Formula
  homepage 'http://code.google.com/p/sagittarius-scheme/'
  url 'http://sagittarius-scheme.googlecode.com/files/sagittarius-0.4.9.tar.gz'
  sha1 '8e6a8993199fa685c35abd26af86d46b71e5195c'

  depends_on 'cmake' => :build
  depends_on 'libffi'
  depends_on 'bdw-gc'

  env :std

  def patches
    { :p1 => DATA }
  end

  def install
    ENV.j1 # This build isn't parallel safe.

    libffi = Formula.factory("libffi")
    cmake_system_processor = MacOS.prefer_64_bit? ? 'x86_64' : 'x86'

    ENV.no_optimization
    ENV['TEST_USE_ANSI'] = '0'
    cmake_args = [
            '.',
            '-DCMAKE_COLOR_MAKEFILE=OFF',
            '-DCMAKE_SYSTEM_NAME=darwin',
            "-DFFI_LIBRARY_DIR=#{libffi.lib}",
            "-DINSTALL_PREFIX=#{prefix}",
            "-DCMAKE_SYSTEM_PROCESSOR=#{cmake_system_processor}"
    ]

    cmake_args += std_cmake_args

    system 'cmake', *cmake_args
    system 'make'
    system 'make doc'
    system 'make test'
    system 'make install'
  end

  def test
    system "echo '(import (r7rs))' | #{bin}/sash"
  end
end

__END__
diff --git a/ext/crypto/libtomcrypt-1.17/CMakeLists.txt b/ext/crypto/libtomcrypt-1.17/CMakeLists.txt
--- a/ext/crypto/libtomcrypt-1.17/CMakeLists.txt
+++ b/ext/crypto/libtomcrypt-1.17/CMakeLists.txt
@@ -8,7 +8,7 @@
 # 
 
 # reset c flags
-IF (CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
+IF (CMAKE_C_COMPILER_ID STREQUAL "Clang" OR CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX)
   SET(CMAKE_C_FLAGS "-Wall -O2 ${DEFAULT_COMPILER_FLAGS}")
   SET(CMAKE_CXX_FLAGS "-Wall -O2 ${DEFAULT_COMPILER_FLAGS}")
   IF( CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64" )
diff --git a/ext/ffi/CMakeLists.txt b/ext/ffi/CMakeLists.txt
--- a/ext/ffi/CMakeLists.txt
+++ b/ext/ffi/CMakeLists.txt
@@ -2,7 +2,22 @@
 # 
 # Build file for regex
 
-CHECK_INCLUDE_FILE(ffi.h HAVE_FFI_H)
+IF (APPLE)
+  IF (FFI_LIBRARY_DIR)
+    MESSAGE(STATUS "Looking for ffi include directory in ${FFI_LIBRARY_DIR}")
+    FILE(GLOB FFI_INCLUDE_DIR "${FFI_LIBRARY_DIR}/libffi-*/include")
+    IF (FFI_INCLUDE_DIR)
+      MESSAGE(STATUS "Looking for ffi include directory in ${FFI_LIBRARY_DIR} - found")
+      INCLUDE_DIRECTORIES(${FFI_INCLUDE_DIR})
+      SET(HAVE_FFI_H TRUE)
+    ELSE()
+      MESSAGE(WARNING "Looking for ffi include directory in ${FFI_LIBRARY_DIR} - not found")
+    ENDIF()
+  ENDIF()
+ELSE()
+  CHECK_INCLUDE_FILE(ffi.h HAVE_FFI_H)
+ENDIF()
+
 IF (HAVE_FFI_H)
   SET(LIB_FFI_FOUND TRUE)
 ELSE()
@@ -14,7 +29,11 @@
 
 IF (LIB_FFI_FOUND)
   #CHECK_FUNCTION_EXISTS(ffi_prep_cif_var HAVE_FFI_PREP_CIF_VAR)
-  FIND_LIBRARY(FFI ffi)
+  IF (FFI_LIBRARY_DIR)
+    FIND_LIBRARY(FFI ffi ${FFI_LIBRARY_DIR} NO_DEFAULT_PATH)
+  ELSE()
+    FIND_LIBRARY(FFI ffi)
+  ENDIF()
   SET(LIB_FFI_LIBRARIES ${FFI})
   CHECK_LIBRARY_EXISTS(${FFI} ffi_prep_cif_var "ffi.h" HAVE_FFI_PREP_CIF_VAR)
   MESSAGE(STATUS "Sagittarius uses platform libffi")
diff --git a/ext/zlib/CMakeLists.txt b/ext/zlib/CMakeLists.txt
--- a/ext/zlib/CMakeLists.txt
+++ b/ext/zlib/CMakeLists.txt
@@ -24,8 +24,12 @@
 #check if zlib is available
 #INCLUDE(${CMAKE_ROOT}/Modules/FindZLIB.cmake)
 FIND_PACKAGE(ZLIB)
+IF (ZLIB_FOUND)
+  CHECK_LIBRARY_EXISTS(${ZLIB_LIBRARIES} inflateReset2 "" HAVE_ZLIB_INFLATE_RESET2)
+  MESSAGE(STATUS "HAVE_ZLIB_INFLATE_RESET2 = ${HAVE_ZLIB_INFLATE_RESET2}")
+ENDIF()
 
-IF (NOT ${ZLIB_FOUND})
+IF (NOT ZLIB_FOUND OR NOT HAVE_ZLIB_INFLATE_RESET2)
 #  IF (MSVC)
 #    # use DLL which is provied by zlib.net
 #  ELSE()
@@ -38,13 +42,17 @@
     IF (NOT EXISTS ${HAS_ZLIB_ARCHIVE})
       MESSAGE(STATUS "donwloading zlib")
       FILE(
-  	DOWNLOAD "http://zlib.net/${USED_ZLIB_VERSION}.tar.gz"
-                 "${CMAKE_CURRENT_BINARY_DIR}/zlib.tar.gz"
-  	SHOW_PROGRESS)
+        DOWNLOAD "http://zlib.net/${USED_ZLIB_VERSION}.tar.gz"
+        "${CMAKE_CURRENT_BINARY_DIR}/zlib.tar.gz"
+        SHOW_PROGRESS)
       EXECUTE_PROCESS(COMMAND ${CMAKE_COMMAND} -E tar xzf
-	${CMAKE_CURRENT_BINARY_DIR}/zlib.tar.gz
-	WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
-	)
+        ${CMAKE_CURRENT_BINARY_DIR}/zlib.tar.gz
+        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
+      IF(UNIX OR CYGWIN OR MINGW)
+        # Default generated CMakeLists.txt does not include correct source directory
+        EXECUTE_PROCESS(COMMAND patch -f -p3 -i ${PROJECT_SOURCE_DIR}/ext/zlib/zlib-CMakeLists.txt.patch
+          WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
+      ENDIF()
       FILE(REMOVE ${CMAKE_CURRENT_BINARY_DIR}/${USED_ZLIB_VERSION}/zconf.h)
       MESSAGE(STATUS "unpacked zlib.tar.gz")
     ENDIF()
@@ -63,7 +71,11 @@
 ENDIF()
 TARGET_LINK_LIBRARIES(sagittarius--zlib sagittarius)
 IF (UNIX)
-  TARGET_LINK_LIBRARIES(sagittarius--zlib z)
+  IF (NOT ZLIB_FOUND OR NOT HAVE_ZLIB_INFLATE_RESET2)
+    TARGET_LINK_LIBRARIES(sagittarius--zlib zlib)
+  ELSE()
+    TARGET_LINK_LIBRARIES(sagittarius--zlib z)
+  ENDIF()
 ELSE()
   TARGET_LINK_LIBRARIES(sagittarius--zlib zlib)
 ENDIF()
diff --git a/ext/zlib/zlib-CMakeLists.txt.patch b/ext/zlib/zlib-CMakeLists.txt.patch
new file mode 100644
--- /dev/null
+++ b/ext/zlib/zlib-CMakeLists.txt.patch
@@ -0,0 +1,11 @@
+--- build/ext/zlib/zlib-1.2.8.org/CMakeLists.txt	2013-04-29 07:57:10.000000000 +0900
++++ build/ext/zlib/zlib-1.2.8/CMakeLists.txt	2013-09-22 11:33:03.000000000 +0900
+@@ -83,7 +83,7 @@
+ 		${ZLIB_PC} @ONLY)
+ configure_file(	${CMAKE_CURRENT_SOURCE_DIR}/zconf.h.cmakein
+ 		${CMAKE_CURRENT_BINARY_DIR}/zconf.h @ONLY)
+-include_directories(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_SOURCE_DIR})
++include_directories(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
+ 
+ 
+ #============================================================================
