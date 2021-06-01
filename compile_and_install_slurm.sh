#!/bin/bash
if [ $# -ne 2 ];
then
        echo "Script needs to be invoked with two arguments."
    echo "./compile_and_install_slurm.sh  /slurm_source /target_install_dir"
fi

slurm_source_dir="$1"
install_dir="$2"
base_dir=$(pwd)

echo "Compiling and installing Slurm from ${slurm_source_dir} to "\
"${install_dir}"

mkdir -p "${install_dir}"
mkdir -p "${install_dir}/slurm_varios/var/state"
mkdir -p "${install_dir}/slurm_varios/var/spool"
mkdir -p "${install_dir}/slurm_varios/log"
mkdir -p "${install_dir}/slurm_conf"

export LIBS="-lrt -lm"

export CFLAGS="-D SLURM_SIMULATOR -D SELECT_DEBUG"

cd "${slurm_source_dir}"

echo "Running Configure"


./configure --exec-prefix=$install_dir/slurm_programs \
--bindir=$install_dir/slurm_programs/bin \
--sbindir=$install_dir/slurm_programs/sbin \
--datadir=$install_dir/slurm_varios/share \
--includedir=$install_dir/slurm_varios/include \
--libdir=$install_dir/slurm_varios/lib \
--libexecdir=$install_dir/slurm_varios/libexec \
--localstatedir=$install_dir/slurm_varios \
--sharedstatedir=$install_dir/slurm_varios \
--mandir=$install_dir/slurm_varios/man \
--prefix=$install_dir/slurm_programs --sysconfdir=$install_dir/slurm_conf \
--without-hwloc \
--without-zlib \
--disable-pam \
--with-hdf5=no \
--enable-front-end \
--enable-simulator 2> slurm_configure.log

echo "Compiling"
make -j10

echo "Installing"
make -j install

echo "Compiling simulator binaries"
cd contribs/simulator
make

echo "Installing simulator binaries"
make -j install

cp ${base_dir}/templates/trace.sh.template.extended $install_dir/slurm_varios
cp ${base_dir}/templates/slurm.conf.* $install_dir/slurm_conf
cp ${base_dir}/templates/users.sim $install_dir/slurm_conf
cp ${base_dir}/templates/env.sh $install_dir

USERNAME=$(whoami)
echo "$(whoami):$(id -u $USERNAME)" >> $install_dir/slurm_conf/users.sim
sed -i "s/dsuser/${USERNAME}/g" $install_dir/slurm_conf/*

