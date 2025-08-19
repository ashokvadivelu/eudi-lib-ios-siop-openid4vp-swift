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

public struct VPConfiguration: Sendable {
  public let presentationDefinitionUriSupported: Bool = true
  public let knownDCQLQueriesPerScope: [String: DCQL] = [:]
  public let vpFormatsSupported: VpFormatsSupported
  public let supportedTransactionDataTypes: [SupportedTransactionDataType]

  public static func `default`() -> VPConfiguration {
    try! .init(
      vpFormatsSupported: .init(
        values: [
          .sdJwtVc(
            sdJwtAlgorithms: [JWSAlgorithm(.ES256)],
            kbJwtAlgorithms: [JWSAlgorithm(.ES256)]
          ),
          .msoMdoc(algorithms: [JWSAlgorithm(.ES256)])
        ]
      ),
      supportedTransactionDataTypes: [
        .init(
          type: .init(value: "authorization"),
          hashAlgorithms: Set([.sha256])
        )
      ]
    )
  }

  public init(
    presentationDefinitionUriSupported: Bool = true,
    vpFormatsSupported: VpFormatsSupported,
    supportedTransactionDataTypes: [SupportedTransactionDataType]
  ) {
    self.vpFormatsSupported = vpFormatsSupported
    self.supportedTransactionDataTypes = supportedTransactionDataTypes
  }
}
