import Foundation
import SwiftyJSON
import XyoClient

extension XyoPayload {
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
