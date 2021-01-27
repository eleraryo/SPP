//
//  kernel.cu
//
//  Created by Arya Mazaheri on 01/12/2018.
//

#include <iostream>
#include <algorithm>
#include <cmath>
#include "ppm.h"

using namespace std;

/*********** Gray Scale Filter  *********/

/**
 * Converts a given 24bpp image into 8bpp grayscale using the GPU.
 */
__global__
void cuda_grayscale(int width, int height, BYTE *image, BYTE *image_out)
{
    //TODO: implement grayscale filter kernel
}


// 1D Gaussian kernel array values of a fixed size (make sure the number > filter size d)
//TODO: Define the cGaussian array on the constant memory 

void cuda_updateGaussian(int r, double sd)
{
	float fGaussian[64];
	for (int i = 0; i < 2*r +1 ; i++)
	{
		float x = i - r;
		fGaussian[i] = expf(-(x*x) / (2 * sd*sd));
	}
	//TODO: Copy computed fGaussian to the cGaussian on device memory 
	cudaMemcpyToSymbol(cGaussian, /* TODO */);
}

//TODO: implement cuda_gaussian() kernel


/*********** Bilateral Filter  *********/
// Parallel (GPU) Bilateral filter kernel
__global__ void cuda_bilateral_filter(BYTE* input, BYTE* output,
	int width, int height,
	int r, double sI, double sS)
{
	//TODO: implement bilateral filter kernel 
}


void gpu_pipeline(const Image & input, Image & output, int r, double sI, double sS)
{
	// Events to calculate gpu run time
	cudaEvent_t start, stop;
	float time;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	// GPU related variables
	BYTE *d_input = NULL;
	BYTE *d_image_out[2] = {0}; //temporary output buffers on gpu device
	int image_size = input.cols*input.rows;
	int suggested_blockSize;   // The launch configurator returned block size 
	int suggested_minGridSize; // The minimum grid size needed to achieve the maximum occupancy for a full device launch

	// ******* Grayscale kernel launch *************

	//Creating the block size for grayscaling kernel
	cudaOccupancyMaxPotentialBlockSize( /* TODO */ );
        
	int block_dim_x, block_dim_y; 

	dim3 gray_block(/* TODO */);

	//TODO: Calculate grid size to cover the whole image

	// Allocate the intermediate image buffers for each step
	Image img_out(input.cols, input.rows, 1, "P5");
	for (int i = 0; i < 2; i++)
	{  
		//TODO: allocate memory on the device
		//TODO: intialize allocated memory on device to zero 
	}

	//copy input image to device
	//TODO: Allocate memory on device for input image 
	//TODO: Copy input image into the device memory

	cudaEventRecord(start, 0); // start timer
	// Convert input image to grayscale
	//TODO: Launch cuda_grayscale() 
	cudaEventRecord(stop, 0); // stop timer
	cudaEventSynchronize(stop);

	// Calculate and print kernel run time
	cudaEventElapsedTime(&time, start, stop);
	cout << "GPU Grayscaling time: " << time << " (ms)\n";
	cout << "Launched blocks of size " << gray_block.x * gray_block.y << endl;
    
	//TODO: transfer image from device to the main memory for saving onto the disk 
	savePPM(img_out, "image_gpu_gray.ppm");
	

	// ******* Bilateral filter kernel launch *************
	
	//Creating the block size for grayscaling kernel
	cudaOccupancyMaxPotentialBlockSize( /* TODO */ ); 

	dim3 bilateral_block(/* TODO */);

	//TODO: Calculate grid size to cover the whole image

	// Create gaussain 1d array
	cuda_updateGaussian(r,sS);

	cudaEventRecord(start, 0); // start timer
	//TODO: Launch cuda_bilateral_filter() 
	cudaEventRecord(stop, 0); // stop timer
	cudaEventSynchronize(stop);

	// Calculate and print kernel run time
	cudaEventElapsedTime(&time, start, stop);
	cout << "GPU Bilateral Filter time: " << time << " (ms)\n";
	cout << "Launched blocks of size " << bilateral_block.x * bilateral_block.y << endl;

	// Copy output from device to host
	//TODO: transfer image from device to the main memory for saving onto the disk 


	// ************** Finalization, cleaning up ************

	// Free GPU variables
	//TODO: Free device allocated memory 
}
