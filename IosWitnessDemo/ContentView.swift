//
//  ContentView.swift
//  IosWitnessDemo
//
//  Created by Joel Carter on 11/13/24.
//

import SwiftUI
import SwiftyJSON

struct ContentView: View {
    // Sample JSON data
    let items: [Item] = [
        Item(json: JSON(["name": "network.xyo.basic", "description": "This is the first item."])),
        Item(json: JSON(["name": "newtwork.xyo.systeminfo", "description": "This is the second item."])),
        Item(json: JSON(["name": "Item 3", "description": "This is the third item."]))
    ]
    
    var body: some View {
        NavigationView {
            List(items) { item in
                NavigationLink(destination: DetailView(item: item)) {
                    Text(item.name)
                }
            }
            .navigationTitle("Witnessed Results")
        }
    }
}

#Preview {
    ContentView()
}
