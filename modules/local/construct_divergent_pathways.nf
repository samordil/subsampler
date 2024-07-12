process CONSTRUCT_DIVERGENT_PATHWAYS {
    tag "construct divergent pathways"
    label 'process_high_cpu'
    
   // conda "${moduleDir}/environment.yml"
   //  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
   //     'https://depot.galaxyproject.org/singularity/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' :
   //     'biocontainers/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' }"

    input:
    path haplotype_sequences_txt
    path metadata_tsv

    output:
    path "divergent_pathways.csv"            , emit: divergent_pathways_csv

    script:
    """
   construct_divergent_pathways.py \
        --threads $task.cpus \
        --haplotypes $haplotype_sequences_txt \
        --metadata  $metadata_tsv \
        --output divergent_pathways.csv
    """
}