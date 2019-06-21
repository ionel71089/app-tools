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

- Open "main.swift"; Depending on executable name, do different things. (trick used by swift compiler)
```swift
switch Swift.CommandLine.arguments.first {
case "cmd-user":
    UserApp().run()
    
default:
    UserApp().run()
    break
}
```

- Add the "User.swift" file
```swift
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

- Download and install Chrome
- Visit https://www.fakenamegenerator.com/gen-random-us-za.php
- Inspect element and copy XPATH
<br /><img src="imgs/Screenshot%202019-06-21%20at%2015.14.46.png" width=200 /> 
- name: ``"//*[@id=\"details\"]/div[2]/div[2]/div/div[1]/h3"``
- id: `"//*[@id=\"details\"]/div[2]/div[2]/div/div[2]/dl[2]/dd/text()"`
- birthday: `"//*[@id=\"details\"]/div[2]/div[2]/div/div[2]/dl[6]/dd/text()"`

- add code to run() function
```swift
    func run() {
        do {
            try cli.parse()
            
            if version.wasSet {
                printVersion()
                return
            }
            
            let genders = ["male", "female"]
            let gender = genders.randomElement()!
            
            let html = try String(contentsOf: URL(string: "https://www.fakenamegenerator.com/gen-\(gender)-us-za.php")!)
            let doc = try HTMLDocument(string: html, encoding: String.Encoding.utf8)
            let name = doc.firstChild(xpath: "//*[@id=\"details\"]/div[2]/div[2]/div/div[1]/h3")?.stringValue ?? ""
            let id = doc.firstChild(xpath: "//*[@id=\"details\"]/div[2]/div[2]/div/div[2]/dl[2]/dd/text()")?.stringValue ?? ""
            let birthday = doc.firstChild(xpath: "//*[@id=\"details\"]/div[2]/div[2]/div/div[2]/dl[6]/dd/text()")?.stringValue ?? ""
            
            let nameComponents = name.components(separatedBy: " ")
            let firstName = nameComponents[0...1].joined(separator: " ")
            let lastName = nameComponents[2]
            
            let df = DateFormatter()
            df.dateFormat = "MMMM dd, yyyy"
            let date = df.date(from: birthday)!
            
            let st = df.string(from: date)
            
            let json: [String: Any] = [
                "firstName": firstName,
                "lastName": lastName,
                "id": id.trimmingCharacters(in: .whitespacesAndNewlines),
                "birthday": st,
                "gender": gender.uppercased()
                
            ]
            print(jsonDebug(json))
        } catch {
            guard !version.wasSet else {
                printVersion()
                return
            }
            
            cli.printUsage(error)
            exit(EX_USAGE)
        }
    }
    
    private func printVersion() {
        print("banana")
        print("""
            \("\(appName) \(VERSION)".blue)
            \("   ".onBlack)\("   ".onYellow)\("   ".onGreen)\("   ".onWhite)\("   ".onRed)\("   ".onBlue)
            
            """
        )
    }
```

- Copy files phase
<br /><img src="imgs/Screenshot%202019-06-21%20at%2016.09.46.png" width=200 />

- Add Script Build Phase "Duplicate Executable"
```shell
cp /usr/local/bin/cmd /usr/local/bin/cmd-user
```

- Make sure to add PATH
- Run Script in terminal
```
cmd-user | pbcopy; pbpaste
```

- Create iOS tabbed app
- Code to decode json in view did appear
```swift
if let data = UIPasteboard.general.string?.data(using: .utf8) {
            struct Patient: Decodable {
                let id: String
                let firstName: String
                let lastName: String
                let birthday: Date
                let gender: SexId
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = DateFormatter.dateCodingStrategy
            if let patient = try? decoder.decode(Patient.self, from: data) {
                firstNameLabel.text = patient.firstName
                lastNameLabel.text = patient.lastName
                idLabel.text = patient.id
                birthdateLabel = patient.birthday
                viewModel?.mutablePatientCgmModel.gender.value = patient.gender
            }
        }
```

- Set user search paths
```
//:configuration = Debug
USER_HEADER_SEARCH_PATHS = ${SDK_DIR}/usr/include/libxml2

//:configuration = Release
USER_HEADER_SEARCH_PATHS = ${SDK_DIR}/usr/include/libxml2
```

- https://github.com/onevcat/Rainbow for colored text

## Next: Create server and use https://github.com/krzysztofzablocki/KZFileWatchers instead of UIPasteboard