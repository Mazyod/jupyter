ARG BASE_IMAGE=jupyter/tensorflow-notebook:python-3.8.8
FROM ${BASE_IMAGE}

USER root

# update all packages to latest versions
# also, labextensions require nodejs != 15
# this command will take care of that
RUN conda update -y --all

USER ${NB_UID}

COPY requirements.txt .

RUN git config --global http.sslverify false

RUN conda install --file requirements.txt \
	&& rm requirements.txt \
	&& fix-permissions "${CONDA_DIR}" \
	&& fix-permissions "/home/${NB_USER}"

RUN jupyter labextension install jupyterlab-plotly @jupyter-widgets/jupyterlab-manager plotlywidget
