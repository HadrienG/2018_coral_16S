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
    publishDir = params.output

    input:
        file read from reads

    output:
        file '*.fastq' into fastq

    script:
        """
        bionode-sra fastq-dump $read
        """
}
