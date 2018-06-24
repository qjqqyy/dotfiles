alias katghc='ghc -O2 -ferror-spans -threaded -rtsopts'
export GHCRTS='-M1024m -K8m'

alias katcc='cc -lm -g -O2 -Wall -Wextra -pedantic -std=gnu99'

alias katjc='javac -encoding UTF-8 -sourcepath . -d .'
alias katj='java -XX:+UseSerialGC -Xss64m -Xms1024m -Xmx1024m -Dfile.encoding=UTF-8 -cp .'
