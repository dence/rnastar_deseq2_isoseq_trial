#Daniel Ence
#oct. 8, 2020

rule samtools_index:
	input:
		"results/star/{sample}-{unit}.Aligned.sortedByCoord.out.bam"
	output:
		"results/star/{sample}-{unit}.Aligned.sortedByCoord.out.bam.bai"
	log:
		"logs/star.{sample}-{unit}.log"
	shell:
		"unset TMPDIR; module load samtools; samtools index {input}"
