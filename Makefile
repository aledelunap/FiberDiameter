SHELL=/bin/bash
CONDA_ACTIVATE=source $$(conda info --base)/etc/profile.d/conda.sh ; conda activate ; conda activate
UNAME := $(shell uname)
UNAME_M := $(shell uname -m)

ifeq (,$(shell which conda))
HAS_CONDA=False
else
HAS_CONDA=True
endif

ifeq (,$(shell which poetry))
HAS_POETRY=False
else
HAS_POETRY=True
endif

#################################################################################
# PROJECT PHONY TARGETS                                                         #
#################################################################################

.PHONY: environment

#################################################################################
# VIRTUAL ENVIRONMENT                                                           #
#################################################################################

.ONESHELL:
environment:
ifeq (False,$(HAS_CONDA))
	@echo ">>> Conda not found, installing miniconda3."
	mkdir -p ~/miniconda3
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-$(UNAME)-$(UNAME_M).sh -O ~/opt/miniconda3/miniconda.sh
	bash ~/opt/miniconda3/miniconda.sh -b -u -p ~/miniconda3
	rm -rf ~/opt/miniconda3/miniconda.sh
	~/opt/miniconda3/bin/conda init bash
	~/opt/miniconda3/bin/conda init zsh
	@echo ">>> Miniconda3 installed in $(HOME)/opt/miniconda3/"


endif
ifeq (False,$(HAS_POETRY))
	@echo ">>> Poetry not found, installing poetry."
	curl -sSL https://install.python-poetry.org | python3 -
	source export PATH="$(HOME)/.local/bin:$(PATH)"
	@echo ">>> Poetry installed in $(shell which poetry)"

endif
	@echo $(shell which conda)
	@echo ">>> Creating virtual environment."
	conda create --name fiberdiameter python=3
	@echo ">>> Activate the environment running: conda activate fiberdiameter"
	$(CONDA_ACTIVATE) fiberdiameter; poetry install --only main

#################################################################################
# MODEL TRAIN                                                                   #
#################################################################################

#################################################################################
# MODEL TEST                                                                    #
#################################################################################