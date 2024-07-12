#!/usr/bin/env python

import pandas as pd
from Bio import SeqIO
import argparse

def main(metadata_file, sequence_file, strain_id_file, output_metadata_file, output_sequence_file):
    # Read strain IDs from strain_id.txt file
    with open(strain_id_file, 'r') as f:
        strain_ids = {line.strip() for line in f}

    # Read metadata.tsv file into a DataFrame
    metadata_df = pd.read_csv(metadata_file, sep='\t')

    # Filter metadata DataFrame to include only strains from strain_id.txt
    filtered_metadata_df = metadata_df[metadata_df['strain'].isin(strain_ids)]

    # Write filtered metadata to a new TSV file
    filtered_metadata_df.to_csv(output_metadata_file, sep='\t', index=False)

    # Filter sequences from sequence.fasta file based on strain IDs and write to output FASTA file
    with open(output_sequence_file, 'w') as seq_out:
        for record in SeqIO.parse(sequence_file, 'fasta'):
            if record.id in strain_ids:
                SeqIO.write(record, seq_out, 'fasta')

    print(f"Filtered metadata has been written to '{output_metadata_file}'")
    print(f"Filtered sequences have been written to '{output_sequence_file}'")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Filter metadata and sequences based on strain IDs')
    parser.add_argument('-m', '--metadata', type=str, required=True, help='Path to the metadata.tsv file')
    parser.add_argument('-s', '--sequences', type=str, required=True, help='Path to the sequence.fasta file')
    parser.add_argument('-i', '--strain_ids', type=str, required=True, help='Path to the strain_id.txt file')
    parser.add_argument('-o', '--output_metadata', type=str, default='filtered_metadata.tsv', help='Path to the output filtered metadata file')
    parser.add_argument('-q', '--output_sequences', type=str, default='filtered_sequences.fasta', help='Path to the output filtered sequences file')

    args = parser.parse_args()

    main(args.metadata, args.sequences, args.strain_ids, args.output_metadata, args.output_sequences)
