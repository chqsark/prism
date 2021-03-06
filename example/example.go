package main

import (
	"flag"
	"github.com/wangkuiyi/file"
	"github.com/wangkuiyi/prism"
	"log"
	"os"
	"path"
)

var (
	actionFlag = flag.String("action", "launch", "{launch, kill}")
	retryFlag  = flag.Int("retry", 2, "Number of retries")
)

func main() {
	flag.Parse()

	switch *actionFlag {
	case "launch":
		launch()
	case "kill":
		kill()
	}
}

func launch() {
	if e := file.Initialize(); e != nil {
		log.Fatalf("file.Initalize() :%v", e)
	}

	buildDir := file.LocalPrefix + path.Dir(os.Args[0])
	log.Printf("Publish %s ...", buildDir)
	if e := prism.Publish(buildDir, "file:/tmp/prism_unittest.zip"); e != nil {
		log.Fatalf("Error: %v", e)
	}
	log.Println("Done")

	if e := prism.Deploy("localhost", "file:/tmp/prism_unittest.zip",
		"file:/tmp"); e != nil {
		log.Fatalf("Prism.Deploy failed: %v", e)
	}

	if e := prism.Launch("localhost:8080", "file:/tmp", "hello", []string{},
		"file:/tmp", *retryFlag); e != nil {
		log.Fatalf("Prism.Launch: %v", e)
	}
}

func kill() {
	if e := prism.Kill("localhost:8080"); e != nil {
		log.Fatalf("Prism.Kill: %v", e)
	}
}
