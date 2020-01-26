package main

import "C"

import (
	 "os"
	 "fmt"	
	 "github.com/OJ/gobuster/cli/cmd"
	 
	 gsq "github.com/kballard/go-shellquote"
)

func main(){
	start("dir -u https://ethicalchaos.dev -w C:\\\\Users\\\\ceri.coburn\\\\fuzz.txt")
}

//export start
func start(arg string) {

	//parse our monolithinc argument string into individual args
	args, err := gsq.Split(arg)

	//our first argument is usally the program name, to just fake it
	args = append([]string{"goreflect"}, args...)


	if err == nil {
		//replace os.Args ready for calling our go program
		os.Args = args
		//run our go program
		fmt.Printf("Starting Go Program with %d argument parsed\n", len(args))
		cmd.Execute()
	} else {
		//parsing arguments failed, so bail.  Possibly unterminated string quote, etc...
		fmt.Printf("Failed to parse start arguments, %v\n", err)
	}
}
