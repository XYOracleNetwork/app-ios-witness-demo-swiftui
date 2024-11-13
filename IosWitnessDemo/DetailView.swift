import SwiftUI
import SwiftyJSON



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


#Preview("DetailView Preview") {
    let sampleData = JSON([
        "schema": "network.xyo.system.info",
        "_$hash": "e2803afb8d78e33eed1b5c1fbe5bc246d2bdefe80af410abf4e661028ecdc30f",
        "_hash": "11480c95ebd71e5b9814871c9756bd2e4e63455d331f8b7ed8ee4a3179689212",
            "_timestamp": 1731465636489
    ])
    let sampleItem = Item(json: sampleData)
    NavigationView {
        DetailView(item: sampleItem)
    }
}
