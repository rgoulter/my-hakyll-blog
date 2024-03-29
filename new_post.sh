#!/usr/bin/env bash
#! nix-shell -i bash -p bash -p python3 python39Packages.jinja2
# Grabbed from some other Hakyll repo, in particular
# https://raw.githubusercontent.com/Keruspe/blog/master/new_post.sh

date_pattern=$(date "+%Y-%m-%d")-

read -r -p "Post name > "
title=${REPLY}
# to ascii, to lowercase, keep only alphanum and ._- space and turn spaces into dashes
clean_title=$(echo "${title}" |
  iconv -f utf8 -t ascii//translit |
  tr '[:upper:]' '[:lower:]' |
  tr -dc 'a-z0-9. _-' |
  tr ' ' '-')

filename=$date_pattern$clean_title.markdown
author=$(git config --get user.name)

cat >"posts/${filename}" <<EOF
---
title: $title
author: $author
tags:
---

EOF
