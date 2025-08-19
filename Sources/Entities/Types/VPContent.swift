/*
 * Copyright (c) 2023 European Commission
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Foundation
import SwiftyJSON

public enum VpContent: Sendable {
  case dcql(verifiablePresentations: [QueryId: [VerifiablePresentation]])
  
  static func encodeDCQLQuery(
    _ query: [QueryId: [VerifiablePresentation]]
  ) -> [String: JSON] {
    
    var components: [String: JSON] = [:]
    for (key, presentations) in query {
      // Encode the array of presentations into JSON
      let jsonArray: [JSON] = presentations.map { presentation in
        switch presentation {
        case .generic(let value):
          return JSON(value)
        case .json(let value):
          return value
        }
      }
      
      // Store as a JSON array under the query ID
      components[key.value] = JSON(jsonArray)
    }
    
    return components
  }
}
