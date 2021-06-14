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
            endpoint.language = .englishUS
            endpoint.measurementSystem = .imperial
            endpoint.dailyLength = 14
            
            let assertResult = "https://api.caiyunapp.com/v2.5/test-token/10.0000,20.0000/weather.json?alert=true&lang=en_US&unit=imperial&dailysteps=14&hourlysteps=48"
            XCTAssertEqual(endpoint.url.absoluteString, assertResult)
        }
        
        func testEndpointCodable() {
            let coordinate = CYCoordinate(longitude: 10, latitude: 20)
            let endpoint = CYEndpoint(token: "test-token", coordinate: coordinate)
            if let data = try? JSONEncoder().encode(endpoint) {
                print(String(data: data, encoding: .utf8)!)
            }
            
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
                     "isAlarmIncluded": true,
                     "dailyLength": 5,
                     "hourlyLength": 48,
                }
                """
                .data(using: .utf8)!
            
            let assertObject = try! JSONDecoder().decode(CYEndpoint.self, from: assertData)
            
            XCTAssertEqual(endpoint, assertObject)
        }
        
        func testRequestValidResponded() {
            let expectation = self.expectation(description: "request")
            var testData: Data?
            var testError: Error?
            
            let token = "test-token"
            let request = CYRequest(token: token)
            request.endpoint.coordinate = CYCoordinate(longitude: 10, latitude: 20)
            XCTAssertEqual(request.endpoint.token, token)
            
            request.request { data, error in
                testData = data
                testError = error
                expectation.fulfill()
            }
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertNotNil(testData)
            XCTAssertNil(testError)
        }
        
        func testInvalidResonse() {
            let expectation = self.expectation(description: "response")
            var testError: Error?
            var testDescription: String = ""
            
            let token = "invalid-token"
            let request = CYRequest(token: token)
            request.request { data, error in
                request.decode(data!) { _, error in
                    testError = error
                    switch error {
                    case .invalidResponse(let description):
                        testDescription = description
                    default:
                        return
                    }
                    expectation.fulfill()
                }
            }
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssert(testError! is CYError)
            XCTAssertEqual(testDescription, "'token is invalid'")
        }
        
        func testResonse() {
            let expectation = self.expectation(description: "response")
            var testResponse: CYResponse?
            var testError: Error?
            
            let token = "sMAot0gj8FX3sipR"
            let request = CYRequest(token: token)
            request.request { data, error in
                request.decode(data!) { response, error in
                    testResponse = response
                    testError = error
                    expectation.fulfill()
                }
            }
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertNil(testError)
            XCTAssertNotNil(testResponse)
        }
    }
