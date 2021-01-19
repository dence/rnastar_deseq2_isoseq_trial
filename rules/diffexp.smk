def get_strandness(units):
	if "strandedness" in units.columns:
		return units["strandedness"].tolist()
	else:
		strand_list=["none"]
		return strand_list*units.shape[0]

rule count_matrix:
	input:
		bams=expand("results/star/{unit.sample}-{unit.unit}.Aligned.sortedByCoord.out.bam", unit=units.itertuples()),
		bai=expand("results/star/{unit.sample}-{unit.unit}.Aligned.sortedByCoord.out.bam.bai", unit=units.itertuples())
	output:
		"results/counts/all.tsv"
	params:
		samples=units["sample"].tolist(),
		ref=config["ref"]["index"]
	conda:
		"../envs/pandas.yaml"
	script:
		"../scripts/count-matrix-bams.py"


def get_deseq2_threads(wildcards=None):
	# https://twitter.com/mikelove/status/918770188568363008
	few_coeffs = False if wildcards is None else len(get_contrast(wildcards)) < 10
	return 1 if len(samples) < 100 or few_coeffs else 6


rule deseq2_init:
	input:
		counts="results/counts/all.tsv"
	output:
		"results/deseq2/all.rds"
	params:
		samples=config["samples"]
	conda:
		"../envs/deseq2.yaml"
	log:
		"logs/deseq2/init.log"
	threads: get_deseq2_threads()
	#script:
	#	"../scripts/deseq2-init.R"
	shell:
		"""
		module load R;
		Rscript ../scripts/deseq2-init.R {input.counts} {output} {params.samples} {log} {threads}
		"""

rule pca:
	input:
		"results/deseq2/all.rds"
	output:
		report("results/pca.svg", "../report/pca.rst")
	params:
		pca_labels=config["pca"]["labels"]
	conda:
		"../envs/deseq2.yaml"
	log:
		"logs/pca.log"
	script:
		"../scripts/plot-pca.R"

def get_contrast(wildcards):
	return config["diffexp"]["contrasts"][wildcards.contrast]

rule deseq2:
	input:
		"results/deseq2/all.rds"
	output:
		table=report("results/diffexp/{contrast}.diffexp.tsv", "../report/diffexp.rst"),
		ma_plot=report("results/diffexp/{contrast}.ma-plot.svg", "../report/ma.rst"),
	params:
		contrast=get_contrast
	conda:
		"../envs/deseq2.yaml"
	log:
		"logs/deseq2/{contrast}.diffexp.log"
	threads: get_deseq2_threads
	script:
		"../scripts/deseq2.R"
