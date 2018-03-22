#!/usr/bin/env nextflow

params.input = 'data/trimmed'
params.samples = 'data/samples.txt'
params.db = 'db/'
params.output = 'results'

samples = file(params.samples)
input_dir = file(params.input)
database_dir = file(params.db)

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

process dada2 {
    container 'hadrieng/dada2'
    publishDir params.output, mode: 'copy'
    cpus 2

    input:
        set val(bioproject), file(metadata) from metadatas
        file input_dir
        file database_dir

    output:
        file("*_${bioproject}.RData") into dadas

    script:
        """
        #!/usr/bin/env Rscript

        library(readr)
        library(dplyr)
        library(dada2)

        path <- '$input_dir'
        metadata <- read_csv('$metadata')

        if ( metadata\$technology == '454' ) {
            reads <- as_tibble(sort(list.files(path,
                               pattern = ".fastq.gz",
                               full.names = TRUE)))
            colnames(reads) <- c('path')

            reads\$run <- sapply(strsplit(basename(reads\$path),
                                          ".",
                                          fixed = TRUE), `[`, 1)
            samples <- reads %>% inner_join(metadata, by = 'run')

            errors <- learnErrors(samples\$path, multithread = TRUE)
            dereps <- derepFastq(samples\$path)
            names(dereps) <- samples\$run

            dada <- dada(dereps, err = errors, HOMOPOLYMER_GAP_PENALTY = -1,
                         BAND_SIZE = 32, multithread = TRUE)
        } else {
            forward <- as_tibble(sort(list.files(path,
                                 pattern = "_R1.fastq.gz",
                                 full.names = TRUE)))
            reverse <- as_tibble(sort(list.files(path,
                                 pattern = "_R2.fastq.gz",
                                 full.names = TRUE)))
            colnames(forward) <- c('r1')
            colnames(reverse) <- c('r2')
            forward\$run <- sapply(strsplit(basename(forward\$r1),
                                          "_",
                                          fixed = TRUE), `[`, 1)
            reverse\$run <- sapply(strsplit(basename(reverse\$r2),
                                        "_",
                                        fixed = TRUE), `[`, 1)
            samples <- forward %>%
                inner_join(reverse, by = 'run') %>%
                inner_join(metadata, by = 'run')

            errors_f <- learnErrors(samples\$r1, multithread = TRUE)
            errors_r <- learnErrors(samples\$r2, multithread = TRUE)

            dereps_f <- derepFastq(samples\$r1)
            dereps_r <- derepFastq(samples\$r2)
            names(dereps_f) <- samples\$run
            names(dereps_r) <- samples\$run

            dada_f <- dada(dereps_f, err = errors_f, multithread = TRUE)
            dada_r <- dada(dereps_r, err = errors_r, multithread = TRUE)

            dada <- mergePairs(dada_f, dereps_f, dada_r, dereps_r)
        }

        seqtab <- makeSequenceTable(dada)
        seqtab_$bioproject <- removeBimeraDenovo(seqtab, method = "consensus",
                                            multithread = TRUE, verbose = TRUE)

        taxa_$bioproject <- assignTaxonomy(seqtab_$bioproject,
                                           "$database_dir/silva_nr_v132_train_set.fa.gz",
                                           multithread = TRUE)
        taxa_$bioproject <- addSpecies(taxa_$bioproject,
                                       "$database_dir/silva_species_assignment_v132.fa.gz")

       save(seqtab_$bioproject, file = "seqtab_${bioproject}.RData")
       save(taxa_$bioproject, file = "taxa_${bioproject}.RData")
        """
}
