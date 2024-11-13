import Foundation
import SwiftyJSON

struct Item: Identifiable {
    // Using `_hash` as the unique ID
    var id: String {
        json["_hash"].stringValue
    }
    
    let json: JSON
    
    // Accessors for known JSON properties
    var schema: String {
        json["schema"].stringValue
    }
    
    var hash: String {
        json["_hash"].stringValue
    }
    
    var hashAlternate: String {
        json["_$hash"].stringValue
    }
    
    var timestamp: Int {
        json["_timestamp"].intValue
    }
}
