import os
import SwiftUI
import XyoClient
import SwiftyJSON

let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "network.xyo.IosWitnessDemo", category: "debug")

let apiDomain = "https://beta.api.archivist.xyo.network"
let archive = "Archivist"

struct ContentView: View {
    private let account: AccountInstance
    private let panel: XyoPanel
    
    @State private var payloads: [JsonPayloadItem] = []
    @State private var previousHash: String?
    
    init(account: AccountInstance? = nil) {
        if let account {
            self.account = account
        } else {
            self.account = AccountServices.getNamedAccount(name: "default")
        }
        _previousHash = State(initialValue: self.account.previousHash)
        let basicWitness = BasicWitness {
            Payload("network.xyo.basic")
        }
        let systemInfoWitness = SystemInfoWitness(allowPathMonitor: true)
        let locationWitness = LocationWitness()
        panel = XyoPanel(
            account: account,
            witnesses: [basicWitness, systemInfoWitness, locationWitness],
            apiDomain: apiDomain,
            archive: archive
        )
    }
    
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

                HStack {
                    Text("Address:").bold()
                    Text("\(account.address)")
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: {
                        // Copy the address to the clipboard
                        UIPasteboard.general.string = account.address
                    }) {
                        Image(systemName: "doc.on.doc")  // Clipboard icon
                            .foregroundColor(.accentColor)
                    }
                }.padding(.horizontal, 16)
                
                HStack {
                    Text("Previous Hash:").bold()
                    Text("\(previousHash ?? "")")
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.padding(.horizontal, 16)

                Spacer()
                
                // Fixed buttons at bottom of screen
                VStack(spacing: 20) {
                    Button("Witness All") {
                        Task {
                            let result =  await panel.reportQuery()
                            let payloads = [result.bw] + result.payloads
                            addWitnessedResults(observations: payloads)
                            previousHash = panel.account.previousHash
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
