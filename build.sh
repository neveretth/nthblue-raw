#!/bin/bash

# **********************************
# This script converts all the markdown (in $raw_data_dir) 
# files of the form: dir/dir/name.md
# to html files (in $output_dir) in the form: 
# dir/dir/name/index.html
# so that it appears clean in nginx webhosting.
# The binary used for conversion is specified by $md2html_bin
# The style specified by css_style (single css file) is added
# to every html file.
# **********************************

raw_data_dir=raw
output_dir=build
md2html_bin=/bin/md2html
css_style=styles/standard.css

file_extention="*.md"

html_prefix='
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="main.css">
</head>
<body>
'
html_suffix='
</body>
</html>
'

files=$(find $raw_data_dir -name "$file_extention" ) 

for file in $files
do
  # This is pretty cursed huh?
  output_location="$output_dir/$(echo $file | sed -e "s/\.md//g")" # remove .md
  output_location="$(echo $output_location | sed -e "s/\.\///g")" # remove ./
  output_location="$(echo $output_location | sed -e "s/raw\///g")" # remove raw/
  output_location="$(echo $output_location | sed -e "s/index//g")" # remove index dir path (if file is an index.md)
  mkdir -p $output_location 
  echo $html_prefix > $output_location/index.html
  $md2html_bin $file >> $output_location/index.html
  echo $html_suffix >> $output_location/index.html
  cp $css_style $output_location/main.css
done
