/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    VALIDATE INPUTS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
if (params.input_fasta)         { ch_input_fasta        = file(params.input_fasta)        } else { ch_input_fasta = []          }
if (params.input_metadata_tsv)  { ch_input_metadata_tsv = file(params.input_metadata_tsv) } else { ch_input_metadata_tsv = []   }
if (params.genome_csv)          { ch_genome_csv         = file(params.genome_csv)         } else { ch_ch_genome_csv = []        }

// Read directory
ref_dir       = file("${params.reference_dir}", type: 'dir' , maxdepth: 1)

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// MODULE: Loaded from modules/local/
//

include { NEXCLADE_DATASET                                       } from '../modules/local/prepare_nextclade_dataset'
include { NEXCLADE_RUN                                           } from '../modules/local/run_nextclade'
include { FILTER_SEQUENCES                                       } from '../modules/local/filter_sequences'
include { GET_NONSYNONYMOUS                                      } from '../modules/local/get_nonsynonymous'
include { GET_KEY_SITES                                          } from '../modules/local/get_key_sites'
include { CONSTRUCT_HAPLOTYPES                                   } from '../modules/local/construct_haplotype_sequences'
include { CONSTRUCT_DIVERGENT_PATHWAYS                           } from '../modules/local/construct_divergent_pathways'
include { GET_INFOS                                              } from '../modules/local/get_infos'
include { GET_ARG_VALUES                                         } from '../modules/local/get_arg_values'
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow SUB_SAMPLE {
    // MODULE: Generate nextclade dataset
    NEXCLADE_DATASET (
        params.name,
        params.output
    )

    // MODULE: run nextclade
    NEXCLADE_RUN (
        ch_input_fasta,
        NEXCLADE_DATASET.out.nextclade_dataset,
        params.min_length
    )

    // MODULE: Filter sequences
    FILTER_SEQUENCES (
        ch_input_metadata_tsv,
        NEXCLADE_RUN.out.nextclade_tsv
    )

    // MODULE: get nonsynonymous mutations
    GET_NONSYNONYMOUS (
        ch_genome_csv,
        FILTER_SEQUENCES.out.strains_txt,
        NEXCLADE_RUN.out.nextclade_tsv,
        ch_input_metadata_tsv
    )

    // MODULE: get key sitesß
    GET_KEY_SITES (
        FILTER_SEQUENCES.out.strains_txt,
        GET_NONSYNONYMOUS.out.nonsynonymous_txt,
        ch_input_metadata_tsv 
    )

    // MODULE: construct haplotype sequences
    CONSTRUCT_HAPLOTYPES (
        FILTER_SEQUENCES.out.strains_txt,
        NEXCLADE_RUN.out.nextclade_tsv,
        GET_KEY_SITES.out.key_sites_txt
    )

    // MODULE: construct divergent pathways
    CONSTRUCT_DIVERGENT_PATHWAYS (
        CONSTRUCT_HAPLOTYPES.out.haplotype_sequences_txt,
        ch_input_metadata_tsv
    )

    // MODULE: get information
    GET_INFOS (
        CONSTRUCT_DIVERGENT_PATHWAYS.out.divergent_pathways_csv,
        ch_input_metadata_tsv,
        NEXCLADE_RUN.out.nextclade_tsv
    )

    // MODULE: get get argument values
    GET_ARG_VALUES (
        GET_INFOS.out.infos_tsv,
        ref_dir
    )
}