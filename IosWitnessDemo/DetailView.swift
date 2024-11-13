//
//  DetailView.swift
//  IosWitnessDemo
//
//  Created by Joel Carter on 11/13/24.
//

import SwiftUICore


struct DetailView: View {
    let item: Item
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Name: \(item.json["name"].stringValue)")
                .font(.headline)
            Text("Description: \(item.json["description"].stringValue)")
                .font(.body)
            
            Spacer()
        }
        .padding()
        .navigationTitle(item.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
