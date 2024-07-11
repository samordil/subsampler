process GET_KEY_SITES {
    tag "get key sites"
    label 'process_medium'
    
   // conda "${moduleDir}/environment.yml"
   //  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
   //     'https://depot.galaxyproject.org/singularity/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' :
   //     'biocontainers/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' }"

    input:
    path strains_txt
    path nonsynonymous_txt
    path metadata_tsv

    output:
    path 'key_sites.txt'            , emit: key_sites_txt

    script:
    """
    get_key_sites.py \
        --strains $strains_txt \
        --nonsynonymous $nonsynonymous_txt \
        --metadata  $metadata_tsv \
        --output key_sites.txt
    """
}