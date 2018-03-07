#!/usr/bin/env nextflow

samples = file 'data/samples.txt'

process parse {
    input:
        file samples

    output:
        stdout accessions

    script:
        """
        cut -d ',' -f 1 $samples | tail -n +2
        """
}

accessions = accessions.splitText()

process download {
    container 'hadrieng/bionode'

    input:
        val acc from accessions

    output:
        file '**/*.sra' into reads

    script:
        """
        bionode-ncbi download sra $acc
        """
}

process dump {
    container 'hadrieng/bionode'
    publishDir = 'data'

    input:
        file read from reads

    output:
        file '*.fastq' into fastq

    script:
        """
        bionode-sra fastq-dump $read
        """
}
