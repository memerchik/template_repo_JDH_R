
FROM jupyter/r-notebook:x86_64-r-4.3.1

COPY . /home/jovyan/work
# install.R must live at the repo root; it’ll now be in /home/jovyan/work/install.R
RUN Rscript -e "options(repos = c(CRAN='https://cloud.r-project.org')); \
               source('install.R')"

CMD ["start.sh"]
