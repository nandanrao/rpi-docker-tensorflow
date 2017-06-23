FROM resin/rpi-raspbian

RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        wget \
        libfreetype6-dev \
        libpng12-dev \
        libzmq3-dev \
        pkg-config \
        python \
        python-dev \
        python-numpy \
        python-scipy \
        rsync \
        libavformat-dev \
        libpq-dev \
        libjpeg-dev \
        rpi-update \
        zlib1g-dev \
        libhdf5-dev \
        unzip

RUN apt-get clean && \
        rm -rf /var/lib/apt/lists/*

RUN rpi-update

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
        rm get-pip.py

RUN pip --no-cache-dir install \
        ipykernel \
        jupyter \
        Pillow \
        h5py \
        picamera \
        matplotlib && \
            python -m ipykernel.kernelspec

# Install tensorflow (get latest!)
RUN wget https://github.com/samjabrahams/tensorflow-on-raspberry-pi/releases/download/v1.1.0/tensorflow-1.1.0-cp27-none-linux_armv7l.whl

RUN pip install tensorflow-1.1.0-cp27-none-linux_armv7l.whl

# Now that we have tensorflow, install keras!
RUN pip --no-cache-dir install keras mock

COPY jupyter_notebook_config.py /root/.jupyter/

# Copy sample notebooks.
COPY notebooks /notebooks
# Jupyter has issues with being run directly:
#   https://github.com/ipython/ipython/issues/7062
# We just add a little wrapper script.
COPY run_jupyter.sh /

# TensorBoard
EXPOSE 6006

# IPython
EXPOSE 8888

WORKDIR "/notebooks"

CMD ["/run_jupyter.sh", "--allow-root"]
