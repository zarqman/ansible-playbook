#!/bin/sh
export JAVA_HOME=/usr/lib/jvm/java
if [ -z "$LD_LIBRARY_PATH" ]; then
  export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64:$JAVA_HOME/jre/lib/amd64/client
else
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$JAVA_HOME/jre/lib/amd64:$JAVA_HOME/jre/lib/amd64/client
fi
