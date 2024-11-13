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
            Text("Schema: \(item.json["schema"].stringValue)")
                .font(.headline)
//            Text("Description: \(item.json["description"].stringValue)")
//                .font(.body)
            Spacer()
        }
        .padding()
        .navigationTitle(item.hash)
        .navigationBarTitleDisplayMode(.inline)
    }
}
