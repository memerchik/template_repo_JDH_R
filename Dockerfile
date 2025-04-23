
FROM jupyter/r-notebook:x86_64-r-4.3.1

WORKDIR /home/jovyan/work

###############################################################################
# 3. Copy your entire repo (including author_guideline_template.ipynb & install.R)
###############################################################################
COPY . .
# install.R must live at the repo root; it’ll now be in /home/jovyan/work/install.R
RUN Rscript -e "options(repos = c(CRAN='https://cloud.r-project.org')); \
               source('install.R')"

CMD ["start.sh"]
