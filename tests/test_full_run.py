from mamonca import MC
import numpy as np
import unittest
import os


class TestTemplate(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        cls.file_location = os.path.dirname(os.path.abspath(__file__))
        cls.ij = np.loadtxt(
            os.path.join(cls.file_location, "neighbors.txt")
        ).astype(int)
        cls.n = np.max(cls.ij) + 1


class TestRaw(TestTemplate):

    def test_thermodynamic_integration(self):
        mc = MC(self.n)
        mc.set_heisenberg_coeff(0.1, *self.ij, index=0)
        mc.set_heisenberg_coeff(-0.03, *self.ij, index=1)
        mc.set_lambda(0.5)
        mc.run(temperature=300, number_of_iterations=100)
        self.assertLess(mc.get_energy(index=0), mc.get_energy(index=1))

class TestPredefine(TestTemplate):
    def setUp(self):
        self.mc = MC(self.n)
        self.mc.set_heisenberg_coeff(0.1, *self.ij, index=0)

    def test_metadynamics(self):
        self.mc.set_metadynamics(max_range=1)
        self.mc.run(temperature=300, number_of_iterations=100)
        meta = self.mc.get_metadynamics_free_energy()
        self.assertAlmostEqual(np.diff(meta["magnetization"]).ptp(), 0)
        self.assertLessEqual(meta["free_energy"].max(), 0)

    def test_spin_dynamics(self):
        self.mc.switch_spin_dynamics()
        self.mc.run(temperature=300, number_of_iterations=100)
        self.assertLess(self.mc.get_energy(), 0)


if __name__ == '__main__':
    unittest.main()
