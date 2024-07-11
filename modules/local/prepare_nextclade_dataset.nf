process NEXCLADE_DATASET {
    tag "generate nextclade data"
    label 'process_medium'

   // conda "${moduleDir}/environment.yml"
   //  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
   //     'https://depot.galaxyproject.org/singularity/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' :
   //     'biocontainers/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' }"

    input:
    val filename
    val nextclade_dir 

    output:
    path "$nextclade_dir"            , emit: nextclade_dataset

    script:
    """
    nextclade dataset get --name $filename --output-dir $nextclade_dir
    """
}