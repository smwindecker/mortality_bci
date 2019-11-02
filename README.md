# Partitioning mortality into growth-dependent and growth-independent hazards across 203 tropical tree species
*By:* James S Camac, Richard Condit, Richard G FitzJohn, Lachlan McCalman,
Daniel Steinberg, Mark Westoby, Joe Wright, Daniel Falster

*Maintainers:* James Camac and Daniel Falster

## Background

We present a model that partitions rates of tropical tree mortality into growth-dependent and growth-independent hazards. This creates the opportunity to examine the relative contributions of within-species and across-species variation on tropical tree mortality rates, but also, how species traits affect each hazard. We parameterize this model using >400,000 observed survival records collected over a 15-year period at Barro Colorado Island from more than 180,000 individuals across 203 species. We show that marginal carbon budgets are a major contributor to tree death on Barro Colorado Island. Moreover, we found that while species' light demand, maximum dbh and wood density affected tree mortality in different ways, they explained only a small fraction of the total variability observed among species.

This repository contains the data and code required to reproduce our entire workflow from data cleaning, rerunning the analysis, producing figures and reproducing the manuscript. Details below instructions on how this work can be reproduced.

## Dataset
This paper uses three datasets collected from  Barro Colorado Island (BCI) Panama. 

Condit, R., Lao, S., Pérez, R., Dolins, S.B., Foster, R.B. Hubbell, S.P. 2012. Barro Colorado Forest Census Plot Data, 2012 Version. DOI http://dx.doi.org/10.5479/data.bci.20130603

Hubbell, S.P, Comita, L., Lao, S. Condit, R. 2014. Barro Colorado Fifty Hectare Plot Census of Canopy Density, 1983-2012. DOI http://dx.doi.org/10.5479/data.bci20140711.

BCI Wood density data measured and collated by Joe Wright (included within this repository).

## Publication
Camac, J.S., Condit, R., FitzJohn, R.G., McCalman, L., Steinberg, D., Westoby, M., Wright, S.J., Falster, D. (2018) Partitioning mortality into growth-dependent and growth-independent hazards across 203 tropical tree species. 115 (49) 12459-12464. DOI https://doi.org/10.1073/pnas.1721040115

## Preprint
A preprint prior to submission to PNAS was released on [BioRxiv](https://doi.org/10.1101/228361). This preprint uses a subset of the models that were eventually published in PNAS. These can be found in the first release of this project.


## Running the code

All analyses were done in `R`, and the paper is written in LaTeX. All code needed to reproduce the submitted products is included in this repository. To reproduce this paper, run the code contained in the `analysis.R` file. The paper will be produced in the directory `ms`.

If you are reproducing this manuscript on your own machine, first download the code and then install the `tinytex` package. 

You can access an interactive RStudio session with the required software pre-installed by opening a container hosted by [Binder](http://mybinder.org): 

[![Launch Rstudio Binder](http://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/traitecoevo/mortality_bci/master?urlpath=rstudio)

To ensure long-term [computational reproducibility](https://www.britishecologicalsociety.org/wp-content/uploads/2017/12/guide-to-reproducible-code.pdf) of this work, we have created a [Docker](http://dockerhub.com) image to enable others to reproduce these results on their local machines using the same software and versions we used to conduct the original analysis. Instructions for reproducing this work using the docker image are available at the bottom of the page. 

## Material included in the repository include:

- `data/`: data used in analysis 
- `downloads/`: downloaded data used in analysis
- `scripts/`: example scripts to run analysis on various clusters
- `ms/`: directory containing manuscript in LaTeX and accompanying style files 
- `DESCRIPTION`: A machine-readable [compendium]() file containing key metadata and dependencies 
- `LICENSE`: License for the materials
- `Dockerfile` & `.binder/Dockerfile`: files used to generate docker containers for long-term reproducibility

## Running via Docker

If you have Docker installed, you can recreate the computing environment as follows in the terminal. 

From the directory you'd like this repo saved in, clone the repository:

```
git clone https://github.com/traitecoevo/mortality_bci.git
```

Then fetch the container:

```
docker pull traitecoevo/mortality_bci
```

Navigate to the downloaded repo, then launch the container using the following code (it will map your current working directory inside the docker container): 

```
docker run --user root -v $(pwd):/home/rstudio/ -p 8787:8787 -e DISABLE_AUTH=true traitecoevo/mortality_bci
```

The code above initialises a docker container, which runs an RStudio session accessed by pointing your browser to [localhost:8787](http://localhost:8787). For more instructions on running docker, see the info from [rocker](https://hub.docker.com/r/rocker/rstudio).

### NOTE: Building the docker image

For posterity, the docker image was built off [`rocker/verse:3.6.1` container](https://hub.docker.com/r/rocker/verse) via the following command, in a terminal contained within the downloaded repo:

```
docker build -t traitecoevo/mortality_bci .
```

and was then pushed to [dockerhub](https://cloud.docker.com/u/traitecoevo/repository/docker/traitecoevo/mortality_bci). The image used by binder builds off this container, adding extra features needed by binder, as described in [rocker/binder](https://hub.docker.com/r/rocker/binder/dockerfile).

## Problems?
If you have any problems getting the workflow to run please create an issue at our [github repository](https://github.com/traitecoevo/mortality_bci) and we will endevour to remedy it ASAP.
