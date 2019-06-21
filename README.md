# app-tools
Command line tools and services to automate repetitive tasks

## Command line tool for scraping site and sharing it through PasteBoard

- Use Xcode Beta

- Create workspace
<br /><img src="imgs/Screenshot%202019-06-21%20at%2013.46.46.png" width=200 />

- Save it as "app-tools"
<br /><img src="imgs/Screenshot%202019-06-21%20at%2013.47.05.png" width=200 />

- File -> New Project
<br /><img src="imgs/Screenshot%202019-06-21%20at%2014.04.06.png" width=200 /> 

- Command line tool
<br /><img src="imgs/Screenshot%202019-06-21%20at%2014.04.21.png" width=200 /> 

- Name it "cmd" and add it to the workspace
<br /><img src="imgs/Screenshot%202019-06-21%20at%2014.05.04.png" width=200 /> 
<br /><img src="imgs/Screenshot%202019-06-21%20at%2014.05.24.png" width=200 /> 

- Add Swift Package dependencies
- https://github.com/IngmarStein/CommandLineKit for making command line apps
<br /><img src="imgs/Screenshot%202019-06-21%20at%2014.27.06.png" width=200 /> 
<br /><img src="imgs/Screenshot%202019-06-21%20at%2014.27.27.png" width=200 /> 
<br /><img src="imgs/Screenshot%202019-06-21%20at%2014.27.47.png" width=200 /> 


- Clone https://github.com/cezheng/Fuzi (for scraping a site) and add it to the workspace as a local package (had some error when )
- Project should look like this
<br /><img src="imgs/Screenshot%202019-06-21%20at%2014.48.32.png" width=200 /> 

- Open "main.swift"
```
switch Swift.CommandLine.arguments.first {
case "cmd-user":
    User().run()
    
default:
    break
}
```

- Add the "User.swift" file
```
import Foundation
import CommandLineKit

class UserApp {
    let VERSION = "1.0.0"
    let appName = "User"

    let cli = CommandLine()

    let version = BoolOption(longFlag: "version", helpMessage: "Prints the version and exits")

    init() {
        cli.addOptions(
            version
        )
    }
    
    func run() {
        print("Hello World")
    }
}
```