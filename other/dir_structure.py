import os

def list_files(startpath):
    with open('directory_structure.txt', 'w') as f:
        for root, dirs, files in os.walk(startpath):
            dirs[:] = [d for d in dirs if d != '.git']
            level = root.replace(startpath, '').count(os.sep)
            indent = ' ' * 4 * (level)
            f.write('{}{}/\n'.format(indent, os.path.basename(root)))
            subindent = ' ' * 4 * (level + 1)
            for file in files:
                f.write('{}{}\n'.format(subindent, file))

list_files('..')
