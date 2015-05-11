# DeflateSwift
Super simple interface for the deflate compression format in Swift. Two very easy to use classes, `DeflateStream` and `InflateStream` with only method `write`

##Features

- Pure Swift. No bridging with Objective-C
- Simple Interface. Only two classes and one method required.
- Advanced Options. Compression level a window bits.

##Install (iOS and OS X)

###CocoaPods

You can use [CocoaPods](http://cocoapods.org/?q=DeflateSwift) to install the `DelfateSwift` framework.

Add the following lines to your `Podfile`.

```ruby
use_frameworks!
pod 'DeflateSwift'
```

The `import DeflateSwift` directive is required in order to access DeflateSwift features.

##Example

```swift
import DeflateSwift

var data : [UInt8] = [ /* some data here */ ]

// compress
var deflater = DeflateStream()
var (deflated, err) = deflater.write(data, flush: true)
if err != nil{
  fatalError("\(err!)")
}

// decompress
ver inflater = InflateStream()
var (inflated, err) = inflater.write(deflated, flush: true)
if err != nil{
  fatalError("\(err!)")
}
println("success: \(inflated == data)")
```

##Contact
Josh Baker [@tidwall](http://twitter.com/tidwall)

##License

The DeflateSwift source code available under the MIT License.
