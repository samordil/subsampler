process CONSTRUCT_HAPLOTYPES {
    tag "construct haplotype sequences"
    label 'process_medium'
    
   // conda "${moduleDir}/environment.yml"
   //  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
   //     'https://depot.galaxyproject.org/singularity/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' :
   //     'biocontainers/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' }"

    input:
    path strains_txt
    path nextclade_tsv
    path key_sites

    output:
    path 'haplotype_sequences.txt'            , emit: haplotype_sequences_txt

    script:
    """
    construct_haplotype_sequences.py \
        --strains $strains_txt \
        --nextclade-tsv $nextclade_tsv \
        --sites $key_sites \
        --output haplotype_sequences.txt
    """
}