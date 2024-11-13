import SwiftUI
import SwiftyJSON

struct JSONObjectView: View {
    let key: String
    let object: JSON

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(key):").bold()
            ForEach(object.dictionaryValue.keys.sorted(), id: \.self) { nestedKey in
                JSONValueView(key: nestedKey, value: object[nestedKey])
                    .padding(.leading, 10)
            }
        }
    }
}
