#include <cuda.h>
#include <cuda_runtime.h>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/scan.h>
#include "common.h"
#include "thrust.h"

namespace StreamCompaction {
    namespace Thrust {
        using StreamCompaction::Common::PerformanceTimer;
        PerformanceTimer& timer()
        {
            static PerformanceTimer timer;
            return timer;
        }
        /**
         * Performs prefix-sum (aka scan) on idata, storing the result into odata.
         */
        void scan(int n, int *odata, const int *idata) {
            thrust::host_vector<int> host_data(idata, idata + n);
            thrust::device_vector<int> dev_data = host_data;

            timer().startGpuTimer();

            thrust::exclusive_scan(dev_data.begin(), dev_data.end(), dev_data.begin());

            timer().endGpuTimer();

            host_data = dev_data;
            memcpy(odata, host_data.data(), n * sizeof(int));
        }
    }
}
