# syntax=docker/dockerfile:1
FROM jupyter/r-notebook:x86_64-r-4.3.1

COPY install.R /tmp/install.R
RUN Rscript -e "options(repos = c(CRAN='https://cloud.r-project.org')); \
                source('/tmp/install.R')"

CMD ["jupyter", "lab", \
     "--ip=0.0.0.0", "--port=8888", "--no-browser", \
     "--LabApp.default_url=/lab/tree/author_guideline_template.ipynb"]