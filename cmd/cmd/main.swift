//
//  main.swift
//  cmd
//
//  Created by Ionel Lescai on 21/06/2019.
//  Copyright © 2019 Ionel Lescai. All rights reserved.
//

import Foundation

public func jsonDebug(_ dictionary: [String: Any]) -> String {
    let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
    return jsonData.flatMap { String(data: $0, encoding: .utf8) } ?? ""
}

switch Swift.CommandLine.arguments.first {
case "cmd-user":
    UserApp().run()
    
default:
    UserApp().run()
    break
}

