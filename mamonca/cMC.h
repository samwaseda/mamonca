#ifndef cMC_H
#define cMC_H

#include <cstdlib>
#include <ctime>
#include <valarray>
#include <chrono>
#include <numeric>
#include <random>
#include <string>

using namespace std;

double power(double, int);
double m_norm(valarray<double>);
valarray<double> m_cross(valarray<double>&, valarray<double>);

class RandomNumberFactory{
    private:
        default_random_engine generator;
        normal_distribution<double> distribution;
        valarray<double> m_new;
    public:
        valarray<double> on_sphere(int size=3); // size
        double uniform(bool symmetric=true, double max_value=1.0);
        double normal();
        valarray<double> n_on_sphere(int size=3); //size
        RandomNumberFactory(){
            m_new.resize(3, 0);
        }
} rand_generator;

struct Constants{
    const double hbar = 0.6582119569;
    const double kB = 8.617333262145e-5;
    double damping_parameter = 8.0e-3;
    double delta_t = 1.0e-3;
} constants;

struct Product;
struct Magnitude;;

class Atom{
    private:
        double mabs, mabs_tmp, E_current[2], dE_current[2], dm, dphi, mmax;
        valarray<double> gradient;
        vector<double> heisen_coeff[2], landau_coeff[2];
        vector<Magnitude*> landau_func[2];
        vector<Product*> heisen_func[2];
        vector<Atom*> neigh[2];
        int acc, count;
        // This does not work when neighbors change their m
        struct UpToDate{
            vector<bool> E, dE;
        } up_to_date;
        bool debug, flip;
        void update_flag(bool ff=false);
        friend Product;
    public:
        void calc_spin_dynamics(double, double, double, double); // gamma, delta_t, mu_s, lambda
        void update_spin_dynamics();
        valarray<double> m, m_tmp;
        valarray<double> get_gradient(double); // lambda
        Atom();
        ~Atom();
        void set_m(valarray<double>, bool diff=false);
        valarray<double> delta_m();
        double get_gradient_residual();
        double get_acceptance_ratio();
        double get_magnitude(int exponent=1, bool old=false);
        double E(int index=0, bool force_compute=false);
        double dE(int index=0, bool force_compute=false);
        double run_gradient_descent(double, double); // h lambda
        void revoke();
        void set_landau_coeff(double, int, int);
        void set_heisenberg_coeff(Atom&, double, int deg=1, int index=0);
        void clear_landau_coeff(int);
        void clear_heisenberg_coeff(int);
        void activate_debug();
        void propose_new_state();
        void rescale_magnitude(double, double);
        void set_magnitude(double, double, bool flip_in=true);
        void check_consistency();
};

class average_energy
{
    private:
        vector<double> EE, E_sum, EE_sq;
        int NN;
    public:
        average_energy();
        void add(double, bool total_energy=false, int index=0);
        double E_mean(int);
        double E_var(int);
        void reset();
};

class Metadynamics{
    private:
        vector<double> hist;
        double denominator, energy_increment, max_range, cutoff;
        bool use_derivative;
        double gauss_exp(double, int);
        int i_min(double);
        int i_max(double);
    public:
        bool initialized;
        Metadynamics();
        void set_metadynamics(double, double, double, int, double, int);
        double get_biased_energy(double, double);
        double get_biased_gradient(double);
        void append_value(double);
        vector<double> get_histogram(vector<double>&, int);
};

class cMC{
    private:
        long long int acc, MC_count;
        int n_tot;
        double steps_per_second, lambda;
        bool debug_mode, spin_dynamics_flag;
        Atom *atom;
        average_energy E_tot;
        bool thermodynamic_integration();
        void run_mc(double);
        void run_spin_dynamics(double, int);
        bool metropolis(double, double);
        vector<int> selectable_id;
        valarray<double> magnetization;
        vector<double> magnetization_hist;
        Metadynamics meta;
        void reset_magnetization();
        void update_magnetization(int, bool backward=false);
    public:
        cMC();
        ~cMC();
        void create_atoms(int);
        void activate_debug();
        void run(double, int number_of_iterations=1, int threads=1);
        void set_lambda(double);
        vector<double> get_magnetic_moments();
        vector<double> get_magnetic_gradients();
        void set_magnetic_moments(vector<double>);
        void set_landau_coeff(vector<double>, int, int index=0);
        void set_heisenberg_coeff(vector<double>, vector<int>, vector<int>, int, int index=0);
        void clear_landau_coeff(int index=0);
        void clear_heisenberg_coeff(int index=0);
        double get_acceptance_ratio();
        vector<double> get_acceptance_ratios();
        double get_energy(int);
        double get_mean_energy(int index=0);
        double get_energy_variance(int index=0);
        double get_steps_per_second();
        int get_number_of_atoms();
        void set_magnitude(vector<double>, vector<double>, vector<int>);
        double run_gradient_descent(
            int, double step_size=1, double decrement=0.001, double diff=1.0e-8);
        void select_id(vector<int>);
        void reset();
        void set_metadynamics(double, double, double, int, double, int);
        void switch_spin_dynamics(
            bool on=true,
            double damping_parameter=8.0e-3,
            double delta_t=1.0e-3,
            bool rescale_mag=true);
        vector<double> get_magnetization();
        vector<double> get_histogram(int);
};

struct Magnitude{
    virtual double value(double);
    virtual valarray<double> gradient(valarray<double>&);
};

struct Square : Magnitude {
    double value(double);
    valarray<double> gradient(valarray<double>&);
} square;

struct Quartic : Magnitude {
    double value(double);
    valarray<double> gradient(valarray<double>&);
} quartic;

struct Sextic : Magnitude {
    double value(double);
    valarray<double> gradient(valarray<double>&);
} sextic;

struct Octic : Magnitude {
    double value(double);
    valarray<double> gradient(valarray<double>&);
} octic;

struct Decic : Magnitude {
    double value(double);
    valarray<double> gradient(valarray<double>&);
} decic;

struct Product{
    virtual double value(Atom&, Atom&);
    virtual double diff(Atom&, Atom&);
    virtual valarray<double> gradient(Atom&, Atom&);
};

struct J_lin_lin : Product {
    double value(Atom&, Atom&);
    double diff(Atom&, Atom&);
    valarray<double> gradient(Atom&, Atom&);
} j_lin_lin;

struct J_cub_lin : Product {
    double value(Atom&, Atom&);
    double diff(Atom&, Atom&);
    valarray<double> gradient(Atom&, Atom&);
} j_cub_lin;

struct J_qui_lin : Product {
    double value(Atom&, Atom&);
    double diff(Atom&, Atom&);
    valarray<double> gradient(Atom&, Atom&);
} j_qui_lin;

#endif
