#!/bin/sh
ls
ls -l formations/
formations/build.sh -o html -t osones -u http://formations.osones.com/revealjs
cp -r formations/output-html/* html/
