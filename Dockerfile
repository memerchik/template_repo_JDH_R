# Use the official R 4.4.3 image as the base image
FROM rocker/r-ver:4.4.3

# Set build arguments (with defaults) and define home directory
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV HOME=/home/${NB_USER}

# Define a user-level R library path
ENV R_LIBS_USER=${HOME}/R/x86_64-pc-linux-gnu-library/4.4.3

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

# Create a .Renviron file to ensure R consistently sees R_LIBS_USER
RUN echo "R_LIBS_USER=${R_LIBS_USER}" > ${HOME}/.Renviron && \
    chown ${NB_USER} ${HOME}/.Renviron

# Copy the entire repository to the HOME directory in the container
COPY . ${HOME}

# Change ownership of the copied files to NB_USER
RUN chown -R ${NB_USER} ${HOME}

# Switch to the non-root user for the remainder of the build
USER ${NB_USER}

# Run the install.R script if it exists; with .Renviron in place,
# R sessions (even non-interactive ones) should now use the user library.
RUN if [ -f ${HOME}/install.R ]; then R --quiet -f ${HOME}/install.R; fi

# Default command: launch an interactive R session.
CMD ["R"]
