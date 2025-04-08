## Use a tag instead of "latest" for reproducibility
FROM rocker/binder:3.6.3

## Declare build arguments with defaults (if not provided during build)
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV HOME=/home/${NB_USER}

## Switch to root user to perform installations and configuration
USER root
RUN apt-get update && apt-get -y install libgsl-dev

## Create the NB_USER if it doesn't exist
RUN id -u ${NB_USER} || useradd -m -u ${NB_UID} ${NB_USER}

## Copy your repository files into the Docker container
COPY . ${HOME}
## Optional: To override with files from the binder subdirectory, uncomment:
## COPY binder ${HOME}
RUN chown -R ${NB_USER} ${HOME}

## Switch back to the normal user
USER ${NB_USER}

## Run an install.R script, if it exists.
RUN if [ -f ${HOME}/install.R ]; then R --quiet -f ${HOME}/install.R; fi
