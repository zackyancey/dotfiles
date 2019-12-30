#! /usr/bin/env bash

# An empty segment, useful if you want the last separator to show up.

segment_direction=$3

segment_value=" "
pretty_print_segment "$settings_return_code_color_primary" "$settings_return_code_color_secondary" "${segment_value}" "$segment_direction"
