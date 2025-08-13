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
import PresentationExchange

extension ResolvedRequestData {
  /// A structure representing the data related to ID token and verifiable presentation (VP) token.
  public struct IdAndVpTokenData: Sendable {
    public let idTokenType: IdTokenType
    public let presentationQuery: PresentationQuery
    public let presentationDefinition: PresentationDefinition
    public let clientMetaData: ClientMetaData.Validated?
    public let client: Client
    public let nonce: String
    public let responseMode: ResponseMode?
    public let state: String?
    public let scope: Scope?
    public let vpFormatsSupported: VpFormatsSupported
    public let transactionData: [TransactionData]?
    public let jarmRequirement: JARMRequirement?
    public let verifierAttestations: [VerifierAttestation]?

    /// Initializes the `IdAndVpTokenData` structure with the provided values.
    /// - Parameters:
    ///   - idTokenType: The type of the ID token.
    ///   - presentationDefinition: The presentation definition.
    ///   - clientMetaData: The client metadata.
    ///   - nonce: The nonce.
    ///   - responseMode: The response mode.
    ///   - state: The state.
    ///   - scope: The scope.
    ///   - vpFormatsSupported: Vp Formats
    ///   - transactionData: Optional list of transcation data
    ///   - verifierAttestations: Optional list of verifierAttestations
    ///   - jarmRequirement: JARM
    public init(
      idTokenType: IdTokenType,
      presentationQuery: PresentationQuery,
      presentationDefinition: PresentationDefinition,
      clientMetaData: ClientMetaData.Validated?,
      client: Client,
      nonce: String,
      responseMode: ResponseMode?,
      state: String?,
      scope: Scope?,
      vpFormatsSupported: VpFormatsSupported,
      transactionData: [TransactionData]? = nil,
      verifierAttestations: [VerifierAttestation]? = nil,
      jarmRequirement: JARMRequirement? = nil
    ) {
      self.idTokenType = idTokenType
      self.presentationQuery = presentationQuery
      self.presentationDefinition = presentationDefinition
      self.clientMetaData = clientMetaData
      self.client = client
      self.nonce = nonce
      self.responseMode = responseMode
      self.state = state
      self.scope = scope
      self.vpFormatsSupported = vpFormatsSupported
      self.transactionData = transactionData
      self.verifierAttestations = verifierAttestations
      self.jarmRequirement = jarmRequirement
    }
  }
}
