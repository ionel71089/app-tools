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
        print("Hello World")
    }
}
