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
import XCTest

@testable import SiopOpenID4VP

final class VerifierIdTests: XCTestCase {

  // Test successful parsing for valid client IDs with prefixes
  func testParseValidClientIdWithPrefix() {
    let validClientId = "\(OpenId4VPSpec.clientIdSchemeRedirectUri):exampleClientId"
    let result = VerifierId.parse(clientId: validClientId)

    switch result {
    case .success(let verifierId):
      XCTAssertEqual(verifierId.scheme, .redirectUri)
      XCTAssertEqual(verifierId.originalClientId, "exampleClientId")
      XCTAssertEqual(verifierId.clientId, validClientId)
    case .failure:
      XCTFail("Parsing failed for valid client ID")
    }
  }

  // Test successful parsing for valid client IDs without prefixes
  func testParseValidClientIdWithoutPrefix() {
    let validClientId = "exampleClientId"
    let result = VerifierId.parse(clientId: validClientId)

    switch result {
    case .success(let verifierId):
      XCTAssertEqual(verifierId.scheme, .preRegistered)
      XCTAssertEqual(verifierId.originalClientId, validClientId)
      XCTAssertEqual(verifierId.clientId, validClientId)
    case .failure:
      XCTFail("Parsing failed for valid client ID without prefix")
    }
  }

  // Test failure for invalid client ID scheme
  func testParseInvalidClientIdScheme() {
    let invalidClientId = "invalidScheme:exampleClientId"
    let result = VerifierId.parse(clientId: invalidClientId)

    switch result {
    case .success:
      XCTFail("Parsing should have failed for invalid client ID scheme")
    case .failure(let error):
      XCTAssert(error.localizedDescription.contains("does not contain a valid Client ID Scheme"))
    }
  }

  // Test failure for pre-registered scheme
  func testParsePreRegisteredClientIdScheme() {
    let clientId = "\(ClientIdScheme.preRegistered.rawValue):exampleClientId"
    let result = VerifierId.parse(clientId: clientId)

    switch result {
    case .success:
      XCTFail("Parsing should have failed for pre-registered scheme")
    case .failure(let error):
      XCTAssert(error.localizedDescription.contains("'preRegistered' cannot be used as a Client ID Scheme"))
    }
  }

  // Test valid HTTPS scheme
  func testParseValidHttpsClientId() {
    let clientId = "\(OpenId4VPSpec.clientIdSchemeHttps):exampleClientId"
    let result = VerifierId.parse(clientId: clientId)

    switch result {
    case .success(let verifierId):
      XCTAssertEqual(verifierId.scheme, .https)
      XCTAssertEqual(verifierId.originalClientId, clientId)
      XCTAssertEqual(verifierId.clientId, clientId)
    case .failure:
      XCTFail("Parsing failed for valid HTTPS client ID")
    }
  }

  // Test valid DID scheme
  func testParseValidDidClientId() {
    let clientId = "\(OpenId4VPSpec.clientIdSchemeDid):exampleClientId"
    let result = VerifierId.parse(clientId: clientId)

    switch result {
    case .success(let verifierId):
      XCTAssertEqual(verifierId.scheme, .did)
      XCTAssertEqual(verifierId.originalClientId, clientId)
      XCTAssertEqual(verifierId.clientId, clientId)
    case .failure:
      XCTFail("Parsing failed for valid DID client ID")
    }
  }

  // Test clientId property for different schemes
  func testClientIdProperty() {
    let verifierId = VerifierId(scheme: .redirectUri, originalClientId: "exampleClientId")
    XCTAssertEqual(verifierId.clientId, "\(OpenId4VPSpec.clientIdSchemeRedirectUri):exampleClientId")
  }
}
