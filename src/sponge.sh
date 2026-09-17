#!/bin/bash
# ------------------------------------------------------------------
# [Shaurita Hutchins] sponge.sh
#          This script runs netzoopy-sponge to download TF prior from the JASPAR2026 database.
#SBATCH --job-name=sponge
#SBATCH --partition=amd-hdr100
#SBATCH --time=08:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=50        # use 50 processes/cores
#SBATCH --mem=50G                # bump if needed
#SBATCH --output=logs/netzoopy_sponge_%j.out
#SBATCH --error=logs/netzoopy_sponge_%j.err

set -euo pipefail

# Load Miniforge (provides Python for venv)
module load miniforge/conda

# Activate environment
source venv/bin/activate

# Set the config file path
CONFIG="config/config_2026.yaml"

echo "Starting netzoopy-sponge with config: $CONFIG"
netzoopy-sponge -c "$CONFIG"
echo "Done."