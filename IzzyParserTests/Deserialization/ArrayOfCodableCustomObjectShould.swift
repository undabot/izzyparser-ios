import Foundation
import Quick
import Nimble
@testable import IzzyParser

// swiftlint:disable force_cast
class ArrayOfCodableCustomObjectShould: QuickSpec {
    override func spec() {
        var sut: ResourceDeserializer!
        
        beforeEach {
            sut = ResourceDeserializer()
            sut.resourceMap = ["articles": Article.self,
                               "people": Author.self,
                               "tags": Tag.self,
                               "comments": Comment.self,
                               "reply": Reply.self,
                               "related_articles": RelatedArticle.self]
        }
        
        afterEach {
            sut = nil
        }

        describe("An object with an [CustomCodableObject]") {
            
            context("It has a typesForKeys override with the proper type") {
                it("should store the inline JSON array into the object") {
                    let data = try? Data(with: "CommentWithReplies", for: type(of: self))
                    let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    var comment: Comment?
                    
                    expect {
                        comment = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                    }.toNot(throwError())
                    
                    expect(comment?.replies?.isEmpty).to(beFalse())
                }
            }
            
            context("It's missing the typesForKeys override with the proper type") {
                it("should fail to decode the array, throwing a runtime exception") {
                    let data = try? Data(with: "CommentWithReplies", for: type(of: self))
                    let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    var comment: BrokenComment?
                    
                    expect {
                        comment = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                    }.toNot(throwError())
                    
                    expect(comment?.replies).to(beNil())
                }
            }
        }
    }
}
