#! /usr/bin/env bash

# Display only the name of the current directory

segment_direction=$3
segment_max_length=$4

path_value=
wdir=${PWD/${HOME}/\~}

if [[ "${#wdir}" -gt "$segment_max_length" ]]; then
  folder=${wdir##*/}
  IFS='/' wdir=$(for p in ${wdir}; do printf '%s/' "${p:0:1}"; done;)
  wdir="${wdir%/*}${folder:1}"
fi

IFS=/ read -r -a wdir_array <<<"${wdir}"

path_value="$wdir"
path_value="$(basename "$path_value")"

pretty_print_segment "$settings_path_color_primary" "$settings_path_color_secondary" "${path_value}" "$segment_direction"
