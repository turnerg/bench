Compiling on Linux

On IU's Cray BigRed3, pick your compiler

    module load openmpi/intel/4.0.2 
    module load openmpi/gnu/4.0.1


mpicc -o b_eff -D MEMORY_PER_PROCESSOR=NNN b_eff.c -lm

where NNN is a number like 128, 256, 512, 1024 
Units are MiBytes; i.e. 1024*1024

References:
	https://fs.hlrs.de/projects/par/mpi/b_eff/
	http://icc.dur.ac.uk/~tt/b_eff.pdf
	https://pdfs.semanticscholar.org/50d5/ce1c6eefdd934c2200ca168f5e85b1ec13ed.pdf
	https://fs.hlrs.de/projects/par/mpi/b_eff/output.html


If not stated other, always the bandwidth per process is printed. 
The output has the following sections:

HEAD

Short information about the memory per processor, the used cartesian
dimensions, and the used values for L (message length).

LOOP

The time spent on the measurements is printed.

LOOPLNGS

The automatically adapted values of looplength are printed.

VALUES

The benchmark measurements are done in this sections. Following output is printed: 
For each value of L, each method and each pattern:

min:

b(L) / (total number of messages of a pattern) * (maximum of messages in one
process) i.e. the minimal bandwidth of one process (except bundary nodes in
acyclic cartesian topologies). The value is printed for each repetition.

->

The maximum of all repetitions and in parentheses the amount of time spent on
the measurement of these values.

avg:

Same as min, but the average of the time spent on the several processes is
computed

max: 

Same as min, but the maximum of the time spent on the several processes
is computed

ELAPSED

The time spent on the measurements and the same time computed via the values
of b(L), i.e. computed with the maximum of time spent for each measurement on
all nodes. If the difference is more than 5% of the whole time then this is a
hint, that the benchmark was not executed on a dedicated system or the MPI
implementation has a bug.

PATTERN

Description of the patterns.

BY-METHODS

Separate analysis for each pattern and each communication method.

BY-REPETITIONS

Separate analysis for each pattern and each repetition.

BY-MTHD-MSGLNG

Separate analysis for each pattern, each communication method and each message
length.

BY-MSGLNG

Separate analysis for each message length. The columns are

The message length.

Accumulated effective bandwidth for this message length.

Effective bandwidth per process for this message length.

Effective bandwidth per process, cartesian patterns only.

Effective bandwidth per process, random patterns only.

Effective bandwidth per process, method 1 (Sendrecv) only.

Effective bandwidth per process, method 2 (Alltoallv) only.

Effective bandwidth per process, method 3 (Irecv+Isend+Waitall) only.

BY-PATTERN-MSGLNG

Separate analysis for each pattern and some message lengths. The last column
is the base for computing the logarithmic average of the cartesian and random
patterns. The last line shows the effective bandwidth per process.

BEFF

The effective bandwidth beff and the system parameters are printed.

Final result line

Summary of the result on one line.
