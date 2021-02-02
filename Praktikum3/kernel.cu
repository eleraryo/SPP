//
//  kernel.cu
//
//  Created by Arya Mazaheri on 01/12/2018.
//

#include "ppm.h"
#include <algorithm>
#include <cmath>
#include <iostream>

using namespace std;
/*********** Gray Scale Filter  *********/

/**
 * Converts a given 24bpp image into 8bpp grayscale using the GPU.
 */
__global__ void cuda_grayscale(int width, int height, BYTE *image,
                               BYTE *image_out) {
  // DONE: implement grayscale filter kernel
  int w = blockIdx.x * blockDim.x + threadIdx.x;
  int h = blockIdx.y * blockDim.y + threadIdx.y;

  if (w >= width || h >= height)
    return;
  int position = h * width + w;
  BYTE *pixel = &image[position * 3];
  image_out[position] = pixel[0] * 0.2126f + // R
                        pixel[1] * 0.7152f + // G
                        pixel[2] * 0.0722f;  // B
  return;
}

// 1D Gaussian kernel array values of a fixed size (make sure the number >
// filter size d)
// DONE: Define the cGaussian array on the constant memory
__constant__ float cGaussian[64];

void cuda_updateGaussian(int r, double sd) {
  float fGaussian[64];
  for (int i = 0; i < 2 * r + 1; i++) {
    float x = i - r;
    fGaussian[i] = expf(-(x * x) / (2 * sd * sd));
  }
  // DONE: Copy computed fGaussian to the cGaussian on device memory
  auto status =
      cudaMemcpyToSymbol(cGaussian, fGaussian, sizeof(float) * (2 * r + 1));
  // cout << "update gaussian memcpy: " << cudaGetErrorName(status) << endl;
}

// DONE: implement cuda_gaussian() kernel
// Gaussian function for range difference
__device__ double cuda_gaussian(float x, double sigma) {
  return expf(-(powf(x, 2)) / (2 * powf(sigma, 2)));
}

/*********** Bilateral Filter  *********/
// Parallel (GPU) Bilateral filter kernel
__global__ void cuda_bilateral_filter(BYTE *input, BYTE *output, int width,
                                      int height, int r, double sI, double sS) {
  // DONE: implement bilateral filter kernel
  //
  int x = blockIdx.x * blockDim.x + threadIdx.x;
  int y = blockIdx.y * blockDim.y + threadIdx.y;

  if (x >= width || y >= height) {
    return;
  }

  double iFiltered = 0;
  double wP = 0;
  unsigned char centerPx = input[y * width + x];
  for (int dy = -r; dy <= r; ++dy) {
    int neighborY = y + dy;
    if (neighborY < 0)
      neighborY = 0;
    else if (neighborY >= height)
      neighborY = height - 1;
    for (int dx = -r; dx <= r; ++dx) {
      int neighborX = x + dx;
      if (neighborX < 0)
        neighborX = 0;
      else if (neighborX >= width)
        neighborX = width - 1;
      unsigned char currPx = input[neighborY * width + neighborX];

      double wG = (cGaussian[dy + r] * cGaussian[dx + r]) *
                  cuda_gaussian(centerPx - currPx, sI);
      iFiltered += wG * currPx;
      wP += wG;
    }
  }
  output[y * width + x] = iFiltered / wP;
}

void gpu_pipeline(const Image &input, Image &output, int r, double sI,
                  double sS) {
  // Events to calculate gpu run time
  cudaEvent_t start, stop;
  float time;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  // GPU related variables
  BYTE *d_input = NULL;
  BYTE *d_image_out = NULL; // temporary output buffers on gpu device
  int image_size = input.cols * input.rows;
  int suggested_blockSize;   // The launch configurator returned block size
  int suggested_minGridSize; // The minimum grid size needed to achieve
                             // the maximum occupancy for a full device
                             // launch

  // ******* Grayscale kernel launch *************

  // Creating the block size for grayscaling kernel
  cudaOccupancyMaxPotentialBlockSize(&suggested_minGridSize,
                                     &suggested_blockSize, cuda_grayscale);

  int block_dim_x = sqrt(suggested_blockSize);
  int block_dim_y = sqrt(suggested_blockSize);

  // DONE: Calculate grid size to cover the whole image
  dim3 threadsPerBlock(block_dim_x, block_dim_y); // this was grey_block
  dim3 numBlocks((input.cols + block_dim_x - 1) / block_dim_x,
                 (input.rows + block_dim_y - 1) / block_dim_y);

  auto out = cudaMalloc(&d_image_out, image_size * sizeof(BYTE));
  // cout << cudaGetErrorName(out) << " malloc did this " << endl;
  // DONE: intialize allocated memory on device to zero
  auto memset_err = cudaMemset(d_image_out, 0, image_size * sizeof(BYTE));
  // cout << cudaGetErrorName(memset_err) << " memset did this " << endl;
  // cudaMemcpy(&d_image_out, &output.pixels, image_size * sizeof(BYTE),
  //            cudaMemcpyHostToDevice);

  // copy input image to device
  // DONE: Allocate memory on device for input image
  auto out2 = cudaMalloc(&d_input, image_size * 3 * sizeof(BYTE));
  // cout << cudaGetErrorName(out2) << " malloc did this " << endl;
  // DONE: Copy input image into the device memory
  auto memcpy_err =
      cudaMemcpy(d_input, input.pixels, image_size * 3 * sizeof(BYTE),
                 cudaMemcpyHostToDevice);
  // cout << cudaGetErrorName(memcpy_err) << " memcopy to device did this "
  //      << endl;

  cudaEventRecord(start, 0); // start timer
  // Convert input image to grayscale

  // DONE: Launch cuda_grayscale()
  printf("call cuda_greyscale with : {%d, %d} threads per block and : "
         "{%d, %d} "
         "number of blocks \n",
         threadsPerBlock.x, threadsPerBlock.y, numBlocks.x, numBlocks.y);
  cuda_grayscale<<<threadsPerBlock, numBlocks>>>(input.cols, input.rows,
                                                 d_input, d_image_out);

  cudaEventRecord(stop, 0); // stop timer
  cudaEventSynchronize(stop);

  // Calculate and print kernel run time
  cudaEventElapsedTime(&time, start, stop);
  cout << "GPU Grayscaling time: " << time << " (ms)\n";

  // DONE: transfer image from device to the main memory for saving onto
  // the disk
  auto memcpy_err2 =
      cudaMemcpy(output.pixels, d_image_out, image_size * sizeof(BYTE),
                 cudaMemcpyDeviceToHost);
  // cout << cudaGetErrorName(memcpy_err2) << " memcopy to host did this " <<
  // endl;
  savePPM(output, "image_gpu_gray.ppm");

  // ******* Bilateral filter kernel launch *************

  // Creating the block size for grayscaling kernel
  cudaOccupancyMaxPotentialBlockSize(
      &suggested_minGridSize, &suggested_blockSize, cuda_bilateral_filter);

  block_dim_x = sqrt(suggested_blockSize);
  block_dim_y = sqrt(suggested_blockSize);

  // DONE: Calculate grid size to cover the whole image
  dim3 threadsPerBlockBiliteral(block_dim_x,
                                block_dim_y); // this was biliteral_block
  // DONE: Calculate grid size to cover the whole image
  dim3 numBlocksBiliteral((input.cols + block_dim_x - 1) / block_dim_x,
                          (input.rows + block_dim_y - 1) / block_dim_y);

  // Create gaussain 1d array
  cuda_updateGaussian(r, sS);

  BYTE *d_bil_image_out = NULL; // temporary output buffers on gpu device
  // create zeroes image output for biliteral
  out = cudaMalloc(&d_bil_image_out, image_size * sizeof(BYTE));
  // cout << cudaGetErrorName(out) << " malloc biliteral did this " << endl;
  // DONE: intialize allocated memory on device to zero
  memset_err = cudaMemset(d_bil_image_out, 0, image_size * sizeof(BYTE));
  // cout << cudaGetErrorName(memset_err) << " memset biliteral did this " <<
  // endl;

  cudaEventRecord(start, 0); // start timer
  // DONE: Launch cuda_bilateral_filter()
  cuda_bilateral_filter<<<threadsPerBlockBiliteral, numBlocksBiliteral>>>(
      d_image_out, d_bil_image_out, input.cols, input.rows, r, sI, sS);
  cudaEventRecord(stop, 0); // stop timer
  cudaEventSynchronize(stop);

  // Calculate and print kernel run time
  cudaEventElapsedTime(&time, start, stop);
  cout << "GPU Bilateral Filter time: " << time << " (ms)\n";

  // Copy output from device to host
  // DONE: transfer image from device to the main memory for saving onto
  // the disk

  out = cudaMemcpy(output.pixels, d_bil_image_out, image_size * sizeof(BYTE),
                   cudaMemcpyDeviceToHost);
  // cout << cudaGetErrorName(out) << " memcopy biliteral to host did this "
  //      << endl;
  savePPM(output, "image_bil_gpu_gray.ppm");
  // ************** Finalization, cleaning up ************

  // Free GPU variables
  // DONE: Free device allocated memory
  out = cudaFree(d_input);
  // cout << cudaGetErrorName(out) << " free d_input did this " << endl;
  out = cudaFree(d_image_out);
  // cout << cudaGetErrorName(out) << " free d_image_out did this " << endl;
  out = cudaFree(d_bil_image_out);
  // cout << cudaGetErrorName(out) << " free d_bil_image_out did this " << endl;
}
