###############################################################################
### ADCIRC Fortran compiler flags
###############################################################################

if(CMAKE_Fortran_COMPILER_ID MATCHES "GNU")
  set(CMAKE_Fortran_FLAGS "-g -fbacktrace")
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Waliasing -fcray-pointer -fconvert=big-endian -ffixed-line-length-132 -fno-range-check -fbacktrace")
  set(CMAKE_Fortran_FLAGS_RELEASE "-O2")
  set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -fcheck=bounds -ffpe-trap=invalid,zero,overflow,underflow" )
  set(CMAKE_Fortran_LINK_FLAGS "")
elseif(CMAKE_Fortran_COMPILER_ID MATCHES "Intel")
  set(CMAKE_Fortran_FLAGS "-g -traceback")
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fno-alias -auto -safe-cray-ptr -ftz -assume byterecl -sox -extend-source")
  set(CMAKE_Fortran_FLAGS_RELEASE "-O2 -debug minimal -fp-model source")
  set(CMAKE_Fortran_FLAGS_DEBUG "-O0 -check -check noarg_temp_created -check nopointer -fpe0 -ftrapuv -init=snan,arrays")
  set(CMAKE_Fortran_LINK_FLAGS "")
else()
  message(WARNING "Fortran compiler with ID ${CMAKE_Fortran_COMPILER_ID} will be used with CMake default options")
endif()
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} ${ADCIRC_Extra_FORTRAN_FLAGS}")

# Machine/OS specific CPP definitions
if(SUN)
  add_definitions(-DCMACHSUN)
elseif(SGI)
  add_definitions(-DSGI)
elseif(CRAY)
  add_definitions(-DCRAY)
elseif(CRAYX1)
  add_definitions(-DCRAYX1)
elseif(UNIX)
  add_definitions(-DLINUX)
elseif(CYGWIN)
  add_definitions(-DLINUX)
elseif(WIN32)
  add_definitions(-DWINDOWS)
elseif(APPLE)
  add_definitions(-DLINUX)
endif(SUN)

if(SUN_MACHINE)
  add_definitions(-DCMACHSUN)
endif(SUN_MACHINE)

###############################################################################
### File lists
###############################################################################

include("adcirc_files.cmake")

###############################################################################
### Options
###############################################################################

# User option for 8-byte real numbers (or 4-byte if turned off)
set(PRECISION_8BYTE ON CACHE BOOL "Use 8-byte real numbers instead of 4-byte.")
if(PRECISION_8BYTE)
  message(STATUS "Compile with 64-bit precision")
  add_definitions(-DREAL8)
else(PRECISION_8BYTE)
  message(STATUS "Compile with 32-bit precision")
  add_definitions(-DREAL4)
endif(PRECISION_8BYTE)

# User option to build adcprep
set(BUILD_ADCPREP OFF CACHE BOOL "Build the MPI parallel ADCIRC preprocessor")

# User option to build utilities
set(BUILD_UTILITIES OFF CACHE BOOL "Build the ADCIRC utility programs")

###############################################################################
### External libraries like metis etc.
###############################################################################

if(BUILD_ADCPREP)
  add_library(metis STATIC ${metis_src_files})
  target_include_directories(metis PRIVATE $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/mod>
                                           $<INSTALL_INTERFACE:mod>)
  set_target_properties(metis PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif(BUILD_ADCPREP)

###############################################################################
### Library for ADCIRC
###############################################################################

add_library(adcirc STATIC ${adcirc_src_files})
set_target_properties(adcirc PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod)
target_include_directories(adcirc PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/mod>
                                         $<INSTALL_INTERFACE:mod>)
target_link_libraries(adcirc PUBLIC esmf)

###############################################################################
### Create source file/s
###############################################################################

add_library(version ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/version_cmake.F)
add_custom_command(
  OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/version_cmake.F
  COMMAND ./adcircVersion.sh ${CMAKE_CURRENT_SOURCE_DIR}/ADCIRC
  COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/ADCIRC/version.F
    ${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/version_cmake.F
  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/ADCIRC/scripts
  COMMENT "Generating ADCIRC version...")
set_target_properties(version PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod)

###############################################################################
### Install utilities 
###############################################################################

if(BUILD_UTILITIES)
  foreach(UTIL_FILE ${util_src_files})
    get_filename_component(UTIL_FILE_EXE ${UTIL_FILE} NAME_WE)
    add_executable(${UTIL_FILE_EXE} ${UTIL_FILE})
    set_target_properties(${UTIL_FILE_EXE} PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod)
    install(TARGETS ${UTIL_FILE_EXE} RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
  endforeach()
endif(BUILD_UTILITIES)

if(BUILD_ADCPREP)
  add_executable(adcprep ${adcprep_src_files})
  set_target_properties(adcprep PROPERTIES Fortran_MODULE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod)
  install(TARGETS adcprep RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

  add_library(mkdir ${CMAKE_CURRENT_SOURCE_DIR}/ADCIRC/prep/mkdir.c)
  target_include_directories(mkdir PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/mod>
                                          $<INSTALL_INTERFACE:mod>)
  set_target_properties(mkdir PROPERTIES EXCLUDE_FROM_ALL TRUE)
  target_link_libraries(adcprep mkdir)
  add_dependencies(adcprep mkdir)

  target_link_libraries(adcprep version)
  add_dependencies(adcprep version)

  target_link_libraries(adcprep metis)
  add_dependencies(adcprep metis)
endif(BUILD_ADCPREP)

###############################################################################
### Install
###############################################################################

install(
  TARGETS adcirc
          version
  EXPORT  adcirc-config
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  COMPONENT Library)

install(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mod DESTINATION ${CMAKE_INSTALL_PREFIX}/ADCIRC)

install(EXPORT      adcirc-config
        DESTINATION lib/cmake)
