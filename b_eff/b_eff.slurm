#!/bin/bash
#SBATCH --time=600
#SBATCH --nodes=2 --ntasks-per-node=1
#SBATCH --exclusive
#!#SBATCH --mail-type=BEGIN,END

# sbatch -o %x.o-%j-`date "+%Y%m%d%H%M%S"` b_eff.slurm

echo -ne "\nStarting at `date` \n\n"

echo -e "\n  SLURM environment\n"
echo SLURM_JOBID=$SLURM_JOBID
echo SLURM_JOB_NUM_NODES=$SLURM_JOB_NUM_NODES
echo SLURM_TASKS_PER_NODE=$SLURM_TASKS_PER_NODE
echo SLURM_NODELIST=$SLURM_NODELIST 

echo -e "\n  HOSTS\n"
srun -l /bin/hostname
echo 

cd ~/bench/b_eff
mkdir $SLURM_JOBID
cd $SLURM_JOBID

srun ../b_eff
EXIT_STATUS=$?

echo 
echo srun exit status = $EXIT_STATUS

echo -ne "\nExiting at  `date` \n\n"


