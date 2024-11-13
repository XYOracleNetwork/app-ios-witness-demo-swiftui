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
        Item(
            json: JSON([
                "schema": "network.xyo.system.info",
                "network": [:], // Empty dictionary
                "os": [
                    "name": "macOS",
                    "version": [
                        "patch": 0,
                        "major": 14,
                        "minor": 7
                    ]
                ],
                "device": [
                    "model": "arm64",
                    "version": "Darwin Kernel Version 23.6.0: Wed Jul 31 20:50:13 PDT 2024; root:xnu-10063.141.1.700.5~1/RELEASE_ARM64_VMAPPLE",
                    "sysname": "Darwin",
                    "nodename": "Mac-1731464958252.local",
                    "release": "23.6.0"
                ],
                "_$hash": "e2803afb8d78e33eed1b5c1fbe5bc246d2bdefe80af410abf4e661028ecdc30f",
                "_hash": "11480c95ebd71e5b9814871c9756bd2e4e63455d331f8b7ed8ee4a3179689212",
                "_timestamp": 1731465636489
            ])
        ),
        Item(
            json: JSON([
                "schema": "network.xyo.basic",
                "_$hash": "540756396cdc97625f245c789d56e4f26306e1fecc2d409a9a7a5ac9fcc50205",
                "_hash": "1269b95d3ebf1b1258a82ccca0b365fabf4b8c99bf8fc852e5045e30ad20fbb1",
                "_timestamp": 1731465636656
            ])
        )
    ]


    
    var body: some View {
        NavigationView {
            List(items) { item in
                NavigationLink(destination: DetailView(item: item)) {
                    Text(item.hash)
                        .lineLimit(1) // Limit to one line
                        .truncationMode(.tail) // Truncate at the end and add "..."
                        .frame(maxWidth: .infinity, alignment: .leading) // Ensure full width
                }
            }
            .navigationTitle("Witnessed Results")
        }
    }
}

#Preview {
    ContentView()
}
