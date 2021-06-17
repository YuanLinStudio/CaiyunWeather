# CaiyunWeather

Request weather information from caiyunapp.com in 10 lines of code.

10 行代码搞定彩云天气 API。

[![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange)](https://developer.apple.com/swift)
[![SPM Availble](https://img.shields.io/badge/SPM-compatible-brightgreen)](https://swift.org/package-manager)
[![GitHub license](https://img.shields.io/github/license/YuanLinStudio/CaiyunWeather)](https://github.com/YuanLinStudio/CaiyunWeather)
[![API v2.5](https://img.shields.io/badge/API-v2.5-orange)](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8)
[![Chinese Docs available](https://img.shields.io/badge/CN_Docs-available-brightgreen)](README-zh.md)

For English Version, click [here](README.md).


## 简介

`CaiyunWeather` 是 [彩云天气 API](http://caiyunapp.com/) 天气服务的一个包装器，采用 Swift 代码编写，并适用于以 Swift 语言构建的程序。

不同于传统的 JSON Serializer 方法，`CaiyunWeather` 将所有内容存储为对象，其中的大多数都可解码和编码。

您可以自定义请求过程和结果处理过程中的几乎全部参数。

`CaiyunWeather` 支持将从 API 获取的数据解码到 `CYResponse` 对象，或将 `CYResponse` 对象编码到本地 `Data` 数据。

因此，项目内置了一个天气内容缓存工具，您可以借助它来减少远程 API 调用次数并 **节省您的成本**！

## 在开始之前

1. 您需要在 [http://caiyunapp.com/](http://caiyunapp.com/) 为自己申请一个天气 token。**记得保密好您的 token 哦！**
2. 非常建议您首先阅读彩云天气的 [API 文档](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8)。

## 要求

- Swift 语言版本 5.0 或以上
- Xcode 版本 11 或以上
- iOS 版本 10 或以上 / macOS 版本 10.12 或以上

## 安装

### 使用 Swift Package Manager

若要使用 [Swift Package Manager](https://swift.org/package-manager/) 安装 `CaiyunWeather`，把下方代码添加到您的 `Package.swift` 文件中即可：

``` swift
let package = Package(
    ...
    dependencies: [
        .package(url: "https://github.com/YuanLinStudio/CaiyunWeather.git", from: "1.0.0")
    ],
    ...
)
```

## 快速开始

使用下方代码来向彩云天气 API 发送请求，并将返回的数据解码为 `CYResponse` 对象：

``` swift
import CaiyunWeather

let token = "your-token-here"

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
    // your subsequent actions for `CYResponse?` result
}
```

## 设置您的 API 请求（`request`）

### 自定义 API 相关的请求参数

所有的 API 相关的参数都定义在 `CYRequest.endpoint`中。选择请求参数之前，请阅读 [API 文档 - 请求参数](https://open.caiyunapp.com/%E9%80%9A%E7%94%A8%E9%A2%84%E6%8A%A5%E6%8E%A5%E5%8F%A3/v2.5#.E8.AF.B7.E6.B1.82.E5.8F.82.E6.95.B0)。

下方说明了全部参数选项。

| 参数路径 | 描述 | 类型 | 默认值 |
| ---- | ---- | ---- | ---- |
| `CYRequest.endpoint.token` | 您的 API token | `String!` | `nil` |
| `CYRequest.endpoint.coordinate` | 请求天气的位置坐标 | `CYCoordinate` | `.defaultCoordinate` as (0, 0) |
| `CYRequest.endpoint.language` | 返回内容的显示语言 | `CYEndpoint.RequestLanguage` | `.chineseSimplified` |
| `CYRequest.endpoint.measurementSystem` | 相应内容的单位制 | `CYEndpoint.MeasurementSystem` (equal to `CYUnit`) | `.metric` |
| `CYRequest.endpoint.shouldIncludeAlerts` | 是否接受天气预警信息 | `Bool` | `true` |
| `CYRequest.endpoint.hourlyLength` | 小时级天气信息的时间长度 | `Int` | `48` |
| `CYRequest.endpoint.dailyLength` | 天级天气信息的时间长度 | `Int` | `5` |
| `CYRequest.endpoint.file` | API 请求的目标文件。 *不建议修改此参数* | `String` | `"weather.json"` |
| `CYRequest.endpoint.version` | API 版本。 *不建议修改此参数* | `String` | `"v2.5"` |

若要自定义参数，首先初始化您的 `CYRequest` 对象（建议采用 `let` 语句），并使用 `<path> = <value>` 来修改。您还可以定义一个 `CYEndpoint` 对象并作出修改，然后用 `<yourCYRequestObject>.endpoint = <yourCYEndpointObject>` 把它传给 `CYRequest` 对象。

Use `CYRequest.endpoint.url` to get the URL after your alternation if in need. Note it can be `nil` if your haven't passed in a token.

> #### 使用 `CYCoordinate`
> 
> `CYCoordinate` 提供了多种方法来初始化： 
> 1. 用经度和纬度
> 2. 用 Apple `CoreLocation` 框架中的 `CLLocationCoordinate2D` 对象
> 3. API 相关的构造器和处理器
> 
> 若要获取用户的位置或地图中的标记点，请使用 `CoreLocation` 或 `MapKit` 来获取其坐标。

### 自定义其他请求参数

如有需要，您还可以自定义天气信息的有效期、处理队列、缓存参数等。

下方说明了全部参数选项。

| 参数路径 | 描述 | 类型 | 默认值 |
| ---- | ---- | ---- | ---- |
| `CYRequest.expiration` | 数据的有效期 | `TimeInterval` | `5 * 60` |
| `CYRequest.queue` | 处理 `CYRequest` 的队列 | `DispatchQueue` | `.global(qos: .background)` |
| `CYRequest.localContentUrl` | 从 API 获取的天气信息的缓存位置 | `URL` | `.cachesDirectory` |

若要自定义参数，首先初始化您的 `CYRequest` 对象（建议采用 `let` 语句），并使用 `<path> = <value>` 来修改。

本地缓存文件将存储在 `CYRequest.localContentUrl` 中，以 `<longitude in %.4f>,<latitude in %.4f>` 命名。该规则暂时不能被修改。

### 便捷构造器

如果您没有上述两个需求（只是将它们保留为默认值），或者希望在初始化后覆盖它们，那么可以使用便捷构造器来快速初始化您的请求。

下方 3 段初始化语句将产生相同的效果：

``` swift
let token = "your-token-here"
let coordinate = CYCoordinate(latitude: 31.025785475418274, longitude: 121.4474754473953)

let request = CYRequest(token: token, coordinate: coordinate)
```

``` swift
let token = "your-token-here"
let coordinate = CYCoordinate(latitude: 31.025785475418274, longitude: 121.4474754473953)

let endpoint = CYEndpoint(token: token, coordinate: coordinate)

let request = CYRequest()
request.endpoint = endpoint
```

``` swift
let token = "your-token-here"
let coordinate = CYCoordinate(latitude: 31.025785475418274, longitude: 121.4474754473953)

var endpoint = CYEndpoint()
endpoint.token = token
endpoint.coordinate = coordinate

let request = CYRequest()
request.endpoint = endpoint
```

## 执行您的请求

若要获取天气信息内容，您应该执行（`perform`）您的请求，无论从远程或本地。

> 继续之前，请保证您的请求已经设置完毕。

### 自动选择信息源

使用 `CYRequest.perform(completionHandler: @escaping (CYResponse?, DataSource, Error?) -> Void)` 方法以使用自动选择的信息源的方式来执行您的请求。也就是说，如果下方 3 个条件满足，将使用本地缓存中的天气信息：

1. 本地缓存文件存在，且没有解码错误；且
2. 与您的请求（`request`）中的坐标位置相同（四舍五入至 `%.4f`，约 100 米的范围内）；且
3. 天气信息在有效期内。

否则，将会从远程 API 重新请求数据并缓存。

`completionHandler` 的 `CYRequest.DataSource` 参数表明本次解析的数据来自哪里。`.local` 表明来源于本地缓存，`.remote` 表明来源于远程 API。

### Explicitly choosing local or remote fetching

You may use `perform(from dataSource: DataSource, completionHandler: @escaping (CYResponse?, DataSource, Error?) -> Void)` if you want to perform your request towards an explicit target. Set `dataSource` to `.local` if you want to fatch data from local cache, or `.remote` from remote API.

### Fetching Data without decoding to `CYResponse` object

You may use `fetchData(from dataSource: DataSource, completionHandler: @escaping (Data?, Error?) -> Void)` if you want to fatch data without decoding it to `CYResponse` object. This shall only be used for debugging and internal using.

### Fetching Example Data

An example JSON file is included in this package for debugging use. Call `fetchExampleData(completionHandler: @escaping (Data?, Error?) -> Void)` to get it.

The example JSON file is a response from caiyunapp.com API, at date of 2021-04-14 and coordinate of (112.8641, 35.4904), which is located in Jincheng, Shanxi, China.

### Using native `URLSession.dataTask` to fetch data from remote

**Not recommended.** Note that `dataTask`s are internally wrapped into `perform` and `fatchData`, so you should mostly use them instead. 

However, if you would prefer to hard-code your URL or you need to do so, the code below may help you. 

``` swift
let url = "your.valid.url/for/api/requests"

URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
    // deal with the data
}
.resume()
```

### Decoding your data to `CYResponse` object

**Content received by `perform` are ready-to-use and DO NOT need to decode. Skip this section and go ahead.** 

If you have your data ready (either fetched with `fatchData`, fetched with `dataTask`, or loaded from local cache), you may use `decode(_ data: Data, completionHandler: @escaping (CYResponse?, CYError?) -> Void)` to decode your data to `CYResponse` object.


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
let windSpeedMeasurement = Measurement(value: windSpeed, unit: unitSystem.windSpeed)

// convert the measurement to specified unit and get the value
let convertedSpeed = windSpeedMeasurement.converted(to: .kilometersPerHour).value
```

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
