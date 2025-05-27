add_library(ramulator-memorysystem OBJECT)

target_sources(
  ramulator-memorysystem PRIVATE
  memory_system.h

  impl/Global_Controller.cpp
  impl/Global_Controller_RAW.cpp
)

target_link_libraries(
  ramulator
  PRIVATE
  ramulator-memorysystem
)