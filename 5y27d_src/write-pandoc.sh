#!/bin/bash
echo "Converting to html"
pandoc -s ./Code/term-data-dictionary.md -o ./Code/term-data-dictionary.html
pandoc -s README.md -o README.html

