import os
import SwiftUI
import XyoClient
import SwiftyJSON

let samplePayloads: [JsonPayloadItem] = [
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

let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "network.xyo.IosWitnessDemo", category: "debug")
let basicWitness = XyoBasicWitness {
    XyoPayload("network.xyo.basic")
}
let systemInfoWitness = XyoSystemInfoWitness(allowPathMonitor: true)
let apiDomain = "http://localhost:8080"
let archive = "Archivist"
let panel = XyoPanel(
    archive: archive,
    apiDomain: apiDomain,
    witnesses: [basicWitness, systemInfoWitness]
)

struct ContentView: View {
    @State private var payloads: [JsonPayloadItem] = []

    var body: some View {
        NavigationView {
            VStack {
                // List view with scrollable content
                List(payloads) { item in
                    NavigationLink(destination: PayloadDetailView(item: item)) {
                        Text(item.schema)
                            .lineLimit(1) // Limit to one line
                            .truncationMode(.tail) // Truncate at the end and add "..."
                            .frame(maxWidth: .infinity, alignment: .leading) // Ensure full width
                    }
                }
                
                Spacer()
                
                // Buttons fixed at the bottom
                VStack(spacing: 20) {
                    Button("Witness Basic") {
                        observeAndAddResults(from: basicWitness)
                    }
                    .buttonStyle(BorderedButtonStyle())
                    Button("Witness System Info ") {
                        observeAndAddResults(from: systemInfoWitness)
                    }
                    .buttonStyle(BorderedButtonStyle())
                    Button("Witness All") {
                        Task {
                            do {
                                let result = try await panel.report()
                                addWitnessedResults(observations: result)
                            } catch {
                                logger.debug("\(error)")
                            }
                        }
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
                .padding(.bottom, 10)
            }
            .navigationTitle("Witnessed Results")
        }
    }
    private func observeAndAddResults<T: AbstractWitness>(from witness: T) {
        let observedPayloads = witness.observe()
        addWitnessedResults(observations: observedPayloads)
    }
    private func addWitnessedResults(observations: [XyoPayload]) {
        for payload in observations {
            if let jsonPayload = payload.toJSON() {
                let jsonItem = JsonPayloadItem(json: jsonPayload)
                payloads.append(jsonItem)
            }
        }
    }
}

#Preview {
    ContentView()
}
