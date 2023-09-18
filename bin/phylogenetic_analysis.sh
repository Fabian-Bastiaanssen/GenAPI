#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

NAME=$1
output=$2
input=$3
threads=$4
mkdir -p ${output}/output_results/phylogenetic_analysis
rm -f ${output}/output_results/phylogenetic_analysis/*.${NAME}

while read file
do
	echo ${file}
	if [[ ${#file} -gt 0 ]]
		then 
		filename=$(basename ${file}) 
		cat ${input}/tmp_column_${filename}.txt | awk 'NR==1{print}NR>1{sub(/\n/,"");printf("%s",$0);}' | sed '1s/^/>/' | sed '${s/$/\n/}' > ${input}/fasta_${filename}
		fi

done < ${output}/output_results/sample_list.txt

cat ${input}/fasta_* > ${input}/${NAME}_binary_alignments.fasta

raxmlHPC -n ${NAME} -s ${input}/${NAME}_binary_alignments.fasta -m BINCAT -p 12345 

if [ `ls -1 *.${NAME} 2>/dev/null | wc -l ` -gt 0  ]
then
	mv *.${NAME} ${output}/output_results/phylogenetic_analysis/ 
else
	rm -rf ${output}/output_results/phylogenetic_analysis
	bash ${SCRIPT_DIR}/remove_temp.sh	
fi

