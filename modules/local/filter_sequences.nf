process FILTER_SEQUENCES {
    tag "filter sequences"
    label 'process_single'
    
   // conda "${moduleDir}/environment.yml"
   //  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
   //     'https://depot.galaxyproject.org/singularity/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' :
   //     'biocontainers/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' }"

    input:
    path metadata_tsv
    path nextclade_tsv

    output:
    path 'strains.txt'            , emit: strains_txt

    script:
    """
    filter_sequences.py \
        --metadata $metadata_tsv \
        --nextclade-tsv $nextclade_tsv \
        --output strains.txt
    """
}