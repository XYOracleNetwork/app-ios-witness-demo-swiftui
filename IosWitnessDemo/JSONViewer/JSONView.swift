import SwiftUI
import SwiftyJSON

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
