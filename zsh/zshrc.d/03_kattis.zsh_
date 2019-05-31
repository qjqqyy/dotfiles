if (( $+commands[ghc] )); then
  alias katghc='ghc -O2 -ferror-spans -threaded -rtsopts'
  export GHCRTS='-M1024m -K8m'
fi

if (( $+commands[javac] )); then
  export _JAVA_OPTIONS='-XX:+UseSerialGC -Xss64m -Xms1024m -Xmx1024m'
  alias javac='javac -encoding UTF-8 -sourcepath . -d .'
  alias java='java -Dfile.encoding=UTF-8 -cp .'
fi

alias katcc='cc -lm -g -O2 -Wall -Wextra -pedantic -std=gnu99'
alias katcx='c++ -g -O2 -Wall -Wextra -pedantic -std=gnu++14'
