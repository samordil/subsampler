process GET_NONSYNONYMOUS {
    tag "get nonsynonymous mutations"
    label 'process_high_cpu'
    
   // conda "${moduleDir}/environment.yml"
   //  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
   //     'https://depot.galaxyproject.org/singularity/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' :
   //     'biocontainers/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' }"

    input:
    path genome_csv
    path strains_txt
    path nextclade_tsv
    path metadata_tsv

    output:
    path 'nonsynonymous.txt'            , emit: nonsynonymous_txt

    script:
    """
    get_nonsynonymous.py \
        --genome $genome_csv \
        --strains $strains_txt \
        --nextclade-tsv $nextclade_tsv \
        --metadata  $metadata_tsv \
        --output nonsynonymous.txt
    """
}