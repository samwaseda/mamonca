all:
	python setup.py build_ext --build-lib=mamonca

clean:
	rm mamonca/*.so mamonca/mc.cpp
