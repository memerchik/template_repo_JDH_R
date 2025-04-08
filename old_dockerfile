# Use the official R 4.4.3 image as the base image
FROM rocker/r-ver:4.4.3

# Set build arguments (with defaults) and define home directory
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV HOME=/home/${NB_USER}

# Define a user-level R library path and also set R_LIBS so R uses it by default
ENV R_LIBS_USER=${HOME}/R/x86_64-pc-linux-gnu-library/4.4.3
ENV R_LIBS=${R_LIBS_USER}

# Switch to root to install system dependencies
USER root

# Update package lists, install libgsl-dev, and clean up apt caches
RUN apt-get update && \
    apt-get install -y --no-install-recommends libgsl-dev && \
    rm -rf /var/lib/apt/lists/*

# Create NB_USER if it doesn't already exist
RUN id -u ${NB_USER} || useradd -m -u ${NB_UID} ${NB_USER}

# Create the user-level R library directory and adjust its permissions
RUN mkdir -p ${R_LIBS_USER} && chown -R ${NB_USER} ${R_LIBS_USER}

# Create a .Renviron file in NB_USER's home to specify R_LIBS_USER
RUN echo "R_LIBS_USER=${R_LIBS_USER}" > ${HOME}/.Renviron && \
    chown ${NB_USER} ${HOME}/.Renviron

# Copy the entire repository to the home directory in the container
COPY . ${HOME}

# Change ownership of the copied files to NB_USER
RUN chown -R ${NB_USER} ${HOME}

# Switch to the non-root user for the remaining steps
USER ${NB_USER}

# Run the install.R script after resetting R's library paths.
# This command uses file.path() and Sys.getenv() to locate install.R.
RUN if [ -f ${HOME}/install.R ]; then \
      R --quiet -e ".libPaths(Sys.getenv('R_LIBS_USER')); source(file.path(Sys.getenv('HOME'),'install.R'))"; \
    fi

# Default command: launch an interactive R session.
CMD ["R"]
