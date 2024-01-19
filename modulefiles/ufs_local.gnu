#%Module

proc ModulesHelp {} {
  puts stderr "\tcit - loads modules required for building and running UFS Model on Linux/GNU"
}

module-whatis "loads UFS Model prerequisites for Linux/GNU"

module use /opt/ufs.local/modulefiles/Core

module load stack-gcc/11.4.0
module load stack-python/3.10.8
module load stack-openmpi/4.1.5

module load jasper/2.0.32
module load zlib/1.2.13
module load libpng/1.6.37
module load hdf5/1.14.0
module load netcdf-c/4.9.2
module load netcdf-fortran/4.6.0
module load parallelio/2.5.10
module load esmf/8.5.0
module load fms/2023.02.01
module load bacio/2.4.1
module load crtm-fix/2.4.0_emc
module load g2/3.4.5
module load g2tmpl/1.10.2
module load ip/4.3.0
module load sp/2.3.3
module load w3emc/2.10.0
module load gftl-shared/1.6.1
module load mapl/2.40.3-esmf-8.5.0
module load scotch/7.0.4

module load cmake/3.23.1

setenv CC mpicc
setenv CXX mpicxx
setenv F77 mpif77
setenv F90 mpif90
setenv FC mpif90
setenv CMAKE_Platform linux.gnu
