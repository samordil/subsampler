process FILTER_META_N_FASTA {
    tag "subsetting metadata and fasta sequences"
    label 'process_medium'
    
   // conda "${moduleDir}/environment.yml"
   //  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
   //     'https://depot.galaxyproject.org/singularity/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' :
   //     'biocontainers/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' }"

    input:
    path strain_id_txt
    path sequences_fasta
    path metadata_tsv
    val seed
    val sample_size
    
    output:
    path "subsampled_${seed}_n${sample_size}.tsv"              , emit: meta_tsv
    path "subsampled_${seed}_n${sample_size}.fasta"            , emit: seq_fasta

    script:
    """
    filter_metadata_and_sequences.py \
        --metadata $metadata_tsv \
        --sequences $sequences_fasta \
        --strain_ids $strain_id_txt \
        --output_metadata subsampled_${seed}_n${sample_size}.tsv \
        --output_sequences subsampled_${seed}_n${sample_size}.fasta
    """
}