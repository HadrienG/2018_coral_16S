# Coral 16S reanalysis

[![Build Status](https://travis-ci.org/HadrienG/2018_coral_16S.svg?branch=master)](https://travis-ci.org/HadrienG/2018_coral_16S)

## Introduction

This repository aims at reanalysing available 16S data from coral reefs and their surrounding environment.

In particular we are interested in papers who claim to investigate the core microbiome of various coral reef species.

## Data

The data from the following papers will hopefully be used

| Paper (doi)                   | Accession   | N samples | metadata |
| :---------------------------- | :---------- | :---------| :--------|
| 10.1038/ismej.2015.39         | PRJNA233450 | 71*       | [#6](https://github.com/HadrienG/2018_coral_16S/issues/6)       |
| 10.1128/mBio.00560-16         | PRJNA328211 | 1\**      | ❎ ([#2](https://github.com/HadrienG/2018_coral_16S/issues/2))       |
| 10.3390/microorganisms4030023 | PRJNA313050 | 26        | ✅       |
| 10.3389/fmicb.2016.00458      | PRJNA296835 | 23        | ✅       |
| 10.1038/srep27277             | PRJNA312472 | 28        | ✅       |
| 10.1111/1758-2229.12412       | PRJNA295144 | 2\**      | ❎ ([#3](https://github.com/HadrienG/2018_coral_16S/issues/3))       |
| 10.1128/AEM.00695-13          | PRJNA189184 | 5         | ✅       |
| 10.1038/ismej.2016.9          | PRJNA310360 | 120\***   | ✅       |
| 10.1111/mec.13251             | PRJNA277291 | 54        | ✅       |
| 10.3354/meps10197             | SRP010998   | 12        | ✅       |
| 10.1111/mec.13567             | PRJNA282461 | 41        | ❎ [#5](https://github.com/HadrienG/2018_coral_16S/issues/5)       |
| 10.1038/srep07320             | SRR1263017  | 2\**      | ❎ ([#4](https://github.com/HadrienG/2018_coral_16S/issues/4))       |
| 10.1038/srep45362             | PRJNA352338 | 55        | ✅       |
| 10.1371/journal.pone.0067745  | PRJNA192455 | 10        | ✅       |
| 10.1111/1462-2920.13840       | PRJNA302254 | 3         | ❎ [#7](https://github.com/HadrienG/2018_coral_16S/issues/7)       |
| 10.7717/peerj.2529            | PRJNA297333 | 5         | ✅       |
| 10.1007/s00248-016-0858-x     | PRJNA312774 | 60        | ✅       |
| 10.1371/journal.pone.0100316  | PRJNA231864 | 34        | ✅       |
| 10.1371/journal.pone.0076095  | PRJNA193567 | 16        | ✅       |

\* no data available in the bioprojects yet, has been the object of an enquiry.  
\*\* Data without sufficient metadata / with pooled samples will not be analysed.  
\*\*\* The samples that were disturbed with antibiotics will not be considered for reanalysis.

See `data/samples.txt` for more information

*Don't see your dataset / article in the list? Open an issue and I'll be more than happy to use it!*

## Setup

To run the code, you'll need [nextflow](https://www.nextflow.io/) and [docker](https://www.docker.com/community-edition) installed.

### Download the data

```bash
nextflow run download.nf
```

which will download the data into the `data` directory,

The data consists of compressed fastq files and is approximately 2 Gb.
You'll need 4Gb of storage for downloading (due the the nextflow temp files that we keep in case we want to resume an interrupted download)

You can remove the temporary files with

```bash
make clean
```

### Download the SILVA database

The following command will download the necessary files to use the SILVA database with dada2

```bash
make db
```

This will create a `db` directory

## Run the pipeline

*WORK IN PROGRESS*

### Data QC and Adapter trimming

```bash
nextflow run qc.nf
gzip data/trimmed/*.fastq
```

You'll need the same storage space as for downloading the data.
Once again you can cleanup the temporary with `make clean`

### Run DADA2

```bash
nextflow run dada.nf
```

### Data visualisation

*wip*

see `analysis.Rmd`
