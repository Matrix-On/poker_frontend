# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/apppoker_tournament_view_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/apppoker_tournament_view_autogen.dir/ParseCache.txt"
  "apppoker_tournament_view_autogen"
  )
endif()
