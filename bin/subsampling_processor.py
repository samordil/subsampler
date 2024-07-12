#!/usr/bin/env python

import argparse

def process_file(input_file, log_file, id_file):
    with open(input_file, 'r') as file, open(log_file, 'w') as log_f, open(id_file, 'w') as id_f:
        for line in file:
            if line.startswith("##"):
                log_f.write(line[2:].strip() + '\n')
            elif line.startswith("# ID"):
                id_f.write("strain\n")
            else:
                id_f.write(line)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Process a subsampling project file to extract log lines and update the header.")
    parser.add_argument('--input', '-i', type=str, required=True, help="The input file to be processed")
    parser.add_argument('--log', '-l', type=str, default='log.txt', help="The log file to write extracted log lines (default: log.txt)")
    parser.add_argument('--id', '-d', type=str, default='strain_ids.txt', help="The ID file to write updated data lines (default: strain_ids.txt)")
    args = parser.parse_args()

    process_file(args.input, args.log, args.id)
