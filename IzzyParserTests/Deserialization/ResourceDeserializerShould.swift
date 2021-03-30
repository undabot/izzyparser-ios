import Foundation
import Quick
import Nimble
@testable import IzzyParser

// swiftlint:disable function_body_length
// swiftlint:disable force_cast
class ResourceDeserializerShould: QuickSpec {
    
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
        
        describe("deserialize(from json: [String: Any]?)") {
            it("should return article object with id and type") {
                let data = try? Data(with: "Base", for: type(of: self))
                let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                var article: Article?
                
                expect {
                    article = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                }.toNot(throwError())
                
                expect(article?.id).to(match("1"))
            }
            
            context("and resource is not registered in resourceMap") {
                context("and debug mode is off") {
                    it("should not throw assertion") {
                        let data = try? Data(with: "Base", for: type(of: self))
                        let json = ((try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]) as [String : Any]??)
                        sut.resourceMap = nil
                        var article: Article?
                        
                        expect {
                            article = try sut.deserializeResource(from: json!!["data"] as! [String: Any])
                        }.toNot(throwError())
                        
                        expect(article).to(beNil())
                    }
                }
                context("and debug mode is on") {
                    it("should throw an error") {
                        let data = try? Data(with: "Base", for: type(of: self))
                        let json = ((try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]) as [String : Any]??)
                        sut.resourceMap = nil
                        sut.isDebugModeOn = true
                        
                        expect {
                            let _ = try sut.deserializeResource(from: json!!["data"] as! [String: Any])
                        }.to(throwError())
                    }
                }
            }
            
            context("and attributes and relationships are null") {
                it("should return resource object with id and type") {
                    let data = try? Data(with: "NullAttributesAndRelationships", for: type(of: self))
                    let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    var article: Resource?
                    
                    expect {
                        article = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                    }.toNot(throwError())
                    
                    expect(article?.id).to(match("1"))
                }
            }
            
            context("and article has different attributes") {
                it("should return article with properly filled attributes") {
                    let data = try? Data(with: "AuthorWithDifferentAttributes", for: type(of: self))
                    let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    var author: Author?
                    
                    expect {
                        author = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                    }.toNot(throwError())
                    
                    expect(author?.firstName).to(match("John"))
                    expect(author?.lastName).to(match("Snow"))
                    expect(author?.nickname).to(beNil())
                    expect(author?.age).to(equal(32))
                    expect(author?.isMarried?.boolValue).to(equal(true))
                    expect(author?.luckyNumbers).to(equal([4, 6, 8]))
                    expect(author?.luckyNames).to(equal(["John", "Black"]))
                    expect(author?.luckyKeyValuePairs?[0]["luckyKey"]).to(equal(4))
                    expect(author?.luckyKeyValuePairs?[1]["otherLuckyKey"]).to(equal(76))
                    expect(author?.favoriteKeyValue?["favoriteKey"]).to(equal(5))
                }
            }
            
            context("and article has author relationship") {
                it("should return article with author's id and type") {
                    let data = try? Data(with: "ArticleWithAuthorRelationship", for: type(of: self))
                    let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    var article: Article?
                    
                    expect {
                        article = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                    }.toNot(throwError())
                    
                    expect(article?.author?.id).to(match("1"))
                }
            }
            
            context("and related article class is article's subclass") {
                it("should return related article filled with attributes and relationships from article class") {
                    let data = try? Data(with: "RelatedArticle", for: type(of: self))
                    let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    var article: RelatedArticle?
                    
                    expect {
                        article = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                    }.toNot(throwError())
                    
                    expect(article?.author?.id).to(match("9"))
                    expect(article?.customAttribute).notTo(beNil())
                    expect(article?.customAttribute?.name).to(match("Custom Attribute"))
                    expect(article?.title).to(match("JSON API paints my bikeshed!"))
                    expect(article?.relatedHeadline).to(match("Super related article"))
                }
            }
            
            context("and reply has author relationship with custom key") {
                it("should return reply with author's id and type") {
                    let data = try? Data(with: "Reply", for: type(of: self))
                    let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    var reply: Reply?
                    
                    expect {
                        reply = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                    }.toNot(throwError())
                    
                    expect(reply?.replyAuthor?.id).to(match("1"))
                }
            }
            
            context("and article has invalid author relationship") {
                it("should return article where author is nil") {
                    let data = try? Data(with: "ArticleWithInvalidRelationship", for: type(of: self))
                    let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    var article: Article?
                    
                    expect {
                        article = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                    }.toNot(throwError())
                    
                    expect(article?.author).to(beNil())
                }
            }
            
            context("and article has tags relationship") {
                it("should return article with array of tag with corresponding ids") {
                    let data = try? Data(with: "ArticleWithTagCollectionRelationship", for: type(of: self))
                    let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    var article: Article?
                    
                    expect {
                        article = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                    }.toNot(throwError())
                    
                    expect(article?.tags?.count).to(equal(2))
                    expect(article?.tags?.first?.id).to(equal("2"))
                    expect(article?.tags?.last?.id).to(equal("3"))
                }
            }
            
            context("and article has custom attribute") {
                it("should get custom attribute from json which can be custom deserialized") {
                    let data = try? Data(with: "ArticleWithCustomAttribute", for: type(of: self))
                    let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    var article: Article?
                    
                    expect {
                        article = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                    }.toNot(throwError())
                    
                    expect(article?.customAttribute).notTo(beNil())
                    expect(article?.customAttribute?.name).to(match("Custom Attribute"))
                }
            }
            
            context("article has author relationship with custom attribute") {
                it("should return article FakeCustomAttribute and article.author with nil customAttribute, both for key 'customAttribute'") {
                    let data = try? Data(with: "ArticleWithRelationshipWithCustomAttribute", for: type(of: self))
                    let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    var article: Article?
                    
                    expect {
                        article = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                    }.toNot(throwError())
                    
                    let author = article?.author
                    expect(author).toNot(beNil())
                    expect(author?.id).to(match("9"))
                    
                    expect(article?.author).notTo(beNil())
                    expect(article?.customAttribute?.name).to(match("Custom Attribute"))
                    expect(article?.author?.customAttribute).to(beNil())
                }
            }
            
            context("and article has links") {
                context("and has self link") {
                    it("should return article with self link") {
                        let data = try? Data(with: "ArticleWithSelfLink", for: type(of: self))
                        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                        var article: Article?
                        
                        expect {
                            article = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                        }.toNot(throwError())
                        
                        expect(article?.links?.`self`?.url).to(equal("http://example.com/articles/1"))
                    }
                }
                
                context("and has related link") {
                    it("should return article with self link and related link") {
                        let data = try? Data(with: "ArticleWithSelfAndRelatedLinks", for: type(of: self))
                        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                        var article: Article?
                        
                        expect {
                            article = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                        }.toNot(throwError())
                        
                        expect(article?.links?.`self`?.url).to(equal("http://example.com/articles/1"))
                        expect(article?.links?.related?.url).to(equal("http://example.com/articles/1/author"))
                    }
                }
                
                context("and has relationship with self and related links") {
                    it("should return article with author which has self and related link") {
                        let data = try? Data(with: "ArticleWithAttributesAndRelationships", for: type(of: self))
                        let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                        var article: Article?
                        
                        expect {
                            article = try sut.deserializeResource(from: json!["data"] as! [String: Any])
                        }.toNot(throwError())
                        
                        expect(article?.author?.id).to(match("9"))
                        
                        expect(article?.author?.links?.`self`?.url).to(match("/articles/1/relationships/author"))
                        expect(article?.author?.links?.related?.url).to(match("/articles/1/author"))
                    }
                }
            }
        }
    }
}
