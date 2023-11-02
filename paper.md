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

# Statement of need

`mamonca` is a C++-based python software package for the computation of magnetic interactions in solid materials. All inputs and outputs are given by setters (starting with `set_`) and getters (starting with `get_`), in order for `mamonca` to spare file-reading and writing, in strong contrast to other existing software packages [@kawamura2017quantum; @bauer2011alps]. As a result, it has an excellent interactivity, as the parameters can be changed on-the-fly, as well as the outputs can be retrieved at any interval chosen by the user. With `mamonca`, the user can analyse any structure that can be defined by other software packages such as Atomic Structure Environment (ASE) [@larsen2017atomic] or pyiron [@janssen2019pyiron], as it takes only the exchange parameters and does not require the knowledge of the structure, which is a strong contrast to existing software packages [@kawamura2017quantum; @bauer2011alps]. `mamonca` has also high flexibility in defining the Hamiltonian, as it allows the user to define not only the classical Heisenberg model, but higher order components including the longitudinal variation, as it has been employed for Fe-Mn systems [@schneider2021ab]. The input parameters for the Hamiltonian can be straightforwardly obtained using a workflow tool such as pyiron, or other calculation software packages such as TB2J [@he2021tb2j]. In addition to the classical Monte Carlo and spin-dynamics, `mamonca` allows also for an addition of Metadynamics [@theodoropoulos2000coarse] and magnetic thermodynamic integration [@frenkel2023understanding], which can deliver the free energy variation.

# Acknowledgements

We gratefully acknowledge the financial support from the German Research Foundation (DFG) under grant HI 1300/15-1 within the DFG-ANR project C-TRAM.

# References
