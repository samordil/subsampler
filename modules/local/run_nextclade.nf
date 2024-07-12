process NEXCLADE_RUN {
    tag "run nextclade"
    label 'process_high_cpu'

   // conda "${moduleDir}/environment.yml"
   //  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
   //     'https://depot.galaxyproject.org/singularity/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' :
   //     'biocontainers/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' }"

    input:
    path fasta_sequences
    path nextclade_dataset
    val min_length

    output:
    path 'nextclade.tsv'            , emit: nextclade_tsv

    script:
    """
    nextclade run \
        $fasta_sequences \
        --jobs $task.cpus \
        --input-dataset $nextclade_dataset \
        --min-length $min_length \
        --output-tsv nextclade.tsv \
        --quiet
    """
}