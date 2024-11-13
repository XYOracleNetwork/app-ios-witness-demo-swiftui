//
//  Item.swift
//  IosWitnessDemo
//
//  Created by Joel Carter on 11/13/24.
//


import Foundation
import SwiftyJSON

struct Item: Identifiable {
    let id = UUID()
    let json: JSON
    var name: String {
        json["name"].stringValue
    }
}
