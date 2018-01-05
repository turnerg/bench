/*
 *  For every pair of nodes in a system, test:
 *   (1) zero-byte latency
 *   (2) point-to-point bandwidth
 *   (3) exchange bandwidth
 *  Farid A. Parpia (parpia@us.ibm.com)
 *                   Last revised 11 Nov 2005
 */

#include <errno.h>
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/param.h>

#define N_EXCHANGE_L  20000
#define N_EXCHANGE_BW 4
/*#define L_MESSAGE_BW  67108864*/
#define L_MESSAGE_BW  33554432

double recv_buffer[L_MESSAGE_BW];
double send_buffer[L_MESSAGE_BW];

int main (int argc, char *argv[])
{
  char hostname[MAXHOSTNAMELEN], other_hostname[MAXHOSTNAMELEN];
  int i, j, k;
  int rc;
  int ranks[2];
  int task_rank, pair_task_rank;
  int task_count;
  int l_hostname, l_other_hostname;
  int n_exchange;
  double clock_resolution;
  double t_end, t_start;
  double exchange_bandwidth;
  double point_to_point_latency;
  double point_to_point_bandwidth;
  MPI_Comm pair_communicator;
  MPI_Group base_group, pair_group;
  MPI_Status status;

  rc = MPI_Init (&argc, &argv);
  rc = MPI_Comm_size (MPI_COMM_WORLD, &task_count);
  if (task_count < 2) {
    fprintf (stderr,
             "%s: task count must equal or exceed 2.\n",
             argv[0]);
    (void) MPI_Abort (MPI_COMM_WORLD, EXIT_FAILURE);
  }
  rc = MPI_Comm_rank (MPI_COMM_WORLD, &task_rank);
  if (gethostname (hostname, MAXHOSTNAMELEN) != 0) {
    fprintf (stderr,
             "%s: gethostname: %s\n",
             argv[0], strerror (errno));
    (void) MPI_Abort (MPI_COMM_WORLD, EXIT_FAILURE);
  }
  printf ("Task %d of %d tasks started on host %s\n",
          task_rank, task_count, hostname);

/*
 *  Establish and report the clock resolution
 */

  clock_resolution = MPI_Wtick ();
  if (task_rank == 0)
    printf ("clock_resolution = %8.2e s\n", clock_resolution);

/*
 *  Measure and report performance for every
 *  pair of nodes
 */

  rc = MPI_Comm_group (MPI_COMM_WORLD, &base_group);

  for (i = 0; i < task_count - 1; i++) {

    ranks[0] = i;

    for (j = i + 1; j < task_count; j++) {

      ranks[1] = j;
      rc = MPI_Group_incl (base_group, 2, ranks, &pair_group);
      rc = MPI_Comm_create (MPI_COMM_WORLD, pair_group, &pair_communicator);
      rc = MPI_Barrier (MPI_COMM_WORLD);

      if (task_rank == i || task_rank == j) {

        rc = MPI_Comm_rank (pair_communicator, &pair_task_rank);
/*
 *  Host pair identification; use MPI_COMM_WORLD because
 *  pair_communicator can scramble order of nodes in output
 */
        rc = MPI_Barrier (pair_communicator);
        if (task_rank == i) {
          rc = MPI_Recv (&l_other_hostname,              1, MPI_INT, j, 1, MPI_COMM_WORLD, &status);
          rc = MPI_Recv (other_hostname, l_other_hostname, MPI_CHAR, j, 2, MPI_COMM_WORLD, &status);
        }
        else {
          l_hostname = strlen (hostname) + 1;
          rc = MPI_Send (&l_hostname,        1, MPI_INT, i, 1, MPI_COMM_WORLD);
          rc = MPI_Send (hostname, l_hostname, MPI_CHAR, i, 2, MPI_COMM_WORLD);
        }

/*
 *  Point-to-point latency
 */
        rc = MPI_Barrier (pair_communicator);
        if (pair_task_rank == 0) {
          t_start = MPI_Wtime ();
          for (k = 0; k < N_EXCHANGE_L; k++) {
            rc = MPI_Send (&send_buffer, 0, MPI_CHAR, 1, 3+k,              pair_communicator);
            rc = MPI_Recv (&recv_buffer, 0, MPI_CHAR, 1, 3+k+N_EXCHANGE_L, pair_communicator, &status);
          }
          t_end = MPI_Wtime ();
          point_to_point_latency = (t_end - t_start) / (2. * N_EXCHANGE_L);
        }
        else {
          for (k = 0; k < N_EXCHANGE_L; k++) {
            rc = MPI_Recv (&recv_buffer, 0, MPI_CHAR, 0, 3+k,              pair_communicator, &status);
            rc = MPI_Send (&send_buffer, 0, MPI_CHAR, 0, 3+k+N_EXCHANGE_L, pair_communicator);
          }
        }
/*
 *  Point-to-point bandwidth
 */
        rc = MPI_Barrier (pair_communicator);
        if (pair_task_rank == 0) {
          t_start = MPI_Wtime ();
          for (k = 0; k < N_EXCHANGE_BW; k++) {
            rc = MPI_Send (&send_buffer, L_MESSAGE_BW, MPI_DOUBLE, 1, 4+k,               pair_communicator);
            rc = MPI_Recv (&recv_buffer, L_MESSAGE_BW, MPI_DOUBLE, 1, 4+k+N_EXCHANGE_BW, pair_communicator, &status);
          }
          t_end = MPI_Wtime ();
          point_to_point_bandwidth = (2. * N_EXCHANGE_BW * L_MESSAGE_BW * sizeof (double)) / (t_end - t_start);
        }
        else {
          for (k = 0; k < N_EXCHANGE_BW; k++) {
            rc = MPI_Recv (&recv_buffer, L_MESSAGE_BW, MPI_DOUBLE, 0, 4+k,               pair_communicator, &status);
            rc = MPI_Send (&send_buffer, L_MESSAGE_BW, MPI_DOUBLE, 0, 4+k+N_EXCHANGE_BW, pair_communicator);
          }
        }
/*
 *  Exchange bandwidth
 */
        rc = MPI_Barrier (pair_communicator);
        if (pair_task_rank == 0) {
          t_start = MPI_Wtime ();
          for (k = 0; k < N_EXCHANGE_BW; k++) {
            rc = MPI_Sendrecv (&send_buffer, L_MESSAGE_BW, MPI_DOUBLE, 1, 5+k,
                               &recv_buffer, L_MESSAGE_BW, MPI_DOUBLE, 1, 5+k+N_EXCHANGE_BW,
                               pair_communicator, &status);
          }
          t_end = MPI_Wtime ();
          exchange_bandwidth = (2. * N_EXCHANGE_BW * L_MESSAGE_BW * sizeof (double)) / (t_end - t_start);
        }
        else {
          for (k = 0; k < N_EXCHANGE_BW; k++) {
            rc = MPI_Sendrecv (&send_buffer, L_MESSAGE_BW, MPI_DOUBLE, 0, 5+k+N_EXCHANGE_BW,
                               &recv_buffer, L_MESSAGE_BW, MPI_DOUBLE, 0, 5+k,
                               pair_communicator, &status);
          }
        }

        rc = MPI_Barrier (pair_communicator);
        rc = MPI_Comm_free (&pair_communicator);
        rc = MPI_Group_free (&pair_group);
      }
      rc = MPI_Barrier (MPI_COMM_WORLD);
      if (task_rank == i)
        printf ("Hosts %s and %s:"
                " latency = %7.4f micro s;"
                " bandwidth = %7.2f MB/s;"
                " exchange bandwidth = %7.2f MB/s.\n",
                hostname, other_hostname,
                1.e6 * point_to_point_latency,
                1.e-6 * point_to_point_bandwidth,
                1.e-6 * exchange_bandwidth);
    }
  }

  rc = MPI_Barrier (MPI_COMM_WORLD);
  rc = MPI_Finalize ();

  return EXIT_SUCCESS;
}
