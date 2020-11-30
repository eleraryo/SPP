#!/bin/bash
#SBATCH -A kurs00042
#SBATCH -p kurs00042
#SBATCH --reservation=kurs00042
#SBATCH -J hello
#SBATCH -t 00:01:00

cd /home/kurse/kurs00042/aa47pese/
./hello

