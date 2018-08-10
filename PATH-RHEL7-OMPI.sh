# useful for RHEL OpenMPI
# install with yum -y install openmpi openmpi-devel

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

# openmpi from RPMs
export PATH=/usr/lib64/openmpi/bin:$PATH
export LD_LIBRARY_PATH=/usr/lib64/openmpi/lib:$LD_LIBRARY_PATH
export PYTHONPATH=/usr/lib64/python2.7/site-packages/openmpi:$PYTHONPATH
export MANPATH=/usr/share/man/openmpi-x86_64:$MANPATH
export MPI_BIN=/usr/lib64/openmpi/bin
export MPI_SYSCONFIG=/etc/openmpi-x86_64
export MPI_FORTRAN_MOD_DIR=/usr/lib64/gfortran/modules/openmpi-x86_64
export MPI_INCLUDE=/usr/include/openmpi-x86_64
export MPI_LIB=/usr/lib64/openmpi/lib
export MPI_MAN=/usr/share/man/openmpi-x86_64
export MPI_PYTHON_SITEARCH=/usr/lib64/python2.7/site-packages/openmpi
export MPI_COMPILER=openmpi-x86_64
export MPI_SUFFIX=_openmpi
export MPI_HOME=/usr/lib64/openmpi

# IOR path
export PATH=~/bench/ior/2.10.3/src/C:$PATH

# nuttcp path
export PATH=~/bench/nuttcp/nuttcp-8.1.4:$PATH

#  sysbench
export PATH=~/bench/sysbench/0.5/bin:$PATH

# fio
export PATH=~/bench/sysbench/0.5/bin:$PATH

