#!/bin/sh
. ~/workspace/docker-jekyll/jekyll.sh
. ~/workspace/docker-jekyll/jekyllserve.sh
jekyll clean
jekyll build
jekyllserve
