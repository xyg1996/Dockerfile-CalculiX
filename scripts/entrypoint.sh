#!/bin/bash

CMD="$@"

# setup enviroment
# that hack is needed because docker do not read the .bashrc in deteached mode
export OMPI_MCA_btl_vader_single_copy_mechanism=none

# execute command
"$CMD"

