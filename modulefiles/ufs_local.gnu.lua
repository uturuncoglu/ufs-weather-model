help([[
loads UFS Model prerequisites for Linux/GNU
]])

prepend_path("MODULEPATH", "/opt/ufs.local/modulefiles/Core")

gnu_ver=os.getenv("gnu_ver") or "11.4.0"
load(pathJoin("stack-gcc", gnu_ver))

python_ver=os.getenv("python_ver") or "3.10.8"
load(pathJoin("stack-python", python_ver))

mpt_ver=os.getenv("mpi_ver") or "4.1.5"
load(pathJoin("stack-openmpi", mpi_ver))

cmake_ver=os.getenv("cmake_ver") or "3.23.1"
load(pathJoin("cmake", cmake_ver))

local ufs_modules = {
  {["jasper"]          = "2.0.32"},
  {["zlib"]            = "1.2.13"},
  {["libpng"]          = "1.6.37"},
  {["hdf5"]            = "1.14.0"},
  {["netcdf-c"]        = "4.9.2"},
  {["netcdf-fortran"]  = "4.6.0"},
  {["parallelio"]      = "2.5.10"},
  {["esmf"]            = "8.5.0"},
  {["fms"]             = "2023.02.01"},
  {["bacio"]           = "2.4.1"},
  {["crtm-fix"]        = "2.4.0_emc"},
  {["g2"]              = "3.4.5"},
  {["g2tmpl"]          = "1.10.2"},
  {["ip"]              = "4.3.0"},
  {["sp"]              = "2.3.3"},
  {["w3emc"]           = "2.10.0"},
  {["gftl-shared"]     = "1.6.1"},
  {["mapl"]            = "2.40.3-esmf-8.5.0"},
  {["scotch"]          = "7.0.4"},
}

for i = 1, #ufs_modules do
  for name, default_version in pairs(ufs_modules[i]) do
    local env_version_name = string.gsub(name, "-", "_") .. "_ver"
    load(pathJoin(name, os.getenv(env_version_name) or default_version))
  end
end

setenv("CC", "mpicc")
setenv("CXX", "mpicxx")
setenv("F77", "mpif77")
setenv("F90", "mpif90")
setenv("FC", "mpif90")
setenv("CMAKE_Platform", "linux.gnu")
