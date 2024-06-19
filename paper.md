---
title: 'mamonca: magnetic Monte Carlo code'
tags:
  - Python
  - Heisenberg-Landau model
  - Spin dynamics
  - Metadynamics
  - Thermodynamic integration
authors:
  - name: Osamu Waseda
    orcid: 0000-0002-1677-4057
    corresponding: true # (This is how to denote the corresponding author)
    equal-contrib: true
    affiliation: 1
  - name: Tilmann Hickel
    affiliation: 1
  - name: Jörg Neugebauer
    affiliation: 1
affiliations:
 - name: Max-Planck-Institut für Eisenforschung, Max-Planck-Straße 1, D-40237 Düsseldorf, Germany
   index: 1
date: 1 November 2023
bibliography: paper.bib

# Optional fields if submitting to a AAS journal too, see this blog post:
# https://blog.joss.theoj.org/2018/12/a-new-collaboration-with-aas-publishing
aas-doi: 10.3847/xxxxx <- update this with the DOI from AAS once you know it.
aas-journal: Astrophysical Journal <- The name of the AAS journal.
---

# Summary

Magnetic interactions account for a significant portion of free energy in certain materials, ranging from relatively simple systems such as iron to complex magneto-caloric effects of Heusler alloys [@weiss1917phenomene]. More specifically, in the case of iron, the ground state would be wrongly predicted without considering magnetic interactions [@friak2001ab]. In Heusler systems, the understanding of magnetic properties could allow for the development of highly efficient refrigeration systems. In materials science, the Heisenberg model is frequently employed to heuristically compute the magnetic part of the potential energy. There are two main methods to make use of the Heisenberg model at finite temperature: one is the Monte Carlo method for an efficient free energy minimization, the other is spin dynamics for the calculation of spin configuration evolution. The Monte Carlo method has the advantage of obtaining the free energy rapidly, while spin dynamics also delivers the kinetics of the system. `mamonca` allows for the evaluation of the Heisenberg Hamiltonian with extended terms using both Monte Carlo method and spin dynamics.

# Model

`mamonca` is based on the Heisenberg Landau model of the format:

$$\mathcal H = -\frac{1}{2}\sum_{ij,\kappa}J_{ij,\kappa}m_i^{2\kappa+1}m_j^{2\kappa+1} + \sum_{i,\kappa} A_{i,\kappa} m_i^{2\kappa}$$

where $i$ and $j$ go over all atoms and $\kappa$ is the exponent ($\kappa=1$ and $A_{i,\kappa}=0$ for all $i$ and $\kappa$ for the classical Heisenberg model) and $m_i$ is the magnetic moment of the atom $i$. These parameters can be set independently via `mamonca.set_landau_parameters` for the longitudinal parameters $A_{i, \kappa}$ and `mamonca.set_heisenberg_parameters` for the Heisenberg parameters $J{ij, \kappa}$. The evaluation takes place either via Metropolis Monte Carlo method or spin dynamics. More technical details and simple examples are given in `notebooks/first_steps.ipynb`.

# Statement of need

`mamonca` is a C++-based python software package for the computation of magnetic interactions in solid materials. Its interactive and modular nature makes it for a user who wants to obtain the magnetic behavior of simple to complex systems as well as combining it with other tools on the fly. All inputs and outputs are given by setters (starting with `set_`) and getters (starting with `get_`), in order for `mamonca` to spare file-reading and writing, in strong contrast to other existing software packages [@kawamura2017quantum; @bauer2011alps; @evans2014atomistic; @hellsvik2011uppsala]. As a result, it has excellent interactivity, as the parameters can be changed on the fly, as well as the outputs can be retrieved at any interval chosen by the user. With `mamonca`, the user can analyse any structure that can be defined by other software packages such as Atomic Structure Environment (ASE) [@larsen2017atomic] or pyiron [@janssen2019pyiron], as `mamonca` takes only the exchange parameters and does not require the knowledge of the structure, which is a strong contrast to existing software packages [@kawamura2017quantum; @bauer2011alps]. `mamonca` has also high flexibility in defining the Hamiltonian, as it allows the user to define not only the classical Heisenberg model, but higher order components including the longitudinal variation, as it has been employed for Fe-Mn systems [@schneider2021ab]. In order to validate the code, a comparison of results produced with `mamonca` with those obtained in [@schneider2021ab] is given in the notebook `notebooks/first_steps.ipynb`. The input parameters for the Hamiltonian can be straightforwardly obtained using a workflow tool such as pyiron, or other calculation software packages such as TB2J [@he2021tb2j]. A typical workflow with pyiron would consist of a general set of physical parameters (chemical element, lattice parameter etc.), is given in the notebook `notebooks/first_steps.ipynb`, which is then evaluated by the software of user's choice. The results can be straightforwardly evaluated to obtain the exchange parameters with the existing tools inside pyiron. Finally, `mamonca` can run to deliver the finite temperature effects of the magnetic part. A full workflow example including the acquisition of magnetic interaction parameters is given in the notebook `notebooks/fitting.ipynb`. This means, the user in principle needs only to insert physical parameters to obtain the magnetic finite temperature behaviour they are interested in. In addition to the classical Monte Carlo and spin-dynamics, `mamonca` allows also for an addition of Metadynamics [@theodoropoulos2000coarse] and magnetic thermodynamic integration (Chap. 9 [@frenkel2023understanding]), which can deliver the free energy variation. It is crucial to include these features within the code, as they have to be applied at each step of the simulation and cannot be evaluated in the post-processing. To authors' knowledge, it is the only one code that is able to run Monte Carlo calculations with Metadynamics and magnetic thermodynamic integration. Both thermodynamic integration and Metadynamics are shown in the notebook `notebooks/first_steps.ipynb` for simple systems.

# Acknowledgements

We gratefully acknowledge the financial support from the German Research Foundation (DFG) under grant HI 1300/15-1 within the DFG-ANR project C-TRAM.

# References
