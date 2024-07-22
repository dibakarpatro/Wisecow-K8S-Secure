#!/usr/bin/env bash

echo "Debugging Info: Starting wisecow.sh"
echo "Debugging Info: PATH=$PATH"
echo "Debugging Info: Adding /usr/games to PATH"
export PATH=$PATH:/usr/games
echo "Debugging Info: PATH after modification=$PATH"
echo "Debugging Info: Listing /usr/games and /usr/local/games directories"
ls -l /usr/games
ls -l /usr/local/games

SRVPORT=4499
RSPFILE=response

command -v cowsay >/dev/null 2>&1 || { echo "Debugging Info: cowsay not found. Install prerequisites."; exit 1; }
command -v fortune >/dev/null 2>&1 || { echo "Debugging Info: fortune not found. Install prerequisites."; exit 1; }

rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
        read line
        echo $line
}

handleRequest() {
    # 1) Process the request
        get_api
        mod=`fortune`

cat <<EOF > $RSPFILE
HTTP/1.1 200


<pre>`cowsay $mod`</pre>
EOF
}

prerequisites() {
        command -v cowsay >/dev/null 2>&1 &&
        command -v fortune >/dev/null 2>&1 || 
                { 
                        echo "Install prerequisites."
                        exit 1
                }
}

main() {
        prerequisites
        echo "Wisdom served on port=$SRVPORT..."

        while [ 1 ]; do
                cat $RSPFILE | nc -lN $SRVPORT | handleRequest
                sleep 0.01
        done
}

main

