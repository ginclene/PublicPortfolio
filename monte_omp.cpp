#include <omp.h>
#include <iostream>
#include <iomanip>
#include <string>
#include <cstdlib>
#include <cmath>


// Copyright 2020 by Alan M. Ferrenberg
// This program is offered freely for any academic use

//  Size of the individual trials of dart throws
const int RUNLENGTH = 1000000;

using std::stoi;
using std::stoul;
using std::cout;
using std::endl;
using std::setprecision;

// Each thread will have its own copy of the random number state which must
// persist throughout the program.  Make this state be a global variable and
// define it as threadprivate

struct drand48_data state;
#pragma omp threadprivate(state)

// Function to initialize the random number states for each thread.  Each
// thread gets a unique seed based on the single seed provided as an argument
void initRNG(unsigned int seed) {
#pragma omp parallel
  {
    int k = omp_get_thread_num();

    // set the initial seed and state with thread-safe version
    srand48_r(seed+23*k, &state);
  }
  return;
}

// This function uses Monte Carlo integration to estimate pi
double monteCarloIntegration(int numBlocks) {
  double pi = 0.0, pisum = 0.0;
  int count = 0;
  double r1, r2;
  // Fill in this routine with a computation of pi using Monte Carlo
  // integration of a quadrant of a circle.
  for (int j = 0; j < numBlocks; j++) {
#pragma omp parallel for shared(RUNLENGTH) private(r1, r2) reduction(+:count)
      for (int i = 0; i < RUNLENGTH; i++) {
          drand48_r(&state, &r1);
          drand48_r(&state, &r2);
          if (((r1 * r1) + (r2 * r2)) < 1) {
             count++;
          }
      }
      pi = (4.0 * count) / RUNLENGTH;
      pisum += pi; 
      pi = 0.0;
      count = 0;
  }
  pisum /= static_cast<double>(numBlocks);
  return pisum;
}

// Main program
int main(int argc, char* argv[]) {
  if (argc < 2) {
      std::cerr << "Usage: " << argv[0] << "SOURCE DESTINATION" << std::endl;
      return 1;
  }
  // N is the number of random numbers to generate
  int N = stoi(argv[1]);
  // The random number generator seed used to generate the RNG state
  unsigned int seed = stoul(argv[2]);
  initRNG(seed);
  double pi = 0.0;
  pi = monteCarloIntegration(N);
  cout << "pi is " << setprecision(12) << pi << endl;
  return 0;
}
