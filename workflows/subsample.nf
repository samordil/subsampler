/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    VALIDATE INPUTS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
if (params.input_fasta)         { ch_input_fasta        = file(params.input_fasta)        } else { ch_input_fasta = []          }
if (params.input_metadata_tsv)  { ch_input_metadata_tsv = file(params.input_metadata_tsv) } else { ch_input_metadata_tsv = []   }
if (params.genome_csv)          { ch_genome_csv         = file(params.genome_csv)         } else { ch_ch_genome_csv = []        }

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

    // MODULE: Filter sequences
    GET_NONSYNONYMOUS (
        ch_genome_csv,
        FILTER_SEQUENCES.out.strains_txt,
        NEXCLADE_RUN.out.nextclade_tsv,
        ch_input_metadata_tsv
        
    )
    
}