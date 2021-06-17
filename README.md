# CaiyunWeather

Request weather information from caiyunapp.com in 10 lines of codes

## Introduction

`CaiyunWeather` is a wrapper for weather service from [caiyunapp.com](http://caiyunapp.com/). 

`CaiyunWeather` is written in and availble for Swift. Different from default JSON Serializer method, `CaiyunWeather` keeps all content as objects and mostly codable. You can also define almost everything during your request and result handling. `CaiyunWeather` supports decoding API-fetched data to Weather content and encoding your Weather content to local-saved data. So, a built-in method of caching weather content is provided, by which means you can minimize your remote API calls and **save your costs**!

## Before you start

1. You have to require a valid token from [http://caiyunapp.com/](http://caiyunapp.com/) (`Chinese`) for yourself. **Always keep your token secret and safe!**
2. You are highly recommended to first read the API [documentation](https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8) (`Chinese`) from caiyunapp.com.

## Installation

- Swift package manager (*Recommended*).
- Download the source code and add them into your project.
- Other implementation of installation methods are welcomed via pull requests and issues.
