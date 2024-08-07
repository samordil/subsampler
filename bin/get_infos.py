#!/usr/bin/env python

'''
get region, country, division, date, pango lineage, nextstrain clade, who clade and mutation of each strain
'''

import argparse
import warnings
import pandas as pd


def main():
    warnings.filterwarnings('ignore')

    # command line interface
    parser = argparse.ArgumentParser(description='Get infos')
    parser.add_argument('--divergent-pathways', required=True, help='Divergent pathways file')
    parser.add_argument('--metadata', required=True, help='Metadata file')
    parser.add_argument('--nextclade-tsv', required=True, help='Nextclade tsv file')
    parser.add_argument('--include-genbank-accession', action='store_true', help='Include genbank accession')
    parser.add_argument('--output', required=True, help='Infos file')
    args = parser.parse_args()

    # read and filter strains from divergent pathway file
    seqs_filtered = []
    pathways = {}
    with open(args.divergent_pathways) as f:
        lines = f.readlines()
        for n, line in enumerate(lines):
            if n != 0:
                seq_id = line.split(',')[0]
                pathway = line.strip().split(',')[1]
                pathways.setdefault(pathway, []).append(seq_id)
    for p in pathways:
        if len(pathways[p]) > 2:
            seqs_filtered.extend(pathways[p])

    # get meta
    meta_cols = ['strain', 'date', 'region_exposure', 'country_exposure', 'division_exposure', 'pangolin_lineage']
    if args.include_genbank_accession:
        meta_cols.append('genbank_accession')
    meta = pd.read_csv(args.metadata, delimiter='\t', usecols=meta_cols, index_col='strain')
    meta = meta[meta.index.isin(seqs_filtered)]
    meta_dict = meta.to_dict()

    # get clade and mutation
    nextclade_cols = ['seqName', 'clade', 'clade_who', 'substitutions', 'aaSubstitutions', 'aaDeletions']
    nextclade = pd.read_csv(args.nextclade_tsv, delimiter='\t', usecols=nextclade_cols, index_col='seqName')
    nextclade = nextclade[nextclade.index.isin(seqs_filtered)]
    nextclade['clade_who'] = nextclade['clade_who'].fillna('others')
    nextclade.fillna('NA', inplace=True)
    nextclade_dict = nextclade.to_dict()

    # get infos
    infos = {}
    for i in seqs_filtered:
        infos[i] = {}
        infos[i]['region'] = meta_dict['region_exposure'][i]
        infos[i]['country'] = meta_dict['country_exposure'][i]
        infos[i]['division'] = meta_dict['division_exposure'][i]
        infos[i]['date'] = meta_dict['date'][i]
        infos[i]['pangoLineage'] = meta_dict['pangolin_lineage'][i]
        infos[i]['nextstrainClade'] = nextclade_dict['clade'][i]
        infos[i]['whoClade'] = nextclade_dict['clade_who'][i]
        infos[i]['substitutions'] = nextclade_dict['substitutions'][i]
        infos[i]['aaSubstitutions'] = nextclade_dict['aaSubstitutions'][i]
        infos[i]['aaDeletions'] = nextclade_dict['aaDeletions'][i]
        if args.include_genbank_accession:
            infos[i]['genbankAccession'] = meta_dict['genbank_accession'][i]

    with open(args.output, 'w') as f:
        if args.include_genbank_accession:
            f.write('ID'+'\t'+'region'+'\t'+'country'+'\t'+'division'+'\t'+'date'+'\t'+'pangoLineage'+'\t'
                +'nextstrainClade'+'\t'+'whoClade'+'\t'+'substitutions'+'\t'+'aaSubstitutions'+'\t'
                +'aaDeletions'+'\t'+'genbankAccession'+'\n')
            for i in infos:
                f.write(
                    i + '\t'
                    + infos[i]['region'] + '\t'
                    + infos[i]['country'] + '\t'
                    + infos[i]['division'] + '\t'
                    + infos[i]['date'] + '\t'
                    + infos[i]['pangoLineage'] + '\t'
                    + infos[i]['nextstrainClade'] + '\t'
                    + infos[i]['whoClade'] + '\t'
                    + infos[i]['substitutions'] + '\t'
                    + infos[i]['aaSubstitutions'] + '\t'
                    + infos[i]['aaDeletions'] + '\t'
                    + infos[i]['genbankAccession'] + '\n'
                )
        else:
            f.write('ID'+'\t'+'region'+'\t'+'country'+'\t'+'division'+'\t'+'date'+'\t'+'pangoLineage'+'\t'
                +'nextstrainClade'+'\t'+'whoClade'+'\t'+'substitutions'+'\t'+'aaSubstitutions'+'\t'+'aaDeletions'+'\n')
            for i in infos:
                f.write(
                    i + '\t'
                    + infos[i]['region'] + '\t'
                    + infos[i]['country'] + '\t'
                    + infos[i]['division'] + '\t'
                    + infos[i]['date'] + '\t'
                    + infos[i]['pangoLineage'] + '\t'
                    + infos[i]['nextstrainClade'] + '\t'
                    + infos[i]['whoClade'] + '\t'
                    + infos[i]['substitutions'] + '\t'
                    + infos[i]['aaSubstitutions'] + '\t'
                    + infos[i]['aaDeletions'] + '\n'
                )


if __name__ == '__main__':
    main()
