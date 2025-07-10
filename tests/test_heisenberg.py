from mamonca import MC
import numpy as np
import unittest
import os
from scipy.sparse import coo_matrix


class TestFull(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.file_location = os.path.dirname(os.path.abspath(__file__))
        cls.ij = np.loadtxt(
            os.path.join(cls.file_location, "neighbors.txt")
        ).astype(int)
        cls.n = np.max(cls.ij) + 1
        cls.mc = MC(cls.n)
        cls.mc.set_heisenberg_coeff(0.1, *cls.ij)
        cls.mc.run(temperature=300, number_of_iterations=1000)

    def test_coo_mat(self):
        data = 0.1 * np.ones(self.ij.shape[1])
        mat = coo_matrix(
            (data, (self.ij[0], self.ij[1])),
            shape=(self.n, self.n),
        )
        for i in range(2):
            mc = MC(self.n)
            mc.set_heisenberg_coeff(mat)
            mc.run(100, number_of_iterations=1000)
            self.assertLess(mc.get_energy(), 0)
            mat = mat + mat # transforms to csr

    def test_acceptance_ratio(self):
        self.assertGreater(self.mc.get_acceptance_ratio(), 0)
        self.assertLess(self.mc.get_acceptance_ratio(), 1)

    def test_energy(self):
        self.assertLess(self.mc.get_energy(), 0)

    def test_energy_variance(self):
        self.assertGreater(self.mc.get_energy_variance(), 0)

    def test_number_of_atoms(self):
        ij = np.loadtxt(os.path.join(self.file_location, "neighbors.txt"))
        mc = MC(np.max(ij))
        self.assertRaises(ValueError, mc.set_heisenberg_coeff, 0.1, *ij)

    def test_magnetic_moments(self):
        m = self.mc.get_magnetic_moments()
        self.assertLess(np.max(m), 1)
        self.assertGreater(np.min(m), -1)
        norm = np.linalg.norm(m, axis=-1)
        self.assertAlmostEqual(norm.min(), norm.max())

    def test_magnetization(self):
        m = self.mc.get_magnetization()
        self.assertEqual(len(m), 1000)
        self.assertLess(m.max(), 1)
        self.assertGreater(m.min(), 0)

if __name__ == '__main__':
    unittest.main()
