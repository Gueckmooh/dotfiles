#! /bin/bash

# Il faut remplacer "$CLIENTID" par le votre (voir l'API twitch)

# GETOPT
usage()
{
    echo "Usage: $0 [-q query]" 2>&1
    exit 1
}

while getopts ":q" opt
do
    case "$opt" in
        q)
            query=1
            ;;
        *)
            usage
            ;;
    esac
done
shift "$((OPTIND - 1))"

get_user_info()
{
    name="$1"
    curl -s -H 'Accept: application/vnd.twitchtv.v5+json' -H "Client-ID: $CLIENTID" -X GET "https://api.twitch.tv/kraken/users?login=$name" | jq -r '.users | .[]'
}

get_id()
{
    name="$1"
    get_user_info "$name" | jq -r '._id'
}

get_logo()
{
    while getopts ":o:a" opt
    do
        case "$opt" in
            o)
                output="$OPTARG"
                ;;
            a)
                output="$(mktemp -u)"
                ;;
            *)
                exit 1
        esac
    done
    shift "$((OPTIND - 1))"
    name="$1"
    logo_url=$(get_user_info "$name" | jq -r '.logo')

    if [[ -z "$output" ]]
    then
        echo "$logo_url"
    else
        output="$output.${logo_url##*.}"
        wget -q -O "$output" "$logo_url"
        echo "$output"
    fi
}

get_stream_info()
{
    name="$1"
    id=$(get_id "$name")
    curl -s -H 'Accept: application/vnd.twitchtv.v5+json' -H "Client-ID: $CLIENTID" -X GET "https://api.twitch.tv/kraken/streams/$id" | jq ".stream"
}

is_live()
{
    name="$1"
    if [[ $(get_stream_info "$name") == "null" ]]
    then
        echo "no"
    else
        echo "yes"
    fi
}

if [[ ! -z "$query" ]]
then
    eval "$*"
    exit 0
fi

get_logo -a gexdragon
