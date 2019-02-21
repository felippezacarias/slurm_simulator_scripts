#SimulationMode=yes
AuthType=auth/none
#AuthType=auth/munge
###UsePAM=0
SlurmUser=bsc28161
SlurmdUser=bsc28161
ControlMachine=TOKEN_CONTROL_MACHINE #ubuntu
ControlAddr=TOKEN_CONTROL_MACHINE #ubuntu
SlurmctldTimeout=300
SlurmdTimeout=300
MessageTimeout=60
ReturnToService=1

#SlurmctldPort=68256
#SlurmdPort=6827
#SlurmdPort=68189
SlurmctldPort=TOKEN_SLURMCTLD_PORT
SlurmdPort=TOKEN_SLURMD_PORT
CryptoType=crypto/openssl
JobCredentialPrivateKey=TOKEN_SLURM_USER_PATH/slurm_conf/slurm.key
JobCredentialPublicCertificate=TOKEN_SLURM_USER_PATH/slurm_conf/slurm.cert
#CryptoType=crypto/munge
PluginDir=TOKEN_SLURM_USER_PATH/slurm_varios/lib/slurm
TaskPlugin=task/none
PropagatePrioProcess=0
PropagateResourceLimitsExcept=CPU
###PropagateResourceLimitsExcept=None
ProctrackType=proctrack/linuxproc
KillWait=60
WaitTime=120
###MaxJobCount=8000
MaxJobCount=20000
MinJobAge=300
#MinJobAge=10
OverTimeLimit=1
InactiveLimit=1800

JobAcctGatherType=jobacct_gather/none
JobAcctGatherFrequency=30

# Job completion (redundant when accounting is used)--However, I believe that the BSC simulator currently needs this.
JobCompType=jobcomp/script
#JobCompType=jobcomp/none
JobCompLoc=TOKEN_SLURM_USER_PATH/slurm_varios/trace.sh

SlurmctldDebug=debug5
SlurmctldLogFile=TOKEN_SLURM_USER_PATH/slurm_varios/log/slurmctld.log
SlurmdDebug=debug5
SlurmdLogFile=TOKEN_SLURM_USER_PATH/slurm_varios/log/slurmd.log

#DebugFlags=Backfill

SlurmdSpoolDir=TOKEN_SLURM_USER_PATH/slurm_varios/var/spool
StateSaveLocation=TOKEN_SLURM_USER_PATH/slurm_varios/var/state
CacheGroups=0
###FastSchedule=1
CheckpointType=checkpoint/none
SwitchType=switch/none
MpiDefault=none
###FirstJobId=1000
SchedulerType=sched/backfill
#SchedulerParameters=bf_interval=30,bf_queue_limit=TOKEN_BF_QUEUE_LIMIT,bf_max_job_test=100,default_queue_depth=50
SchedulerParameters=bf_interval=30,bf_queue_limit=TOKEN_BF_QUEUE_LIMIT,default_queue_depth=50
###PriorityDecayHalfLife=7-0
#PriorityDecayHalfLife=14-00:00:00
###SelectType=select/cons_res
#SelectType=select/linear # As close as this simulator env can get to being select/alps
###SelectTypeParameters=CR_CPU
#TopologyPlugin=topology/tree
SelectType=select/cons_res
SelectTypeParameters=CR_Core_Memory
#SelectTypeParameters=CR_core

#PriorityType=priority/multifactor
#PriorityWeightAge=50000000 ###100
#PriorityWeightFairShare=0
#PriorityWeightQOS=0 ###1000000000
#PriorityWeightPartition=0 ###0
#PriorityWeightJobSize=600000000 ###0
#AccountingStorageType=accounting_storage/filetxt
#AccountingStorageLoc=TOKEN_SLURM_USER_PATH/slurm_varios/job_accounting
#AccountingStorageType=accounting_storage/slurmdbd
#AccountingStorageHost=localhost
###AccountingStorageEnforce=limits,qos
################################################################################################################AccountingStorageEnforce=limits
ClusterName=perfdevel_mall

###NodeName=DEFAULT RealMemory=3168 Procs=12 Sockets=2 CoresPerSocket=6 ThreadsPerCore=1
###NodeName=n[1-126] NodeAddr=bre NodeHostName=bre Procs=12 Sockets=2 CoresPerSocket=6 ThreadsPerCore=1

###PartitionName=projects Nodes=n[1-122] Default=YES MaxTime=INFINITE State=UP
###PartitionName=debug Nodes=n[123-126] Default=NO MaxTime=20:00 State=UP
FrontendName=TOKEN_CONTROL_MACHINE #ubuntu

#DefaultStorageType=slurmdbd

SlurmctldPidFile=TOKEN_SLURM_USER_PATH/slurm_varios/slurmctld.pid
SlurmdPidFile=TOKEN_SLURM_USER_PATH/slurm_varios/slurmd.pid

#PriorityFavorSmall=YES
#PriorityUsageResetPeriod=QUARTERLY    # CSCS policy
#PriorityFlags=SMALL_RELATIVE_TO_TIME



#DefMemPerNode=32768
#MaxMemPerNode=32768



FastSchedule=2

# Original
#NodeName=nid0[0008-0063,0072-0127,0136-0191,0200-0255,0264-0323,0328-0383,0388-0451,0456-0511,0516-0579,0584-0767,0772-0835,0840-0895,0900-0963,0968-1151,1156-1219,1224-1279,1284-1535,1540-1603,1608-1663,1668-1919,1924-1987,1992-2047,2052-2303,2308-2371,2376-2431,2436-2687,2692-2755,2760-2815,2820-3071,3076-3139,3144-3455,3460-3523,3528-3839,3844-3907,3912-4223,4228-4291,4296-4607,4992-5443,5448-5759,5764-5827,5832-5951,5956-6143] Sockets=2 CoresPerSocket=12 ThreadsPerCore=1 RealMemory=64523 TmpDisk=32258 

#PartitionName=normal Nodes=nid0[0008-0063,0072-0127,0136-0191,0200-0255,0264-0323,0328-0383,0388-0451,0456-0511,0516-0579,0584-0767,0772-0835,0840-0895,0900-0963,0968-1151,1156-1219,1224-1279,1284-1535,1540-1603,1608-1663,1668-1919,1924-1987,1992-2047,2052-2303,2308-2371,2376-2431,2436-2687,2692-2755,2760-2815,2820-3071,3076-3139,3144-3455,3460-3523,3528-3839,3844-3907,3912-4223,4228-4291,4296-4607,4992-5443,5448-5759,5764-5827,5832-5951,5956-6143] Default=YES State=UP Shared=EXCLUSIVE DefMemPerNode=64000

NodeName=n[1-TOKEN_NNODES_HALF] Sockets=2 CoresPerSocket=24 ThreadsPerCore=1 RealMemory=95200
NodeName=n[HALF_PLUS_1-TOKEN_NNODES] Sockets=2 CoresPerSocket=24 ThreadsPerCore=1 RealMemory=385000
PartitionName=normal Nodes=n[1-TOKEN_NNODES] Default=YES MaxTime=INFINITE State=UP Shared=NO

