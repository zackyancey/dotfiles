ahead=$(config rev-list --count origin/master..)
behind=$(config rev-list --count ..origin/master)

[[ -n $(config status -s) ]] && echo "Config files have uncommitted changes"
[[ $ahead != "0" ]] && echo "Config files are $ahead commits ahead of the remote"
[[ $behind != "0" ]] && echo "Config files are $behind commits behind the remote"
