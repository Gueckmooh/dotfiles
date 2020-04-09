#! /bin/bash

# Il faut remplacer "$CLIENTID" par le votre (voir l'API twitch)

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
    echo "output = $output"
    logo_url=$(get_user_info "$name" | jq -r '.logo')

    if [[ -z "$output" ]]
    then
        echo "$logo_url"
    else
        output="$output.${logo_url##*.}"
        wget -O "$output" "$logo_url"
        echo "$output"
    fi
}

get_logo -a gexdragon
