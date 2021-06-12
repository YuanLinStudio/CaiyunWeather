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
    }
