#!/bin/bash

work_dir=`pwd`

echo "Compiling baseline approach"
slurm_install_dir="${work_dir}/install_sb1q1"
slurm_source_dir="${work_dir}/baseline"

git clone -b baseline --single-branch https://github.com/felippezacarias/slurm_simulator.git baseline

cd $slurm_source_dir
make clean

echo "Regenerating automake Makefiles in Slurm"
autoreconf -f -v

cd $work_dir

./compile_and_install_slurm.sh "${slurm_source_dir}" "${slurm_install_dir}"

