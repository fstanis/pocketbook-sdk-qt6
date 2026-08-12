function(pocketbook_compile_qrc out_variable qrc)
  get_filename_component(qrc_path "${qrc}" ABSOLUTE)
  get_filename_component(qrc_directory "${qrc_path}" DIRECTORY)
  get_filename_component(qrc_name "${qrc_path}" NAME_WE)

  file(READ "${qrc_path}" qrc_text)
  string(REGEX MATCHALL "<file[^>]*>[^<]+</file>" entries "${qrc_text}")
  set(dependencies "")
  foreach(entry IN LISTS entries)
    string(REGEX REPLACE "<file[^>]*>([^<]+)</file>" "\\1" entry_path "${entry}")
    string(STRIP "${entry_path}" entry_path)
    list(APPEND dependencies "${qrc_directory}/${entry_path}")
  endforeach()

  # --no-zstd: the device's QtCore exports no qt_resourceFeatureZstd, and rcc references that
  # symbol whenever zstd is on the table, which links here and fails to load there.
  set(generated "${CMAKE_CURRENT_BINARY_DIR}/qrc_${qrc_name}.cpp")
  add_custom_command(
    OUTPUT "${generated}"
    COMMAND "${POCKETBOOK_RCC}" --name "${qrc_name}" --no-zstd
            --output "${generated}" "${qrc_path}"
    DEPENDS "${qrc_path}" ${dependencies}
    WORKING_DIRECTORY "${qrc_directory}"
    COMMENT "Compiling ${qrc}"
    VERBATIM
  )
  set_source_files_properties("${generated}" PROPERTIES SKIP_AUTOMOC ON)
  set(${out_variable} "${generated}" PARENT_SCOPE)
endfunction()

#[[
Adds an app the device's launcher can run.

  pocketbook_add_app(<name>
    SOURCES <file>...
    [QRC <file>]
    [LIBRARIES <target>...]
  )

Produces <name>.app, linked against Qt Quick and InkView; QRC is compiled into the binary, which
is how a QML scene reaches a device where the app is a single file with no directory beside it.
LIBRARIES adds to the default link set, e.g. PocketBook::CommonUtilities or Qt6::Network.
]]
function(pocketbook_add_app name)
  cmake_parse_arguments(PARSE_ARGV 1 arg "" "QRC" "SOURCES;LIBRARIES")
  if(NOT arg_SOURCES)
    message(FATAL_ERROR "pocketbook_add_app(${name}) needs SOURCES")
  endif()

  set(sources ${arg_SOURCES})
  if(arg_QRC)
    pocketbook_compile_qrc(qrc_source "${arg_QRC}")
    list(APPEND sources "${qrc_source}")
  endif()

  add_executable(${name} ${sources})
  set_target_properties(${name} PROPERTIES
    OUTPUT_NAME "${name}.app"
    SUFFIX ""
    AUTOMOC ON
    QT_MAJOR_VERSION 6
  )
  target_link_libraries(${name} PRIVATE
    Qt6::Quick
    Qt6::Qml
    Qt6::Gui
    Qt6::Core
    PocketBook::InkView
    ${arg_LIBRARIES}
  )
endfunction()
