#!/usr/bin/env nextflow

params.samples = 'data/samples.txt'
params.output = 'data'

samples = file params.samples

process parse {
    input:
        file samples

    output:
        stdout accessions

    script:
        """
        cut -d ',' -f 2 $samples | tail -n +2
        """
}

accessions = accessions.splitText()

process dump {
    tag {acc.trim()}
    container 'hadrieng/sratoolkit'
    publishDir params.output, mode: 'copy'

    input:
        val acc from accessions

    output:
        file '*.fastq.gz' into fastq

    script:
        """
        fastq-dump --gzip --skip-technical --split-files -I $acc
        """
}
