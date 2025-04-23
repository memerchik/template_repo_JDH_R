# syntax=docker/dockerfile:1
FROM jupyter/r-notebook:x86_64-r-4.3.1

COPY install.R /tmp/install.R
RUN Rscript -e "options(repos = c(CRAN='https://cloud.r-project.org')); \
                source('/tmp/install.R')"

CMD ["start.sh"]
