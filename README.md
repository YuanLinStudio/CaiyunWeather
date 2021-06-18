# CaiyunWeather

Request weather information from caiyunapp.com in 10 lines of code.

10 行代码搞定彩云天气 API。

[![API v2.5](https://img.shields.io/badge/API-v2.5-orange)](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8)
[![SPM Availble](https://img.shields.io/badge/SPM-compatible-brightgreen)](https://swift.org/package-manager)
[![GitHub license](https://img.shields.io/github/license/YuanLinStudio/CaiyunWeather)](https://github.com/YuanLinStudio/CaiyunWeather)
[![Chinese Docs available](https://img.shields.io/badge/CN_Docs-available-brightgreen)](README-zh.md)

中文版本，访问[这里](README-zh.md)。


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

### Swift Package Manager

To install `CaiyunWeather` using the [Swift Package Manager](https://swift.org/package-manager/), add it as a dependency into your `Package.swift` file:

``` swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/YuanLinStudio/CaiyunWeather.git", from: "1.0.0")
    ],
    ...
)
```


## Quick starts

Use the code below to perform a request to caiyunapp.com and get the returned data decoded as `CYResponse` object:

``` swift
import CaiyunWeather

let token: String = "your-token-here"

// the place's coordinate of which you want to request weather
let coordinate = CYCoordinate(latitude: 31.025785475418274, longitude: 121.4474754473953)

// declare an request
let request = CYRequest(token: token, coordinate: coordinate)

// request the data
request.perform { response, source, error in
    guard let response = response, error == nil else {
        print(error.debugDescription)
        return
    }
    print(response)
    // your subsequent actions for `CYResponse?` result ...
}
```


## Making your API request

### Altering API-related options of your request

All API-related options are defined in `CYRequest.endpoint`. Please read [API documentation - API Request](https://open.caiyunapp.com/%E9%80%9A%E7%94%A8%E9%A2%84%E6%8A%A5%E6%8E%A5%E5%8F%A3/v2.5#.E8.AF.B7.E6.B1.82.E5.8F.82.E6.95.B0) (`Chinese`) before choosing your request options.

All options are shown below:

| Path of parameter | Description | Type | Default value |
| ---- | ---- | ---- | ---- |
| `CYRequest.endpoint.token` | Your valid API token. | `String!` | `nil` |
| `CYRequest.endpoint.coordinate` | The place's coordinate you want to request weather of. | `CYCoordinate` | `.defaultCoordinate` as (0, 0) |
| `CYRequest.endpoint.language` | The displaying language of the response. | `CYEndpoint.RequestLanguage` | `.chineseSimplified` |
| `CYRequest.endpoint.measurementSystem` | The unit system of the response. | `CYEndpoint.MeasurementSystem` (equal to `CYUnit`) | `.metric` |
| `CYRequest.endpoint.shouldIncludeAlerts` | Would you like to receive weather alerts in your response. | `Bool` | `true` |
| `CYRequest.endpoint.hourlyLength` | How many hours would you like to receive hourly weather content. | `Int` | `48` |
| `CYRequest.endpoint.dailyLength` | How many days would you like to receive daily weather content. | `Int` | `5` |
| `CYRequest.endpoint.file` | The target file of the response. *You are not recommended to change this parameter.* | `String` | `"weather.json"` |
| `CYRequest.endpoint.version` | API version. *You are not recommended to change this parameter.* | `String` | `"v2.5"` |

To alter a parameter, initialize your `CYRequest` object (recommended with `let` statement), and use `<path> = <value>` to make changes. Or, you may define a `CYEndpoint` object and make your alternations, then pass it to `CYRequest` object by `<yourCYRequestObject>.endpoint = <yourCYEndpointObject>`.

Use `CYRequest.endpoint.url` to get the URL after your alternation if in need. Note it can be `nil` if your haven't passed in a token.

> #### Working with `CYCoordinate`
> 
> `CYCoordinate` provides several ways to initialize: 
> 1. with longitude and latitude
> 2. with `CLLocationCoordinate2D` objects from Apple's `CoreLocation` Framework
> 3. API related initializer and handler
> 
> To get user's location or a pin from map, please use `CoreLocation` or `MapKit` to get the coordinate.

### Altering other options of your request

You may also redefine the data expiration, queue on which to perform actions or caching options if needed.

All options are shown below:

| Path of parameter | Description | Type | Default value |
| ---- | ---- | ---- | ---- |
| `CYRequest.expiration` | How long the local data is valid. | `TimeInterval` | `5 * 60` |
| `CYRequest.queue` | On which queue to perform `CYRequest` actions. | `DispatchQueue` | `.global(qos: .background)` |
| `CYRequest.localContentUrl` | Where to save API-returned cached data. | `URL` | `.cachesDirectory` |

To alter a parameter, initialize your `CYRequest` object (recommended with `let` statement), and use `<path> = <value>` to make changes.

Locally cached files will be saved in `CYRequest.localContentUrl` with files named `<longitude in %.4f>,<latitude in %.4f>`. This cannot be changed currently.

### Convenient initializers

If you don't have the above two requirements (just keep them as default), or you would prefer overwriting parameters after they are initialized, you may use convenient initializers to quickly start up with your request.

The three initializing statements below are equal:

``` swift
let token: String = "your-token-here"
let coordinate = CYCoordinate(latitude: 31.025785475418274, longitude: 121.4474754473953)

let request = CYRequest(token: token, coordinate: coordinate)
```

``` swift
let token: String = "your-token-here"
let coordinate = CYCoordinate(latitude: 31.025785475418274, longitude: 121.4474754473953)

let endpoint = CYEndpoint(token: token, coordinate: coordinate)

let request = CYRequest()
request.endpoint = endpoint
```

``` swift
let token: String = "your-token-here"
let coordinate = CYCoordinate(latitude: 31.025785475418274, longitude: 121.4474754473953)

var endpoint = CYEndpoint()
endpoint.token = token
endpoint.coordinate = coordinate

let request = CYRequest()
request.endpoint = endpoint
```


## Performing your request

You should perform your request to get weather contents, either from remote or local. 

> Before continuing, make sure you have finished your request initialization.

### Automatically choosing target

Use `CYRequest.perform(completionHandler: @escaping (CYResponse?, CYRequest.DataSource, Error?) -> Void)` to perform your request by auto choosing target. That means, The local cached data will be fetched if the following 3 conditions are met:

1. the local cached file exists with no decoding errors; and
2. it is for the coordinate you are requiring (rounded to `%.4f`, about 100 meters in distance); and
3. it is not expired.

Elsewise, a new data will be fetched from remote API and then cached.

`CYRequest.DataSource` as parameter for the `completionHandler` receives the target from which the data is fetched. `.local` means local cache, while `.remote` means remote API.

### Explicitly choosing local or remote fetching

You may use `CYRequest.perform(from dataSource: CYRequest.DataSource, completionHandler: @escaping (CYResponse?, CYRequest.DataSource, Error?) -> Void)` if you want to perform your request towards an explicit target. Set `dataSource` to `.local` if you want to fatch data from local cache, or `.remote` from remote API.

### Fetching Data without decoding to `CYResponse` object

You may use `CYRequest.fetchData(from dataSource: CYRequest.DataSource, completionHandler: @escaping (Data?, Error?) -> Void)` if you want to fatch data without decoding it to `CYResponse` object. This shall only be used for debugging and internal using.

### Fetching Example Data

An example JSON file is included in this package for debugging use. Call `CYRequest.fetchExampleData(completionHandler: @escaping (Data?, Error?) -> Void)` to get it.

The example JSON file is a response from caiyunapp.com API, at date of 2021-04-14 and coordinate of (112.8641, 35.4904), which is located in Jincheng, Shanxi, China.

### Using native `URLSession.dataTask` to fetch data from remote

**Not recommended.** Note that `dataTask`s are internally wrapped into `perform` and `fatchData`, so you should mostly use them instead. 

However, if you would prefer to hard-code your URL or you need to do so, the code below may help you. 

``` swift
let url = "your.valid.url/for/api/requests"

URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
    // deal with data ...
}
.resume()
```

### Decoding your data to `CYResponse` object

**Content received by `perform` are ready-to-use and DO NOT need to decode. Skip this section and go ahead.** 

If you have your data ready (either fetched with `fatchData`, fetched with `dataTask`, or loaded from local cache), you may use `CYRequest.decode(_ data: Data, completionHandler: @escaping (CYResponse?, CYError?) -> Void)` to decode your data to `CYResponse` object.


## Working with API response

> Before continuing, you are highly recommended to read the [API documentation](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8) (`Chinese`) to have a brief outline of the response content.

The default contents are very long, that means few people will use all of them. Therefore, **you are very welcomed to define your own data model, with an adaptor from `CYResponse`**.

Some instructions about content types and return types are as follows. You are encouraged to read them all together, but here's an alternation for you: just skip this section and continue, come back when you meet problems.

### `CYContent` types

`CYContent` defines some common types for weather content, which are handful to reuse.

#### Physical types

| Type | Description | Prpoerties |
| ---- | ---- | ---- |
| `CYContent.Datetime1970Based` |  | `time` |
| `CYContent.DatetimeServerType` |  | `time` |
| `CYContent.LifeIndex<T>` | Life indices with optional properties of type `T`. | `ultraviolet`, `comfort`, `carWashing`, `coldRisk`, `dressing` |
| `CYContent.Wind` |  | `speed`, `direction` |
| `CYContent.Wind.WindContent` |  | `value`, `description` |
| `CYContent.AirQuality` | Optional properties. | `pm25`, `pm10`, `o3`, `so2`, `no2`, `co`, `aqi`, `description` |
| `CYContent.Phenomenon` | Enumeration. | All cases defined in [API documentation - Phenomenon Codes](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8#.E5.A4.A9.E6.B0.94.E7.8E.B0.E8.B1.A1.E4.BB.A3.E7.A0.81.E8.A1.A8) |

#### Abstruct types

| Type | Description | Prpoerties |
| ---- | ---- | ---- |
| `CYContent.CountryRelated<T>` |  | `chn`, `usa` |
| `CYContent.IndexWithDescription<T>` |  | `index`, `description` |
| `CYContent.AverageAndExtremum<T>` |  | `average`, `maximum`, `minimum` |

> `extension` them to better serve you!

### Response objects

If you have used `perform` or `decode` function above, your content will now be `CYResponse?` object. **Don't forget to unwrap your content.** If there's no error, your content will contain all objects returned and decoded from remote API. `CYResponse` and most nested objects are defined as `struct` with `let` statements to make your workspace clean and save memories of users' device.

The following tables explains `CYResponse` and most nested objects. No description will be provided, as the name of them are defined easy and simple.

#### `CYResponse`

| Property | Type | API Original Key |
| ---- | ---- | ---- |
| `responseStatus` | `String` | `status` |
| `version` | `String` | `api_version` |
| `apiStatus` | `String` | `api_status` |
| `language` | `String` | `lang` |
| `unit` | `CYUnit` | `unit` |
| `coordinate` | `CYCoordinate` | `location` |
| `serverTime` | `CYContent.Datetime1970Based` | `server_time` |
| `serverTimeZone` | `CYTimeZone` | `tzshift` |
| `result` | `CYResult` | `result` |

#### `CYResult`

| Property | Type | API Original Key |
| ---- | ---- | ---- |
| `alert` | `CYAlert` | `alert` |
| `realtime` | `CYRealtime` | `realtime` |
| `minutely` | `CYMinutely` | `minutely` |
| `hourly` | `CYHourly` | `hourly` |
| `daily` | `CYDaily` | `daily` |
| `keypoint` | `String` | `forecast_keypoint` |

#### `CYAlert`

| Property | Type | API Original Key |
| ---- | ---- | ---- |
| `responseStatus` | `String` | `status` |
| `content` | `[CYAlert.AlertContent]` | `content` |

`CYAlert.AlertContent`

| Property | Type | API Original Key |
| ---- | ---- | ---- |
| `publishTime` | `CYContent.Datetime1970Based` | `pubtimestamp` |
| `id` | `String` | `alertId` |
| `status` | `String` | `status` |
| `adcode` | `String` | `adcode` |
| `location` | `String` | `location` |
| `province` | `String` | `province` |
| `city` | `String` | `city` |
| `county` | `String` | `county` |
| `code` | `CYAlert.AlertContent.AlertCode` | `code` |
| `source` | `String` | `source` |
| `title` | `String` | `title` |
| `description` | `String` | `description` |

Redefined types

| Type | Description | Prpoerties |
| ---- | ---- | ---- |
| `CYAlert.AlertContent.AlertCode` |  | `type`, `level` |
| `CYAlert.AlertContent.AlertCode.AlertType` |  | All cases defined in [API documentation - Alert type codes](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8#.E9.A2.84.E8.AD.A6.E7.B1.BB.E5.9E.8B.E7.BC.96.E7.A0.81.E5.AF.B9.E7.85.A7.E8.A1.A8) |
| `CYAlert.AlertContent.AlertCode.AlertLevel` |  | All cases defined in [API documentation - Alert level codes](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8#.E9.A2.84.E8.AD.A6.E7.BA.A7.E5.88.AB.E7.BC.96.E7.A0.81.E5.AF.B9.E7.85.A7.E8.A1.A8) |

#### `CYRealtime`

| Property | Type | API Original Key |
| ---- | ---- | ---- |
| `responseStatus` | `String` | `status` |
| `temperature` | `Double` | `temperature` |
| `apparentTemperature` | `Double` | `apparent_temperature` |
| `pressure` | `Double` | `pressure` |
| `humidity` | `Double` | `humidity` |
| `cloudrate` | `Double` | `cloudrate` |
| `phenomenon` | `CYContent.Phenomenon` | `skycon` |
| `visibility` | `Double` | `visibility` |
| `dswrf` | `Double` | `dswrf` |
| `wind` | `CYContent.Wind` | `wind` |
| `precipitation` | `CYRealtime.Precipitation` | `precipitation` |
| `airQuality` | `CYContent.AirQuality?` | `air_quality` |
| `lifeIndex` | `CYContent.LifeIndex<CYContent.IndexWithDescription<Int>>` | `life_index` |

Redefined types

| Type | Description | Prpoerties |
| ---- | ---- | ---- |
| `CYRealtime.Precipitation` |  | `local`, `nearest` |
| `CYRealtime.Precipitation.PrecipitationContent` | `datasource` and `distance` are optional. | `responseStatus`, `datasource`, `intensity`, `distance` |

#### `CYMinutely`

| Property | Type | API Original Key |
| ---- | ---- | ---- |
| `datasource` | `String` | `datasource` |
| `description` | `String` | `description` |
| `probability` | `[Double]` | `probability` |
| `intensity` | `[Double]` | `precipitation_2h` |

#### `CYHourly`

| Property | Type | API Original Key |
| ---- | ---- | ---- |
| `responseStatus` | `String` | `status` |
| `description` | `String` | `description` |
| `phenomenon` | `[CYHourly.ValueWithDatetime<CYContent.Phenomenon>]` | `skycon` |
| `temperature` | `[CYHourly.ValueWithDatetime<Double>]` | `temperature` |
| `precipitation` | `[CYHourly.ValueWithDatetime<Double>]` | `precipitation` |
| `cloudrate` | `[CYHourly.ValueWithDatetime<Double>]` | `cloudrate` |
| `humidity` | `[CYHourly.ValueWithDatetime<Double>]` | `humidity` |
| `pressure` | `[CYHourly.ValueWithDatetime<Double>]` | `pressure` |
| `wind` | `[CYHourly.ValueWithDatetimeFlat<CYContent.Wind>]` | `wind` |
| `visibility` | `[CYHourly.ValueWithDatetime<Double>]` | `visibility` |
| `dswrf` | `[CYHourly.ValueWithDatetime<Double>]` | `dswrf` |
| `airQuality` | `CYHourly.AirQuality` | `air_quality` |

Redefined types

| Type | Description | Prpoerties |
| ---- | ---- | ---- |
| `CYHourly.AirQuality` |  | `aqi`, `pm25` |

Abstruct types

| Type | Description | Prpoerties |
| ---- | ---- | ---- |
| `CYHourly.ValueWithDatetime<T>` |  | `datetime`, `value` |
| `CYHourly.ValueWithDatetimeFlat<T>` |  | `datetime`, `value` |

#### `CYDaily`

| Property | Type | API Original Key |
| ---- | ---- | ---- |
| `responseStatus` | `String` | `status` |
| `astronomy` | `[CYDaily.Astronomy]` | `astro` |
| `phenomenon` | `[CYDaily.ValueWithDate<CYContent.Phenomenon>]` | `skycon` |
| `phenomenonDaytime` | `[CYDaily.ValueWithDate<CYContent.Phenomenon>]` | `skycon_08h_20h` |
| `phenomenonNighttime` | `[CYDaily.ValueWithDate<CYContent.Phenomenon>]` | `skycon_20h_32h` |
| `temperature` | `[CYDaily.AverageAndExtremumWithDate<Double>]` | `temperature` |
| `precipitation` | `[CYDaily.AverageAndExtremumWithDate<Double>]` | `precipitation` |
| `pressure` | `[CYDaily.AverageAndExtremumWithDate<Double>]` | `pressure` |
| `wind` | `[CYDaily.AverageAndExtremumWithDate<CYContent.Wind>]` | `wind` |
| `cloudrate` | `[CYDaily.AverageAndExtremumWithDate<Double>]` | `cloudrate` |
| `humidity` | `[CYDaily.AverageAndExtremumWithDate<Double>]` | `humidity` |
| `dswrf` | `[CYDaily.AverageAndExtremumWithDate<Double>]` | `dswrf` |
| `visibility` | `[CYDaily.AverageAndExtremumWithDate<Double>]` | `visibility` |
| `airQuality` | `[CYDaily.AirQuality]` | `air_quality` |
| `lifeIndex` | `CYContent.LifeIndex<[CYDaily.IndexWithDescriptionWithDate<String>]>` | `life_index` |

Redefined types

| Type | Description | Prpoerties |
| ---- | ---- | ---- |
| `CYDaily.Astronomy` |  | `date`, `value` |
| `CYDaily.Astronomy.AstronomyContent` |  | `sunrise`, `sunset` |
| `CYDaily.Astronomy.AstronomyContent.AstronomyTime` |  | `timeInterval` |
| `CYDaily.AirQuality` |  | `aqi`, `pm25` |

Abstruct types

| Type | Description | Prpoerties |
| ---- | ---- | ---- |
| `CYHourly.ValueWithDate<T>` |  | `date`, `value` |
| `CYHourly.AverageAndExtremumWithDate<T>` |  | `date`, `value` |
| `CYHourly.IndexWithDescriptionWithDate<T>` |  | `date`, `value` |

> `extension` them to better serve you!


## Measurement and unit converting

API provides [5 unit systems](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8#.E6.94.AF.E6.8C.81.E7.9A.84.E5.8D.95.E4.BD.8D.E5.88.B6) for your requests. In this project, these 5 unit systems are also implemented and available for you to converting the weather values between them and more. 

The following codes shows an example converting the wind speed: 

``` swift
let windSpeed = response.result.realtime.wind.speed.value

// get current unit system by either of these
let unitSystem = unit.system
// let unitSystem = request.endpoint.measurementSystem.system

// define a measurement
let measurement = Measurement(value: windSpeed, unit: unitSystem.windSpeed)

// convert the measurement to specified unit and get the value
let convertedSpeed = measurement.converted(to: .kilometersPerHour).value
```

Measurement and unit converting are implemented with `Measurement` in Apple's `Foundation` Framework. Please refer to [Apple Developer Documentation - Measurement](https://developer.apple.com/documentation/foundation/measurement) for more information.

Refer to `CYUnit` for all defined measurement units.

> `extension` them to better serve you!


## Localization

API provides [5 languages](https://open.caiyunapp.com/%E9%80%9A%E7%94%A8%E9%A2%84%E6%8A%A5%E6%8E%A5%E5%8F%A3/v2.5#.E8.AF.B7.E6.B1.82.E5.8F.82.E6.95.B0) for your requests. In this project, some of weather contents are localized in 2 languages (`en` and `zh-Hans`), such as phenomenon, alert and wind.

Refer to `Localizable` for more information.

> `extension` them to better serve you!


## License

MIT


## Disclaimer

- This project has no direct connection with caiyunapp.com. 
- caiyunapp.com is neither a sponsor nor responsible for this project. 
- All rights that belong to caiyunapp.com are fully respected.
