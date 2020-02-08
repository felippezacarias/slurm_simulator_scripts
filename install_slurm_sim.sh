#!/bin/bash

work_dir=`pwd`
slurm_install_dir="${work_dir}/install"
slurm_source_dir="${work_dir}/slurm"

cd $slurm_source_dir

echo "Regenerating automake Makefiles in Slurm"
## For version < 19.05
#./autogen.sh > ../autogen.output.txt
## For version > 19.05
autoreconf

cd $work_dir

./compile_and_install_slurm.sh "${slurm_source_dir}" "${slurm_install_dir}"
