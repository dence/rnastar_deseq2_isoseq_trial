#Daniel ence
#December 21, 2020


rule get_aligned_report:
	input:
		expand("results/star/{sample}-{unit}.Log.final.out",sample=units["sample"],unit=units["unit"])
	output:
		"results/reports/star_percent_aligned_report.txt"
	params:
		samples=samples["sample"].tolist()
	script:
		"../scripts/percent_aligned_report.py"
