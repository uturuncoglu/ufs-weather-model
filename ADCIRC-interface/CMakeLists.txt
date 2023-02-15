###############################################################################
### ADCIRC Fortran compiler flags
###############################################################################

if(CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
  set(CMAKE_Fortran_FLAGS "-g -fbacktrace")
  #set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fdefault-real-8 -fdefault-double-8")
  #set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Waliasing -fcray-pointer -fconvert=big-endian -ffree-line-length-none -fno-range-check -fbacktrace")
  #set(CMAKE_Fortran_FLAGS_RELEASE "-O2")
  #set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -fcheck=bounds -ffpe-trap=invalid,zero,overflow,underflow" )
  #set(CMAKE_Fortran_LINK_FLAGS "")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
  #set(CMAKE_Fortran_FLAGS "-g -traceback")
  #set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -i4 -r8")
  #set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fno-alias -auto -safe-cray-ptr -ftz -assume byterecl -sox")
  #set(CMAKE_Fortran_FLAGS_RELEASE "-O2 -debug minimal -fp-model source")
  #set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -check -check noarg_temp_created -check nopointer -fpe0 -ftrapuv -init=snan,arrays")
  #set(CMAKE_Fortran_LINK_FLAGS "")
  set(CMAKE_Fortran_FLAGS "-extend-source")
else()
  message(WARNING "Fortran compiler with ID ${CMAKE_Fortran_COMPILER_ID} will be used with CMake default options")
endif()
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${MOM6_Extra_FORTRAN_FLAGS}")

###############################################################################
### File lists
###############################################################################

include("adcirc_files.cmake")

###############################################################################
### Options
###############################################################################

if(32BIT)
  message(STATUS "Compile with 32-bit precision")
  add_definitions(-DREAL4)
else()
  message(STATUS "Compile with 64-bit precision")
  add_definitions(-DREAL8)
endif()

###############################################################################
### Libraries
###############################################################################

### Create target library
add_library(adcirc STATIC ${adcirc_src_files})

### Set PUBLIC interfaces on the library
set_target_properties(adcirc PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod)
target_include_directories(adcirc PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/mod>
                                         $<INSTALL_INTERFACE:mod>)
target_link_libraries(adcirc PUBLIC esmf)

###############################################################################
### Create source file/s
###############################################################################

add_custom_target(version DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/version_cmake.F)
add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/version_cmake.F
  COMMAND ./adcircVersion.sh ${CMAKE_CURRENT_SOURCE_DIR}/ADCIRC
  COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/ADCIRC/version.F
    ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/version_cmake.F
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/ADCIRC/scripts
  COMMENT "Generating ADCIRC version...")
add_dependencies (adcirc version)

#add_custom_command(
#  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/version.F
#  PRE_BUILD
#  #COMMAND ./adcircVersion.sh ${CMAKE_CURRENT_SOURCE_DIR}/ADCIRC >/dev/null
#  ${CMAKE_COMMAND} -E echo Hi this is a custom target
#  #WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/ADCIRC/scripts"
#  #DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/ADCIRC/scripts/adcircVersion.sh"
#  COMMENT "Generating version.F ..."
#  VERBATIM)

  #OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/version_cmake.F
  #COMMAND ./adcircVersion.sh ${CMAKE_CURRENT_SOURCE_DIR}/ADCIRC >/dev/null
  #COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/ADCIRC/version.F
  #        ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/version_cmake.F
  #WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/ADCIRC/scripts
  #COMMENT "Generating ADCIRC version...")

###############################################################################
### Install
###############################################################################

install(
  TARGETS adcirc
  EXPORT  adcirc-config
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  COMPONENT Library)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod DESTINATION ${CMAKE_INSTALL_PREFIX}/ADCIRC)

install(EXPORT      adcirc-config
        DESTINATION lib/cmake)
