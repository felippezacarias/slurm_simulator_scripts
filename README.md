To install the Simulator:
- Run: ./install_slurm_sim.sh
--it will call compile_and_install_slurm.sh.

DIRECTORIES ORGANIZATION:
- Simulator's source code is under slurm directory
- SLURM daemons' binaries will be installed in install/slurm_programs/sbin.
- SLURM and SLURM simulator's binaries will be installed in install/slurm_programs/bin.

LAUCHING SIMULATOR:
- On a cluster: sbatch submit_serial_simulation.sh 0 ../trace_name
- Local: ./submit_local.sh <id_folder_simulation> 0 ../trace_name


INPUTS:
- cirne.10n.maxjob8n.anl.200.arrin10min.jobcomp.sim is a small input trace example of 200 jobs generated by CIRNE model for the system of 10 nodes, max job size 8 nodes.

PREPARING INPUT:
- Use/modify swf2trace.c (contribs/simulator) 
- gcc -O3 -g -Wall  swf2trace.c -o swf2trace -lm
- ./swf2trace input.swf
- it will generate a file called simple.trace and you can use this file to execute the simulation.
- From workload_test branch compile swf2trace using
	- gcc swf2trace.c -o swf2trace -I../../ -lm

OUTPUTS:
- Job completion log will be under simulation_<output>/TRACES/trace.test.<output>$
- SLURM daemons'logs. if enabled in slurm.conf, will be under slurm_varios/log/

TIPS:
- For version > 19.05, check if the system has: autoconf,automake,gtk2-devel installed. Also use autoreconf to generate configure files.
- Before launching the local or remote job be sure your user is on slurm.conf files and users.sim. This only need to be done once.
- To modify users on slurm.conf execute: sed -i 's/bsc28161/<user_name>/g' slurm.conf.template
- To add your user to  users.sim type: echo "$(whoami):$(id -u bscuser)" >> users.sim
- Also check if the users specified on the users.sim match with their id using the commmand id -u <user_name> 
