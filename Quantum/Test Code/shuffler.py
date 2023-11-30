import random

def read_and_shuffle(file_path):
    # Read lines from the file
    with open(file_path, 'r') as file:
        lines = file.readlines()

    # Remove trailing newline characters
    lines = [line.strip() for line in lines]

    # Shuffle the lines randomly
    random.shuffle(lines)

    return lines

def write_to_file(file_path, lines):
    # Write shuffled lines back to the file
    with open(file_path, 'w') as file:
        for line in lines:
            file.write(line + '\n')

# Example usage:
file_path = '_buffer.txt'  # Replace with the path to your text file
shuffled_lines = read_and_shuffle(file_path)

# Write shuffled lines back to the same file
write_to_file(file_path, shuffled_lines)