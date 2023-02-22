# distutils: language = c++

from mamonca.cMC cimport cMC as MCcpp
from libcpp.vector cimport vector
import numpy as np

cdef class MC:
    """

    Magnetic Metropolis Monte Carlo module. It does not have to work with pyiron, but for
    convenience it is strongly recommended to do so. Here's a short example:

    >>> from pyiron import Project
    >>> from mc import MC
    >>> 
    >>> structure = Project('.').create.structure.bulk(
    >>>     name='Fe',
    >>>     cubic=True
    >>> )
    >>> 
    >>> structure.set_repeat(10)
    >>> J = 0.1 # eV
    >>> neighbors = structure.get_neighbors()
    >>> first_shell_tensor = neighbors.get_shell_matrix()[0]
    >>> 
    >>> mc = MC(len(structure))
    >>> mc.set_heisenberg_coeff(J*first_shell_tensor.toarray())
    >>> 
    >>> mc.run(temperature=300, number_of_iterations=1000)

    The results can be analysed by attributes like `get_mean_energy()` or
    `get_magnetic_moments()`.

    The Hamiltonian H is given in the form:

    H = -0.5*sum_ij J_ij*(m_i*m_j)^deg + sum_i A_i*m_i^deg

    The first coefficients (J_ij) can be inserted with set_heisenberg_coeff and the
    magnitude dependent terms (A_i) can be set via set_landau_coeff. Beware of the signs for
    the Heisenberg coefficients.
    """
    cdef MCcpp c_mc

    def __cinit__(self, number_of_atoms):
        """
        args:
            number_of_atoms (int): number of atoms
        """
        self.c_mc.create_atoms(number_of_atoms)

    def set_landau_coeff(self, coeff, deg, index=0):
        """
        Args:
            coeff (float/list/ndarray): Coefficient to the Landau term. If a single number is
                given, the same parameter is applied to all the atoms.
            deg (int): Polynomial degree (usually an even number)
            index (int): Potential index for thermodynamic integration (0 or 1; choose 0 if
                not thermodynamic integration)

        Comment:
            Landau term is given by: sum_i coeff_i*m_i^deg
        """
        coeff = np.array([coeff]).flatten()
        if len(coeff)==1:
            coeff = np.tile(coeff, self.c_mc.get_number_of_atoms())
        if len(coeff)!=self.c_mc.get_number_of_atoms():
            raise ValueError('coeff has to be a single number or a list of length'
                             'corresponding to the number of atoms in the box')
        self.c_mc.set_landau_coeff(coeff, deg, index)

    def set_heisenberg_coeff(self, coeff, i=None, j=None, deg=1, index=0):
        """
            Args:
                coeff (float/list/ndarray): Heisenberg coefficient. If a single number is given,
                    the same parameter is applied to all the pairs defined in me and neigh.
                    Instead of giving me and neigh, you can also give a n_atom x n_atom tensor.
                i (list/ndarray): list of indices i (s. definition in the comment)
                j (list/ndarray): list of indices j (s. definition in the comment)
                deg (int): polynomial degree
                index (int): potential index for thermodynamic integration (0 or 1; choose 0 if
                    not thermodynamic integration)
            Comment:
                Heisenberg term is given by: -sum_ij coeff_ij*(m_i*m_j)^deg. Beware of the
                negative sign.
        """
        if i is None and j is None:
            n = self.c_mc.get_number_of_atoms()
            if np.array(coeff).shape!=(n, n):
                raise ValueError(
                    'If i and j are not specified, coeff has to be a 2d tensor with the length '
                    + 'equal to the number of atoms in each direction.'
                )
            i,j = np.where(coeff!=0)
            coeff = coeff[coeff!=0]
        coeff = np.array([coeff]).flatten()
        i = np.array(i).flatten()
        j = np.array(j).flatten()
        if len(coeff)==1:
            coeff = np.tile(coeff, len(i))
        if len(coeff)!=len(i) or len(i)!=len(j):
            raise ValueError('Length of vectors not the same')
        self.c_mc.set_heisenberg_coeff(coeff, i, j, deg, index)

    def clear_heisenberg_coeff(self, index=0):
        """
            Args:
                index (int): potential index for thermodynamic integration (0 or 1; choose 0 if
                             not thermodynamic integration)

            This function erases all the Heisenberg coefficients defined before.
        """
        self.c_mc.clear_heisenberg_coeff(index)

    def clear_landau_coeff(self, index=0):
        """
            Args:
                index (int): potential index for thermodynamic integration (0 or 1; choose 0 if
                             not thermodynamic integration)

            This function erases all the Landau coefficients defined before.
        """
        self.c_mc.clear_landau_coeff(index)

    def clear_all_coeff(self):
        """
            This function erases all the coefficients defined before.
        """
        self.clear_heisenberg_coeff()
        self.clear_heisenberg_coeff(1)
        self.clear_landau_coeff()
        self.clear_landau_coeff(1)

    def get_magnetic_gradients(self):
        """
            Returns:
                nx3 array of magnetic gradients
        """
        m = self.c_mc.get_magnetic_gradients()
        return np.array(m).reshape(-1, 3)

    def get_magnetic_moments(self):
        """
            Returns:
                nx3 array of magnetic moments
        """
        m = self.c_mc.get_magnetic_moments()
        return np.array(m).reshape(-1, 3)

    def set_magnetic_moments(self, magmoms):
        """
            Args:
                magmoms (ndarray/list): nx3 magnetic moments to set
        """
        self.c_mc.set_magnetic_moments(np.array(magmoms).flatten())

    def get_magnetization(self):
        """
            Returns:
                average magnetization value or vector
        """
        return np.array(self.c_mc.get_magnetization())

    def get_output(self, index=0):
        """
            Args:
                index (int): Potential index (only for thermodynamic integration)

            Returns:
                dict of output values
        """
        return {'energy': self.get_energy(index=index),
                'mean_energy': self.get_mean_energy(index=index),
                'magnetization': np.mean(self.get_magnetization()),
                'energy_variance': self.get_energy_variance(index=index),
                'acceptance_ratio': self.get_acceptance_ratio(),
                'steps_per_second': self.get_steps_per_second()}


    def run(self, temperature, number_of_iterations=1, reset=True, threads=1):
        """
            Args:
                temperature (float): Temperature in K
                number_of_iterations (int): Number of MC steps (internally multiplied
                                            by the number of atoms)
                reset (bool): Resets statistics (s. get_mean_energy() etc.)
        """
        if reset:
            self.c_mc.reset()
        self.c_mc.run(temperature, number_of_iterations, threads)

    def get_acceptance_ratio(self, individual=False):
        """
            Args:
                individual (bool): If true, an array containing each acceptance ratio is returned
            Returns:
                Acceptance ratio since the last reset (s. reset())
        """
        if individual:
            return np.array(self.c_mc.get_acceptance_ratios())
        return self.c_mc.get_acceptance_ratio()

    def get_energy(self, index=0, per_atom=False):
        """
            Returns:
                Energy value of current snapshot in eV
        """
        if per_atom:
            return self.c_mc.get_energy(index)/self.c_mc.get_number_of_atoms()
        return self.c_mc.get_energy(index)

    def get_mean_energy(self, index=0, per_atom=False):
        """
            Returns:
                Mean energy value since the last reset (s. reset())
        """
        if per_atom:
            return self.c_mc.get_mean_energy(index)/self.c_mc.get_number_of_atoms()
        return self.c_mc.get_mean_energy(index)

    def get_energy_variance(self, index=0, per_atom=False):
        """
            Returns:
                Energy variance since the last reset (s. reset())
        """
        if per_atom:
            return self.c_mc.get_energy_variance(index)/self.c_mc.get_number_of_atoms()
        return self.c_mc.get_energy_variance(index)

    def revoke_qmc(self):
        self.set_eta(1)

    def set_lambda(self, val):
        """
            Args:
                val (float): Lambda value for thermodynamic integration
        """
        if val<0 or val>1:
            raise ValueError("Lambda value has to be between 0 and 1")
        self.c_mc.set_lambda(val)

    def select_id(self, indices):
        """
            Args:
                indices (list): list of id's that can be chosen
        """
        self.c_mc.select_id(np.array(indices).tolist())

    def get_steps_per_second(self):
        """
            Returns:
                Number of MC steps performed per second
        """
        return np.rint(self.c_mc.get_steps_per_second()).astype(int)

    def set_magnitude(self, dm, dphi, flip=1):
        """
            Args:
                dm (float/list/ndarray): Magnitude variation strength. If a single value is set,
                    the same value is used for all the atoms (applies to dphi and dtheta)
                dphi (float/list/ndarray): Phi variation strength
                dtheta (float/list/ndarray): Theta variation strength

            Comment:
                MC algorithm proposes a new magnetic moment by

                m_new = abs(m_old+dm*random_number)
                phi_new = phi_old+dphi*2*PI*random_number;

                where random_number is a random number between -1 and 1.
        """
        dm = np.array([dm]).flatten()
        dphi = np.array([dphi]).flatten()
        flip = np.array([flip]).flatten()
        if len(dm)==1:
            dm = np.array(self.c_mc.get_number_of_atoms()*dm.tolist())
        if len(dphi)==1:
            dphi = np.array(self.c_mc.get_number_of_atoms()*dphi.tolist())
        if len(flip)==1:
            flip = np.array(self.c_mc.get_number_of_atoms()*flip.tolist())
        self.c_mc.set_magnitude(dm, dphi, flip)

    def run_gradient_descent(self, max_iter=None, step_size=1, decrement=0.001, diff=1.0e-8):
        """
            args:
                max_iter (int): number of steps to perform
                step_size (float): step size
                decrement (float): decrement value
        """
        if max_iter is None:
            max_iter = self.c_mc.get_number_of_atoms()**2;
        return self.c_mc.run_gradient_descent(max_iter, step_size, decrement, diff)

    def set_metadynamics(
        self,
        max_range=4,
        energy_increment=1e-3,
        length_scale=0.1,
        bins=100,
        cutoff=5,
        use_derivative=True,
    ):
        """
        Set metadynamics calculation. Currently only the average magnetization can be chosen as
        the collective variable.

        Args:
            max_range (float): Maximum magnetization value (larger: less accurate; smaller:
                potentially misses free energy minimum)
            energy_increment (float): Energy increment (or prefactor) for the Gaussian histogram
                (larger: less accurate; smaller: slower convergence)
            length_scale (float): Magnetization length scale (or Gaussian smearing) (larger:
                potentially smears out free energy minimum; smaller: MC could become unstable)
            bins (int): Number of bins for histogram (larger: slower; smaller: less accurate)
            cutoff (float): Cutoff value (in length_scale unit) above which the Gaussian smearing
                is considered to be 0
            use_derivative (bool): Use derivative information of metadynamics. This should be set
                to True if the number of atoms is sufficiently high (>1000) and the MC step
                magnitude is not too large (around 0.1). In other words, except for code testing,
                it is unlikely that this should be set to False. If set to False, make sure that
                the number of bins is large enough for the Metadynamics to make sense (it has to
                be at least 10 x max_range x n_atoms / displacement_magnitude).
        """
        if bins < max_range/length_scale:
            raise ValueError('Number of bins too small for this length_scale and max_range')
        self.c_mc.set_metadynamics(
            max_range, energy_increment, length_scale, bins, cutoff, use_derivative*1
        )

    def get_metadynamics_free_energy(self, derivative=False):
        """
        Get free energy of the metadynamics simulation

        Args:
            derivative (bool): Whether to return the derivative values (only available if
                derivative is used for metadynamics).

        Returns:
            (dict) Containing ndarray of 'magnetization' and 'free_energy'
        """
        data = np.array(self.c_mc.get_histogram(derivative*1)).reshape(2, -1, order='C')
        return {'magnetization': data[0], 'free_energy': -data[1]}

    def switch_spin_dynamics(
        self, turn_on=True, damping_parameter=8.0e-3, delta_t=1.0e-3, rescale_mag=True
    ):
        """
        Turn on (or off) spin dynamics calculation

        Args:
            turn_on (bool): Turn on or off (turning it off means mc)
            damping_parameter (float): damping parameter (default: 8.0e-3)
            delta_t (float): time discretization in fs (default: 1.0e-3)
            rescaler_mag (bool): Whether or not rescale the displacement magnitude. Not setting
                it to True when spin dynamics on might rescale the time scale. This argument is
                probably going to be removed in the near future.

        The equations are based on this paper:
        Ma, Pui-Wai, and S. L. Dudarev.
        "Longitudinal magnetic fluctuations in Langevin spin dynamics."
        Physical Review B 86.5 (2012): 054416.
        https://journals.aps.org/prb/pdf/10.1103/PhysRevB.86.054416
        """
        self.c_mc.switch_spin_dynamics(1*turn_on, damping_parameter, delta_t, rescale_mag*1)

    def activate_debug(self):
        """
            Activate debug mode (not so helpful though...)
        """
        self.c_mc.activate_debug()

