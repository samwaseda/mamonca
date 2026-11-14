all:
	/cmmc/ptmp/pyironhb/mambaforge/envs/pyiron_mpie_cmti_2025-07-14/bin/python setup.py build_ext

clean:
	rm -rf mamonca/*.so mamonca/mc.cpp build
