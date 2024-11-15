import os
import SwiftUI
import XyoClient
import SwiftyJSON
import CoreLocation


let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "network.xyo.IosWitnessDemo", category: "debug")
let basicWitness = BasicWitness {
    Payload("network.xyo.basic")
}
let systemInfoWitness = SystemInfoWitness(allowPathMonitor: true)
let locationWitness = LocationWitness()
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
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Spacer()
                
                // Fixed buttons at bottom of screen
                VStack(spacing: 20) {
                    Button("Witness Location") {
                        Task {
                            do {
                                let result = try await locationWitness.observe()
                                addWitnessedResults(observations: result)
                            } catch {
                                logger.debug("\(error)")
                            }
                        }
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
    private func observeAndAddResults<T: WitnessSync>(from witness: T) {
        let observedPayloads = witness.observe()
        addWitnessedResults(observations: observedPayloads)
    }
    private func addWitnessedResults(observations: [Payload]) {
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
