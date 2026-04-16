/*
   Copyright @ 2021 bocloud <fushaosong@beyondcent.com>.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
*/
package main

import (
	"os"
	"runtime/debug"

	"github.com/carina-io/carina/cmd/carina-node/run"
	"github.com/carina-io/carina/utils/log"
)

func main() {
	printBuildInfo()
	run.Execute()
}

func printBuildInfo() {
	commit := "unknown"
	if info, ok := debug.ReadBuildInfo(); ok {
		for _, s := range info.Settings {
			if s.Key == "vcs.revision" {
				commit = s.Value
			}
		}
	}
	log.Info("-------- Welcome to use Carina Node Server --------")
	log.Infof("Git Commit : %s", commit)
	log.Infof("node name : %s", os.Getenv("NODE_NAME"))
	log.Info("------------------------------------")
}
