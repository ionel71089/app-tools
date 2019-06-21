//
//  User.swift
//  cmd
//
//  Created by Ionel Lescai on 21/06/2019.
//  Copyright © 2019 Ionel Lescai. All rights reserved.
//

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
}
