Pick your compiler

    module load openmpi/intel/4.0.2 
    module load openmpi/gnu/4.0.1

mpicc -o hello hello_c.c 
sbatch -o %x.o-%j-`date "+%Y%m%d%H%M%S"` hello.slurm 

mpicc -o connectivity connectivity_c.c
sbatch -o %x.o-%j-`date "+%Y%m%d%H%M%S"` connectivity.slurm

