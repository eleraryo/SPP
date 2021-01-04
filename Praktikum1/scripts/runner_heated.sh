#!/bin/bash -x
#SBATCH -J heated-plate-parallel
#SBATCH -A kurs00042
#SBATCH -p kurs00042
#SBATCH --reservation=kurs00042
#SBATCH --mail-type=NONE
#SBATCH --mail-user=patrick.lutz@stud.tu-darmstadt.de
#SBATCH -e /home/kurse/kurs00042/aa47pese/log/heated.err%j
#SBATCH -o /home/kurse/kurs00042/aa47pese/log/heated.out%j
#SBATCH -t 00:10:00
#SBATCH -n 1
#SBATCH -c 16
#SBATCH --mem-per-cpu=2000

#module purge
module load gcc
#module load cmake
#module load openmpi
#export OMP_NUM_THREADS=32
cd /home/kurse/kurs00042/aa47pese/
./SPP/Praktikum1/heated-plate-parallel
