#!/bin/bash

#SBATCH --nodes=1
#SBATCH --cpus-per-task=40
#SBATCH --ntasks=1
#SBATCH --time=2:55:00
#SBATCH --job-name funsies-on-slurm

module load gaussian/G16_RevC01
module load anaconda3

conda create -y -n funsies
conda activate funsies
conda install -y python=3.8

pip install funsies
pip install cclib
pip install cctk

conda config --add channels conda-forge
conda install -y -c conda-forge redis-py
conda install -y -c conda-forge redis-server
conda install -y xtb

redis-server redis.conf &
funsies wait
srun --ntasks=${SLURM_NTASKS} --cpus-per-task=${SLURM_CPUS_PER_TASK} \
	-o worker_%j.%t.out -e worker_%j.%t.err \
	funsies worker redis &
  
python run_gaussian.py 'C[C@H]1[C@H](O)[C@@H](O)[C](O)[C@H](OC)O1' -c 0 -s 2 3_rad
  
funsies shutdown

redis-cli --rdb results.rdb
redis-cli shutdown 
