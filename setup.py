from distutils.core import setup
from Cython.Build import cythonize
from distutils.extension import Extension
from distutils.command.build_ext import build_ext


ext = Extension(
    'mc',
    sources=["mamonca/mc.pyx"],
    language="c++",
    extra_compile_args=['-fopenmp'],
    extra_link_args=['-lgomp']
)

setup(
    name='mamonca',
    version='0.0.5',
    description='mamonca - interactive Magnetic Monte Carlo code',
    url='https://github.com/samwaseda/mamonca',
    author='Sam Waseda',
    author_email='waseda@mpie.de',
    license='BSD',
    cmdclass={"build_ext": build_ext},
    ext_modules=cythonize([ext], language_level="3"),
    options={'build': {'build_lib': 'mamonca'}}
)
