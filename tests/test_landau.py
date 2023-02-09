from mamonca.mc import MC
import numpy as np
import unittest


class TestFull(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        ij = np.loadtxt('neighbors.txt')
        cls.mc = MC(np.max(ij) + 1)
        cls.mc.set_heisenberg_coeff(0.1, *ij)
        cls.mc.set_landau_coeff(-0.1, 2)
        cls.mc.set_landau_coeff(0.01, 4)
        cls.mc.run(temperature=300, number_of_iterations=1000)

    def test_acceptance_ratio(self):
        self.assertGreater(self.mc.get_acceptance_ratio(), 0)
        self.assertLess(self.mc.get_acceptance_ratio(), 1)

    def test_energy(self):
        self.assertLess(self.mc.get_energy(), 0)

    def test_energy_variance(self):
        self.assertGreater(self.mc.get_energy_variance(), 0)

    def test_magnetic_moments(self):
        m = self.mc.get_magnetic_moments()
        self.assertGreater(np.var(np.linalg.norm(m, axis=-1)), 0)

    def test_magnetization(self):
        m = self.mc.get_magnetization()
        self.assertGreater(m.min(), 0)


if __name__ == '__main__':
    unittest.main()
