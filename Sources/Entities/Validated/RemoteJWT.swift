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

public struct RemoteJWT: Codable, Equatable {
  let jwt: JWTString

  public init(jwt: JWTString) {
    self.jwt = jwt
  }
}

extension RemoteJWT {

  enum Key: String, CodingKey {
    case jwt
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: Key.self)
    try? container.encode(jwt, forKey: .jwt)
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: Key.self)
    jwt = try container.decode(String.self, forKey: .jwt)

    if !jwt.isValidJWT() {
      throw JSONParseError.invalidJWT
    }
  }
}
