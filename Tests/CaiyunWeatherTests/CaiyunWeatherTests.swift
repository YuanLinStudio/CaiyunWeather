    import XCTest
    @testable import CaiyunWeather
    
    final class CaiyunWeatherTests: XCTestCase {
        
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
            
            let assertData =
                """
                {
                    "language": "zh_CN",
                    "measurementSystem": "metric",
                    "coordinate": [10, 20],
                    "file": "weather.json",
                    "token": "test-token",
                    "version": "v2.5",
                    "shouldIncludeWarnings": true,
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
            let request = CYRequest()
            request.endpoint.token = token
            request.endpoint.coordinate = CYCoordinate(longitude: 10, latitude: 20)
            XCTAssertEqual(request.endpoint.token, token)
            
            request.fetchDataFromRemote { data, error in
                testData = data
                testError = error
                expectation.fulfill()
            }
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertNotNil(testData)
            XCTAssertNil(testError)
        }
        
        func testNoToken() {
            let expectation = self.expectation(description: "response")
            var testError: CYError?
            
            let request = CYRequest()
            request.fetchDataFromRemote { _, error in
                if let cyError = error as? CYError {
                    testError = cyError
                }
                expectation.fulfill()
            }
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssert(testError! == CYError.tokenIsNil)
        }
        
        func testInvalidResonse() {
            let expectation = self.expectation(description: "response")
            var testError: Error?
            var testDescription: String = ""
            
            let token = "invalid-token"
            let request = CYRequest()
            request.endpoint.token = token
            
            request.fetchDataFromRemote { data, error in
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
            let request = CYRequest()
            request.endpoint.token = token
            request.fetchDataFromRemote { data, error in
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
        
        func testLocalized() {
            let phenomenon: CYContent.Phenomenon = .cloudy
            XCTAssertEqual(phenomenon.localized(), "Cloudy")
        }
        
        func testLocalSourceResponse() {
            let expectation = self.expectation(description: "response")
            var testResponse: CYResponse?
            var testError: Error?
            var testWarningType: CYWarning.WarningContent.WarningCode.WarningType?
            var testWindDirection: String?
            
            let request = CYRequest()
            
            request.fetchExampleData { data, error in
                request.decode(data!) { response, error in
                    testResponse = response
                    testError = error
                    testWarningType = response!.result.warning.content[0].code.type
                    testWindDirection = response!.result.realtime.wind.direction.description
                    expectation.fulfill()
                }
            }
            let assertWarningType: CYWarning.WarningContent.WarningCode.WarningType = .gale
            
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertNil(testError)
            XCTAssertNotNil(testResponse)
            XCTAssertEqual(testWarningType, assertWarningType)
            XCTAssertEqual(testWindDirection!, "SSE")
        }
        
        func testResponseEquallyCodable() {
            let expectation = self.expectation(description: "response")
            var firstResponse: CYResponse?
            var secondResponse: CYResponse?
            var thirdResponse: CYResponse?
            var secondData: Data?
            var thirdData: Data?
            
            let path = Bundle.module.path(forResource: "Weather", ofType: "json")!
            let data = try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            
            let request = CYRequest()
            
            request.decode(data) { response1st, _ in
                firstResponse = response1st
                
                secondData = try? JSONEncoder().encode(firstResponse!)
                
                request.decode(secondData!) { response2nd, _ in
                    secondResponse = response2nd
                    
                    thirdData = try? JSONEncoder().encode(secondResponse!)
                    
                    request.decode(thirdData!) { response3rd, _ in
                        thirdResponse = response3rd
                        
                        expectation.fulfill()
                    }
                }
            }
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertEqual(firstResponse!, secondResponse!)
            XCTAssertNotNil(secondData)
            XCTAssertNotNil(thirdData)
            XCTAssertEqual(secondData, thirdData)
            XCTAssertNotNil(secondResponse)
            XCTAssertNotNil(thirdResponse)
            XCTAssertEqual(secondResponse, thirdResponse)
        }
        
        func testSaveRead() {
            let assertData =
                """
                {
                    "language": "zh_CN",
                    "measurementSystem": "metric",
                    "coordinate": [10, 20],
                    "file": "weather.json",
                    "token": "test-token",
                    "version": "v2.5",
                    "shouldIncludeWarnings": true,
                    "dailyLength": 5,
                    "hourlyLength": 48,
                }
                """
                .data(using: .utf8)!
            
            let request = CYRequest()
            try! request.saveDataToLocal(assertData)
            try! request.saveDataToLocal(assertData)
            
            let testData = try! request.readDataFromLocal()
            
            XCTAssertNotNil(testData)
            XCTAssertEqual(testData, assertData)
        }
        
        func testValidate() {
            let expectation = self.expectation(description: "response")
            var testValid: Bool = true
            
            let request = CYRequest()
            request.fetchExampleData { data, _ in
                request.decode(data!) { response, _ in
                    testValid = request.validate(response!)
                    expectation.fulfill()
                }
            }
            
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertFalse(testValid)
        }
        
        func testSecondRequest() {
            let expectation = self.expectation(description: "response")
            
            var firstResponse: CYResponse?
            var firstSource: CYRequest.DataSource?
            var firstError: Error?
            
            var secondResponse: CYResponse?
            var secondSource: CYRequest.DataSource?
            var secondError: Error?
            
            let token = "sMAot0gj8FX3sipR"
            let coordinate = CYCoordinate(longitude: 121.4474754473953, latitude: 31.025785475418274)
            
            let request = CYRequest()
            request.endpoint.token = token
            request.endpoint.coordinate = coordinate
            request.perform { response1st, source1st, error1st in
                firstResponse = response1st
                firstSource = source1st
                firstError = error1st
                
                request.perform { response2nd, source2nd, error2nd in
                    secondResponse = response2nd
                    secondSource = source2nd
                    secondError = error2nd
                    
                    expectation.fulfill()
                }
            }
            
            waitForExpectations(timeout: 5, handler: nil)
            XCTAssertNil(firstError)
            XCTAssertNil(secondError)
            // XCTAssertEqual(firstSource, .remote)
            XCTAssertEqual(secondSource, .local)
            XCTAssertNotNil(firstResponse)
            XCTAssertNotNil(secondResponse)
            XCTAssertEqual(firstResponse, secondResponse)
        }
        
    }
