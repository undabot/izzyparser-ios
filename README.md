# IzzyParser iOS

IzzyParser is a library for serializing and deserializing [JSON API](http://jsonapi.org) objects.

![Test](https://github.com/undabot/izzyparser-ios/actions/workflows/ios.yml/badge.svg)
[![codecov](https://codecov.io/gh/undabot/izzyparser-ios/branch/master/graph/badge.svg?token=RSKJM6G86T)](https://codecov.io/gh/undabot/izzyparser-ios)
![Platform](https://img.shields.io/cocoapods/p/IzzyParser)
![Pod version](https://img.shields.io/cocoapods/v/IzzyParser)
![SPM](https://img.shields.io/badge/SPM-supported-orange)
![Top language](https://img.shields.io/github/languages/top/undabot/izzyparser-ios)
![License](https://img.shields.io/github/license/undabot/izzyparser-ios)

## Installation

#### Swift Package Manager

1. Using Xcode 11 or higher go to File > Swift Packages > Add Package Dependency
2. Paste the project URL: https://github.com/undabot/izzyparser-ios.git
3. Click on next, select the project target and click finish
4. `Import IzzyParser`

#### Cocoapods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects
To integrate IzzyParser into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
target '<Your Target Name>' do
    pod 'IzzyParser'
end
```

Then, run the following command:

```bash
$ pod install
```


## Usage

#### Defining resource

All resources MUST inherit `Resource` class.

Basic resource:

```swift
class Author: Resource {
    
    override class var type: String {
        return "people"
    }
    
    required init(id: String) {
        super.init(id: id)
    }
}
```

Resource with `customKeys` for serialization and `typesForKeys` for deserialization:

```swift
class Article: Resource {
    @objc var title: String = ""
    @objc var author: Author?
    @objc var comment: Comment?
    
    override class var type: String {
        return "articles"
    }
    
    // Custom coding keys
    override public class var customKeys: [String: String] {
        return ["komentar": "comment"]
    }
    
    override public class var typesForKeys: [String: CustomObject.Type] {
        return ["komentar": Comment.self]
    }
    
    init(id: String, title: String, author: Author, comment: Comment? = nil) {
        self.title = title
        self.author = author
        self.comment = comment
        super.init(id: id)
    }
    
    required init(id: String) {
        super.init(id: id)
    }
}
```

Object with custom deserializer:

```swift

class Comment: NSObject, CustomObject {
    @objc var id: String
    @objc var content: String
    required init(objectJson: [String: Any]) {
        self.id = objectJson["id"] as? String ?? ""
        self.content = objectJson["content"] as? String ?? ""
    }
}
```

Codable custom object:

```swift

class CodableComment: NSObject, CodableCustomObject {
    var id: String?
    var content: String?
}
```


### Registering resources

All resources MUST be registered to `Izzy` instance.

```swift
// Creating resource map
let resourceMap: [Resource.Type] = [
    Article.self,
    Author.self
]

// Registering resources
let izzy = Izzy()
izzy.registerResources(resources: resourceMap)

```

Developers often forget to register resources to resource map. If resource is not registered, deserializer will return nil for missing object (it is wanted behaviour). But, you can turn on debug mode while developing, so Izzy will throw an error if resource is not registered. <b>Don't enable debug mode for production code because it will cause crashes</b>, it should be used only for debugging purpose - so that you can detect what resources are not registered.

```
// Registering resources
let izzy = Izzy()
izzy.isDebugModeOn = true
izzy.registerResources(resources: resourceMap)
```

### Serializing

#### Serializing single resource: 

```swift
// Article serialization
let author = Author(id: "authorID")
let article = Article(id: "articleID", title: "Article title", author: author)

let serializedArticle = izzy.serialize(resource: article)
```

Output:
```swift
// Serialized article JSON:
/**
	{
	  "data" : {
	    "attributes" : {
	      "title" : "Article title"
	    },
	    "id" : "articleID",
	    "type" : "articles",
	    "relationships" : {
	      "author" : {
	        "data" : {
	          "id" : "authorID",
	          "type" : "people"
	        }
	      }
	    }
	  }
	}
*/
```

#### Serializing single resource with custom property serialization: 

```swift
// Article serialization with custom author serialization
let customRelationshipDict: [String: Any] = [
    "name": "John",
    "surname": "Smith",
    "age": NSNull()
]

serializedArticle = izzy.serializeCustom(resource: article, relationshipKey: "author", relationshipValue: customRelationshipDict)
```

Output: 
```swift
// Serialized article JSON:
/**
	{
	  "data" : {
	    "attributes" : {
	      "title" : "Article title"
	    },
	    "id" : "articleID",
	    "type" : "articles",
	    "relationships" : {
	      "author" : {
	        "name" : "John",
	        "surname" : "Smith",
	        "age" : null
	      }
	    }
	  }
	}
*/
```

#### Serializing resource collection:

```swift
let author = Author(id: "authorID")
let article = Article(id: "articleID", title: "Article title", author: author)

let serializedResourceCollection = izzy.serialize(resourceCollection: [article, article])
```

Output: 
```swift
// Serialized resource collection:
 /**
 	{
	  "data" : [
	    {
	      "attributes" : {
	        "title" : "Article title"
	      },
	      "id" : "articleID",
	      "type" : "articles",
	      "relationships" : {
	        "author" : {
	          "data" : {
	            "id" : "authorID",
	            "type" : "people"
	          }
	        }
	      }
	    },
	    {
	      "attributes" : {
	        "title" : "Article title"
	      },
	      "id" : "articleID",
	      "type" : "articles",
	      "relationships" : {
	        "author" : {
	          "data" : {
	            "id" : "authorID",
	            "type" : "people"
	          }
	        }
	      }
	    }
	  ]
	}
 */
```


### Deserializing

#### Deserializing single resource: 

Input JSON:
```swift
// JSON data:
/**
	{
    "data": {
        "type": "articles",
        "id": "1",
        "attributes": {
            "title": "Rails is Omakase",
            "komentar": {
                "id": "11",
                "content": "Custom content"
            }

        },
        "relationships": {
            "author": {
                "links": {
                    "self": "/articles/1/relationships/author",
                    "related": "/articles/1/author"
                },
                "data": { "type": "people", "id": "9" }
            }
        }
    }
}
*/
```

```swift
// Article deserialization
do {
    let document: Document<Article> = try izzy.deserializeResource(from: data)
    let article = document.data
    
    let id = article?.id
} catch let error {
    print(error.localizedDescription)
}
```

#### Deserializing resource collection:

```swift
// Article deserialization
do {
    let document: Document<[Article]> = try izzy.deserializeCollection(data)
    let articles = document.data
} catch let error {
    print(error.localizedDescription)
}
```
#### Resource with array of custom objects:

Input JSON:
```swift
/**
{
    "data": {
        "type": "subscription",
        "id": "1",
        "attributes": {
            "title": "Very nice subscription!",
            "prices": [{
                "type:": "monthly",
                "value": "1"
            },
            {
                "type:": "onetime",
                "value": "10"
            }]
        }
    }
}
*/

@objcMembers class SubscriptionResource: Resource {
    
    var title: String?
    var prices: [Price]?

    override class var type: String {
        return "subscription"
    }

    override class var typesForKeys: [String : CustomObject.Type] {
        return ["prices": Price.self]
    }
}

struct Price: Codable {
    var value: String?
    var type: String?
}
```

## License
IzzyParser is released under the MIT license. [See LICENSE](https://github.com/undabot/izzyparser-ios/blob/master/LICENSE.md) for details.


