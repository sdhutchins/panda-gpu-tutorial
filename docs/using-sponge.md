# Using sponge

**sponge** generates motif and PPI priors that you can use instead of the GRAND
downloads in the main demo. This guide uses **netzoopy-sponge v2.1.0** on an HPC
system that runs Slurm. The goal is to create a stable, reproducible Python
environment for batch jobs without depending on system Python or inherited
shell state. Miniforge provides Python, and a virtual environment keeps the
sponge dependencies isolated.

## Prerequisites

Before creating the environment, confirm that you have:

- Access to a cluster login node
- Miniforge available via `module load miniforge/conda`
- Enough home or project storage for a venv

## Create the virtual environment

Run the following commands in an interactive shell on the cluster. Loading
Miniforge first ensures that the virtual environment uses its Python
installation.

```bash
module load miniforge/conda

python -m venv venv
source venv/bin/activate

pip install --upgrade pip
pip install netzoopy-sponge==2.1.0

pip freeze > requirements.lock.txt
```

The repository's [requirements.lock.txt](../requirements.lock.txt) was generated
with `pip freeze` and pins the installed package versions for reproducibility.
To recreate the same environment elsewhere, activate a virtual environment and
run `pip install -r requirements.lock.txt`.

## Run sponge with the batch script

The [src/sponge.sh](../src/sponge.sh) script runs netzoopy-sponge as a Slurm
job. It:

- Loads Miniforge and activates the venv
- Runs `netzoopy-sponge` with the sponge config [config/sponge.yml](../config/sponge.yml)
- Writes logs under `logs/` (create that directory if needed)

The YAML file defines the genome, motif (JASPAR), and PPI options. The job then
writes the resulting priors to files such as `data/motif_prior.tsv` and
`data/ppi_prior.tsv`. Before submitting the job, confirm that both `venv` and
`config/sponge.yml` exist.

Once the job finishes, use the sponge outputs as the motif and PPI inputs for
PANDA. Return to the [main tutorial](../README.md) to run the GPU demo.
