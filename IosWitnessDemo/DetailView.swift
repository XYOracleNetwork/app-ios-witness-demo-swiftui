import SwiftUI
import SwiftyJSON

struct DetailView: View {
    let item: Item

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Schema: \(item.json["schema"].stringValue)")
                    .font(.headline)
                
                JSONView(json: item.json) // Recursive view for JSON content
            }
            .padding()
        }
        .navigationTitle(item.hash)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Recursive JSONView to display JSON data
struct JSONView: View {
    let json: JSON

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Explicitly type the keys array as [String]
            let keys: [String] = Array(json.dictionaryValue.keys).sorted()
            ForEach(keys, id: \.self) { (key: String) in
                if let value = json[key].string {
                    // Display string values
                    HStack {
                        Text("\(key):").bold()
                        Text(value)
                            .lineLimit(1) // Limit to one line
                            .truncationMode(.tail) // Truncate at the end and add "..."
                            .frame(maxWidth: .infinity, alignment: .leading) // Ensure full width
                    }
                } else if let number = json[key].number {
                    // Display numeric values
                    let numStr = "\(number)"
                    HStack {
                        Text("\(key):").bold()
                        Text(numStr)
                            .lineLimit(1) // Limit to one line
                            .truncationMode(.tail) // Truncate at the end and add "..."
                            .frame(maxWidth: .infinity, alignment: .leading) // Ensure full width
                    }
                }
//                else if json[key].isArray {
//                    // Display arrays by recursively calling JSONView for each element
//                    Text("\(key):").bold()
//                    ForEach(0..<json[key].arrayValue.count, id: \.self) { index in
//                        JSONView(json: json[key][index])
//                            .padding(.leading, 10)
//                    }
//                } else if json[key].isDictionary {
//                    // Display nested dictionaries recursively
//                    Text("\(key):").bold()
//                    JSONView(json: json[key])
//                        .padding(.leading, 10)
//                }
                else {
                    // Display other types (e.g., null)
                    HStack {
                        Text("\(key):").bold()
                        Text("null")
                    }
                }
            }
        }
    }
}

#Preview("DetailView Preview") {
    let sampleData = JSON([
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
    let sampleItem = Item(json: sampleData)
    NavigationView {
        DetailView(item: sampleItem)
    }
}
