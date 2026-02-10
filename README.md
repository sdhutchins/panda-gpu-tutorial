# netZooPy GPU Tutorial

A simple tutorial for running **netZooPy** (PANDA / LIONESS) with **CuPy GPU
acceleration** on an HPC cluster (Open OnDemand, SLURM). The demo uses motif
and PPI priors downloaded from GRAND; we also document **sponge** so you can
use motif and PPI priors from sponge instead. Notebooks are compute-only;
installs happen outside Jupyter.

This tutorial is an update of the [netZooPy gpuPanda tutorial](https://github.com/netZoo/netZooPy/blob/master/tutorials/gpupanda/gpuPanda_tutorial.ipynb) (Daniel Morgan, Channing Division of Network Medicine, Brigham and Women's Hospital / Harvard Medical School).

## Table of Contents

- [Prerequisites](#prerequisites)
- [Install & Setup](#install--setup)
- [Usage](#usage)
- [Directory Structure](#directory-structure)
- [Contributing](#contributing)
- [License](#license)
- [Authors](#authors)
- [References](#references)

## Prerequisites

- Open OnDemand Jupyter app
- SLURM GPU partition
- NVIDIA GPU nodes (CUDA 12–compatible, e.g. A100)
- NVIDIA driver ≥ CUDA 12
- CUDA runtime provided via modules (no CUDA in conda; will set it up for this later)
- User Miniforge install

Assumed:

- `cupy-cuda12x`
- CUDA module close to `CUDA/12.3.0`

## Install & Setup

### Conda environment (for OOD Jupyter)

Use `config/netzoo-gpu.yml` or the block below:

```yaml
name: netzoo-gpu
channels:
  - conda-forge

dependencies:
  - python=3.10
  - pip
  - numpy<1.24
  - pandas
  - psutil
  - s3fs
  - ipykernel

  - pip:
      - cupy-cuda12x
```

Notes: CuPy via pip to match system CUDA; CUDA from modules, not conda. NumPy pinned for netZooPy.

### Set up the environment

On a hpc, load Miniforge and create/activate the environment, then
register the Jupyter kernel.

```bash
module load miniforge/conda
```

```bash
conda env create -f config/netzoo-gpu.yml
```

```bash
conda activate netzoo-gpu
```

```bash
python -m ipykernel install --user \
  --name netzoo-gpu \
  --display-name "Python (netzoo-gpu)"
```

### Install netZooPy from source

Install `netZooPy` into the `netzoo-gpu` environment from a user-writable
source directory.

```bash
mkdir -p $HOME/src
cd $HOME/src
```

```bash
git clone --branch devel https://github.com/netZoo/netZooPy.git
cd netZooPy
pip install -e .
```

### Alternative: sponge (motif and PPI priors)

You can use **sponge** to obtain motif and PPI priors instead of the GRAND
downloads in the demo. For setup, see [using sponge](docs/using-sponge.md) and `config/sponge.yml`.

## Usage

1. **Start Jupyter on a GPU node (Open OnDemand)**  
   Load CUDA **before** starting the Jupyter server.

   ```bash
   module load CUDA/12.3.0
   ```

   Select kernel: `Python (netzoo-gpu)`.

2. **Run the demo**  
   Open [panda-gpu-demo.ipynb](panda-gpu-demo.ipynb). It downloads LCL motif and PPI data from GRAND into `data/`, runs PANDA with GPU and precision options, and writes results to `output/`. To use motif and PPI priors from sponge instead, see [Using sponge](docs/using-sponge.md).

## Troubleshooting

### Verify Python path

```python
import sys
sys.executable
```

Expected:

```text
.../miniforge3/envs/netzoo-gpu/bin/python
```

### Verify GPU access

```python
import cupy as cp
cp.cuda.runtime.getDeviceCount()
```

If this fails:

- Confirm a GPU was requested in Open OnDemand
- Confirm `CUDA/12.3.0` was loaded before Jupyter launch
- Restart the Jupyter server after module changes

## Directory Structure

```text
panda-gpu-tutorial/
├── config/           # Environment configs (conda, sponge)
│   ├── netzoo-gpu.yml
│   └── sponge.yml
├── data/             # Input data (e.g. from GRAND; see data/README.md)
├── docs/             # Project documentation (e.g. using-sponge.md)
├── output/           # PANDA and other pipeline outputs
├── src/              # Scripts (e.g. sponge.sh)
├── tests/            # Tests
├── panda-gpu-demo.ipynb
├── README.md
├── requirements.lock.txt
├── CONTRIBUTING.md
├── LICENSE
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── workflows/
└── .gitignore
```

## Contributing

We welcome contributions. See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

View the [LICENSE](LICENSE) for this project.

## Authors

- Shaurita Hutchins [email](mailto:shaurita.d.hutchins@gmail.com) | PhD Candidate| [sdhutchins](https://github.com/sdhutchins)

## References

- **netZooPy (PANDA, GPU):** [The Network Zoo: a multilingual package for the inference and analysis of gene regulatory networks](https://academic.oup.com/nargab/article/4/1/lqac002/6524305). *NAR Genomics and Bioinformatics* 4(1), lqac002 (2022).
- **sponge:** [sponge: reproducible Python environments for HPC](https://academic.oup.com/bioinformatics/article/41/7/btaf320/8176566). *Bioinformatics* 41(7), btaf320 (2025).
