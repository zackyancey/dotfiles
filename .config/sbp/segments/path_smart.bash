#! /usr/bin/env bash

# This segment attempts to intelligently shorten the current working directory
# path to only contain relevant information.


segment_direction=$3
segment_max_length=$4

path_value=
wdir=${PWD/${HOME}/\~}

is_landmark () {
  local dir="$1"
  # Any directory in /
  if [[ $dir =~ ^/([^/]+)?$ ]]; then
    landmark=$dir
    return 0
  fi 
  # Any directory in ~
  if [[ $dir =~ ^$HOME(/[^/]+)?$ ]]; then
    landmark=${dir/${HOME}/\~}
    return 0
  fi 

  # The root directory of a git repo
  git -C "$dir" rev-parse --show-toplevel > /dev/null 2>&1
  if [[ $? -eq 0 ]]
  then
    git_dir=`git -C "$dir" rev-parse --show-toplevel`
    if [[ $dir == $git_dir ]]; then
      landmark=$(basename $dir)
      return 0
    fi
  fi
  return 1
}

get_short_path () {
  # Find the landmark directory for a path. The landmark is the first directory
  # moving up from the current directory that meets one of the following
  # criteria:
  #   * the root directory of a git repository
  #   * a directory in / or ~
  #   * / or ~
  local wdir=$1
  local dir=$wdir
  local prevdir=""
  local landmark_levels=0

  until [[  "$dir" == "$prevdir" ]] # Give up if we end up in an endless loop
  do
    is_landmark $dir && break
    landmark_levels=$((landmark_levels + 1))
    prevdir=$dir
    dir="${dir%/*}"
  done
  local landmark_path=$dir

  # Find the name of the current directory
  if [[ $landmark_levels -eq 0 ]]; then
    short_path=$landmark
  elif [[ $landmark_levels -eq 1 ]]; then
    short_path=$landmark/$(basename $wdir)
  else
    short_path=$landmark$settings_path_skip_icon$(basename $wdir)
  fi
}

get_short_path $PWD
pretty_print_segment "$settings_path_color_primary" "$settings_path_color_secondary" "${short_path}" "$segment_direction"
