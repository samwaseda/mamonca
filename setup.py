from Cython.Build import cythonize
from setuptools import Extension, setup

ext = Extension(
    "mamonca",
    sources=["mamonca/mc.pyx"],
    language="c++",
    extra_compile_args=["-std=c++11"],
)

with open("README.md") as readme_file:
    readme = readme_file.read()

setup(
    name="mamonca",
    version="0.0.8",
    description="mamonca - interactive Magnetic Monte Carlo code",
    long_description=readme,
    long_description_content_type="text/markdown",
    url="https://github.com/samwaseda/mamonca",
    author="Sam Waseda",
    author_email="waseda@mpie.de",
    license="BSD",
    install_requires=["numpy>=1.26.4"],
    ext_modules=cythonize([ext]),
    options={"build": {"build_lib": "mamonca"}},
)
