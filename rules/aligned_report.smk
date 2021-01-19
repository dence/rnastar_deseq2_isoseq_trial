#Daniel ence
#December 21, 2020


rule get_aligned_report:
	input:
		"results/star/{sample}-{unit}}.Log.final.out"
	output:
		"results/reports/star_percent_aligned_report.txt"
	script:
		"../scripts/percent_aligned_report.py"
