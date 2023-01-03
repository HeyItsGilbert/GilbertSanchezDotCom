#!/usr/bin/python3

import sys
import frontmatter

# print(f"workspaceArg: {sys.argv[1]}")
# print(f"fileArg: {sys.argv[2]}")
# print(f"frontMatterArg: {sys.argv[3]}")

post = frontmatter.load(sys.argv[2])

# Grab all the tags and turn them into keywords
for tag in post["tags"]:
    print(tag.lower())
