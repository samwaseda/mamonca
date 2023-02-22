all:
	python setup.py build_ext

clean:
	rm mamonca/*.so mamonca/mc.cpp
