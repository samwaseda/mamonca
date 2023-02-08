from mamonca import MC
import numpy as np
import unittest


class TestFull(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        ij = np.loadtxt('neighbors.txt')
        cls.mc = MC(np.max(ij) + 1)
        cls.mc.set_heisenberg_coeff(0.1, *ij)
        cls.mc.run(temperature=300, number_of_iterations=1000)

    def test_acceptance_ratio(self):
        self.assertGreater(self.mc.get_acceptance_ratio(), 0)
        self.assertLess(self.mc.get_acceptance_ratio(), 1)

    def test_energy(self):
        self.assertLess(self.mc.get_energy(), 0)

if __name__ == '__main__':
    unittest.main()
