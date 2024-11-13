import SwiftUI
import SwiftyJSON

struct JSONNumberView: View {
    let key: String
    let value: JSON

    var body: some View {
        HStack {
            Text("\(key):").bold()
            Text("\(value.numberValue)")
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
