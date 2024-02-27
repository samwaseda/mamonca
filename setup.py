from Cython.Build import cythonize
from setuptools.command.build_ext import build_ext
from setuptools import setup, Extension


ext = Extension(
    'mamonca',
    sources=["mamonca/mc.pyx"],
    language="c++",
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
    ext_modules=cythonize([ext], language_level="3"),
    options={'build': {'build_lib': 'mamonca'}},
    setup_requires=[
        # Setuptools 18.0 properly handles Cython extensions.
        'setuptools>=18.0',
        'cython',
        'numpy',
    ],
)
