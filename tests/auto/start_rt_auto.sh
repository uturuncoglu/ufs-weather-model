#!/bin/bash --login
set -eux

if [[ $HOSTNAME == hfe* ]]; then
  export PATH=/scratch1/NCEPDEV/nems/emc.nemspara/soft/miniconda3/bin:$PATH
  export PYTHONPATH=/scratch1/NCEPDEV/nems/emc.nemspara/soft/miniconda3/lib/python3.8/site-packages
elif [[ $HOSTNAME == hecflow* ]]; then
  export PATH=/scratch1/NCEPDEV/nems/emc.nemspara/soft/miniconda3/bin:$PATH
  export PYTHONPATH=/scratch1/NCEPDEV/nems/emc.nemspara/soft/miniconda3/lib/python3.8/site-packages
elif [[ $HOSTNAME == Orion-login-* ]]; then
  export PATH=/work/noaa/nems/emc.nemspara/soft/miniconda3/bin:$PATH
  export PYTHONPATH=/work/noaa/nems/emc.nemspara/soft/miniconda3/lib/python3.8/site-packages
elif [[ $HOSTNAME == fe* ]]; then
  export PATH=/contrib/spack-stack/miniconda3/23.11.0/envs/ufs-weather-model/bin:/contrib/spack-stack/miniconda3/23.11.0/bin:${PATH}
  export PYTHONPATH=/contrib/spack-stack/miniconda3/23.11.0/envs/ufs-weather-model/lib/python3.8/site-packages:/contrib/spack-stack/miniconda3/23.11.0/lib/python3.8/site-packages
elif [[ $HOSTNAME == gaea* ]]; then
  export PATH=/lustre/f2/pdata/esrl/gsd/contrib/miniconda3/4.8.3/envs/ufs-weather-model/bin:$PATH
  export PYTHONPATH=/lustre/f2/pdata/esrl/gsd/contrib/miniconda3/4.8.3/lib/python3.8/site-packages
elif [[ $HOSTNAME == *chadmin* ]]; then
  export MACHINE_ID=derecho
  export PATH=/glade/p/ral/jntp/tools/miniconda3/4.8.3/envs/ufs-weather-model/bin:/glade/p/ral/jntp/tools/miniconda3/4.8.3/bin:$PATH
  export PATH=/glade/work/epicufsrt/contrib/derecho/rocoto/bin:$PATH
  export PYTHONPATH=/glade/p/ral/jntp/tools/miniconda3/4.8.3/envs/ufs-weather-model/lib/python3.8/site-packages:/glade/p/ral/jntp/tools/miniconda3/4.8.3/lib/python3.8/site-packages
else
  echo "No Python Path for this machine."
  exit 1
fi

python rt_auto.py

exit 0
