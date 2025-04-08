# Use the official R 4.4.3 image as the base image
FROM rocker/r-ver:4.4.3

# Define HOME as /root (the default home directory for root)
ENV HOME=/root

# Install system dependencies (e.g. libgsl-dev)
RUN apt-get update && \
    apt-get install -y --no-install-recommends libgsl-dev && \
    rm -rf /var/lib/apt/lists/*

# Copy your repository into the container’s home directory
COPY . ${HOME}

# Run the install.R script (if it exists) from the repository.
# Running as root allows package installations into /usr/local/lib/R/site-library.
RUN if [ -f ${HOME}/install.R ]; then \
      R --quiet -e 'source("/root/install.R")'; \
    fi

# Default command to launch an interactive R session
# CMD ["R"]
CMD ["jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]
