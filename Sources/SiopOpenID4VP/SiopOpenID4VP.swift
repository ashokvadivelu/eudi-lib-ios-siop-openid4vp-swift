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
@_exported import PresentationExchange
import SwiftyJSON

/**
 OpenID for Verifiable Presentations

 - Requesting and presenting Verifiable Credentials
   Reference: https://openid.net/specs/openid-4-verifiable-presentations-1_0.html
 
 */
public protocol SiopOpenID4VPType {
  func authorize(url: URL) async -> AuthorizationRequest
  func match(presentationDefinition: PresentationDefinition, claims: [Claim]) -> Match
  func dispatch(response: AuthorizationResponse) async throws -> DispatchOutcome
  func submit()
  func consent()
}

public class SiopOpenID4VP: SiopOpenID4VPType {

  let walletConfiguration: SiopOpenId4VPConfiguration?
  let authorizatinRequestResolver: AuthorizationRequestResolving

  public init(
    walletConfiguration: SiopOpenId4VPConfiguration? = nil,
    authorizatinRequestResolver: AuthorizationRequestResolving = AuthorizationRequestResolver()
  ) {
    self.walletConfiguration = walletConfiguration
    self.authorizatinRequestResolver = authorizatinRequestResolver
    registerDependencies()
  }

  public func authorize(url: URL) async -> AuthorizationRequest {

    guard let walletConfiguration = walletConfiguration else {
      return .invalidResolution(
        error: ValidationError.nonDispatchable(
          ValidationError.missingConfiguration
        ),
        dispatchDetails: nil
      )
    }

    let unvalidatedRequest = UnvalidatedRequest.make(from: url.absoluteString)
    switch unvalidatedRequest {
    case .success(let request):
      return await authorizatinRequestResolver.resolve(
        walletConfiguration: walletConfiguration,
        unvalidatedRequest: request
      )

    case .failure(let error):
      return .invalidResolution(
        error: ValidationError.validationError(error.localizedDescription),
        dispatchDetails: nil
      )
    }
  }

  /**
   Matches a presentation definition to a list of claims.

   - Parameters:
    - presentationDefinition: A valid URL
    - claims: A list of claim objects

   - Returns: A ClaimsEvaluation object, empty or with matches
   */
  public func match(presentationDefinition: PresentationDefinition, claims: [Claim]) -> Match {
    let matcher = PresentationMatcher()
    return matcher.match(claims: claims, with: presentationDefinition)
  }

  /**
   Dispatches an autorisation request.

   - Parameters:
    - response: An AuthorizationResponse

   - Returns: A DispatchOutcome enum
   */
  public func dispatch(response: AuthorizationResponse) async throws -> DispatchOutcome {

    let dispatcher = Dispatcher(
      authorizationResponse: response
    )

    return try await dispatcher.dispatch(
      poster: Poster(
        session: walletConfiguration?.session ?? URLSession.shared
      )
    )
  }

  /**
   Dispatches an autorisation request.

   - Parameters:
    - response: An AuthorizationResponse

   - Returns: A DispatchOutcome enum
   */
  public func dispatch(
    error: AuthorizationRequestError,
    details: ErrorDispatchDetails?
  ) async throws -> DispatchOutcome {

    let dispatcher = ErrorDispatcher(
      error: error,
      details: details
    )

    return try await dispatcher.dispatch(
      poster: Poster(
        session: walletConfiguration?.session ?? URLSession.shared
      )
    )
  }

  /**
   WIP: Consent to matches
   */
  public func consent() {}

  /**
   WIP: Submits a request
   */
  public func submit() {}
}

private extension SiopOpenID4VP {
  func registerDependencies() {
    DependencyContainer.shared.register(type: Reporting.self, dependency: {
      Reporter()
    })
  }
}
