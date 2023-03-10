#!/bin/bash
# Author: Yevgeniy Goncharov, https://lab.sys-adm.in
# Run acme for defined domain name

# Sys env / paths / etc
# -------------------------------------------------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

ACME=/$USER/.acme.sh/acme.sh
TARGET=/etc/nginx/certs

# -------------------------------------------------------------------------------------------\

# Yes / No confirmation
confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

exit_0() {
    echo -e "\nOk. Exit. Bye!\n"
    exit 0
}

# -------------------------------------------------------------------------------------------\

# Get domain name from user
read -p "Enter Domain Name: " my_domain

if [[ -z "${my_domain}" ]]; then
    echo "Please set domain name. Exit."
    exit 1
fi

echo "Checking domain for exists..."

OUTPUT=`dig ${my_domain}`
if echo "$OUTPUT" | grep -i -e "status: NXDOMAIN" -e "No match for" -e "No whois server"; then
    echo "Domain does not exists. Exit. Bye."
    exit 1
fi

echo "Ok."

if confirm "Release certs for: ${my_domain}? (y/n or enter for exit)"; then
    # Run acme for release
    # . "/$USER/.acme.sh/acme.sh.env"
    $ACME --server zerossl --issue -d ${my_domain} --dns dns_cf --ocsp-must-staple --keylength 4096
else
    exit_0
fi

if confirm "Install cert? (y/n or enter)"; then
    $ACME --install-cert -d ${my_domain} --cert-file ${TARGET}/${my_domain}/cert --key-file ${TARGET}/${my_domain}/key --fullchain-file ${TARGET}/${my_domain}/fullchain --reloadcmd "chmod -R 640 /etc/nginx/certs/;"
else
    exit_0
fi



