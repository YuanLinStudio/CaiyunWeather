    import XCTest
    @testable import CaiyunWeather
    
    final class CaiyunWeatherTests: XCTestCase {
        func testExample() {
            // This is an example of a functional test case.
            // Use XCTAssert and related functions to verify your tests produce the correct
            // results.
            XCTAssertEqual(CaiyunWeather().text, "Hello, World!")
        }
        
        func testEndpointContent() {
            let coordinate = CYCoordinate(longitude: 10, latitude: 20)
            
            var endpoint = CYEndpoint(token: "test-token", coordinate: coordinate)
            endpoint.language = "en_US"
            endpoint.measurementSystem = .imperial
            
            let assertResult = "https://api.caiyunapp.com/v2.5/test-token/10.0000,20.0000/weather.json?alert=true&lang=en_US&unit=imperial"
            XCTAssertEqual(endpoint.url.absoluteString, assertResult)
        }
        
        func testEndpointCodable() {
            let coordinate = CYCoordinate(longitude: 10, latitude: 20)
            let endpoint = CYEndpoint(token: "test-token", coordinate: coordinate)
            
            let assertData =
                """
                {
                    "language": "zh_CN",
                    "measurementSystem": "metric",
                    "coordinate":
                    {
                        "longitude": 10,
                        "latitude": 20,
                    },
                    "file": "weather.json",
                    "token": "test-token",
                    "version": "v2.5",
                }
                """
                .data(using: .utf8)!
            let assertObject = try! JSONDecoder().decode(CYEndpoint.self, from: assertData)
            
            XCTAssertEqual(endpoint, assertObject)
        }
        
        func testRequestValidResponded() {
            let expectation = self.expectation(description: "request")
            var respondData: Data?
            var respondError: Error?
            
            let token = "test-token"
            let request = CYRequest(token: token)
            request.endpoint.coordinate = CYCoordinate(longitude: 10, latitude: 20)
            XCTAssertEqual(request.endpoint.token, token)
            
            request.request { data, error in
                respondData = data
                respondError = error
                expectation.fulfill()
            }
            
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertNotNil(respondData)
            XCTAssertNil(respondError)
        }
        
        func testInvalidResonse() {
            let expectation = self.expectation(description: "request")
            var respondError: Error?
            var respondDescription: String = ""
            
            let token = "invalid-token"
            let request = CYRequest(token: token)
            request.request { data, error in
                request.decode(data!) { error in
                    respondError = error
                    if let error = error! as? CYError {
                        switch error {
                        case .invalidResponse(let description):
                            respondDescription = description
                        default:
                            return
                        }
                    }
                    expectation.fulfill()
                }
            }
            
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssert(respondError! is CYError)
            XCTAssertEqual(respondDescription, "'token is invalid'")
        }
    }
