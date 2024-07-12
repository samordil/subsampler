process SUBSAMPLING {
    tag "subsampling"
    label 'process_high'

    // conda "${moduleDir}/environment.yml"
   //  container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
   //     'https://depot.galaxyproject.org/singularity/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' :
   //     'biocontainers/mulled-v2-36d7254367b6ad6a1b47fbbca41b9e60238df0ac:e01e41d46acce1c1c39cbaa37fbd8a7453695ff3-0' }"
    
    input:
    path infos_tsv
    path haplotype_sequences_txt
    path divergent_pathways_csv
    val description
    val location
    val date_start
    val date_end
    val sample_size
    val characteristic
    val seed
    val temporally_even

    output:
    path "strain_${seed}_${sample_size}.txt"            , emit: subsampled_strain_id_txt
    path "log_${seed}_${sample_size}.txt"               , emit: log

    script:
    def temporally_even_option = temporally_even ? '--temporally-even' : ""

    """
    ncov_sampling.py \
        --infos $infos_tsv \
        --haplotypes $haplotype_sequences_txt \
        --divergent-pathways $divergent_pathways_csv \
        --description "$description" \
        --location $location \
        --date-start $date_start \
        --date-end $date_end \
        --size $sample_size \
        --characteristic $characteristic \
        --seed $seed \
        $temporally_even_option \
        --output subsample_${seed}_${sample_size}.txt
    
    # Separate the strain ids from the log
    subsampling_processor.py \
        --input subsample_${seed}_${sample_size}.txt \
        --log log_${seed}_${sample_size}.txt \
        --id strain_${seed}_${sample_size}.txt
    """
}