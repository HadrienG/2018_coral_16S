#!/usr/bin/env nextflow

params.input = 'data/trimmed'
params.samples = 'data/samples.txt'

samples = file(params.samples)

process get_bioprojects {
    input:
        file samples

    output:
        stdout bioprojects

    script:
        """
        cut -d ',' -f 1 $samples | tail -n +2 | sort | uniq
        """
}

process get_accessions {
    container 'hadrieng/dada2'

    input:
        val bioproject from bioprojects.splitText() { it.trim() }
        file samples

    output:
        set val(bioproject), file("${bioproject}.csv") into metadatas

    script:
        """
        #!/usr/bin/env Rscript

        library(readr)
        library(dplyr)

        metadata <- read_csv('$samples')
        sample_names <- metadata %>%
            filter(project == '$bioproject') %>%
            write_csv('${bioproject}.csv')
        """
}

metadatas.println()
