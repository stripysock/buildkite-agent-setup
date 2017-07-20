#!/bin/bash
#
# Generate a new public/private key pair intended for use as a github deploy token

REPO_NAME=$1
TOKEN_PATH="${HOME}/.ssh/{REPO_NAME}_rsa"
PUBLIC_TOKEN_PATH="${TOKEN_PATH}.pub"

[[ -f ${TOKEN_PATH} ]] && echo "private key already exists at ${TOKEN_PATH}" && exit 1
[[ -f ${PUBLIC_TOKEN_PATH} ]] && echo "public key already exists at ${PUBLIC_TOKEN_PATH}" && exit 1

ssh-keygen -b 4096 -C "${REPO_NAME}" -f ${TOKEN_PATH}

echo "Add the following to ~/.ssh/config:"
echo "Host github.com-${REPO_NAME}"
echo "    HostName github.com"
echo "    IdentityFile ${TOKEN_PATH}"

echo "Add the public key as a deploy token at https://github.com/stripysock/${REPO_NAME}/settings/keys:"
cat ${PUBLIC_TOKEN_PATH}
