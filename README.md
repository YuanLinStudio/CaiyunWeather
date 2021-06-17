# CaiyunWeather

Request weather information from caiyunapp.com in 10 lines of code.

[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange)](https://developer.apple.com/swift)
[![SPM Availble](https://img.shields.io/badge/SPM-compatible-brightgreen)](https://swift.org/package-manager)
[![GitHub license](https://img.shields.io/github/license/YuanLinStudio/CaiyunWeather)](https://github.com/YuanLinStudio/CaiyunWeather)
[![API v2.5](https://img.shields.io/badge/API-v2.5-orange)](https://developer.apple.com/swift)


## Introduction

`CaiyunWeather` is a wrapper for weather service from [caiyunapp.com](http://caiyunapp.com/), written in and availble for Swift.

Different from default JSON Serializer method, `CaiyunWeather` keeps all content as objects and mostly codable. 

You can also define almost everything during your request and result handling. 

`CaiyunWeather` supports decoding API-fetched data to weather content as `CYResponse` object, and encoding your `CYResponse` object to locally saved data. 

Therefore, a built-in method of caching weather content is provided, which means you can cut down your remote API calls and **save your costs**!

## Before you start

1. You have to request a valid token from [http://caiyunapp.com/](http://caiyunapp.com/) (`Chinese`) for yourself. **Always keep your token secret and safe!**
2. You are highly recommended to firstly read the [API documentation](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8) (`Chinese`) from caiyunapp.com.

## Requirements

- Swift 5.0 or later
- Xcode 11 or later
- iOS 10 or later / macOS 10.12 or later

## Installation

### Swift package manager (*Recommended*).

To install `CaiyunWeather` using the [Swift Package Manager](https://swift.org/package-manager/), add it as a dependency into your Package.swift file:

``` swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/YuanLinStudio/CaiyunWeather.git", from: "1.0.0")
    ],
    ...
)
```

## Usage

### Quick Start

Use the code below to perform a request to caiyunapp.com and get the returned data decoded as `CYResponse` object:

``` swift
import CaiyunWeather

let token = "your-token-here"
// the place's coordinate of which you want to request weather
let coordinate = CYCoordinate(latitude: 31.025785475418274, longitude: 121.4474754473953)

// declare an endpoint
let endpoint = CYEndpoint(token: token, coordinate: coordinate)

// declare an request and pass in the endpoint
let request = CYRequest()
request.endpoint = endpoint

// request the data
request.perform { response, source, error in
    guard let response = response, error == nil else {
        print(error.debugDescription)
        return
    }
    print(response)
    // your subsequent actions for `CYResponse?` result.
}
```

## License

MIT

## Disclaimer

- This project has no direct connection with caiyunapp.com. 
- caiyunapp.com is neither a content provider nor a sponsor for this project. 
- All rights that belong to caiyunapp.com are respected.
