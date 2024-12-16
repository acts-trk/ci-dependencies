#!/bin/bash

set -u
set -e

packages_file=$(spack location -r)/spack/etc/spack/packages.yaml
echo "Packages file: $packages_file"

if ! command -v sudo &> /dev/null
then
    SUDO=""
else
    SUDO="sudo"
fi

os=$(spack arch --family)

echo "OS: $os"

if [[ "$os" == *ubuntu* ]]; then
  ${SUDO} apt-get update
  ${SUDO} apt-get install -y libgl1-mesa-dev
cat <<EOF > "$packages_file"
packages:
  opengl:
    buildable: false
    externals:
    - prefix: /usr/
      spec: opengl@4.5
EOF
cat "$packages_file"
elif [[ "$os" == *almalinux* ]]; then
  ${SUDO} dnf install -y mesa-libGLU
cat <<EOF > "$packages_file"
packages:
  opengl:
    buildable: false
    externals:
    - prefix: /usr/
      spec: opengl@4.6
EOF
cat "$packages_file"
else [[ "$os" == *darwin* ]]
  echo "Nothing to do on Darwin"
fi
