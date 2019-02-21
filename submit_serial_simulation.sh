#!/bin/bash -xe
#SBATCH -J slurm-simulator-into-slurm
#SBATCH -o OUTPUTS/test1_%j.out
#SBATCH -e OUTPUTS/test1_%j.err
#SBATCH -c 48
#SBATCH --nodes=1
#SBATCH -t 01:00:00
#SBATCH --qos=debug

#unset OMP_NUM_THREADS
#source enableenv_mn4

date

bf_queue_limit=5000

sim_path="simulation_"$SLURM_JOBID
mkdir $sim_path
cp -r install/* $sim_path

sim_path="$(pwd)/$sim_path"

control_host="$SLURM_NODELIST"

slave_nnodes=3456
#slave_nnodes=10

slurm_conf_template="$sim_path/slurm_conf/slurm.conf.template"

slurmctld_port=$((($SLURM_JOBID%65535))) #12 is the max number of jobs that can enter mn4 node
#not working, i will assume the risk instead of die trying 
#ok="0";
#while [ $ok -eq 0 ]
#do
#	netstat -ntl | grep [0-9]:$slurmctld_port -q ;
#	if [ $? -eq 1 ]
#    	then
#		echo qui
#        	ok="1"
#	else
#		echo li
#		slurmctld_porti=$(($slurmctld_port+1))
#	fi
#	echo ola
#done

slurmd_port=$(($slurmctld_port+12))
#ok="0";
#while [ $ok -eq 0 ]
#do
#        netstat -ntl | grep [0-9]:$slurmd_port -q ;
#	if [ $? -eq 1 ]
#        then
#                ok="1"
#        else
#                slurmctld_port=$(($slurmd_port+12))
#        fi
#	echo hola
#done

openssl genrsa -out $sim_path/slurm_conf/slurm.key 1024
openssl rsa -in $sim_path/slurm_conf/slurm.key -pubout -out $sim_path/slurm_conf/slurm.cert

cd $sim_path

sed -e s/{ID_JOB}/$SLURM_JOBID/ \
    -e s:{DIR_WORK}:$sim_path: slurm_varios/trace.sh.template > slurm_varios/trace.sh;

chmod +x slurm_varios/trace.sh

mkdir TRACES

sed -e s:TOKEN_SLURM_USER_PATH:$sim_path: \
    -e s:TOKEN_CONTROL_MACHINE:$control_host: \
    -e s:TOKEN_NNODES:$slave_nnodes: \
    -e s:TOKEN_SLURMCTLD_PORT:$slurmctld_port: \
    -e s:TOKEN_SLURMD_PORT:$slurmd_port: \
    -e s:TOKEN_BF_QUEUE_LIMIT:$bf_queue_limit: \
    $slurm_conf_template > $sim_path/slurm_conf/slurm.conf

#./run_sim.sh $1 $2 $3 > $SLURM_JOBID.log
#./run_sim_sudo.sh $1 $2  2>&1 > $3 &
#./run_sim_sudo.sh $1 $2
# 2>&1 > $3 &
source env.sh
#./reset_user.sh
#slurmdbd
export SLURM_CONF=$(pwd)/slurm_conf/slurm.conf
sim_mgr $1 -f -w $2

#generate output
#Not tested
#printf 'JobId;Nodes;NodeList;Submit time;Start time;End time;Wait time;Run time;Response time;Slowdown;Backfilled\n' > "o_"$workload_name".csv"
#cat TRACES/trace.test.$SLURM_JOBID | sed -e 's!JobId=!!' | sort -n | awk '{print "JobId="$1,$12,$11,$8,$9,$10,$15}' | awk '-F[=/ /]' '{split($0,a); printf("%d;%d;%s;%d;%d;%d;%d;%d;%d;%f;%d\n",a[2],a[4],a[6],a[8],a[10],a[12],a[10]-a[8],a[12]-a[10],a[12]-a[8],(a[12]-a[8])/(a[12]-a[10]),a[14]) }' >> "o_"$workload_name".csv"

#cat TRACES/trace.test.$SLURM_JOBID | sed -e 's!JobId=!!' | sort -n | awk '{print $8,$9,$10,$15}' | awk -F'[=/ /]' '{split($0,a); print a[2], a[4], a[6], a[8] }' > "o_"$workload_name

#cat TRACES/trace.test.$SLURM_JOBID | sed -e 's!JobId=!!' | sort -n | awk '{ print $1,$7,$8,$9,$10,$13 }' | awk -F'[=/ /]' '{split($0,a); printf("%s\t%s\t%s\t%s\t%s\t-1\t-1\t%s\t%s\t-1\t1\t-1\t-1\t-1\t-1\t-1\t-1\t-1\n",a[1]-1,a[5],a[7]-a[5],a[9]-a[7],a[11],a[11],a[3])}' > "o_"$workload_name".swf"

date
