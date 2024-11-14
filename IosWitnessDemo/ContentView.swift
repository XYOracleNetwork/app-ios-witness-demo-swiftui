import os
import SwiftUI
import XyoClient
import SwiftyJSON


let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "network.xyo.IosWitnessDemo", category: "debug")
let basicWitness = XyoBasicWitness {
    XyoPayload("network.xyo.basic")
}
let systemInfoWitness = XyoSystemInfoWitness(allowPathMonitor: true)
let apiDomain = "https://beta.api.archivist.xyo.network"
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
