#!/usr/bin/python2

import jinja2
import re
import time

# Get a title for the post
postTitle = raw_input("Enter post title: ")

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

filename = "posts/%s.markdown" % cleanTitle

# Output content to file
if len(postTitle) > 0:
    f = open(filename, "w")
    f.write(outputText)
    f.close()
