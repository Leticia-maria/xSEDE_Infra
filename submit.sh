module load gaussian/G16_RevC01
module load anaconda3
conda create -y -n funsies
conda activate funsies
conda install -y python=3.8
pip install funsies
pip install cclib
pip install cctk
conda config --add channels conda-forge
conda install -c -y conda-forge redis-py
conda install -c -y conda-forge redis-server
conda install -y xtb
