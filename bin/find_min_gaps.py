import sys

def read_fasta_file(filename):
    sequences = {}
    current_header = None
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            if line.startswith('>'):
                current_header = line[1:]
                sequences[current_header] = ''
            else:
                sequences[current_header] += line
    return sequences

def find_sequence_with_least_dashes(sequences):
    min_dashes = float('inf')
    selected_sequence = None
    for header, sequence in sequences.items():
        num_dashes = sequence.count('-')
        if num_dashes < min_dashes:
            min_dashes = num_dashes
            selected_sequence = sequence
    return selected_sequence

def write_sequence_to_file(sequence, input_filename, output_filename):
    with open(output_filename, 'w') as f:
        f.write(">")
        f.write(input_filename.rsplit('.', 1)[0])
        f.write("\n")
        f.write(sequence)

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python script.py input.fasta output.fasta")
    else:
        input_filename = sys.argv[1]
        output_filename = sys.argv[2]

        sequences = read_fasta_file(input_filename)
        selected_sequence = find_sequence_with_least_dashes(sequences)

        if selected_sequence:
            write_sequence_to_file(selected_sequence, input_filename, output_filename)
            print("The sequence with the least amount of gaps was written to:", output_filename)
        else:
            print("Either there were no sequences found in the input file or all sequences contain gaps.")

