from Cython.Build import cythonize
from setuptools.command.build_ext import build_ext
from setuptools import setup, Extension


ext = Extension(
    'mamonca',
    sources=["mamonca/mc.pyx"],
    language="c++",
    extra_link_args=['-lgomp'],
)

setup(
    name='mamonca',
    version='0.0.6',
    description='mamonca - interactive Magnetic Monte Carlo code',
    url='https://github.com/samwaseda/mamonca',
    author='Sam Waseda',
    author_email='waseda@mpie.de',
    license='BSD',
    cmdclass={"build_ext": build_ext},
    ext_modules=cythonize([ext], language_level="3"),
    options={'build': {'build_lib': 'mamonca'}}
)
