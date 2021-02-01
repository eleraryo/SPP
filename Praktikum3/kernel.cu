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
  // TODO: implement grayscale filter kernel
  // iterate over Matrix style element
  int w = blockIdx.x * blockDim.x + threadIdx.x;
  int h = blockIdx.y * blockDim.y + threadIdx.y;

  if (w >= width || h >= height)
    return;
  // printf("trying to write pixel %d, %d\n", w, h);
  BYTE *pixel = &image[w * h + w];
  image_out[w * h + w] = pixel[0] * 0.2126f + // R
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
  cudaMemcpyToSymbol(cGaussian, fGaussian, sizeof(float) * (2 * r + 1));
}

// TODO: implement cuda_gaussian() kernel

/*********** Bilateral Filter  *********/
// Parallel (GPU) Bilateral filter kernel
__global__ void cuda_bilateral_filter(BYTE *input, BYTE *output, int width,
                                      int height, int r, double sI, double sS) {
  // TODO: implement bilateral filter kernel
  //
  // __global__ void d_bilateral_filter(uint * od, int w, int h, float e_d, int
  // r,
  //                                    cudaTextureObject_t rgbaTex) {
  int x = blockIdx.x * blockDim.x + threadIdx.x;
  int y = blockIdx.y * blockDim.y + threadIdx.y;

  // if (x >= w || y >= h) {
  //   return;
  // }

  // float sum = 0.0f;
  // float factor;
  // float4 t = {0.f, 0.f, 0.f, 0.f};
  // float4 center = tex2D<float4>(rgbaTex, x, y);

  // for (int i = -r; i <= r; i++) {
  //   for (int j = -r; j <= r; j++) {
  //     float4 curPix = tex2D<float4>(rgbaTex, x + j, y + i);
  //     factor = cGaussian[i + r] * cGaussian[j + r] * // domain factor
  //              euclideanLen(curPix, center, e_d);    // range factor

  //     t += factor * curPix;
  //     sum += factor;
  //   }
  // }

  // od[y * w + x] = rgbaFloatToInt(t / sum);
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
  // BYTE *d_image_out[2] = {0}; // temporary output buffers on gpu device //
  // TODO check why this was {0} instead of NULL
  BYTE *d_image_out = NULL; // temporary output buffers on gpu device
  int image_size = input.cols * input.rows;
  int suggested_blockSize;   // The launch configurator returned block size
  int suggested_minGridSize; // The minimum grid size needed to achieve the
                             // maximum occupancy for a full device launch

  // ******* Grayscale kernel launch *************

  // Creating the block size for grayscaling kernel
  cudaOccupancyMaxPotentialBlockSize(&suggested_minGridSize,
                                     &suggested_blockSize, cuda_grayscale);

  int block_dim_x = sqrt(suggested_blockSize);
  int block_dim_y = sqrt(suggested_blockSize);

  // DONE: Calculate grid size to cover the whole image
  dim3 threadsPerBlock(block_dim_x, block_dim_y);
  dim3 numBlocks((input.cols + block_dim_x - 1) / block_dim_x,
                 (input.rows + block_dim_y - 1) / block_dim_y);

  // Allocate the intermediate image buffers for each step
  // Image img_out(input.cols, input.rows, 1, "P5");
  // for (int i = 0; i < 2; i++) {
  //   // TODO Why do we do this twice but don't use the second one?
  //   // DONE: allocate memory on the device
  //   // TODO check if maybe sizeof(Image) or sizeof(input)
  //   cudaMalloc(&d_image_out, image_size * sizeof(BYTE *));
  //   // DONE: intialize allocated memory on device to zero
  //   cudaMemset(&d_image_out, 0, image_size * sizeof(BYTE *));
  // }
  cudaMalloc(&d_image_out, image_size * sizeof(BYTE *));
  // DONE: intialize allocated memory on device to zero
  cudaMemset(&d_image_out, 0, image_size * sizeof(BYTE *));

  // copy input image to device
  // DONE: Allocate memory on device for input image
  cudaMalloc(&d_input, image_size * sizeof(BYTE *));
  // DONE: Copy input image into the device memory
  cudaMemcpy(&d_input, &input.pixels, image_size * sizeof(BYTE *),
             cudaMemcpyHostToDevice);

  cudaEventRecord(start, 0); // start timer
  // Convert input image to grayscale

  // DONE: Launch cuda_grayscale()
  printf("call cuda_greyscale with : {%d, %d} threads per block and : {%d, %d} "
         "number of blocks \n",
         threadsPerBlock.x, threadsPerBlock.y, numBlocks.x, numBlocks.y);
  cuda_grayscale<<<threadsPerBlock, numBlocks>>>(input.cols, input.rows,
                                                 d_input, d_image_out);
  printf("finished cuda_greyscale\n");

  cudaEventRecord(stop, 0); // stop timer
  cudaEventSynchronize(stop);

  // Calculate and print kernel run time
  cudaEventElapsedTime(&time, start, stop);
  cout << "GPU Grayscaling time: " << time << " (ms)\n";
  // TODO back in: cout << "Launched blocks of size " << gray_block.x *
  // gray_block.y << endl;

  // DONE: transfer image from device to the main memory for saving onto the
  // disk
  cudaMemcpy(&output.pixels, &d_image_out, image_size * sizeof(BYTE *),
             cudaMemcpyDeviceToHost);
  savePPM(output, "image_gpu_gray.ppm");

  // ******* Bilateral filter kernel launch *************

  // Creating the block size for grayscaling kernel
  cudaOccupancyMaxPotentialBlockSize(
      &suggested_minGridSize, &suggested_blockSize, cuda_bilateral_filter);

  dim3 bilateral_block(/* TODO */);

  // TODO: Calculate grid size to cover the whole image

  // Create gaussain 1d array
  cuda_updateGaussian(r, sS);

  cudaEventRecord(start, 0); // start timer
  // TODO: Launch cuda_bilateral_filter()
  cudaEventRecord(stop, 0); // stop timer
  cudaEventSynchronize(stop);

  // Calculate and print kernel run time
  cudaEventElapsedTime(&time, start, stop);
  cout << "GPU Bilateral Filter time: " << time << " (ms)\n";
  // TODO back in: cout << "Launched blocks of size " << bilateral_block.x *
  // bilateral_block.y << endl;

  // Copy output from device to host
  // TODO: transfer image from device to the main memory for saving onto the
  // disk

  // ************** Finalization, cleaning up ************

  // Free GPU variables
  // DONE: Free device allocated memory
  cudaFree(&d_input);
  cudaFree(&d_image_out);
}
