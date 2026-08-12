# Declared by hand: Debian's Qt6 CMake config hard-requires WrapOpenGL, which this device has none of.
set(POCKETBOOK_QT_CANDIDATE_MODULES
  Core Gui Qml Quick Network DBus Sql Xml Concurrent Widgets Svg SvgWidgets WebSockets
  QuickControls2 QuickTemplates2 QuickShapes QmlModels PrintSupport
  CACHE INTERNAL "Qt modules to declare if the toolchain provides them"
)

set(POCKETBOOK_QT_MODULES "")
foreach(module IN LISTS POCKETBOOK_QT_CANDIDATE_MODULES)
  set(library "${POCKETBOOK_TARGET_LIB_DIR}/libQt6${module}.so.6")
  if(NOT EXISTS "${library}")
    continue()
  endif()

  list(APPEND POCKETBOOK_QT_MODULES ${module})
  if(NOT TARGET Qt6::${module})
    add_library(Qt6::${module} SHARED IMPORTED GLOBAL)
    set_target_properties(Qt6::${module} PROPERTIES
      IMPORTED_LOCATION "${library}"
      INTERFACE_INCLUDE_DIRECTORIES
        "${POCKETBOOK_QT_INCLUDE_DIR};${POCKETBOOK_QT_INCLUDE_DIR}/Qt${module}"
    )
  endif()
endforeach()
set(POCKETBOOK_QT_MODULES "${POCKETBOOK_QT_MODULES}" CACHE INTERNAL "Declared Qt modules")

# Cached, not a directory variable, so AUTOMOC still finds it in a consumer's own directory.
set(QT_VERSION_MAJOR 6 CACHE INTERNAL "Qt major version, for AUTOMOC")
if(NOT TARGET Qt6::moc)
  add_executable(Qt6::moc IMPORTED GLOBAL)
  set_target_properties(Qt6::moc PROPERTIES IMPORTED_LOCATION "${POCKETBOOK_MOC}")
endif()
