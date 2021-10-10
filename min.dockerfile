FROM jupyter/minimal-notebook

COPY min.requirements.txt requirements.txt

RUN pip install --quiet --no-cache-dir -r requirements.txt \
	&& rm requirements.txt \
	&& fix-permissions "${CONDA_DIR}" \
	&& fix-permissions "/home/${NB_USER}"

