# Magnetic Metropolis Monte Carlo following classical Boltzmann statistics

This code allows you to launch Metropolis Monte Carlo simulations via Heisenberg Landau models (with various polynomial degrees) from a jupyter notebook.

## How to compile

Download all files and run `python setup.py build_ext --inplace`.

## First steps:

In the following simple (but complete) example, we create a bcc Fe system using [pyiron](http://github.com/pyiron/pyiron) and launch a Metropolis Monte Carlo simulation with a Heisenberg coefficient `J=0.1` (eV) for the first nearest neighbor pairs:

```python
from pyiron import Project
from mc import MC

structure = Project('.').create.structure.bulk(
    name='Fe',
    cubic=True
)

structure.set_repeat(10)
J = 0.1 # eV
neighbors = structure.get_neighbors()
first_shell_tensor = neighbors.get_shell_matrix()[0]

mc = MC(len(structure))
mc.set_heisenberg_coeff(J*first_shell_tensor.toarray())

mc.run(temperature=300, number_of_iterations=1000)
```

## How to set inputs and get outputs

As a rule of thumb, you can set all input parameters via functions starting with `set_`. Similarly, output values can be obtained via functions whose names start with `get_`. Take a look at the list of auto-complete and see their docstrings

