#!/bin/bash
formations/build.sh -o html -t osones -u http://formations.osones.com/revealjs
cp -r formations/output-html/* html/
