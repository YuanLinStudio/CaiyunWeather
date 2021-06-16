    import XCTest
    @testable import CaiyunWeather
    
    final class CaiyunWeatherTokenRelatedTests: XCTestCase {
        
        func testResponse() {
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
            
            XCTAssertNotNil(firstSource)
            XCTAssertNotNil(secondSource)
            // XCTAssertEqual(firstSource, .remote)
            XCTAssertEqual(secondSource, .local)
            
            XCTAssertNotNil(firstResponse)
            XCTAssertNotNil(secondResponse)
            XCTAssertEqual(firstResponse, secondResponse)
        }
    }
