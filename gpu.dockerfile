FROM jupyter/tensorflow-notebook:python-3.9.10

USER root

#RUN apt-get update -y \
#    && apt-get install -y software-properties-common \
#    && apt-get install -y gnupg2 wget
#
#RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin \
#    && mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600 \
#    && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/7fa2af80.pub \
#    && add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/ /"
#
#RUN apt-get update \
#    && apt-get -y install cuda

RUN apt-get update \
    && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates \
    && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub \
    && apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64/7fa2af80.pub \
    && echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/cuda.list \
    && echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu2004/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list \
    && apt-get purge --autoremove -y curl \
    && rm -rf /var/lib/apt/lists/*

ENV CUDA_VERSION 11.2.0

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update \
    && apt-get install -y --no-install-recommends cuda-cudart-11-2=11.2.72-1 cuda-compat-11-2 \
    && ln -s cuda-11.2 /usr/local/cuda \
    && rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf \
    && echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH} \
    LD_LIBRARY_PATH=/usr/local/cuda-11.2/compat:/usr/local/cuda/lib64:/usr/local/nvidia/lib:/usr/local/nvidia/lib64

#COPY NGC-DL-CONTAINER-LICENSE /

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES=all \
    NVIDIA_DRIVER_CAPABILITIES=compute,utility \
    NVIDIA_REQUIRE_CUDA="cuda>=11.2 brand=tesla,driver>=418,driver<419 brand=tesla,driver>=440,driver<441 driver>=450"

ENV NCCL_VERSION 2.8.4

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    cuda-libraries-11-2=11.2.0-1 \
    libnpp-11-2=11.2.1.68-1 \
    cuda-nvtx-11-2=11.2.67-1 \
    libcublas-11-2=11.3.1.68-1 \
    libcusparse-11-2=11.3.1.68-1 \
    libnccl2=$NCCL_VERSION-1+cuda11.2 \
    && rm -rf /var/lib/apt/lists/*

# apt from auto upgrading the cublas package. See https://gitlab.com/nvidia/container-images/cuda/-/issues/88
RUN apt-mark hold libcublas-11-2 libnccl2


ENV CUDNN_VERSION 8.1.1.33

RUN apt-get update \
    && apt-get install -y --no-install-recommends libcudnn8=$CUDNN_VERSION-1+cuda11.2 \
    && apt-mark hold libcudnn8 \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    cuda-cupti-11-2=11.2.67-1

RUN ln -s /usr/local/cuda/lib64/libcudart.so.11.2.152 /usr/local/cuda/lib64/libcudart.so.10.1

USER ${NB_UID}
