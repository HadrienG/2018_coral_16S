#!/usr/bin/env nextflow

params.input = "data/"
params.output = 'data/trimmed'
params.adapters = 'data/adapters.fasta'

adapters = file(params.adapters)

reads_atropos_se = Channel
    .fromFilePairs(params.input + '*_{1,2,3}.fastq.gz', size: -1)

reads_atropos_pe = Channel
    .fromFilePairs(params.input + '*_{1,2,3}.fastq.gz', size: 2, flat: true)

process trimming_se {
    container 'jdidion/atropos'
    publishDir params.output, mode: 'copy'

    input:
        set val(id), file(reads) from reads_atropos_se
        file adapters

    when:
        reads instanceof Path

    output:
        file "trimmed_*" into trimmed_reads_se



    script:
        """
        mkdir trimmed
        atropos -b file:$adapters -T 4 -m 50 --max-n 0 -q 10,10 \
            -se $reads -o trimmed_$reads
        """
}

process trimming_pe {
    container 'jdidion/atropos'
    publishDir params.output, mode: 'copy'

    input:
        set val(id), file(read1), file(read2) from reads_atropos_pe
        file adapters

    output:
        file "trimmed_*" into trimmed_reads_pe

    script:
        """
        mkdir trimmed
        atropos -b file:$adapters -B file:$adapters -T 4 -m 50 --max-n 0 \
            -q 10,10 -pe1 $read1 -pe2 $read2 \
            -o trimmed_$read1 -p trimmed_$read2
        """
}

reads_multiqc = Channel
    .fromPath(params.output + '*.fastq.gz')

process fastqc {
    container 'hadrieng/fastqc'

    input:
        file reads from reads_multiqc

    output:
        file "*_fastqc.{zip,html}" into fastqc_results

    script:
        """
        mkdir fastqc
        fastqc $reads
        """
}

process multiqc {
    container 'ewels/multiqc'
    publishDir 'results', mode: 'copy'

    input:
        file 'fastqc/*' from fastqc_results.collect()

    output:
        file 'multiqc_report.html'

    script:
        """
        multiqc .
        """
}
