go install github.com/wangkuiyi/prism/prism
go install github.com/wangkuiyi/prism/example
go install github.com/wangkuiyi/prism/example/hello

killall prism
killall hello

# Start Prism and listen on :12340
$GOPATH/bin/prism -prism=:12340 -namenode=:50070&


# Deploy and launch hello using Prism
sleep 1
$GOPATH/bin/example -prism=:12340 -namenode=:50070 -action=launch
sleep 1
R=$(curl -s http://localhost:8080/Hello)
if [ "$R" != 'Hello, "/Hello"' ]; then
    echo "hello is not running as expected"
fi

# Kill hello
$GOPATH/bin/example -prism=:12340 -namenode=:50070 -action=kill
sleep 1
R=$(curl -s http://localhost:8080/Hello)
if [ "$R" != '' ]; then
    echo "hello is not killed as expected"
fi

# Deploy and launch again
$GOPATH/bin/example -prism=:12340 -namenode=:50070 -action=launch
sleep 1
R=$(curl -s http://localhost:8080/Hello)
if [ "$R" != 'Hello, "/Hello"' ]; then
    echo "hello is not running as expected"
fi

# Kill again
$GOPATH/bin/example -prism=:12340 -namenode=:50070 -action=kill
sleep 1
R=$(curl -s http://localhost:8080/Hello)
if [ "$R" != '' ]; then
    echo "hello is not killed as expected"
fi

echo '========= Congratulations! Testing passed. ========='
