# This is the PyAudio distribution makefile.

.PHONY: docs clean build

VERSION := 0.2.12+s1
PYTHON ?= python
BUILD_ARGS ?=
SPHINX ?= sphinx-build
DOCS_OUTPUT=docs/
PYTHON_BUILD_DIR:=$(shell $(PYTHON) -c "import distutils.util; import sys; print(f'{distutils.util.get_platform()}-{sys.version_info[0]}.{sys.version_info[1]}')")
BUILD_DIR:=lib.$(PYTHON_BUILD_DIR)
BUILD_STAMP:=$(BUILD_DIR)/build
SRCFILES := src/*.c src/*.h src/*.py
EXAMPLES := examples/*.py
TESTS := tests/*.py

what:
	@echo "make targets:"
	@echo
	@echo " tarball    : build source tarball"
	@echo " docs       : generate documentation (requires sphinx)"
	@echo " clean      : remove build files"
	@echo
	@echo "To build pyaudio, run:"
	@echo
	@echo "   python setup.py install"

clean:
	@rm -rf build dist MANIFEST $(DOCS_OUTPUT) src/*.pyc

######################################################################
# Documentation
######################################################################

build: build/$(BUILD_STAMP)

build/$(BUILD_STAMP): $(SRCFILES)
	$(PYTHON) setup.py build $(BUILD_ARGS)
	touch $@

docs: build
	PYTHONPATH=build/$(BUILD_DIR) $(SPHINX) -b html sphinx/ $(DOCS_OUTPUT)

######################################################################
# Source Tarball
######################################################################
tarball: $(SRCFILES) $(EXAMPLES) $(TESTS) MANIFEST.in
	@$(PYTHON) setup.py sdist
