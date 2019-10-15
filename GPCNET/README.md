# Global Performance and Congestion Network Test - GPCNeT #

This benchmark suite consists of two applications:

network_test: Full system network tests in random and natural ring, alltoall 
              and allreduce

network_load_test: Select full system network tests run with four congestors to
                   measure network congestion or contention

# Compile #

To compile all applications:

make all

or

make all CC="MPI compiler wrapper"


To compile a specific test:

make network

make load

There is a verbose mode for all codes that will generate more data and in the case
of network_load_test run more tests.  This is done by adding the following flag
as an argument to make:

FLAGS="-DVERBOSE"

For example, network_test built in verbose mode is:

make network FLAGS="-DVERBOSE"

# Running #

Run example at 64 node of BDW 18 parts (2 per node) fully packed:

aprun -n 2304 -N 36 ./network_test

or

aprun -n 2304 -N 36 ./network_load_test

Each application has no arguments.  

# Benchmarking Practices

GPCNeT applications should ideally be run at full system scale, in particular
network_load_test.  network_test can be run at any scale above 2 nodes to measure
the capability of a network for complex communication patterns.

network_load_test should not be run at much less than full system scale.  The results
will likely not be representative if the network has significant head room.  

The primary tuning parameter users can use is the number of processes per node (PPN).
The higher the PPN the more the benchmark will push the network.  For the network_test,
higher PPN will push bandwidth per node (note the benchmark reports bwandwidth per rank)
higher and will produce more realistic latency numbers from an HPC application perspective.
For network_load_test, higher PPN makes congestors more intense and sensitive traffic
more sensitive.  The recommended practice is to run either application at three
values of PPN:

* 1 PPN: this will be a lightly loaded network and produce the least congestion for
         network_load_test

* X PPN: X should be some intermediate value that is representative of the system workloads
         for the number of communicating cores on a node.  For example, a CPU-GPU system
         might only have one MPI rank (with one communicating core) per GPU on a node.

* N PPN: N should be equal or nearly equal to the number of cores on a node.

The results at N PPN will provide the most signal for congestion.

# Modifying Defaults #

For network_load_test, the intensity of
congestors can be lessened by reducing the number of processes per node or
modifying the message sizes of congestors.

Tuning of message sizes and loop counts is done with the defs at the beginning of
network_test.c or network_load_test.c.  For example, to modify the message size of 
of the one-sided incast look for this line in network_load_test.c

#define INCAST_MSG_COUNT 512

This count is in 8-byte words and can be adjuested up or down.

# Questions #

Please contact any of the following people if you have any questions.

* Pete Mendygral (pjm@cray.com)
* Taylor Groves (tgroves@lbl.gov)
* Sudheer Chunduri (sudheer@anl.gov)
* Mark Atkins (matkins@cray.com)
* Richard Walsh (rwalsh@cray.com)
