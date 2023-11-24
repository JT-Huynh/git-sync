#!/usr/bin/env bash

# Bitbucket repo url
GW_URL="git@bitbucket.org:workgotcom/gateway.git"
AW_URL="git@bitbucket.org:workgotcom/accountworkspace.git"
NO_URL="git@bitbucket.org:workgotcom/notification.git"
CO_URL="git@bitbucket.org:workgotcom/base.git"
UR_URL="git@bitbucket.org:workgotcom/userroleteam.git"
RP_URL="git@bitbucket.org:workgotcom/baserolepermission.git"
RT_URL="git@bitbucket.org:workgotcom/realtime.git"



function repo_query(){
    git_path="$(git rev-parse --show-toplevel)/source"

    service=$1

    [ -z "${service}" ] && print_error "Undefined services ${service} !!" && exit 1

    case "${service}" in
        'gw' )
            prefix='gw'
            source_dir="${git_path}/gw"
            repo_url=${GW_URL}
            ;;
        'aw' )
            prefix='aw'
            source_dir="${git_path}/aw"
            repo_url=${AW_URL}
            ;;
        'no' )
            prefix='no'
            source_dir="${git_path}/no"
            repo_url=${NO_URL}
            ;;
        'co' )
            prefix='co'
            source_dir="${git_path}/co"
            repo_url=${CO_URL}
            ;;
        'rp' )
            prefix='rp'
            source_dir="${git_path}/rp"
            repo_url=${RP_URL}
            ;;
        'rt' )
            prefix='rt'
            source_dir="${git_path}/rt"
            repo_url=${RT_URL}
            ;;
        'ur' )
            prefix='ur'
            source_dir="${git_path}/ur"
            repo_url=${UR_URL}
            ;;
    esac

    export SERVICE="${prefix}"
}

repo_query "$1"

if [ "$(prep '[s]sh-agent' | wc -l)" -gt 0 ] ; then
    echo "ssh-agent is already running"
else
    eval "$(ssh-agent -s)"
    if [ "$(ssh-add -l)" == "The agent has no identities." ] ; then
        ssh-add "$SSH_KEY"

        if [ ! -d "${source_dir}" ]; then
            git clone "${repo_url}" "${source_dir}"
        fi
    fi

    # Don't leave extra agents around: kill it on exit. You may not want this part.
    trap "ssh-agent -k" exit
fi
