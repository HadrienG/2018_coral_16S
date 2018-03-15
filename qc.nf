#!/usr/bin/env nextflow

params.input = "data/"
params.output = 'data/trimmed'

Channel
    .fromFilePairs( params.input + "*.fastq.gz", size: -1 )
    .ifEmpty { error "Cannot find any reads matching: ${params.reads}" }
    .set { read_files }


process qc {
    tag {acc.trim()}
    container 'jdidion/atropos'
    publishDir params.output, mode: 'copy'

    input:
        set val(name), file(reads) from read_files

    output:
        file 'trimmed/*.fastq.gz' into trimmed_reads

    script:
        def single = reads instanceof Path
        if( !single ) {
            """
            mkdir trimmed
            cd trimmed
            echo $reads
            atropos detect -pe1 reads_1 -pe2 reads_2
            atropos -m 50
            """
        }
        else {
            """
            mkdir trimmed
            atropos detect -se $reads -o adapters.fasta
            atropos -B adapters.fasta -m 50 -se $reads -o trimmed/$reads
            """
        }
}
