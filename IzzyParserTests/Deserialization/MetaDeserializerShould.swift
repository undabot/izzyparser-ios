import Quick
import Nimble
@testable import IzzyParser

class MetaDeserializerShould: QuickSpec {
    
    override func spec() {
        var sut: MetaDeserializer!
        
        beforeEach {
            sut = MetaDeserializer()
        }
        
        afterEach {
            sut = nil
        }
        
        describe("deserializeMeta(from json: [String: Any])") {
            
            context("and meta dictionary exists in json") {
                it("should return meta dictionary from json") {
                    let data = try? Data(with: "Meta", for: type(of: self))
                    let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    let meta = sut.deserializeMeta(from: json!)
                    
                    expect(meta?.isEmpty).toNot(beTrue())
                }
            }
            
            context("and meta dictionary DOESN'T exist in json") {
                it("should NOT return meta dictionary from json") {
                    let data = try? Data(with: "JsonApi", for: type(of: self))
                    let json = (try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any])
                    let meta = sut.deserializeMeta(from: json!)
                    
                    expect(meta).to(beNil())
                }
            }
        }
    }
}
