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

Magnetic interactions account for a significant portion of free energy in certain materials, ranging from iron, whose ground state would be wrongly predicted without considering magnetic interactions, to Heusler alloys, whose magnetic properties could allow for the development of highly efficient refrgiration systems. In materials science, the Heisenberg model is frequently employed to heuristically compute the potential energy. There are two main methods to make use of the Heisenberg model at finite temperature: one is the Monte Carlo method for an efficient free energy minimization, the other is spin dynamics for the calculation of spin configuration evolution.

# Statement of need

`mamonca` is a C++-based python software package for the computation of magnetic interactions in solid materials. It has a clear interface consisting of setters (methods starting with `set_`) for inputs and getters (methods starting with `get_`). It has also an excellent interactivity, as the parameters can be changed on-the-fly, as well as the outputs can be retrieved in the same way. In order to have full flexibility in terms of multi-component systems and inclusion of defects, `mamonca` outsourced the structure definition, so that the user can analyse the interactions externally using a software package like pyiron or ASE. `mamonca` has also high flexibility in defining the Hamiltonian, as it allows the user to define not only the classical Heisenberg model, but higher order components including the longitudinal variation can be defined, as it has been employed for Fe-Mn systems [@schneider2021ab]. In addition to the classical Monte Carlo and spin-dynamics, `mamonca` allows also for an addition of Metadynamics and magnetic thermodynamic integration, which can deliver the free energy variation.



# Mathematics

Single dollars ($) are required for inline mathematics e.g. $f(x) = e^{\pi/x}$

Double dollars make self-standing equations:

$$\Theta(x) = \left\{\begin{array}{l}
0\textrm{ if } x < 0\cr
1\textrm{ else}
\end{array}\right.$$

You can also use plain \LaTeX for equations
\begin{equation}\label{eq:fourier}
\hat f(\omega) = \int_{-\infty}^{\infty} f(x) e^{i\omega x} dx
\end{equation}
and refer to \autoref{eq:fourier} from text.

# Citations

Citations to entries in paper.bib should be in
[rMarkdown](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html)
format.

If you want to cite a software repository URL (e.g. something on GitHub without a preferred
citation) then you can do it with the example BibTeX entry below for @fidgit.

For a quick reference, the following citation commands can be used:
- `@author:2001`  ->  "Author et al. (2001)"
- `[@author:2001]` -> "(Author et al., 2001)"
- `[@author1:2001; @author2:2001]` -> "(Author1 et al., 2001; Author2 et al., 2002)"

# Figures

Figures can be included like this:
![Caption for example figure.\label{fig:example}](figure.png)
and referenced from text using \autoref{fig:example}.

Figure sizes can be customized by adding an optional second parameter:
![Caption for example figure.](figure.png){ width=20% }

# Acknowledgements

We acknowledge contributions from Brigitta Sipocz, Syrtis Major, and Semyeong
Oh, and support from Kathryn Johnston during the genesis of this project.

# References
