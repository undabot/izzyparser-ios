import Foundation
import Quick
import Nimble
@testable import IzzyParser

class JsonApiDeserializerShould: QuickSpec {
    
    override class func spec() {
        var sut: JSONApiDeserializer!
        
        beforeEach {
            sut = JSONApiDeserializer()
        }
        
        afterEach {
            sut = nil
        }
        
        describe("deserializeJSONApi(from document: [String: Any])") {
            
            context("and jsonapi dictionary exists in json") {
                it("should return meta dictionary from json") {
                    let data = try? Data(with: "JsonApi", for: JsonApiDeserializerShould.self)
                    let json = (try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any])
                    let jsonapi = sut.deserializeJSONApi(from: json!)
                    
                    expect(jsonapi?.isEmpty).toNot(beTrue())
                }
            }
            
            context("and jsonapi dictionary DOESN'T exist in json") {
                it("should NOT return jsonapi dictionary from json") {
                    let data = try? Data(with: "Meta", for: JsonApiDeserializerShould.self)
                    let json = (try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any])
                    let jsonapi = sut.deserializeJSONApi(from: json!)
                    
                    expect(jsonapi).to(beNil())
                }
            }
        }
    }
}
