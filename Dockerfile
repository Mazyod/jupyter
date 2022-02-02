ARG BASE_IMAGE=jupyter/tensorflow-notebook:python-3.8.8
FROM ${BASE_IMAGE}

# update all packages to latest versions
# also, labextensions require nodejs != 15
# this command will take care of that
# NOTE: tried to update conda as well, but it fails
RUN conda update -y --all

COPY requirements.txt .

RUN git config --global http.sslverify false

RUN conda install --file requirements.txt
RUN jupyter labextension install jupyterlab-plotly @jupyter-widgets/jupyterlab-manager plotlywidget
