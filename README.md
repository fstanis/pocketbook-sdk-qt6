# pocketbook-sdk-qt6

Build Qt Quick apps for PocketBook e-readers: CMake targets, a toolchain file, a cross-compiler
image, and a kitchen-sink example.

Apps dynamically link the Qt 6.8.2 already on the device, in `/ebrmain/lib`, and draw with
`com.pocketbook.controls`, the firmware's own QML component library in `/ebrmain/qml`.
[COMPONENTS.md](COMPONENTS.md) is the inventory. Nothing is bundled, so an app ships as a single ELF
with its own QML compiled in as a Qt resource.

## Use it in your own app

```cmake
cmake_minimum_required(VERSION 3.21)
project(myapp CXX)

set(CMAKE_CXX_STANDARD 20)

include(FetchContent)
FetchContent_Declare(pocketbook-sdk-qt6
  GIT_REPOSITORY https://github.com/fstanis/pocketbook-sdk-qt6.git
  GIT_TAG main
)
FetchContent_MakeAvailable(pocketbook-sdk-qt6)

pocketbook_add_app(myapp
  SOURCES src/main.cpp
  QRC qml/myapp.qrc
  LIBRARIES Qt6::Network
)
```

```bash
docker run --rm -v "$PWD:/src" -w /src ghcr.io/fstanis/pocketbook-sdk-qt6-builder \
  bash -c 'cmake -B build && cmake --build build'
```

`ghcr.io/fstanis/pocketbook-sdk-qt6-builder` is Debian trixie with `crossbuild-essential-armel`,
Qt 6.8.2 `:armel`, clang 19 and GCC 14, published for amd64 and arm64 by
[.github/workflows/builder-image.yml](.github/workflows/builder-image.yml). It sets
`CMAKE_TOOLCHAIN_FILE` in its environment, so no toolchain argument is needed. That has to come from
the image, because CMake consumes the variable on the first configure, before `FetchContent` has
fetched anything to point it at.

Copy the resulting `build/myapp.app` to `/mnt/ext1/applications/` and launch it from the Applications
list.

`pocketbook_add_app(<name> SOURCES <files> [QRC <file>] [LIBRARIES <targets>])` links Qt Quick and
InkView by default, runs AUTOMOC, compiles the `QRC` into the binary, and names the output
`<name>.app` with an empty suffix, which is the extension the launcher keys off. Available targets
are `PocketBook::InkView`, `PocketBook::HwConfig`, and `Qt6::` for every module the image provides
(`Core`, `Gui`, `Qml`, `Quick`, `Network`, `DBus`, `Sql`, `Xml`, `Svg`, `WebSockets`).

`FetchContent` checks out PocketBook's published SDK submodule, 2.6 GB for the four files used here.
To trim it:

```bash
git -C sdk sparse-checkout set SDK-B288/usr/arm-obreey-linux-gnueabi/sysroot/usr/local
```

## Writing an app

Order matters in `main()`, and most of it happens before `QGuiApplication` exists:

* Set `QT_PLUGIN_PATH=/ebrmain/plugins` and `QT_QPA_PLATFORM=pocketbook2`, then
  `QCoreApplication::setSetuidAllowed(true)`. The launcher starts apps in a way that trips Qt's
  setuid check.
* `InitInkview(TASK_MAKEACTIVE)`. The QPA plugin opens the screen itself if nobody has, but then the
  task is registered without `TASK_MAKEACTIVE` and every frame goes to a framebuffer the panel is not
  showing, which looks like a black screen.
* `QQuickWindow::setGraphicsApi(QSGRendererInterface::Software)`, before any `QQuickWindow`.
* `engine.addImportPath("/ebrmain/qml")` before loading the scene.
* Take the default font from `iv_get_default_font(FONT_FAMILY)`. Fontconfig does not produce a usable
  default here.
* Size the window from `ScreenWidth()`/`ScreenHeight()` minus `PanelHeight()`. The QPA plugin ignores
  a request for fullscreen visibility, and a `Window` that only asks for it ends up 0x0.

`inkview.h` in the submodule is the authoritative API reference. Keep InkView in as few translation
units as possible, because its unnamespaced `BLACK` and `ALIGN_*` macros collide with Qt headers.

Constraints the toolchain already enforces, worth knowing when adding a dependency:

* **`-mfloat-abi=softfp` is mandatory**, with `-march=armv7-a -mfpu=neon`. A hardfp binary will not
  link against `libinkview.so` or the firmware's Qt. Verify with `readelf -A`, which must report no
  `Tag_ABI_VFP_args`.
* **C++20.** Debian's GCC 14 libstdc++ supports it in full.
* **`rcc --no-zstd`**, applied to any `QRC`. Debian's QtCore is built with zstd and the device's is
  not: it exports `qt_resourceFeatureZlib` but no `qt_resourceFeatureZstd`, and rcc references that
  symbol whenever zstd is on the table. Without the flag the binary links but fails to load.
* **Qt is declared by hand, not via `find_package(Qt6)`.** Debian's Qt6 CMake config hard-requires
  WrapOpenGL, which would drag Mesa onto a link line the device cannot satisfy.
* Everything links by soname with no rpath (`CMAKE_SKIP_BUILD_RPATH`). The device resolves each
  library from `/ebrmain/lib`.
* The image's glibc is 2.41 against the device's 2.39, and a binary comes out needing only
  `GLIBC_2.34`. Check with `readelf -V` after adding a dependency.

## The example

```bash
git clone --recurse-submodules https://github.com/fstanis/pocketbook-sdk-qt6.git
cd pocketbook-sdk-qt6
docker run --rm -v "$PWD:/src" -w /src ghcr.io/fstanis/pocketbook-sdk-qt6-builder \
  bash -c 'cmake -B build -DCMAKE_TOOLCHAIN_FILE=/src/cmake/pocketbook.toolchain.cmake && cmake --build build'
```

Produces `build/example/kitchensink.app`. Pointing `CMAKE_TOOLCHAIN_FILE` at the checkout's own copy
shadows the one baked into the image, and the checkout's is the one under development here. Add
`-DCMAKE_BUILD_TYPE=Debug` for an unstripped `-O0 -g` build. An existing checkout without the
submodule needs `git submodule update --init --depth 1` first.

The kitchen sink puts most of `com.pocketbook.controls` on one screen: typography, buttons,
selection, text input, indicators, decoration, dialogs, and what the device reports about itself.
[example/src/device_info.h](example/src/device_info.h) is the only place InkView is called.

## Device

Tested only on the PocketBook InkPad Color 3. Other Allwinner B288 and B300 readers plausibly work,
since they share the softfp userland and the `/ebrmain` layout, but that is untested.

| | |
|---|---|
| Model | `Pocket743K3`, variant `U743k3`, description `PB743K3` |
| SoC | Allwinner A50 `sun8iw15` (`allwinner,sun8iw15p1`), 4x Cortex-A7 armv7l |
| ABI | armv7-a, NEON, softfp (no `Tag_ABI_VFP_args`) |
| Kernel | 4.9.56 |
| Userland | Buildroot 2024.05.1, glibc 2.39, libstdc++ up to `GLIBCXX_3.4.32` and `CXXABI_1.3.14` |
| Firmware built with | clang 15.0.3, GCC 13.3.0 runtime |
| Qt | 6.8.2 in `/ebrmain/lib`. The QPA plugin to use is `pocketbook2`, in `/ebrmain/plugins/platforms`. QML modules, Qt's own plus `com.pocketbook.controls`, are in `/ebrmain/qml`. None of the three is on a default search path for a binary on `/mnt/ext1`, so the app points Qt at them itself |
| Graphics | no GPU, no OpenGL, no libGL or libEGL. The firmware's `libQt6Gui.so` links neither, so software rasterisation is the only option |
| Locale | `ANSI_X3.4-1968`. Qt switches itself to `C.UTF-8` and warns as it does |
| Apps | plain ELF at `/mnt/ext1/applications/<name>.app`. `/ebrmain/config/extensions.cfg` maps `.app` to the launcher |
| Permissions | uid 101 (`reader`), no `CAP_NET_ADMIN` or `CAP_NET_RAW`, no usable `su` |
| Filesystems | rootfs, `/boot` and `/ebrmain` are read-only ext2. `/mnt/ext1` is writable vfat |

Qt is the one version pinned exactly, because an app shares class layouts with the device's
`libQt6*.so.6`.

## Why not PocketBook's own toolchain

Recent firmware is built on a current Buildroot, and Debian trixie lines up with it well enough to
cross-compile for the device directly. `armel` is ARM EABI with the soft-float calling convention,
the same as the firmware's; the `qt6-*:armel` packages are Qt 6.8.2, the exact version the device
ships; the libstdc++ soname matches; and a binary built here needs no glibc symbol above
`GLIBC_2.34`, which the device's 2.39 satisfies.

PocketBook's SDK toolchain (`/opt/SDK-B300-6.8`) targets much older firmware. Its libstdc++ is GCC
6.3.0's, from Buildroot 2017.05, and has no `<optional>`, no `<string_view>` and no `<chrono>`
literals. Qt 6 headers use all three, so it cannot compile a Qt app at all. Nothing here depends on
it.

The `sdk/` submodule is still used, but only for `inkview.h` and two link-time stub libraries. Those
stubs are older than the firmware's own (clang 7.0.0, GCC 6.3.0, Buildroot 2017.05, needing only
`GLIBC_2.4` through `2.7`), which is why linking against them cannot pull in a symbol the device
lacks.

## Layout

```
CMakeLists.txt  declares the targets and pocketbook_add_app(); builds the example when top-level
cmake/          pocketbook.toolchain.cmake (compiler and ABI flags only), PocketBookSDK.cmake
                (PocketBook::* targets), PocketBookQt.cmake (Qt6::* targets, only for modules the
                image has), PocketBookApp.cmake (pocketbook_add_app() and the rcc plumbing)
sdk/            submodule: pocketbook/SDK_6.3.0 branch 6.5. Four files are used, all from
                sdk/SDK-B288/usr/arm-obreey-linux-gnueabi/sysroot/usr/local: inkview.h, hwconfig.h,
                and libinkview.so/libhwconfig.so for the linker to resolve entry points and record
                sonames against. Nothing from it ships in an app; its compiler and sysroot are unused
example/        the kitchen sink: qml/ compiled into the binary, src/ for main() and the InkView bridge
tools/          the Dockerfile behind ghcr.io/fstanis/pocketbook-sdk-qt6-builder
```

Anything an app would need belongs in `cmake/`, and anything for the example's sake belongs in
`example/`. The top-level `CMakeLists.txt` must stay safe to `add_subdirectory`, so every imported
target is `GLOBAL`, and anything a consumer's own directory needs, such as `QT_VERSION_MAJOR` for
AUTOMOC, goes in the cache rather than a directory variable.

After editing the Dockerfile or the toolchain file, rebuild the image locally. The context is the
repository root because the image bakes in the toolchain file, and [.dockerignore](.dockerignore)
keeps the SDK submodule out of it.

```bash
docker build -f tools/Dockerfile -t ghcr.io/fstanis/pocketbook-sdk-qt6-builder .
```
