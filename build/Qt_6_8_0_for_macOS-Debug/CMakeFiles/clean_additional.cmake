# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appTestQT_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appTestQT_autogen.dir/ParseCache.txt"
  "appTestQT_autogen"
  )
endif()
