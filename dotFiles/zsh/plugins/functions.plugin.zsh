#!/usr/bin/env zsh

function proxy_on() {
  PROXY_SERVER=www-proxy.us.oracle.com
  PROXY_PORT=80

  export HTTP_PROXY="http://$PROXY_SERVER:$PROXY_PORT"
  export HTTPS_PROXY=$HTTP_PROXY
  export FTP_PROXY=$HTTP_PROXY
  export ALL_PROXY=$HTTP_PROXY
  export NO_PROXY="localhost,127.0.0.1,*.$USERDNSDOMAIN"

  if type "git" > /dev/null; then
    echo "Proxy set for git"
    git config --global http.proxy $HTTP_PROXY
  fi

  echo -e "Proxy set to $HTTP_PROXY"
}


function proxy_off() {
  proxy=("HTTP_PROXY" "HTTPS_PROXY" "FTP_PROXY" "ALL_PROXY" "NO_PROXY")
  for i in "${proxy[@]}"; do unset $i; done

  if type "git" > /dev/null; then
    echo "Proxy unset for git"
    git config --global --unset http.proxy
  fi

  echo -e "Proxy settings removed"
}


export JDK_BASE=/Library/Java/JavaVirtualMachines
function switch-java() {
  jvms=( `\ls -1 $JDK_BASE` )
  pref='jdk-'

  if [ "$1" = "8" ] ; then
    pref='jdk1.'
  fi

  if [ "$1" != "" ] ; then
    SELECTION=$(\ls -1 $JDK_BASE | grep $pref$1)
  fi

  if [ "$SELECTION" = "" ] ; then
    echo "Switch to which JVM?"
    for i in ${!jvms[@]}; do
      printf "   %2d - %s\n" $i ${jvms[$i]}
    done

    while [[ $SELECTION -ge ${#jvms[@]} ]] || [[ $SELECTION -lt 0 ]] || [[ $SELECTION == '' ]] ; do
      read -p "Select a JVM: " SELECTION
    done

    SELECTION=${jvms[$SELECTION]}
  fi

  echo '-----------------------------------------------------------------'
  echo "Switching to Java: $SELECTION"
  echo "Full path: $JDK_BASE/$SELECTION/Contents/Home"
  echo ":java-cmd \"$JDK_BASE/$SELECTION/Contents/Home/bin/java\""
  echo '-----------------------------------------------------------------'
  export JAVA_HOME=$JDK_BASE/$SELECTION/Contents/Home
  export JAVA_CMD=$JAVA_HOME/bin/java
  export PATH=$JAVA_HOME/bin:$PATH
  java -version
  echo '-----------------------------------------------------------------'

}
