#!/usr/bin/env python
#! nix-shell -i python3 -p python3 python39Packages.jinja2

import os
import re
import time

import jinja2

# Get a title for the post
postTitle = input("Enter post title: ")

templateLoader = jinja2.FileSystemLoader( searchpath="." )
templateEnv = jinja2.Environment( loader=templateLoader )

template = templateEnv.get_template("new_post.jinja")


templateVars = { "title" : postTitle,
                 "author" : "Richard Goulter"
               }

outputText = template.render(templateVars)

# To ascii,
# to lowercase,
# keep only alphanumeric and ._-
# replace spaces with dashes
def clean(s):
    s = s.lower()
    s = re.sub(r'[^a-zA-Z0-9. _-]', '', s)
    s = s.replace(" ", "-")
    return s

yyyymmdd = time.strftime("%Y-%m-%d-")
cleanTitle = clean(yyyymmdd + postTitle)

provider = os.environ.get("HAKYLL_PROVIDER_DIRECTORY", ".")
filename = "%s/posts/%s.markdown" % (provider, cleanTitle)

# Output content to file
if len(postTitle) > 0:
    f = open(filename, "w")
    f.write(outputText)
    f.close()
