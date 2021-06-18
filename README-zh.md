# CaiyunWeather

Request weather from caiyunapp.com in 10 lines of code.

10 行代码搞定彩云天气 API。

[![API v2.5](https://img.shields.io/badge/API-v2.5-orange)](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8)
[![SPM Availble](https://img.shields.io/badge/SPM-compatible-brightgreen)](https://swift.org/package-manager)
[![GitHub license](https://img.shields.io/github/license/YuanLinStudio/CaiyunWeather)](https://github.com/YuanLinStudio/CaiyunWeather)
[![Chinese Docs available](https://img.shields.io/badge/CN_Docs-available-brightgreen)](README-zh.md)

For English version, please click [here](README.md).


## 目录

  - [简介](#简介)
  - [在开始之前](#在开始之前)
  - [要求](#要求)
  - [安装](#安装)
    - [使用 Swift Package Manager](#使用-swift-package-manager)
  - [快速开始](#快速开始)
  - [设置您的 API 请求（`request`）](#设置您的-api-请求request)
    - [自定义 API 相关的请求参数](#自定义-api-相关的请求参数)
    - [自定义其他请求参数](#自定义其他请求参数)
    - [便捷构造器](#便捷构造器)
  - [执行您的请求](#执行您的请求)
    - [自动选择信息源](#自动选择信息源)
    - [显式选择使用本地缓存或远程 API 信息源](#显式选择使用本地缓存或远程-api-信息源)
    - [只请求数据（`Data` 对象），而不解析为 `CYResponse` 对象](#只请求数据data-对象而不解析为-cyresponse-对象)
    - [请求示例数据（`Data` 对象）](#请求示例数据data-对象)
    - [使用原始 `URLSession.dataTask` 方法从远程 API 请求数据](#使用原始-urlsessiondatatask-方法从远程-api-请求数据)
    - [将数据（`Data` 对象）解码到 `CYResponse` 对象](#将数据data-对象解码到-cyresponse-对象)
  - [处理 API 响应内容](#处理-api-响应内容)
    - [`CYContent` 类型](#cycontent-类型)
      - [实际类型](#实际类型)
      - [抽象类型](#抽象类型)
    - [响应对象](#响应对象)
      - [`CYResponse`](#cyresponse)
      - [`CYResult`](#cyresult)
      - [`CYAlert`](#cyalert)
      - [`CYRealtime`](#cyrealtime)
      - [`CYMinutely`](#cyminutely)
      - [`CYHourly`](#cyhourly)
      - [`CYDaily`](#cydaily)
  - [计量单位换算](#计量单位换算)
  - [本地化和翻译](#本地化和翻译)
  - [许可](#许可)
  - [免责声明](#免责声明)


## 简介

`CaiyunWeather` 是 [彩云天气 API](http://caiyunapp.com/) 天气服务的一个包装器，采用 Swift 代码编写，并适用于以 Swift 语言构建的程序。

不同于传统的 JSON Serializer 方法，`CaiyunWeather` 将所有内容存储为对象，其中的大多数都可解码和编码。

您可以自定义请求过程和结果处理过程中的几乎全部参数。

`CaiyunWeather` 支持将从 API 获取的数据解码到 `CYResponse` 对象，或将 `CYResponse` 对象编码到本地 `Data` 数据。

因此，项目内置了一个天气内容缓存工具，您可以借助它来减少远程 API 调用次数并**节省您的成本**！


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

let token: String = "您的 token"

// 请求天气位置的坐标
let coordinate = CYCoordinate(latitude: 31.025785475418274, longitude: 121.4474754473953)

// 声明一个请求（`request`）
let request = CYRequest(token: token, coordinate: coordinate)

// 请求数据
request.perform { response, source, error in
    guard let response = response, error == nil else {
        print(error.debugDescription)
        return
    }
    print(response)
    // 您为 `CYResponse?` 定义的后续方法...
}
```


## 设置您的 API 请求（`request`）

### 自定义 API 相关的请求参数

所有的 API 相关的参数都定义在 `CYRequest.endpoint`中。选择请求参数之前，请阅读 [API 文档 - 请求参数](https://open.caiyunapp.com/%E9%80%9A%E7%94%A8%E9%A2%84%E6%8A%A5%E6%8E%A5%E5%8F%A3/v2.5#.E8.AF.B7.E6.B1.82.E5.8F.82.E6.95.B0)。

下方说明了全部参数选项。

| 参数路径 | 描述 | 类型 | 默认值 |
| ---- | ---- | ---- | ---- |
| `CYRequest.endpoint.token` | 您的 API token | `String!` | `nil` |
| `CYRequest.endpoint.coordinate` | 请求天气的位置坐标 | `CYCoordinate` | `.defaultCoordinate` 即 (0, 0) |
| `CYRequest.endpoint.language` | 返回内容的显示语言 | `CYEndpoint.RequestLanguage` | `.chineseSimplified` |
| `CYRequest.endpoint.measurementSystem` | 相应内容的单位制 | `CYEndpoint.MeasurementSystem` （即 `CYUnit`） | `.metric` |
| `CYRequest.endpoint.shouldIncludeAlerts` | 是否接受天气预警信息 | `Bool` | `true` |
| `CYRequest.endpoint.hourlyLength` | 小时级天气信息的时间长度 | `Int` | `48` |
| `CYRequest.endpoint.dailyLength` | 天级天气信息的时间长度 | `Int` | `5` |
| `CYRequest.endpoint.file` | API 请求的目标文件。 *不建议修改此参数* | `String` | `"weather.json"` |
| `CYRequest.endpoint.version` | API 版本。 *不建议修改此参数* | `String` | `"v2.5"` |

若要自定义参数，首先初始化您的 `CYRequest` 对象（建议采用 `let` 语句），并使用 `<参数路径> = <值>` 来修改。您还可以定义一个 `CYEndpoint` 对象并作出修改，然后用 `<您的 CYRequest 对象>.endpoint = <您的 CYEndpoint 对象>` 来把它传给您的 `CYRequest` 对象。

使用 `CYRequest.endpoint.url` 来获取您修改请求参数后的请求 URL。注意，若您没有传入 token，它可能返回 `nil`。

> #### 使用 `CYCoordinate`
> 
> `CYCoordinate` 是 Apple `CoreLocation` 框架中的 `CLLocationCoordinate2D` 类型的别名，并增加了一些扩展（`extension`）来满足`Codable` 和 `Equatable` 协议。您可以用经度和纬度初始化一个 `CYCoordinate` 对象，也可以用 `.defaultCoordinate` 来获取一个位置坐标为 (0, 0) 的默认对象。
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

若要自定义参数，首先初始化您的 `CYRequest` 对象（建议采用 `let` 语句），并使用 `<参数路径> = <值>` 来修改。

本地缓存文件将存储在 `CYRequest.localContentUrl` 中，以 `<经度的 %.4f>,<纬度的 %.4f>` 命名。该规则暂时不能被修改。

### 便捷构造器

如果您没有上述两个需求（只是将它们保留为默认值），或者希望在初始化后覆盖它们，那么可以使用便捷构造器来快速初始化您的请求。

下方 3 段初始化语句将产生相同的效果：

``` swift
let token: String = "您的 token"
let coordinate = CYCoordinate(latitude: 31.025785475418274, longitude: 121.4474754473953)

let request = CYRequest(token: token, coordinate: coordinate)
```

``` swift
let token: String = "您的 token"
let coordinate = CYCoordinate(latitude: 31.025785475418274, longitude: 121.4474754473953)

let endpoint = CYEndpoint(token: token, coordinate: coordinate)

let request = CYRequest()
request.endpoint = endpoint
```

``` swift
let token: String = "您的 token"
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

使用 `CYRequest.perform(completionHandler: @escaping (CYResponse?, CYRequest.DataSource, Error?) -> Void)` 方法以使用自动选择的信息源的方式来执行您的请求。也就是说，如果下方 3 个条件满足，将使用本地缓存中的天气信息：

1. 本地缓存文件存在，且没有解码错误；且
2. 与您的请求（`request`）中的坐标位置相同（四舍五入至 `%.4f`，约 100 米的范围内）；且
3. 天气信息在有效期内。

否则，将会从远程 API 重新请求数据并缓存。

`completionHandler` 的 `CYRequest.DataSource` 参数表明本次解析的数据来自哪里。`.local` 表明来源于本地缓存，`.remote` 则表明来源于远程 API。

### 显式选择使用本地缓存或远程 API 信息源

若您想要显式选择信息源，您可以使用 `CYRequest.perform(from dataSource: CYRequest.DataSource, completionHandler: @escaping (CYResponse?, CYRequest.DataSource, Error?) -> Void)` 方法。将 `dataSource` 设置为 `.local` 以从本地缓存中请求，或 `.remote` 以从远程 API 中请求。

### 只请求数据（`Data` 对象），而不解析为 `CYResponse` 对象

若您想要只请求数据而不解析为 `CYResponse` 对象，您可以使用 `CYRequest.fetchData(from dataSource: CYRequest.DataSource, completionHandler: @escaping (Data?, Error?) -> Void)` 方法。该方法应当仅在您调试过程或内部使用过程中调用。

### 请求示例数据（`Data` 对象）

本项目 package 中包含了一个示例 JSON 文件。调用 `CYRequest.fetchExampleData(completionHandler: @escaping (Data?, Error?) -> Void)` 方法来获取它。

示例 JSON 文件是彩云天气 API 的一个返回内容，时间是 2021-04-14，位置坐标是 (112.8641, 35.4904)，该位置在山西省晋城市境内。

### 使用原始 `URLSession.dataTask` 方法从远程 API 请求数据

**不建议使用**。注意，在`perform` 和 `fatchData` 方法内部已经使用 `dataTask` 来完成，因此多数情况下您应当直接调用这两个方法。

尽管如此，如果您倾向于硬编码您的 URL 或您需要使用原始方法，下方代码可能会为您提供帮助。

``` swift
let url: URL = "您请求数据的 URL"

URLSession.shared.dataTask(with: url) { (data, urlResponse, error) in
    // 处理数据（`data`）...
}
.resume()
```

### 将数据（`Data` 对象）解码到 `CYResponse` 对象

**若您使用 `perform` 方法接收到了内容，您的内容可被直接使用，而无需再次进行解码。请跳过这一节。** 

如果您准备好了您的数据（使用 `fatchData`、`dataTask`、或由本地文件载入），您可以调用 `CYRequest.decode(_ data: Data, completionHandler: @escaping (CYResponse?, CYError?) -> Void)` 方法来将您的数据（`Data` 对象）解码到 `CYResponse` 对象。


## 处理 API 响应内容

> 继续之前，我们非常建议您阅读 [彩云天气 API 文档](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8) 来了解 API 响应的内容。

默认的返回内容非常长，这意味着您可能不会全部用到它们。因此，**我们非常欢迎您定义您自己的天气数据模型，并使用对 `CYResponse` 的适配器来构造它**。

有关内容类型和返回类型的说明如下。我们鼓励您读完它们，但这里有一个供您选择的方法：跳过这一节，等到编写程序遇到问题时再回来。

### `CYContent` 类型

`CYContent` 定义了一些处理天气信息的通用数据类型，它们非常好用。

#### 实际类型

| 类型 | 描述 | 属性 |
| ---- | ---- | ---- |
| `CYContent.Datetime1970Based` |  | `time` |
| `CYContent.DatetimeServerType` |  | `time` |
| `CYContent.LifeIndex<T>` | `T` 类型的生活指数 | `ultraviolet`, `comfort`, `carWashing`, `coldRisk`, `dressing` |
| `CYContent.Wind` |  | `speed`, `direction` |
| `CYContent.Wind.WindSpeed` |  | `value`, `description` |
| `CYContent.Wind.WindDirection` |  | `value`, `description` |
| `CYContent.AirQuality` | 属性值为 Optional 类型 | `pm25`, `pm10`, `o3`, `so2`, `no2`, `co`, `aqi`, `description` |
| `CYContent.Phenomenon` | 枚举类型 | [彩云天气 API 文档 - 天气现象代码表](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8#.E5.A4.A9.E6.B0.94.E7.8E.B0.E8.B1.A1.E4.BB.A3.E7.A0.81.E8.A1.A8) 中定义的所有内容 |

#### 抽象类型

| 类型 | 描述 | 属性 |
| ---- | ---- | ---- |
| `CYContent.CountryRelated<T>` |  | `chn`, `usa` |
| `CYContent.IndexWithDescription<T>` |  | `index`, `description` |
| `CYContent.AverageAndExtremum<T>` |  | `average`, `maximum`, `minimum` |

> 您可以扩展（`extension`）它们来更好地为您提供服务。

### 响应对象

如果您使用了上述提到的 `perform` 或 `decode` 方法，您的内容此时可能是 `CYResponse?` 对象。**别忘了对您的内容进行解包。** 若无异常，您的内容将包含从远程 API 返回并解码过的全部内容。为了优化您的工程并节省用户内存、提高响应速度，`CYResponse` 对象和其包含的多数对象都以带 `let` 语句的 `struct` 形式定义。

下方表格解释了 `CYResponse` 对象和其包含的对象。部分对象在代码注释中提供了中文解释。

#### `CYResponse`

| 属性 | 类型 | API 原始键值 |
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

| 属性 | 类型 | API 原始键值 |
| ---- | ---- | ---- |
| `alert` | `CYAlert` | `alert` |
| `realtime` | `CYRealtime` | `realtime` |
| `minutely` | `CYMinutely` | `minutely` |
| `hourly` | `CYHourly` | `hourly` |
| `daily` | `CYDaily` | `daily` |
| `keypoint` | `String` | `forecast_keypoint` |

#### `CYAlert`

| 属性 | 类型 | API 原始键值 |
| ---- | ---- | ---- |
| `responseStatus` | `String` | `status` |
| `content` | `[CYAlert.AlertContent]` | `content` |

`CYAlert.AlertContent`

| 属性 | 类型 | API 原始键值 |
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

重定义类型

| 类型 | 描述 | 属性 |
| ---- | ---- | ---- |
| `CYAlert.AlertContent.AlertCode` |  | `type`, `level` |
| `CYAlert.AlertContent.AlertCode.AlertType` |  | [彩云天气 API 文档 - 预警类型编码对照表](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8#.E9.A2.84.E8.AD.A6.E7.B1.BB.E5.9E.8B.E7.BC.96.E7.A0.81.E5.AF.B9.E7.85.A7.E8.A1.A8) 中定义的所有内容 |
| `CYAlert.AlertContent.AlertCode.AlertLevel` |  | [彩云天气 API 文档 - 预警级别编码对照表](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8#.E9.A2.84.E8.AD.A6.E7.BA.A7.E5.88.AB.E7.BC.96.E7.A0.81.E5.AF.B9.E7.85.A7.E8.A1.A8) 中定义的所有内容 |

#### `CYRealtime`

| 属性 | 类型 | API 原始键值 |
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

重定义类型

| 类型 | 描述 | 属性 |
| ---- | ---- | ---- |
| `CYRealtime.Precipitation` |  | `local`, `nearest` |
| `CYRealtime.Precipitation.PrecipitationContent` | `datasource` 和 `distance` 属性为 `Optional` 类型 | `responseStatus`, `datasource`, `intensity`, `distance` |

#### `CYMinutely`

| 属性 | 类型 | API 原始键值 |
| ---- | ---- | ---- |
| `datasource` | `String` | `datasource` |
| `description` | `String` | `description` |
| `probability` | `[Double]` | `probability` |
| `intensity` | `[Double]` | `precipitation_2h` |

#### `CYHourly`

| 属性 | 类型 | API 原始键值 |
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

重定义类型

| 类型 | 描述 | 属性 |
| ---- | ---- | ---- |
| `CYHourly.AirQuality` |  | `aqi`, `pm25` |

抽象类型

| 类型 | 描述 | 属性 |
| ---- | ---- | ---- |
| `CYHourly.ValueWithDatetime<T>` |  | `datetime`, `value` |
| `CYHourly.ValueWithDatetimeFlat<T>` |  | `datetime`, `value` |

#### `CYDaily`

| 属性 | 类型 | API 原始键值 |
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

重定义类型

| 类型 | 描述 | 属性 |
| ---- | ---- | ---- |
| `CYDaily.Astronomy` |  | `date`, `value` |
| `CYDaily.Astronomy.AstronomyContent` |  | `sunrise`, `sunset` |
| `CYDaily.Astronomy.AstronomyContent.AstronomyTime` |  | `timeInterval` |
| `CYDaily.AirQuality` |  | `aqi`, `pm25` |

抽象类型

| 类型 | 描述 | 属性 |
| ---- | ---- | ---- |
| `CYHourly.ValueWithDate<T>` |  | `date`, `value` |
| `CYHourly.AverageAndExtremumWithDate<T>` |  | `date`, `value` |
| `CYHourly.IndexWithDescriptionWithDate<T>` |  | `date`, `value` |

> 您可以扩展（`extension`）它们来更好地为您提供服务。


## 计量单位换算

彩云天气 API 为您的请求提供了 [5 种单位制](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8#.E6.94.AF.E6.8C.81.E7.9A.84.E5.8D.95.E4.BD.8D.E5.88.B6)。本项目实现了此 5 种单位制，并可为您提供它们之间的单位换算，甚至向其他单位换算。

下方代码提供了换算风速的示例：

``` swift
let windSpeed = response.result.realtime.wind.speed.value

// 使用下方两种方法中的任意一种来获取当前的单位制
let unitSystem = unit.system
// let unitSystem = request.endpoint.measurementSystem.system

// 定义一个 `Measurement` 对象
let measurement = Measurement(value: windSpeed, unit: unitSystem.windSpeed)

// 将 `Measurement` 对象换算至特定单位并获取换算后的值
let convertedSpeed = measurement.converted(to: .kilometersPerHour).value
```

单位换算使用 Apple `Foundation` 框架中的 `Measurement` 实现，具体方法请参阅 [Apple Developer Documentation - Measurement](https://developer.apple.com/documentation/foundation/measurement) (`EN`)。

有关所有定义的测量单位，请参阅 `CYUnit`。

> 您可以扩展（`extension`）它们来更好地为您提供服务。


## 本地化和翻译

彩云天气 API 为您的请求提供了 [5 种本地化语言](https://open.caiyunapp.com/%E9%80%9A%E7%94%A8%E9%A2%84%E6%8A%A5%E6%8E%A5%E5%8F%A3/v2.5#.E8.AF.B7.E6.B1.82.E5.8F.82.E6.95.B0)。本项目为其中 2 种语言（英语 `en` 和简体中文 `zh-Hans`）编写了本地化文件，内容包括天气现象、预警和风力风向等。

获取更多信息，请参阅 `Localizable`。

> 您可以扩展（`extension`）它们来更好地为您提供服务。


## 许可

MIT


## 免责声明

- 本项目与彩云天气 API 无直接联系。
- 彩云天气 API 不是本项目的赞助者，也不对本项目负责。
- 我们非常尊重彩云天气 API 所有的全部权利。
