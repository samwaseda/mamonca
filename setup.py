from distutils.core import setup
from Cython.Build import cythonize
from distutils.extension import Extension

from distutils.command.build_ext import build_ext
from distutils.sysconfig import customize_compiler

class my_build_ext(build_ext):
    def build_extensions(self):
        customize_compiler(self.compiler)
        try:
            self.compiler.compiler_so.remove("-Wstrict-prototypes")
        except (AttributeError, ValueError):
            pass
        build_ext.build_extensions(self)

ext = Extension('mc', sources=["mamonca/mc.pyx"], language="c++", extra_compile_args=['-fopenmp'], extra_link_args=['-lgomp'])

setup(
    name='mamonca',
    version='0.0.5',
    description='mamonca - interactive Magnetic Monte Carlo code',
    url='https://github.com/samwaseda/mamonca',
    author='Sam Waseda',
    author_email='waseda@mpie.de',
    license='BSD',
    cmdclass = {'build_ext': my_build_ext}, ext_modules=cythonize([ext], language_level="3")
)
