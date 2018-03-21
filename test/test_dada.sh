#!/usr/bin/env bash

nextflow run ../dada.nf --samples test_samples.txt --input test_trimmed \
    --output test_results --db ../db
