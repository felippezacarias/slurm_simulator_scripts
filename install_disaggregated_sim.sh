#!/bin/bash

work_dir=`pwd`

echo "Compiling disaggregated approach"
slurm_install_dir="${work_dir}/install_ewhb1q1"
slurm_source_dir="${work_dir}/disaggregated"

git clone -b disaggregated --single-branch https://github.com/felippezacarias/slurm_simulator.git disaggregated


sed -i "s|/home/user/|${work_dir}/slowdown_model_files/|g" disaggregated/src/common/lrmodel.c


cd $slurm_source_dir
make clean

echo "Regenerating automake Makefiles in Slurm"
autoreconf -f -v

cd $work_dir

./compile_and_install_slurm.sh "${slurm_source_dir}" "${slurm_install_dir}"

sed -i 's/cons_res/cons_res_ehybrid/g' ${slurm_install_dir}/slurm_conf/*
sed -i 's/OverSubscribe=EXCLUSIVE//g' ${slurm_install_dir}/slurm_conf/*

echo "Compiling trace builder"
gcc ${slurm_source_dir}/contribs/simulator/memorymodel2trace.c -I${slurm_source_dir}/ -o trace_disaggregated_builder -lm

