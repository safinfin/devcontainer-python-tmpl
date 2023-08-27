#!/bin/bash
set -eu

mkFile="$(dirname "${0}")/Makefile"
pyprojectToml="$(dirname "${0}")/pyproject.toml"
devconDir="$(dirname "${0}")/.devcontainer"
devconJson="${devconDir}/devcontainer.json"
composeYml="${devconDir}/compose.yaml"
appName=""
repoName=""

function usage() {
  cat << EOF

initialization script to replace app-name and repo-name in the template files.

- app-name: your app name
- repo-name: your repository name
- template files:
  - project_root/Makefile
  - project_root/pyproject.toml
  - project_root/.devcontainer/devcontainer.json
  - project_root/.devcontainer/compose.yaml

Usage:
  replace-names.sh -a <app-name> -r <repo-name>

Example:
  replace-names.sh -a sampleapp -r github.com/safinfin/sampleapp
EOF
}

function parse_args() {
  while getopts "a:r:h" OPT; do
    case ${OPT} in
      a)
        appName=${OPTARG}
        ;;
      r)
        repoName=${OPTARG}
        ;;
      h)
        usage
        exit 0
        ;;
      :|\?)
        usage
        exit 0
        ;;
    esac
  done
}

function check_args() {
  if [[ -z ${appName} || -z ${repoName} ]]; then
    echo "the flag '-a' and '-r' is required"
    usage
    exit 1
  fi
}

function check_file() {
  if [[ ! -f ${mkFile} ]]; then
    echo "${mkFile} does not exist"
    exit 1
  fi
  if [[ ! -f ${pyprojectToml} ]]; then
    echo "${pyprojectToml} does not exist"
    exit 1
  fi
  if [[ ! -f ${devconJson} ]]; then
    echo "${devconJson} does not exist"
    exit 1
  fi
  if [[ ! -f ${composeYml} ]]; then
    echo "${composeYml} does not exist"
    exit 1
  fi
}

function main() {
  echo "----- start -----"

  echo "--- replace 'repo-name' to '${repoName}' in ${mkFile} ---"
  sed -i -e "s|repo-name|${repoName}|g" "${mkFile}"

  echo "--- replace 'app-name' to '${appName}' in ${pyprojectToml} ---"
  sed -i -e "s|app-name|${appName}|g" "${pyprojectToml}"

  echo "--- replace 'app-name' to '${appName}' in ${devconJson} ---"
  sed -i -e "s|app-name|${appName}|g" "${devconJson}"

  echo "--- replace 'app-name' to '${appName}' in ${composeYml} ---"
  sed -i -e "s|app-name|${appName}|g" "${composeYml}"
  echo "--- replace 'repo-name' to '${repoName}' in ${composeYml} ---"
  sed -i -e "s|repo-name|${repoName}|g" "${composeYml}"

  echo "----- finish -----"
}

if [[ ${BASH_SOURCE[0]} == "${0}" ]]; then
  parse_args "$@"
  check_args "$@"
  check_file
  main "${appName}" "${repoName}"
  exit 0
fi
