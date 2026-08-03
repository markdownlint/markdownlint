#!/bin/bash

# RULES.md cannot be MDL'd for a few reasons;
#   1. It contains intentional violations to show the good/bad
#   2. It is parsed by tests to ensure Params are right, which
#      expect everything on a single line
bundle exec ./bin/mdl README.md $(ls docs/* | grep -v RULES)
