all:
	python setup.py build_ext

clean:
	rm -rf mamonca/*.so mamonca/mc.cpp build
