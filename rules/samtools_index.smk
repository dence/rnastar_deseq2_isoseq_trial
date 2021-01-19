#Daniel Ence
#oct. 8, 2020

rule samtools_index:
	input:
		"results/star/{sample}-{unit}.sortedByCoord.Aligned.out.bam"
	output:
		"results/star/{sample}-{unit}.sortedByCoord.Aligned.out.bam"
	log:
		"logs/star.{sample}-{unit}.log"
	shell:
		"unset TMPDIR; module load samtools; samtools index {input}"
