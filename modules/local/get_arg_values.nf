process GET_ARG_VALUES {
    tag "get arg values"
    label 'process_medium'
    
   // conda "${moduleDir}/environment.yml"
   //  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
   //     'https://depot.galaxyproject.org/singularity/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' :
   //     'biocontainers/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' }"

    input:
    path infos_tsv
    path reference_dir

    output:
    path "args"            , emit: arg_dir

    script:
    """
    get_arg_values.py \
        --infos $infos_tsv \
        --reference-dir $reference_dir \
        --output args
    """
}