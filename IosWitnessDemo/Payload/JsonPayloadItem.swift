import Foundation
import SwiftyJSON

struct JsonPayloadItem: Identifiable {
  //    // Using `_hash` as the unique ID
  //    var id: String {
  //        json["_hash"].stringValue
  //    }
  let id: UUID = UUID()

  let json: JSON

  // Accessors for known JSON properties
  var schema: String {
    json["schema"].stringValue
  }

  var hash: String {
    json["_hash"].stringValue
  }

  var rootHash: String {
    json["_$hash"].stringValue
  }

  var timestamp: Int {
    json["_timestamp"].intValue
  }
}
