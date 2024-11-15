import Foundation
import SwiftyJSON
import XyoClient

extension Payload {
    func toJSON() -> JSON? {
        do {
            let data = try JSONEncoder().encode(self)
            return JSON(data)
        } catch {
            print("Failed to encode XyoPayload to JSON:", error)
            return nil
        }
    }
}
