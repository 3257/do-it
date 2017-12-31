//
//  ColorPallete.swift
//  do-it
//
//  Created by Deyan Aleksandrov on 31.12.17.
//  Copyright © 2017 dido. All rights reserved.
//

import UIKit

struct ColorPallete {
    static let ElectricGreen = UIColor(netHex: 0xC6DA02)
    static let Green = UIColor(netHex: 0x79A700)
    static let Orange = UIColor(netHex: 0xF68B2C)
    static let Mustard = UIColor(netHex: 0xE2B400)
    static let Red = UIColor(netHex: 0xF5522D)
    static let Pink = UIColor(netHex: 0xFF6E83)

    static func getColor(for name: String?) -> UIColor {
        // Return chosen default color when no name provided
        guard let name = name else { return .lightGray }

        switch name {
        case "ElectricGreen":
            return ColorPallete.ElectricGreen
        case "Green":
            return ColorPallete.Green
        case "Orange":
            return ColorPallete.Orange
        case "Mustard":
            return ColorPallete.Mustard
        case "Red":
            return ColorPallete.Red
        case "Pink":
            return ColorPallete.Pink
        default:
            // No match color
            return .lightGray
        }
    }
}
