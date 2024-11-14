import SwiftUI
import XyoClient
import SwiftyJSON

struct ContentView: View {
    @State private var items: [JsonPayloadItem] = [
        JsonPayloadItem(
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
        JsonPayloadItem(
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
            VStack {
                // List view with scrollable content
                List(items) { item in
                    NavigationLink(destination: DetailView(item: item)) {
                        Text(item.schema)
                            .lineLimit(1) // Limit to one line
                            .truncationMode(.tail) // Truncate at the end and add "..."
                            .frame(maxWidth: .infinity, alignment: .leading) // Ensure full width
                    }
                }
                
                Spacer()
                
                // Buttons fixed at the bottom
                VStack(spacing: 20) {
                    Button("Basic Witness") {
                        let witness = XyoBasicWitness {
                            XyoPayload("network.xyo.basic")
                        }
                        observeAndAddPayloads(from: witness)
                    }
                    .buttonStyle(BorderedButtonStyle())
                    Button("System Info Witness") {
                        let witness = XyoSystemInfoWitness(allowPathMonitor: true)
                        observeAndAddPayloads(from: witness)
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
                .padding(.bottom, 10)
            }
            .navigationTitle("Witnessed Results")
        }
    }
    private func observeAndAddPayloads<T: AbstractWitness>(from witness: T) {
        let observedPayloads = witness.observe()
        for payload in observedPayloads {
            if let jsonPayload = payload.toJSON() {
                let jsonItem = JsonPayloadItem(json: jsonPayload)
                items.append(jsonItem)
            }
        }
    }
}

#Preview {
    ContentView()
}
