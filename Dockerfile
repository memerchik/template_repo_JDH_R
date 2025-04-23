# syntax=docker/dockerfile:1
###############################################################################
# 1. Base image: ships Jupyter, R, IRkernel & start.sh
###############################################################################
FROM jupyter/r-notebook:x86_64-r-4.3.1

###############################################################################
# 2. Install your extra R packages as jovyan (no root needed), 
#    with a CRAN mirror set so install.packages() works non-interactively
###############################################################################
COPY install.R /tmp/install.R
RUN Rscript -e "options(repos = c(CRAN='https://cloud.r-project.org')); source('/tmp/install.R')" \
    && rm /tmp/install.R

###############################################################################
# 3. Let the parent image handle launch
###############################################################################
CMD ["start.sh"]
