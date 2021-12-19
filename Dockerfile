ARG BASE_IMAGE=jupyter/tensorflow-notebook:python-3.8.8
FROM ${BASE_IMAGE}

USER root

RUN apt-get update \
	&& apt-get install -y --no-install-recommends unixodbc-dev unixodbc libpq-dev

USER ${NB_UID}

COPY requirements.txt .

RUN git config --global http.sslverify false

# no idea why export doesn't work
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

# labextensions require nodejs != 15 :/
USER root

RUN conda remove --force --yes nodejs \
	&& wget -q -O- https://deb.nodesource.com/setup_16.x | sudo -E bash - \
	&& apt-get install -y nodejs

USER ${NB_UID}
# end section

RUN jupyter labextension install jupyterlab-plotly @jupyter-widgets/jupyterlab-manager plotlywidget
