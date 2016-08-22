#!/usr/bin/env python3

import os
import sys

def main(packages):
    if len(packages) <= 0:
        packages = filter(
            lambda path: os.path.isdir(path) and not path.startswith("."),
            os.listdir(),
        )

    for package in packages:
        link(package)

def link(package):
    for root, _, files in os.walk(package):
        dir = os.path.join(
            os.path.expanduser("~"),
            # ignore package name
            os.path.split(root)[1:],
        )

        os.makedirs(dir, exist_ok=True)

        for file in files:
            os.symlink(
                os.path.join(root, file),
                os.path.join(dir, file),
            )

if __name__ == '__main__':
    main(sys.argv[1:])
