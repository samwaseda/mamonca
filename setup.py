from setuptools.command.build_ext import build_ext
from setuptools import setup, Extension
import numpy

# Check if Cython is available
try:
    from Cython.Build import cythonize
except ImportError:
    def cythonize(module_list):
        return module_list

# Define the extension module
ext = Extension(
    'mamonca',
    sources=["mamonca/mc.pyx"],
    language="c++",
    include_dirs=[numpy.get_include()],
    extra_compile_args=['-std=c++11'],
)

with open('README.md') as readme_file:
    readme = readme_file.read()

setup(
    name='mamonca',
    version='0.0.8',
    description='mamonca - interactive Magnetic Monte Carlo code',
    long_description=readme,
    long_description_content_type='text/markdown',
    url='https://github.com/samwaseda/mamonca',
    author='Sam Waseda',
    author_email='waseda@mpie.de',
    license='BSD',
    cmdclass={"build_ext": build_ext},
    ext_modules=cythonize([ext]),
    options={'build': {'build_lib': 'mamonca'}},
    setup_requires=[
        'setuptools>=18.0',
        'cython',
        'numpy',
    ],
)

