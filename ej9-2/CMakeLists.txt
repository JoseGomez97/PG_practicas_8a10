cmake_minimum_required(VERSION 2.8)

project(ej9-2)

add_executable(ej9-2 main.cpp)
target_link_libraries(ej9-2 PGUPV)

include(../PGUPV/pgupv.cmake)

set_target_properties( ej9-2 PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY_DEBUG   ${CMAKE_SOURCE_DIR}/bin 
  RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_SOURCE_DIR}/bin
)

install(TARGETS ej9-2 DESTINATION ${PG_SOURCE_DIR}/bin)
