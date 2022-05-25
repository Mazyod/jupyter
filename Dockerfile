ARG BASE_IMAGE=jupyter/tensorflow-notebook:python-3.9.10
FROM ${BASE_IMAGE}

USER root

RUN apt update && apt install -y unixodbc unixodbc-dev g++ tdsodbc

USER ${NB_USER}

# update all packages to latest versions
# also, labextensions require nodejs != 15
# this command will take care of that
# NOTE: tried to update conda as well, but it fails
RUN conda update -y --all

COPY odbcinst.ini /etc/odbcinst.ini
COPY requirements.txt .

RUN git config --global http.sslverify false

# no idea why export doesn't work
# NOTE: tried to use conda to install, but it is riddled with issues
RUN CURL_CA_BUNDLE='' python -m pip install \
	--default-timeout=100 \
	--ignore-installed \
	--no-cache-dir \
	--trusted-host pypi.org \
	--trusted-host files.pythonhosted.org \
	-r requirements.txt \
	&& rm requirements.txt \
	&& fix-permissions "${CONDA_DIR}" \
	&& fix-permissions "/home/${NB_USER}"

RUN jupyter labextension install jupyterlab-plotly @jupyter-widgets/jupyterlab-manager plotlywidget
