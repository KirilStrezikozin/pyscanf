.ONESHELL:

.DEFAULT_GOAL := venv

PYTHON = /bin/python3
PIP = /bin/pip
VENV = venv
PYTHON_VENV = ./$(VENV)/bin/python3
PIP_VENV = ./$(VENV)/bin/pip

venv/bin/activate: requirements.txt
	$(PYTHON) -m venv $(VENV)
	$(PYTHON) -m pip install --upgrade pip
	chmod +x ./$(VENV)/bin/activate
	source ./$(VENV)/bin/activate
	$(PIP_VENV) install -r requirements.txt

venv: venv/bin/activate

lint: venv
	$(PYTHON_VENV) -m flake8 ./pyscanf/ --count --select=E9,F63,F7,F82 --show-source --statistics
	$(PYTHON_VENV) -m flake8 ./pyscanf/ --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics

test: venv
	$(PYTHON_VENV) -m pytest

build: clean lint test
	rm -rf dist
	$(PYTHON_VENV) -m build

upload_test: build
	$(PYTHON_VENV) -m twine upload --repository testpypi dist/*

upload: build
	$(PYTHON_VENV) -m twine upload dist/*

clean: venv
	pyclean .
	# rm -rf $(VENV)
	rm -rf *.egg-info
	rm -rf dist

.PHONY: build clean

