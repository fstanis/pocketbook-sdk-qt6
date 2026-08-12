set(POCKETBOOK_TOOLCHAIN_LOADED TRUE)

set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_VERSION 1.0)
set(CMAKE_SYSTEM_PROCESSOR armv7a)

set(POCKETBOOK_TARGET "arm-linux-gnueabi")
set(POCKETBOOK_CROSS_ROOT "/usr/${POCKETBOOK_TARGET}" CACHE PATH "Debian crossbuild-essential-armel install root")

set(CMAKE_C_COMPILER "/usr/bin/clang")
set(CMAKE_CXX_COMPILER "/usr/bin/clang++")
set(CMAKE_STRIP "/usr/bin/${POCKETBOOK_TARGET}-strip")

set(CMAKE_C_COMPILER_TARGET "${POCKETBOOK_TARGET}")
set(CMAKE_CXX_COMPILER_TARGET "${POCKETBOOK_TARGET}")

# Not CMAKE_SYSROOT: Debian's libc.so is a linker script of absolute paths that --sysroot
# double-prefixes. --gcc-toolchain is what points clang at the cross g++.
set(CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN "/usr")
set(CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN "/usr")

set(CMAKE_FIND_ROOT_PATH "${POCKETBOOK_CROSS_ROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)

set(POCKETBOOK_TARGET_INCLUDE_DIR "/usr/include/${POCKETBOOK_TARGET}")
set(POCKETBOOK_TARGET_LIB_DIR "/usr/lib/${POCKETBOOK_TARGET}")
set(POCKETBOOK_QT_INCLUDE_DIR "${POCKETBOOK_TARGET_INCLUDE_DIR}/qt6")

# Host binaries: moc and rcc run on the build machine, not the target.
set(POCKETBOOK_MOC "/usr/lib/qt6/libexec/moc")
set(POCKETBOOK_RCC "/usr/lib/qt6/libexec/rcc")

# softfp is mandatory: a hardfp binary will not link against the firmware's libraries.
set(POCKETBOOK_ARCH_FLAGS "-march=armv7-a -mtune=cortex-a7 -mfpu=neon -mfloat-abi=softfp")

set(CMAKE_C_FLAGS "-fsigned-char -Werror=return-type ${POCKETBOOK_ARCH_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "-fsigned-char -Werror=return-type ${POCKETBOOK_ARCH_FLAGS}" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_RELEASE "-DNDEBUG -O2 -pipe -fomit-frame-pointer" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_RELEASE "-DNDEBUG -O2 -pipe -fomit-frame-pointer" CACHE STRING "" FORCE)
set(CMAKE_C_FLAGS_DEBUG "-DDEBUG -O0 -g -pipe" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS_DEBUG "-DDEBUG -O0 -g -pipe" CACHE STRING "" FORCE)
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "-s" CACHE STRING "" FORCE)

# The SDK's libraries name libraries this repository does not carry (libjpeg.so.8 among them), so
# their own dependencies cannot be resolved here. An app's own imports are still checked.
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--allow-shlib-undefined" CACHE STRING "" FORCE)

# The device resolves every library from /ebrmain/lib, so an rpath is dead weight.
set(CMAKE_SKIP_BUILD_RPATH ON)

add_definitions(-DPLATFORM_FC)
