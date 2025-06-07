urldecode() {
    local data
    data="${1//+/ }"
    printf '%b' "${data//%/\\x}"
}

raw_url="$1"

decoded_url=$(urldecode "$raw_url")
parsed_args="${decoded_url#mpv://}"

# Split params
mapfile -t args_array < <(xargs -n1 <<< "$parsed_args")

# IFS=$'\n' read -d '' -ra args_array < <(
#     printf "%s\n" "$parsed_args" | 
#     xargs -n1
# )

# eval "args_array=($parsed_args)"

exec mpv "${args_array[@]}"
