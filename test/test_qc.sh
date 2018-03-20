#!/usr/bin/env bash

nextflow run ../qc.nf --input test_data/ --output test_trimmed/ --adapters ../data/adapters.fasta
