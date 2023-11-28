#!/bin/bash
set -eu

makeFile="$(dirname "${0}")/Makefile"
pyprojectToml="$(dirname "${0}")/pyproject.toml"
devconDir="$(dirname "${0}")/.devcontainer"
composeYml="${devconDir}/compose.yaml"
appDir="$(dirname "${0}")/devcontainer-python-tmpl"
appName=""

function usage() {
  cat << EOF

initialization script to rename app-name in the template files/directory to your app name.

- app-name: your app name
- template files:
  - project_root/Makefile
  - project_root/pyproject.toml
  - project_root/.devcontainer/compose.yaml
- template directory: project_root/devcontainer-python-tmpl

Usage:
  ${0} -a <your-app-name>

Example:
  ${0} -a sampleapp
EOF
}

function parse_args() {
  while getopts "a:h" OPT; do
    case ${OPT} in
      a)
        appName=${OPTARG}
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
  if [[ -z ${appName} ]]; then
    echo "the flag '-a' is required"
    usage
    exit 1
  fi
}

function check_file() {
  for tmpl in ${makeFile} ${pyprojectToml} ${composeYml} ${appDir}
  do
    if [[ ! -e ${tmpl} ]]; then
      echo "${tmpl} does not exist"
      exit 1
    fi
  done
}

function main() {
  echo "----- start -----"

  echo "--- replace 'app-name' to '${appName}' in ${makeFile} ---"
  sed -i -e "s|devcontainer-python-tmpl|${appName}|g" "${makeFile}"

  echo "--- replace 'app-name' to '${appName}' in ${pyprojectToml} ---"
  sed -i -e "s|devcontainer-python-tmpl|${appName}|g" "${pyprojectToml}"

  echo "--- replace 'app-name' to '${appName}' in ${composeYml} ---"
  sed -i -e "s|devcontainer-python-tmpl|${appName}|g" "${composeYml}"

  echo "--- replace directory name of ${appDir} to '${appName}' ---"
  mv "${appDir}" "$(dirname "${0}")/${appName}"

  echo "----- finish -----"
}

if [[ ${BASH_SOURCE[0]} == "${0}" ]]; then
  parse_args "$@"
  check_args "$@"
  check_file
  main "${appName}"
  exit 0
fi
