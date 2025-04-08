# Use the official R 4.4.3 image as the base image
FROM rocker/r-ver:4.4.3

# Define HOME as /root (default home for root)
ENV HOME=/root

# Install system dependencies:
# - libgsl-dev: needed for R packages using GSL.
# - libzmq5: provides libzmq.so.5 for pbdZMQ.
# - python3 and python3-pip: required to install Jupyter.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libgsl-dev \
        libzmq5 \
        python3 \
        python3-pip && \
    # Install Jupyter with the --break-system-packages flag.
    pip3 install --break-system-packages jupyter && \
    rm -rf /var/lib/apt/lists/*

# (Optional) Expose port 8888 (this helps Binder know where to connect)
EXPOSE 8888

# Copy your repository into the container's home directory
COPY . ${HOME}

# Run the install.R script (if it exists) to install R package dependencies.
# For example, your install.R could contain:
#   install.packages("IRkernel")
#   IRkernel::installspec()   # registers the kernel with Jupyter
#   install.packages("ggplot2")
RUN if [ -f ${HOME}/install.R ]; then \
      R --quiet -e 'source("/root/install.R")'; \
    fi

# Launch a Jupyter Notebook server, allowing root, on all interfaces.
CMD ["jupyter", "notebook", "--allow-root", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]
