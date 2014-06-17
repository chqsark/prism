if go install github.com/wangkuiyi/prism/prism \
    github.com/wangkuiyi/prism/example \
    github.com/wangkuiyi/prism/example/hello; then
    echo -e "\033[1mBuild Prism completed\033[0m"
else
    echo -e "\033[1mBuild Prism failed\033[0m"
    exit
fi

killall prism
killall hello

# Start Prism and listen on :12340
$GOPATH/bin/prism &

echo -e "\033[1mDeploy and launch hello using Prism.\033[0m"
sleep 1
$GOPATH/bin/example -action=launch -retry=10
sleep 1
R=$(curl -s http://localhost:8080/Hello)
if [ "$R" != 'Hello, "/Hello"' ]; then
    echo -e "\033[1mhello is not running as expected!\033[0m"
    exit
fi

echo -e "\033[1mKill hello using killall should lead to restart.\033[0m"
killall hello
sleep 1
R=$(curl -s http://localhost:8080/Hello)
if [ "$R" != 'Hello, "/Hello"' ]; then
    echo -e "\033[1mhello is unexpectedly killed by killall!\033[0m"
    exit
fi

echo -e "\033[1mKill hello should kill hello.\033[0m"
$GOPATH/bin/example -action=kill
sleep 1
R=$(curl -s http://localhost:8080/Hello)
if [ "$R" != '' ]; then
    echo -e "\033[1mhello is not killed as expected!\033[0m"
    exit
fi

echo -e "\033[1mDeploy and launch again.\033[0m"
$GOPATH/bin/example -action=launch -retry=2
sleep 1
R=$(curl -s http://localhost:8080/Hello)
if [ "$R" != 'Hello, "/Hello"' ]; then
    echo -e "\033[1mhello is not running as expected!\033[0m"
    exit
fi

echo -e "\033[1mKill again.\033[0m"
$GOPATH/bin/example -action=kill
sleep 1
R=$(curl -s http://localhost:8080/Hello)
if [ "$R" != '' ]; then
    echo -e "\033[1mhello is not killed as expected\033[0m"
    exit
fi

echo -e "\033[1m========= Congratulations! Testing passed. =========\033[0m"
