# syntax=docker/dockerfile:1
###############################################################################
# 1. Base image: ships Jupyter, R, IRkernel & start.sh
###############################################################################
FROM jupyter/r-notebook:x86_64-r-4.3.1

###############################################################################
# 2. Install your extra R packages as jovyan (no root needed)
###############################################################################
COPY install.R /tmp/install.R
RUN Rscript /tmp/install.R && rm /tmp/install.R
# install.R need only install your packages (e.g. ggplot2) – IRkernel is pre-registered :contentReference[oaicite:0]{index=0}&#8203;:contentReference[oaicite:1]{index=1}

###############################################################################
# 3. Let the parent image handle launch
###############################################################################
CMD ["start.sh"]
