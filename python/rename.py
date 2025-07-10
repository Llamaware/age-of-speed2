import os
import shutil
import sys

def main(source_folder, destination_folder):
    # Create the destination folder if it doesn't exist already
    if not os.path.exists(destination_folder):
        os.makedirs(destination_folder)

    # Walk through all nested directories in source_folder
    for root, dirs, files in os.walk(source_folder):
        for file in files:
            # Process only .ls files
            if file.endswith('.ls'):
                # Expecting a filename like "Prefix - ActualName.ls"
                # Split on the first occurrence of " - " to remove the prefix
                if " - " in file:
                    new_filename = file.split(" - ", 1)[1]
                else:
                    new_filename = file  # If no prefix, just copy the file name as is

                # Full path for the original and the new file
                source_path = os.path.join(root, file)
                destination_path = os.path.join(destination_folder, new_filename)

                # Copy the file over to the destination folder
                shutil.copy2(source_path, destination_path)
                print(f"Copied '{source_path}' to '{destination_path}'")

if __name__ == '__main__':
    if len(sys.argv) != 3:
        print("Usage: python script.py <source_folder> <destination_folder>")
        sys.exit(1)

    source_folder = sys.argv[1]
    destination_folder = sys.argv[2]
    main(source_folder, destination_folder)
