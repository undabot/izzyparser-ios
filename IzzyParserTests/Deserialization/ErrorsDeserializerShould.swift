import Quick
import Nimble
@testable import IzzyParser

class ErrorsDeserializerShould: QuickSpec {
    
    override func spec() {
        var sut: ErrorsDeserializer!
        
        beforeEach {
            sut = ErrorsDeserializer()
        }
        
        afterEach {
            sut = nil
        }
        
        describe("deserializeErrors(from json: [String: Any]?)") {
            it("should return JSONAPIError object") {
                let data = try? Data(with: "ErrorsCollection", for: type(of: self))
                let json = (try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any])
                var jsonApiErrors: [JSONAPIError]?
                
                expect {
                    jsonApiErrors = try sut.deserializeErrors(from: json!)
                    }.toNot(throwError())

                expect(jsonApiErrors).notTo(beNil())
                expect(jsonApiErrors?.count).to(equal(2))
                
                let firstError = jsonApiErrors?[0]
                let secondError = jsonApiErrors?[1]
                
                expect(firstError?.id).to(match("Error id 1"))
                expect(firstError?.status).to(match("Error status 1"))
                expect(firstError?.code).to(match("1"))
                expect(firstError?.title).to(match("Error title 1"))
                expect(firstError?.detail).to(match("Error detail 1"))
                
                expect(secondError?.id).to(match("Error id 2"))
                expect(secondError?.status).to(match("Error status 2"))
                expect(secondError?.code).to(match("2"))
                expect(secondError?.title).to(match("Error title 2"))
                expect(secondError?.detail).to(match("Error detail 2"))
            }
            
            context("error has links and source") {
                it("should return JSONAPIError object with links and source") {
                    let data = try? Data(with: "ErrorWithLinksAndSource", for: type(of: self))
                    let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    var jsonApiErrors: [JSONAPIError]?
                    
                    expect {
                        jsonApiErrors = try sut.deserializeErrors(from: json!)
                        }.toNot(throwError())
                    
                    let error = jsonApiErrors?.first
                    let selfLink = error?.links?.`self`?.url
                    
                    expect(selfLink).to(match("http://example.com/articles/1"))
                    expect(error?.source?.pointer).to(match("/data/attributes/title"))
                    expect(error?.source?.parameter).to(match("URIparam"))
                }
            }
        }
    }
}
