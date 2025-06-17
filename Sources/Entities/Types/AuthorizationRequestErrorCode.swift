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

enum AuthorizationRequestErrorCode: String {
  // OAUTH2 & OpenID4VP

  /// Requested scope value is invalid, unknown, or malformed
  case invalidScope = "invalid_scope"

  /// Various invalid request scenarios
  case invalidRequest = "invalid_request"

  /// The Wallet did not have the requested Credentials to satisfy the Authorization Request.
  case accessDenied = "access_denied"

  /// client_metadata parameter is present, but the Wallet recognizes Client Identifier
  case invalidClient = "invalid_client"

  /// The Wallet does not support any of the formats requested by the Verifier
  case vpFormatsNotSupported = "vp_formats_not_supported"

  /// The Presentation Definition URL cannot be reached
  case invalidPresentationDefinitionURI = "invalid_presentation_definition_uri"

  /// The Presentation Definition URL can be reached, but the specified presentation_definition cannot be found
  case invalidPresentationDefinitionReference = "invalid_presentation_definition_reference"

  /// The value of the request_uri_method request parameter is neither get nor post
  case invalidRequestURIMethod = "invalid_request_uri_method"

  case invalidTransactionData = "invalid_transaction_data"

  // SIOPv2 Error Codes
  case userCancelled = "user_cancelled"
  case registrationValueNotSupported = "registration_value_not_supported"
  case subjectSyntaxTypesNotSupported = "subject_syntax_types_not_supported"
  case invalidRegistrationURI = "invalid_registration_uri"
  case invalidRegistrationObject = "invalid_registration_object"

  // JAR errors
  case invalidRequestURI = "invalid_request_uri"
  case invalidRequestObject = "invalid_request_object"
  case requestURINotSupported = "request_uri_not_supported"

  case processingFailure = "processing_error"
}

extension AuthorizationRequestErrorCode {

  /// Maps an `AuthorizationRequestError` into an `AuthorizationRequestErrorCode`
  static func fromError(_ error: AuthorizationRequestError) -> AuthorizationRequestErrorCode {
    if let validatetionError = error as? ValidationError {
      switch validatetionError {
      default: return .invalidRequest
      }
    }
    return .invalidRequest
  }
}
