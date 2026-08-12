get_filename_component(POCKETBOOK_SDK_ROOT
  "${CMAKE_CURRENT_LIST_DIR}/../sdk/SDK-B288/usr/arm-obreey-linux-gnueabi/sysroot/usr/local"
  ABSOLUTE)
set(POCKETBOOK_SDK_INCLUDE_DIR "${POCKETBOOK_SDK_ROOT}/include")

if(NOT EXISTS "${POCKETBOOK_SDK_INCLUDE_DIR}/inkview.h")
  message(FATAL_ERROR
    "The PocketBook SDK submodule is not checked out. Run:\n"
    "  git submodule update --init --depth 1\n"
    "from the root of this repository, or clone with --recurse-submodules.")
endif()

function(pocketbook_declare_library name file)
  if(TARGET PocketBook::${name})
    return()
  endif()
  add_library(PocketBook::${name} SHARED IMPORTED GLOBAL)
  set_target_properties(PocketBook::${name} PROPERTIES
    IMPORTED_LOCATION "${POCKETBOOK_SDK_ROOT}/lib/${file}"
    INTERFACE_INCLUDE_DIRECTORIES "${POCKETBOOK_SDK_INCLUDE_DIR}"
  )
endfunction()

pocketbook_declare_library(InkView libinkview.so)
pocketbook_declare_library(HwConfig libhwconfig.so)
