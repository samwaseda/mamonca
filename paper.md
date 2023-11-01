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

Magnetic interactions account for a significant portion of free energy in certain materials, ranging from iron, whose ground state would be wrongly predicted without considering magnetic interactions [@friak2001ab], to the magnetocaloric effects of Heusler alloys [@weiss1917phenomene], whose magnetic properties could allow for the development of highly efficient refrgiration systems. In materials science, the Heisenberg model is frequently employed to heuristically compute the potential energy. There are two main methods to make use of the Heisenberg model at finite temperature: one is the Monte Carlo method for an efficient free energy minimization, the other is spin dynamics for the calculation of spin configuration evolution.

`mamonca` is a C++-based python software package for the computation of magnetic interactions in solid materials. It has a clear interface consisting of setters (methods starting with `set_`) for inputs and getters (methods starting with `get_`). It has also an excellent interactivity, as the parameters can be changed on-the-fly, as well as the outputs can be retrieved in the same way. In order to have full flexibility in terms of multi-component systems and inclusion of defects, `mamonca` outsourced the structure definition, so that the user can analyse the interactions externally using a software package like pyiron [@janssen2019pyiron] or Atomic Structure Environment (ASE) [@larsen2017atomic]. `mamonca` has also high flexibility in defining the Hamiltonian, as it allows the user to define not only the classical Heisenberg model, but higher order components including the longitudinal variation can be defined, as it has been employed for Fe-Mn systems [@schneider2021ab]. In addition to the classical Monte Carlo and spin-dynamics, `mamonca` allows also for an addition of Metadynamics [@theodoropoulos2000coarse] and magnetic thermodynamic integration [@frenkel2023understanding], which can deliver the free energy variation.

Internally, each atom points to the magnetic moment of the interacting neighboring atoms, which allows for an efficient computation of pairwise interactions both in terms of speed and memory. Moreover, while it performs an on-the-fly computation of average magnetization and average energy, it does not allocate new memory for any property on-the-fly, which makes it highly memory-efficient.

# Acknowledgements

We acknowledge contributions from Brigitta Sipocz, Syrtis Major, and Semyeong
Oh, and support from Kathryn Johnston during the genesis of this project.

# References
