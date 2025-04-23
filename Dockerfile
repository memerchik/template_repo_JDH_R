# syntax=docker/dockerfile:1
###############################################################################
# 1. Start from a Binder-ready base image that already knows how to run Jupyter
###############################################################################
FROM jupyter/r-notebook:lab-4.3.3

###############################################################################
# 2. Install the extra R packages your notebook needs
###############################################################################
USER root                     # root rights are required for system-wide install
COPY install.R /tmp/install.R
RUN --mount=type=cache,target=/var/cache/apt \
    Rscript /tmp/install.R && rm /tmp/install.R
# └─ install.R only installs packages such as ggplot2 – IRkernel is **already**
#    present and its spec pre-registered in the base image, so the extra
#    IRkernel::installspec() line in your file can be deleted. :contentReference[oaicite:0]{index=0}&#8203;:contentReference[oaicite:1]{index=1}

###############################################################################
# 3. Hand control back to the parent image’s default user & start command
###############################################################################
USER ${NB_UID}                
CMD ["start.sh"]              
#            ↑ The parent image provides start.sh, which in turn executes the
#              health-checked jupyterhub-singleuser entry-point Binder needs
