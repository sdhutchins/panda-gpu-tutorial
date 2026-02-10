# Using sponge

**sponge** gives you motif and PPI priors as an alternative to the GRAND downloads in the main demo. This section assumes **netzoopy-sponge v2.1.0** on an HPC system (e.g., Slurm). The goal is a stable, reproducible Python environment you can use in batch jobs without relying on system Python or shell state. We use **Miniforge** (not a separate Python module) to create a venv and install dependencies.

## Prerequisites

- Access to a cluster login node
- Miniforge available via `module load miniforge/conda`
- Enough home or project storage for a venv

## Create the virtual environment

Run the following on the cluster (interactively). Python comes from Miniforge.

```bash
module load miniforge/conda

python -m venv venv
source venv/bin/activate

pip install --upgrade pip
pip install netzoopy-sponge==2.1.0

pip freeze > requirements.lock.txt
```

The repo’s [requirements.lock.txt](../requirements.lock.txt) was generated this way and pins versions for reproducibility. Use it to recreate the same environment elsewhere (e.g. `pip install -r requirements.lock.txt` in an activated venv).

## Run sponge with the batch script

The script [src/sponge.sh](../src/sponge.sh) runs netzoopy-sponge in a Slurm job. It:

- Loads Miniforge and activates the venv
- Runs `netzoopy-sponge` with the sponge config [config/sponge.yml](../config/sponge.yml)
- Writes logs under `logs/` (create that directory if needed)

The YAML sets genome, motif (JASPAR), and PPI options and writes motif and PPI priors (e.g. `data/motif_prior.tsv`, `data/ppi_prior.tsv`). Ensure `venv` and `config/sponge.yml` exist before submitting the job.

Use the sponge outputs as motif and PPI inputs when running PANDA (see [README](../README.md) for the main tutorial).
