import SwiftUI
import SwiftyJSON

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
