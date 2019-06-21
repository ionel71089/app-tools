//
//  main.swift
//  cmd
//
//  Created by Ionel Lescai on 21/06/2019.
//  Copyright © 2019 Ionel Lescai. All rights reserved.
//

import Foundation

switch Swift.CommandLine.arguments.first {
case "cmd-user":
    UserApp().run()
    
default:
    break
}

