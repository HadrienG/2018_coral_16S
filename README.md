# Coral 16S reanalysis

## Introduction

This repository aims at reanalysing available 16S data from coral reefs and their surrounding environment.

In particular we are interested in papers who claim to investigate the core microbiome of various coral reef species.

## Data

The data from the following papers will hopefully  be used

| Paper (doi)                   | Accession   | N samples | metadata |
| :---------------------------- | :---------- | :---------| :--------|
| 10.1038/ismej.2015.39         | PRJNA233450 | 71*       | #6       |
| 10.1128/mBio.00560-16         | PRJNA328211 | 1\**      | #2       |
| 10.3390/microorganisms4030023 | PRJNA313050 | 26        | ✅       |
| 10.3389/fmicb.2016.00458      | PRJNA296835 | 23        | ✅       |
| 10.1038/srep27277             | PRJNA312472 | 28        | ✅       |
| 10.1111/1758-2229.12412       | PRJNA295144 | 2\**      | #3       |
| 10.1128/AEM.00695-13          | PRJNA189184 | 5         | ✅       |
| 10.1038/ismej.2016.9          | PRJNA310360 | 120\***   | ✅       |
| 10.1111/mec.13251             | PRJNA277291 | 54        | ✅       |
| 10.3354/meps10197             | SRP010998   | 12        | ✅       |
| 10.1111/mec.13567             | PRJNA282461 | 41        | #5       |
| 10.1038/srep07320             | SRR1263017  | 2\**      | #4       |
| 10.1038/srep45362             | PRJNA352338 | 55        | ✅       |
| 10.1371/journal.pone.0067745  | PRJNA192455 | 10        | ✅       |
| 10.3354/dao069079             |             |           |          |
| 10.1371/journal.pone.0050130  |             |           |          |
| 10.1111/1462-2920.12366       |             |           |          |
| 10.1111/1462-2920.13840       |             |           |          |
| 10.1371/journal.pone.0143790  |             |           |          |
| 10.7717/peerj.2529            |             |           |          |
| 10.1139/cjm-2016-0100         |             |           |          |
| 10.3389/fmicb.2015.01094      |             |           |          |
| 10.1128/AEM.07764-11          |             |           |          |
| 10.1038/ismej.2011.144        |             |           |          |
| 10.1155/2012/746720           |             |           |          |
| 10.1007/s11274-006-9315-1     |             |           |          |
| 10.1007/s00248-016-0858-x     |             |           |          |
| 10.1371/journal.pone.0100316  |             |           |          |
| 10.1371/journal.pone.0076095  |             |           |          |
| 10.1111/mec.12392             |             |           |          |

\* Samples marked with an asterisk have no data available in the bioprojects (yet?)  
\*\* Data without sufficient metadata / with pooled samples will not be analysed.  
\*\*\* The samples that were disturbed with antibiotics will not be considered for reanalysis

See `data/samples.txt` for more information

## Setup

To run the code, you'll need [nextflow](https://www.nextflow.io/) installed.

### Download the data

```bash
nextflow download.nf
```

### Run the pipeline

see `dada2.Rmd`
