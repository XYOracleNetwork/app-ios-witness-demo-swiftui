import SwiftUI
import SwiftyJSON

struct DetailView: View {
    let item: Item

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                JSONView(json: item.json)
            }
            .padding()
        }
        .navigationTitle(item.hash)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct JSONView: View {
    let json: JSON

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            let keys = Array(json.dictionaryValue.keys).sorted()
            ForEach(keys, id: \.self) { key in
                JSONValueView(key: key, value: json[key])
            }
        }
    }
}

struct JSONValueView: View {
    let key: String
    let value: JSON

    var body: some View {
        if value.number != nil {
            JSONNumberView(key: key, value: value)
        } else if value.rawValue is String {
            JSONStringView(key: key, value: value)
        } else if value.array != nil {
            JSONArrayView(key: key, array: value.arrayValue)
        } else if value.dictionary != nil {
            JSONObjectView(key: key, object: value)
        } else {
            HStack {
                Text("\(key):").bold()
                Text("null")
            }
        }
    }
}

struct JSONNumberView: View {
    let key: String
    let value: JSON

    var body: some View {
        HStack {
            Text("\(key):").bold()
            Text("\(value.numberValue)")
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct JSONStringView: View {
    let key: String
    let value: JSON

    var body: some View {
        HStack {
            Text("\(key):").bold()
            Text(value.stringValue)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct JSONArrayView: View {
    let key: String
    let array: [JSON]

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(key):").bold()
            ForEach(0..<array.count, id: \.self) { index in
                JSONValueView(key: "\(key)[\(index)]", value: array[index])
                    .padding(.leading, 10)
            }
        }
    }
}

struct JSONObjectView: View {
    let key: String
    let object: JSON

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(key):").bold()
            ForEach(object.dictionaryValue.keys.sorted(), id: \.self) { nestedKey in
                JSONValueView(key: nestedKey, value: object[nestedKey])
                    .padding(.leading, 10)
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
