cmake_minimum_required(VERSION 2.8)

project(ej8-4)

add_executable(ej8-4 main.cpp)
target_link_libraries(ej8-4 PGUPV)

include(../PGUPV/pgupv.cmake)

set_target_properties( ej8-4 PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY_DEBUG   ${CMAKE_SOURCE_DIR}/bin 
  RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_SOURCE_DIR}/bin
)

install(TARGETS ej8-4 DESTINATION ${PG_SOURCE_DIR}/bin)
