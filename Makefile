clean:
	rm -rf work/
	rm -rf .nextflow.log*
	cd test && rm -rf work && rm -rf .nextflow.log* && rm -rf results

db:
	mkdir -p db
	cd db; \
	wget -N https://zenodo.org/record/1172783/files/silva_nr_v132_train_set.fa.gz; \
	wget -N https://zenodo.org/record/1172783/files/silva_species_assignment_v132.fa.gz
