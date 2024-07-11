process GET_INFOS {
    tag "construct divergent pathways"
    label 'process_medium'
    
   // conda "${moduleDir}/environment.yml"
   //  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
   //     'https://depot.galaxyproject.org/singularity/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' :
   //     'biocontainers/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' }"

    input:
    path divergent_pathways_csv
    path metadata_tsv
    path nextclade_tsv

    output:
    path "infos.tsv"            , emit: infos_tsv

    script:
    """
   get_infos.py \
        --divergent-pathways $divergent_pathways_csv \
        --metadata  $metadata_tsv \
        --nextclade-tsv $nextclade_tsv \
        --output infos.tsv
    """
}