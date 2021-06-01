#!/bin/bash

DATE_START=$(date +%s)

BASEDIR=$(pwd)
template_folder=$BASEDIR/templates

inputfolder="${BASEDIR}/input/traces/"

nnodes=SCNNODES
nsockets=SCNSOCKETS
ncores=SCNCORES
nmemory=SCNMEMORY
foldertocp=SCFOLDER
traceinput=SCTRACE
iter=SCITER

sim_name="${foldertocp}_${traceinput}_${nnodes}n_$(($nsockets*$ncores))c_${nmemory}mb_$iter"

aux_res_folder="${traceinput}"
traceinput=${inputfolder}${traceinput}".sim"

bf_queue_limit=x

sim_path="sim_"${sim_name}
res_path="res_${sim_path}"

if [ -e $sim_path ]
then
	#echo "[ERROR]"
	echo "Folder $sim_path exists! Remove or provide another arg for [$sim_name]"
	exit 0
fi

aux_res_folder="output"
if [ ! -e $aux_res_folder ]
then
	mkdir $aux_res_folder
fi

mkdir $sim_path
cp -r "install_$foldertocp"/* $sim_path

sim_path="$(pwd)/$sim_path"

control_host="localhost"

slurm_conf_template="$sim_path/slurm_conf/slurm.conf.template"

SLURM_JOBID=11965668

slurmctld_port=$((($SLURM_JOBID%65535)))

ok="0";
while [ $ok -eq "0" ];
do
	PRES=$(egrep -w "${slurmctld_port}/(tcp|udp)" /etc/services)
	if [[ ! -z "$PRES" ]];
    	then
		echo "${slurmctld_port} ok"
        	ok="1"
	else
		echo "Trying another slurmctld port"
		slurmctld_port=$(($slurmctld_port+1))
	fi
done

slurmd_port=$(($slurmctld_port+12))
ok="0";
while [ $ok -eq "0" ];
do
	PRES=$(egrep -w "${slurmd_port}/(tcp|udp)" /etc/services)
	if [[ ! -z "$PRES" ]];
        then
			echo "${slurmd_port} ok"
            ok="1"
        else
			echo "Trying another slurmd port"
            slurmd_port=$(($slurmd_port+1))
        fi
done

openssl genrsa -out $sim_path/slurm_conf/slurm.key 1024
openssl rsa -in $sim_path/slurm_conf/slurm.key -pubout -out $sim_path/slurm_conf/slurm.cert

cd $sim_path

sed -e s/{ID_JOB}/$SLURM_JOBID/ \
    -e s:{DIR_WORK}:$sim_path: slurm_varios/trace.sh.template.extended > slurm_varios/trace.sh;

chmod +x slurm_varios/trace.sh

mkdir TRACES

sed -e s:TOKEN_SLURM_USER_PATH:$sim_path: \
    -e s:TOKEN_CONTROL_MACHINE:$control_host: \
    -e s:TOKEN_NNODES:$nnodes: \
    -e s:TOKEN_NSOCKETS:$nsockets: \
    -e s:TOKEN_NCORES:$ncores: \
    -e s:TOKEN_NMEMORY:$nmemory: \
    -e s:TOKEN_SLURMCTLD_PORT:$slurmctld_port: \
    -e s:TOKEN_SLURMD_PORT:$slurmd_port: \
    -e s:TOKEN_BF_QUEUE_LIMIT:$bf_queue_limit: \
    $slurm_conf_template > $sim_path/slurm_conf/slurm.conf



source env.sh

export SLURM_CONF=$(pwd)/slurm_conf/slurm.conf
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$(pwd)/slurm_varios/lib/slurm

${sim_path}/slurm_programs/bin/sim_mgr 0 -f -w $traceinput


cd ..
mkdir $res_path
mv ${sim_path}/slurm_varios/log $res_path
mv ${SLURM_CONF} $res_path
mv ${sim_path}/TRACES $res_path
rm -r ${sim_path}

DATE_END=$(date +%s)
DTRT=$(echo "${DATE_END}-${DATE_START}" | bc)
echo "JOB_RUNTIME $DTRT"

DATE_START=$(date +%s)

echo "Formating trace log"
if [ -f "${res_path}/TRACES/trace.test.${SLURM_JOBID}" ]; then
	${template_folder}/./format_simul_trace.sh ${res_path}/TRACES/trace.test.${SLURM_JOBID} trace_${sim_name}.csv
	${template_folder}/./format_simul_utilization.sh ${res_path}/log/slurmctld.log utilization_${sim_name}.csv
	${template_folder}/./format_simul_overhead.sh ${res_path}/log/slurmctld.log overhead_${sim_name}.csv
fi

DATE_END=$(date +%s)
DTRT=$(echo "${DATE_END}-${DATE_START}" | bc)
echo "JOB_FORMAT $DTRT"

DATE_START=$(date +%s)

mv trace_${sim_name}.csv utilization_${sim_name}.csv overhead_${sim_name}.csv ${aux_res_folder}/
tar -czvf ${res_path}.tar.gz ${res_path}/
mv ${res_path}.tar.gz ${aux_res_folder}/
rm -r ${res_path}

DATE_END=$(date +%s)
DTRT=$(echo "${DATE_END}-${DATE_START}" | bc)
echo "JOB_ZIP $DTRT"

echo "killing detached process"
ps -aux | grep slurm  | awk '{print $2}' | xargs kill -9;
