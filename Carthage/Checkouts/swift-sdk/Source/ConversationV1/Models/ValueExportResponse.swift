/**
 * Copyright IBM Corporation 2017
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import RestKit

/** ValueExportResponse. */
public struct ValueExportResponse: JSONDecodable, JSONEncodable {

    /// The name of the corresponding entity.
    public let value: String

    /// Any metadata related to the entity value.
    public let metadata: [String: Any]

    /// The timestamp for creation of the entity value.
    public let created: String

    /// The timestamp for the last update to the entity value.
    public let updated: String

    /// An array of synonyms.
    public let synonyms: [String]?

    /**
     Initialize a `ValueExportResponse` with member variables.

     - parameter value: The name of the corresponding entity.
     - parameter metadata: Any metadata related to the entity value.
     - parameter created: The timestamp for creation of the entity value.
     - parameter updated: The timestamp for the last update to the entity value.
     - parameter synonyms: An array of synonyms.

     - returns: An initialized `ValueExportResponse`.
    */
    public init(value: String, metadata: [String: Any], created: String, updated: String, synonyms: [String]? = nil) {
        self.value = value
        self.metadata = metadata
        self.created = created
        self.updated = updated
        self.synonyms = synonyms
    }

    // MARK: JSONDecodable
    /// Used internally to initialize a `ValueExportResponse` model from JSON.
    public init(json: JSON) throws {
        value = try json.getString(at: "value")
        metadata = try json.getDictionaryObject(at: "metadata")
        created = try json.getString(at: "created")
        updated = try json.getString(at: "updated")
        synonyms = try? json.decodedArray(at: "synonyms", type: String.self)
    }

    // MARK: JSONEncodable
    /// Used internally to serialize a `ValueExportResponse` model to JSON.
    public func toJSONObject() -> Any {
        var json = [String: Any]()
        json["value"] = value
        json["metadata"] = metadata
        json["created"] = created
        json["updated"] = updated
        if let synonyms = synonyms {
            json["synonyms"] = synonyms.map { $0 }
        }
        return json
    }
}
