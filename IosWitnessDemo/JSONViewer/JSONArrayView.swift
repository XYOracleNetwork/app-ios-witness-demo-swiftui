import SwiftUI
import SwiftyJSON

struct JSONArrayView: View {
    let key: String
    let array: [JSON]

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(key):").bold()
            ForEach(0..<array.count, id: \.self) { index in
                JSONValueView(key: "\(key)[\(index)]", value: array[index])
                    .padding(.leading, 10)
            }
        }
    }
}
