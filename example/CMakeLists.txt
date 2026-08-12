set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

pocketbook_add_app(kitchensink
  SOURCES
    src/main.cpp
    src/device_info.cpp
  QRC qml/kitchensink.qrc
)

target_compile_definitions(kitchensink PRIVATE QT_NO_CAST_FROM_ASCII QT_NO_CAST_TO_ASCII)
