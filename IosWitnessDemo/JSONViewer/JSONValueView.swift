import SwiftUI
import SwiftyJSON

struct JSONValueView: View {
  let key: String
  let value: JSON

  var body: some View {
    if value.number != nil {
      JSONNumberView(key: key, value: value)
    } else if value.rawValue is String {
      JSONStringView(key: key, value: value)
    } else if value.array != nil {
      JSONArrayView(key: key, array: value.arrayValue)
    } else if value.dictionary != nil {
      JSONObjectView(key: key, object: value)
    } else {
      HStack {
        Text("\(key):").bold()
        Text("null")
      }
    }
  }
}
