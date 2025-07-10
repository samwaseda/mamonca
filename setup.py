from setuptools import setup, Extension
from setuptools.command.build_ext import build_ext
from Cython.Build import cythonize
import numpy


ext = Extension(
    'mamonca',
    sources=["mamonca/mc.pyx"],
    language="c++",
    extra_compile_args=['-std=c++11'],
    include_dirs=[numpy.get_include()],
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
    ext_modules=cythonize([ext]),
    options={'build': {'build_lib': 'mamonca'}},
)
