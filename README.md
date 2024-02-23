# mamonca - interactive Magnetic Monte Carlo

This code allows you to launch Metropolis Monte Carlo simulations via Heisenberg Landau models (with various polynomial degrees) from a jupyter notebook.

## Model

`mamonca` is based on the Heisenberg Landau model of the format:

$$\mathcal H = -\frac{1}{2}\sum_{ij,\kappa}J_{ij,\kappa}m_i^{2\kappa+1}m_j^{2\kappa+1} + \sum_{i,\kappa} A_{i,\kappa} m_i^{2\kappa}$$

where $i$ and $j$ go over all atoms and $\kappa$ is the exponent ($\kappa=1$ and $A_{i,\kappa}=0$ for all $i$ and $\kappa$ for the classical Heisenberg model). The evaluation takes place either via Metropolis Monte Carlo (MC) method or spindynamics (SD). MC has the advantage of converging very fast, while SD also delivers the kinetics.

## How to compile

`mamonca` can be installed directly from conda:

```
conda install -c conda-forge mamonca
```
In order to use build it from the repository, run
```
git clone https://github.com/samwaseda/mamonca
cd mamonca
python setup.py build_ext --user
```

## First steps:

In the following simple (but complete) example, we create a bcc Fe system using [pyiron](http://github.com/pyiron/pyiron) (install via `conda install pyiron`) and launch a Metropolis Monte Carlo simulation with a Heisenberg coefficient `J=0.1` (eV) for the first nearest neighbor pairs:

```python
from pyiron_atomistics import Project
from mamonca import MC

basis = Project('.').create.structure.bulk(
    name='Fe',
    cubic=True
)

# Repeat the structure 10 times in each direction
structure = basis.repeat(10)
J = 0.1 # eV
neighbors = structure.get_neighbors()
first_shell_tensor = neighbors.get_shell_matrix()[0]

mc = MC(len(structure))
mc.set_heisenberg_coeff(J * first_shell_tensor)

mc.run(temperature=300, number_of_iterations=1000)
```

More complete list of examples can be found in `notebooks/first_steps.ipynb`

## How to set inputs and get outputs

As a rule of thumb, you can set all input parameters via functions starting with `set_`. Similarly, output values can be obtained via functions whose names start with `get_`. Most notably, you can get all basic output values via `get_output()` in a dictionary. Otherwise, take a look at the list of auto-complete and see their docstrings

## Notes

- Currently only Linux installation is supported
- You can run tests located in the `tests` folder
