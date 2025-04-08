# Use the official R 4.4.3 image as the base image
FROM rocker/r-ver:4.4.3

# Set build arguments (with defaults) and define home directory
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV HOME=/home/${NB_USER}

# Switch to root to install system dependencies
USER root

# Update package lists, install libgsl-dev, and clean up apt caches
RUN apt-get update && \
    apt-get install -y --no-install-recommends libgsl-dev && \
    rm -rf /var/lib/apt/lists/*

# Create NB_USER if it doesn’t already exist
RUN id -u ${NB_USER} || \
    useradd -m -u ${NB_UID} ${NB_USER}

# Copy the entire repository to the HOME directory in the container
COPY . ${HOME}

# Change ownership of the copied files to NB_USER
RUN chown -R ${NB_USER} ${HOME}

# Switch back to the non-root user for security and consistency
USER ${NB_USER}

# Run the install.R script if it exists to install R package dependencies
RUN if [ -f ${HOME}/install.R ]; then R --quiet -f ${HOME}/install.R; fi

# For a Binder environment that uses R (via IRkernel), the entrypoint is set by repo2docker.
# If you need to customize the startup command, you might add or override CMD here.
# For example, to start an interactive R session you can use:
CMD ["R"]
