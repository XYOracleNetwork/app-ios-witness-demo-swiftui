import SwiftUI
import SwiftyJSON

struct PayloadDetailView: View {
    let item: JsonPayloadItem

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
    let sampleItem = JsonPayloadItem(json: sampleData)
    NavigationView {
        PayloadDetailView(item: sampleItem)
    }
}
