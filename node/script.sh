#!/bin/bash

set -e

TARGET_DIR="pb-node"

pf=(`find . -maxdepth 1 -name "*.proto"`)
if [ ${#pf[*]} -eq 0 ]; then
  echo "No proto files found!"
  exit 1
fi

if [ ${#pf[@]} -gt 1 ]; then
  echo "More than one proto file found..."
  echo "  by convention, only one proto file allowed!"
  exit 1
fi

echo "Found Proto definitions:"
printf "\t+%s\n" "${pf[@]}"

echo

if [ ! -d "$TARGET_DIR" ]; then
  mkdir $TARGET_DIR
fi

# create a prefix for our FileDescriptorSet
t1=${pf[@]}
t2="$(echo $t1 | cut -d'/' -f2)"
fds="$TARGET_DIR/$(echo $t2 | cut -d'.' -f1).desc"

echo "Building Node..."
protoc -I . ${pf[@]} --js_out=import_style=commonjs,binary:./$TARGET_DIR --grpc_out=./$TARGET_DIR --plugin=protoc-gen-grpc=/opt/namely/grpc_node_plugin -o./$fds
echo "Done"
