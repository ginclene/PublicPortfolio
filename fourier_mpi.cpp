#include <cmath>
#include <iostream>
#include <mpi.h>
// Copyright 2020 Alan M. Ferrenberg

using std::cerr;
using std::cout;
using std::endl;
using std::stoi;

#define ZERO 0.0000000000000000000000000000000000

// Compute the discrete Fourier transform of the function provided
void computeFT(int N, double oR[], double oI[], double fR[], double fI[]) {
  int k, n;
  double tempR, tempI;

  // Loop over the N frequency values
  for (k = 0; k < N; k++) {
    tempR = ZERO;
    tempI = ZERO;
    // Loop over the N spatial/temporal values
    for (n = 0; n < N; n++) {
      double arg = 2.0*M_PI*k*n/N;
      double cosArg = cos(arg);
      double sinArg = sin(arg);
      
      // Accumulate the real and imaginary components of the Fourier transform
      // for frequency k in temporary variables
      tempR += oR[n]*cosArg + oI[n]*sinArg;
      tempI += oI[n]*cosArg - oR[n]*sinArg;
    }
    // Update the values of for the real and imaginary components of the
    // Fourier transform
    fR[k] = tempR;
    fI[k] = tempI;
  }
}

void computeFtMpi(int k, int N, double oR[], double oI[], double &fr, double &fi) {
  int n = 0;
  double tempR, tempI;
  tempR = ZERO;
  tempI = ZERO;
    // Loop over the N spatial/temporal values
    for (n = 0; n < N; n++) {
      double arg = 2.0*M_PI*k*n/N;
      double cosArg = cos(arg);
      double sinArg = sin(arg);

      // Accumulate the real and imaginary components of the Fourier transform
      // for frequency k in temporary variables
      tempR += oR[n]*cosArg + oI[n]*sinArg;
      tempI += oI[n]*cosArg - oR[n]*sinArg;
    }
    // Update the values of for the real and imaginary components of the
    // Fourier transform
    fr = tempR;
    fi = tempI;
}


// Initialize the real and imaginary components of the original function and
// the Fourier transform.  The function is sinc(x) = sin(ax)/x
void initialize(int N, double oR[], double oI[], double fR[], double fI[]) {
  double a = 2.0;
  oR[0] = a;
  oI[0] = ZERO;
  fR[0] = ZERO;
  fI[0] = ZERO;
  
  for (int n = 1; n < N; n++) {
    oR[n] = sin(a*n)/n;
    oI[n] = ZERO;
    fR[n] = ZERO;
    fI[n] = ZERO;
  }
}

// Main method for this program
int main(int argc, char *argv[]) {
  // Declare pointers to the Function and fourier transform arrays
  double *oR, *oI, *fR, *fI;
  int rank, size, value, *kValues;
  // Check whether the number of samples has been provided
  if (argc < 2) {
    cerr << endl << "Usage:  fourier_serial number_of_samples." << endl;
    exit(1);
  }

  // Number of samples is the command line argument
  int N = stoi(argv[1]);

  oR = new double[N];
  oI = new double[N];

  // initialize MPI
  if((value = MPI_Init(&argc, &argv)) != 0) {
      std::cerr << "Problem with MPI_Init" << std::endl;
      exit(value);
  }

  //Get ranks and size
  if((value = MPI_Comm_rank(MPI_COMM_WORLD, &rank)) != 0) {
      std::cerr << "Problem with MPI_rank" << std::endl;
      exit(value);
  }

  if((value = MPI_Comm_size(MPI_COMM_WORLD, &size)) != 0) {
      std::cerr << "Problem with MPI_size" << std::endl;
      exit(value);
  }

  //initializing array of k values
  kValues = new int[N];
  for (int i = 0; i < N; i++) {
      kValues[i] = i;
  }
  double eTime, cTime;
  // MANAGER SECTION
  if (rank == 0) {
  double cpu, totalCpu, eStart, eEnd;
  clock_t t1;
  fR = new double[N];
  fI = new double[N];
  MPI_Status status;
  int sentCount = 0;
  initialize(N, oR, oI, fR, fI);
  eStart = MPI_Wtime();
  t1 = clock();
  MPI_Bcast(oR, N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  MPI_Bcast(oI, N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
  for (int i = 1; i < size; i++) {
          MPI_Send(&sentCount, 1, MPI_INT, i, i, MPI_COMM_WORLD);
        //   std::cout << "Sending out first k value to worker " << sentCount << endl;
          sentCount++;
      }
  for(int j = sentCount; j <= N; j++) {
      MPI_Recv(&fR[sentCount-1], 1, MPI_DOUBLE, MPI_ANY_SOURCE, MPI_ANY_TAG, MPI_COMM_WORLD, &status);
   //    std::cout << "manager Recieved a real number from source " << status.MPI_SOURCE << " with tag " << status.MPI_TAG << endl;
      MPI_Recv(&fI[sentCount-1], 1, MPI_DOUBLE, status.MPI_SOURCE, status.MPI_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
   //    std::cout << "manager Recieved an imaginary number  from source " << status.MPI_SOURCE << " with tag " << status.MPI_TAG << endl;
      MPI_Send(&sentCount, 1, MPI_INT, status.MPI_SOURCE, status.MPI_TAG, MPI_COMM_WORLD);
   //   std::cout << "Sending worker k value of " << sentCount << endl;
      sentCount++;
  }
//  std::cout << "Made it out of manager loop" << endl;
  int stop = -1;
  for (int i = 1; i < size; i++) {
  //    std::cout << "sending a value of -1 to worker " << i << endl;
      MPI_Send(&stop, 1, MPI_INT, i, i, MPI_COMM_WORLD);
  }
  // Timing calculations done here
  t1 = clock() - t1;
  cpu = static_cast<double>(t1)/static_cast<double>(CLOCKS_PER_SEC);
  MPI_Reduce(&cpu, &totalCpu, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
  // Get the end elapsed time and determine the transfer rate
  eEnd = MPI_Wtime();
  eTime = (eEnd - eStart);
  cTime = totalCpu;
  for (int i = 0; i < N; i++) {
      std::cout << "n: " << i << " fR: " << fR[i] << " fI: " << fI[i] << endl;
  }
  std::cerr << "Elapsed Time: " << eTime << " CPU time: " << cTime << endl;
  delete [] fR;
  delete [] fI;
  // END OF MANAGER SECTION
} else {
//WORKER SECTION
      double fr, fi, cpu, totalCpu;
      clock_t t1;
      int k = 0;
      t1 = clock();
      MPI_Bcast(oR, N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
      MPI_Bcast(oI, N, MPI_DOUBLE, 0, MPI_COMM_WORLD);
      MPI_Recv(&k, 1, MPI_INT, 0, rank, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
   //   std::cout << "worker recieved a k value of " << k << endl;
      while (k >= 0) {
              computeFtMpi(k, N, oR, oI, fr, fi);
              MPI_Send(&fr, 1, MPI_DOUBLE, 0, rank, MPI_COMM_WORLD);
           //   std::cout << "Sending fr value manager, value: " << fr << " with tag " << k << endl;
              MPI_Send(&fi, 1, MPI_DOUBLE, 0, rank, MPI_COMM_WORLD); 
           //   std::cout << "Sending fi value manager, value: " << fi << " with tag " << k << endl;
              MPI_Recv(&k, 1, MPI_INT, 0, rank, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
           //   std::cout << "worker recieved a k value of " << k << endl;
      }
   //   std::cout << "out of worker loop" <<  endl;
      t1 = clock() - t1;
      cpu = static_cast<double>(t1)/static_cast<double>(CLOCKS_PER_SEC);
      MPI_Reduce(&cpu, &totalCpu, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);

// END OF WORKER SECTION
  }

  // If OUTPUT is defined, print out the original function and exit
#ifdef OUTPUT
  for (int n = 0; n < N; n++) {
    cout << n << " " << oR[n] << " " << oI[n] << endl;
  }
  exit(0);
#endif

  // Compute the Fourier transform of the function
  // computeFT(N, oR, oI, fR, fI);

  // Write out the real and imaginary components of the Fourier transform
//  for (int k = 0; k < N; k++) {
//    cout << k << " " << fR[k] << " " << fI[k] << endl;
//  }

  MPI_Finalize();

  // Free up the memory on the heap
  delete [] oR;   delete [] oI;

  // Exit!
  exit(0);
}
