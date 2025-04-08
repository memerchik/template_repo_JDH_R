# Use the official R 4.4.3 image as the base image
FROM rocker/r-ver:4.4.3

# Define HOME as /root (the default home for root)
ENV HOME=/root

# Install system dependencies: libgsl-dev for R and libzmq5 for pbdZMQ
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libgsl-dev \
        libzmq5 && \
    rm -rf /var/lib/apt/lists/*

# Copy your repository into the container’s home directory
COPY . ${HOME}

# Run the install.R script (if it exists) to install R package dependencies.
# Running as root allows installation into the system library.
RUN if [ -f ${HOME}/install.R ]; then \
      R --quiet -e 'source("/root/install.R")'; \
    fi

# Set the default command to launch a Jupyter Notebook server.
# This is suitable if you want to use IRkernel via Jupyter on Binder.
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]
