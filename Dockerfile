# Use the official R 4.4.3 image as the base image
FROM rocker/r-ver:4.4.3

# Define HOME as /root (the default home for root)
ENV HOME=/root

# Install system dependencies:
# - libgsl-dev: for R packages requiring GSL.
# - libzmq5: provides libzmq.so.5 for pbdZMQ.
# - python3 and python3-pip: needed to install Jupyter.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libgsl-dev \
        libzmq5 \
        python3 \
        python3-pip && \
    # Install Jupyter using pip with the --break-system-packages flag.
    pip3 install --break-system-packages jupyter && \
    rm -rf /var/lib/apt/lists/*

# Copy your repository into the container's home directory
COPY . ${HOME}

# Run the install.R script, if it exists, to install and configure R packages.
# Make sure your install.R script includes code to install IRkernel and register it.
# For example, install.R may contain:
#   install.packages("IRkernel")
#   IRkernel::installspec()  # to register the kernel with Jupyter
#   install.packages("ggplot2")
RUN if [ -f ${HOME}/install.R ]; then \
      R --quiet -e 'source("/root/install.R")'; \
    fi

# Default command: launch a Jupyter Notebook server.
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]
