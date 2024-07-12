process SUBSAMPLING {
    tag "subsampling"
    label 'process_high'
    
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
    path "subsample_${seed}_${sample_size}.txt"            , emit: sampled_txt

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
    """
}