import os
import SwiftUI
import XyoClient
import SwiftyJSON

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
    witnesses: [basicWitness, systemInfoWitness, locationWitness]
)

let account = AccountServices.getNamedAccount(name: "default")
//let address = account.addressHex

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
                    Button("Witness All") {
                        Task {
                            let result =  await panel.report()
                            addWitnessedResults(observations: result)

                        }
                    }
                    .buttonStyle(BorderedButtonStyle())
                }
                .padding(.bottom, 10)
            }
            .navigationTitle("Witnessed Results")
        }
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
