# Socketing

A minimal iOS/macOS Socket Framework.

## Requirements

* iOS 8.0+
* macOS 10.9+
* Xcode 8 with Swift 3

## Installnation

#### CocoaPods

```ruby
pod 'Socketing'
```
## Usage

Use TCP for example:

#### Client

``` swift
let client = TCPClient(address: "127.0.0.1", port: 8080)
// or:
let client = TCP.Client(address: "127.0.0.1", port: 8080)
```

``` swift
switch client.connect(timeout: 10) {
  case .success:
    // ...
  case .failure(let error):
    // ...
}
```

``` swift
let data: Data = // ...
let result = client.send(data: data)
// or:
let result = client.send(string: "string")
```

``` swift
// [Int8]?
var data = client.read(length: 1024*10)
```

``` swift
client.close()
```

#### Server

```swift
let server = TCPServer(address: "127.0.0.1", port: 8080)
// or:
let server = TCP.Server(address: "127.0.0.1", port: 8080)
```

```swift
switch server.listen() {
  case .success:
    // ...
  case .failure(let error):
    // ...
}
```

```swift
if let client = server.accept() {
  // ...
}
```

```swift
server.close()
```

## Example:

#### Client

``` swift
let client = TCP.Client(address: "127.0.0.1", port: 8080)
switch client.connect(timeout: 60) {
  case .success:
    switch client.send(string: "This is a Message" ) {
      case .success:
        guard let data = client.read(length: 1024 * 10) else {
          // ... goes wrong
          return
        }
        if let response = String(bytes: data, encoding: .utf8) {
          // ... sent
        }
      case .failure(let error):
        // ... sending error
    }
  case .failure(let error):
    // ... connect error
}
```

#### Server

``` swift
let server = TCPServer(address: "127.0.0.1", port: 8080)

switch server.listen() {
  case .success:
    if let client = server.accept() {
      // ... new client
    }
  case .failure(let error):
    // ... listen error
}
```
