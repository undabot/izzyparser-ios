import Quick
import Nimble
@testable import IzzyParser

// swiftlint:disable function_body_length
// swiftlint:disable type_body_length
class IzzyDeserializerShould: QuickSpec {

    override func spec() {
        var sut: IzzyDeserializer!

        beforeEach {
            sut = IzzyDeserializer()
            sut.resourceDeserializer = ResourceDeserializer()
            sut.resourceDeserializer.resourceMap = [ Article.type: Article.self,
                                                     Author.type: Author.self,
                                                     Tag.type: Tag.self,
                                                     Comment.type: Comment.self
                                                    ]
            sut.linksDeserializer = LinksDeserializer()
        }

        afterEach {
            sut = nil
        }
        
        describe("deserialize<T: Resource>(_ data: Data) -> Document<T>") {

            context("and data is invalid") {
                it("should throw invalidJSONFormat error") {
                    let data = try? Data(with: "RandomData", for: type(of: self))
                    var document: Document<Resource>?

                    expect {
                        document = try sut.deserialize(data!)
                        }.to(throwError { (error: IzzyError) in expect(error.description).to(equal(IzzyError.invalidJSONFormat.description))
                        })
                    
                    expect(document).to(beNil())
                }
            }

            context("and data is null") {
                it("should return nil") {
                    let data = try? Data(with: "NullData", for: type(of: self))
                    var document: Document<Resource>?

                    expect {
                        document = try sut.deserialize(data!)
                        }.toNot(throwError())

                    expect(document?.data).to(beNil())
                }
            }
            
            context("and Resource type is not overriden") {
                it("should throw error when registering resource") {
                    
                    expect {
                        sut.resourceDeserializer.resourceMap = [ThrowableResource.type: ThrowableResource.self]
                    }.to(throwAssertion())
                }
            }

            context("and json contains errors and data fields") {
                it("should throw invalidJSONAPIResponse error") {
                    let data = try? Data(with: "InvalidJson", for: type(of: self))
                    var document: Document<Resource>?

                    expect {
                        document = try sut.deserialize(data!)
                        }
                        .to(throwError { (error: IzzyError) in expect(error.description).to(equal(IzzyError.invalidJSONAPIResponse.description))
                        })
                    
                    expect(document).to(beNil())
                }
            }
            
            context("and json contains only errors field") {
                it("should create document with error") {
                    let data = try? Data(with: "ErrorsCollection", for: type(of: self))
                    
                    let document: Document<[Resource]>? = try? sut.deserializeCollection(data!)
                    let errors = document?.errors
                    
                    expect(document?.data).to(beNil())
                    expect(errors).toNot(beNil())
                    expect(errors?.first).to(beAKindOf(JSONAPIError.self))
                }
            }
            
            context("and json contains only data field") {
                it("should corectly deserialize and link resources") {
                    let data = try? Data(with: "MultipleRelationships", for: type(of: self))
                    var document: Document<Article>?
                    
                    expect {
                        document = try sut.deserialize(data!)
                        }.toNot(throwError())
                    
                    let article = document?.data
                    expect(article?.id).to(equal("1"))
                    expect(article?.title).to(equal("JSON API paints my bikeshed!"))
                    expect(article?.author?.firstName).to(equal("Dan"))
                    expect(article?.author?.lastName).to(equal("Gebhardt"))
                    expect(article?.author?.twitter).to(equal("dgeb"))
                    expect(article?.comments?.first?.body).to(equal("First!"))
                    expect(article?.comments?[1].body).to(equal("I like XML better"))
                    expect(article?.comments?[1].author).to(equal(article?.author))
                }
                
                context("and author has top level links") {
                    it("should return document with links dictionary") {
                        let data = try? Data(with: "ToOneRelationshipLink", for: type(of: self))
                        var document: Document<Author>?
                        
                        expect {
                            document = try sut.deserialize(data!)
                            }.toNot(throwError())
                        
                        let links = document?.links
                        expect(links).notTo(beNil())
                        expect(links?.`self`?.url).to(match("/articles/1/relationships/author"))
                        expect(links?.related?.url).to(match("/articles/1/author"))
                    }
                    
                    context("and article has top level links and a relationship") {
                        it("should return document with links") {
                            let data = try? Data(with: "ArticleWithLinksAndAuthorRelationships", for: type(of: self))
                            var document: Document<Article>?
                            
                            expect {
                                document = try sut.deserialize(data!)
                                }.toNot(throwError())
                            
                            let links = document?.links
                            expect(links).notTo(beNil())
                            expect(links?.`self`?.url).to(match("http://example.com/articles/1"))
                        }
                    }
                    
                    context("and article has top level links") {
                        it("should return document with links") {
                            let data = try? Data(with: "ArticleWithTopLevelSelfLinkObject", for: type(of: self))
                            var document: Document<Article>?
                            
                            expect {
                                document = try sut.deserialize(data!)
                                }.toNot(throwError())
                            
                            let links = document?.links
                            expect(links).notTo(beNil())
                            
                            let relatedLinks = links?.related
                            expect(relatedLinks).notTo(beNil())
                            expect(relatedLinks?.url).to(match("http://example.com/articles/"))
                            
                            let metaDictionary = relatedLinks?.meta as? [String: Any]
                            let count = metaDictionary?["count"]
                            expect(count as? Int).to(equal(10))
                        }
                    }
                }
            }
            
            context("and article has author relationship with meta") {
                it("should return article with author that contains meta") {
                    let data = try? Data(with: "ArticleWithAuthorMeta", for: type(of: self))
                    var document: Document<Article>?
                    
                    expect {
                        document = try sut.deserialize(data!)
                        }.toNot(throwError())
                    
                    let metaResource = document?.data?.author?.meta?["resource"] as? [String: Any]
                    expect(document?.data?.author?.id).to(match("9"))
                    expect(metaResource?["id"] as? Int).to(equal(43))
                    expect(metaResource?["url"] as? String).to(match("https://www.google.com/test"))
                }
            }

            context("and response is empty (no content)") {
                it("should return empty document") {
                    let data = try? Data(with: "EmptyResponse", for: type(of: self))
                    var document: Document<Resource>?

                    expect {
                        document = try sut.deserialize(data!)
                        }.toNot(throwError())

                    expect(document).toNot(beNil())
                }
            }
        }
        
        describe("deserializeCollection<T: Resource>(_ data: Data) -> Document<[T]>") {

            context("and data is invalid") {
                it("should throw invalidJSONFormat error") {
                    let data = try? Data(with: "RandomData", for: type(of: self))
                    var document: Document<[Resource]>?

                    expect {
                        document = try sut.deserializeCollection(data!)
                        }.to(throwError { (error: IzzyError) in expect(error.description).to(equal(IzzyError.invalidJSONFormat.description))
                        })
                    
                    expect(document).to(beNil())
                }
            }

            context("data is empty") {
                it("should return empty array") {
                    let data = try? Data(with: "EmptyData", for: type(of: self))
                    var document: Document<[Resource]>?

                    expect {
                        document = try sut.deserializeCollection(data!)
                        }.toNot(throwError())

                    expect(document?.data).to(beEmpty())
                }
            }
            
            context("and json contains only errors field") {
                it("should create document with error") {
                    let data = try? Data(with: "ErrorsCollection", for: type(of: self))
                    
                    let document: Document<[Resource]>? = try? sut.deserializeCollection(data!)
                    let errors = document?.errors
                    
                    expect(document?.data).to(beNil())
                    expect(errors).toNot(beNil())
                    expect(errors?.first).to(beAKindOf(JSONAPIError.self))
                }
            }

            context("and only one object is inside of a collection") {
                it("should return comment object with id and type") {
                    let data = try? Data(with: "OneObjectCollection", for: type(of: self))
                    var document: Document<[Resource]>?

                    expect {
                        document = try sut.deserializeCollection(data!)
                        }.toNot(throwError())

                    expect(document?.data?.first?.id).to(match("123"))
                }
            }

            context("and every comment in a collection has attributes") {
                it("should return comments with attribute 'title'") {
                    let data = try? Data(with: "CollectionOfArticlesWithAttributes", for: type(of: self))
                    var document: Document<[Comment]>?

                    expect {
                        document = try sut.deserializeCollection(data!)
                        }.toNot(throwError())

                    expect(document?.data?.count).to(equal(2))

                    let firstComment = document?.data?[0]
                    let secondComment = document?.data?[1]

                    expect(firstComment?.title).to(match("This is the first title"))
                    expect(secondComment?.title).to(match("This is the second title"))
                }
            }
            
            context("and every article inside of a collection has custom attribute") {
                it("should get custom attribute from json which can be custom deserialized") {
                    let data = try? Data(with: "ArticleCollectionWithCustomAttributes", for: type(of: self))
                    var document: Document<[Article]>?
                    
                    expect {
                        document = try sut.deserializeCollection(data!)
                        }.toNot(throwError())
                    
                    let firstArticle = document?.data?[0]
                    let secondArticle = document?.data?[1]
                    let thirdArticle = document?.data?[2]
                    let fourthArticle = document?.data?[3]
                    let fifthArticle = document?.data?[4]
                    
                    expect(firstArticle?.customAttribute?.name).to(match("Custom Attribute 1"))
                    expect(secondArticle?.customAttribute?.name).to(match("Custom Attribute 2"))
                    expect(thirdArticle?.customAttribute?.name).to(beNil())
                    expect(fourthArticle?.anotherCustomAttribute?.anotherName).to(match("Custom Attribute 4"))
                    expect(fifthArticle?.codableCustomAttribute?.codableName).to(equal("Codable Name"))
                }
            }

            context("and json contains only data field") {
                context("collection of tags has top level links") {
                    it("should return collection of tags with links") {
                        let data = try? Data(with: "ToManyRelationshipsLink", for: type(of: self))
                        var document: Document<[Tag]>?

                        expect {
                            document = try sut.deserializeCollection(data!)
                            }.toNot(throwError())

                        let links = document?.links
                        expect(links).notTo(beNil())
                        expect(links?.`self`?.url).to(match("/articles/1/relationships/tags"))
                        expect(links?.related?.url).to(match("/articles/1/tags"))
                    }
                    
                    context("and collection of tags has top level pagination links") {
                        it("should return collection of tags with pagination links") {
                            let data = try? Data(with: "ArticleWithPaginationLinks", for: type(of: self))
                            var document: Document<[Article]>?
                            
                            expect {
                                document = try sut.deserializeCollection(data!)
                                }.toNot(throwError())

                            let links = document?.links
                            expect(links).notTo(beNil())
                            expect(links?.`self`?.url).to(equal("http://example.com/articles?page[number]=3&page[size]=1"))
                            expect(links?.first?.url).to(equal("http://example.com/articles?page[number]=1&page[size]=1"))
                            expect(links?.last?.url).to(equal("http://example.com/articles?page[number]=13&page[size]=1"))
                            expect(links?.prev?.url).to(equal("http://example.com/articles?page[number]=2&page[size]=1"))
                            expect(links?.next?.url).to(equal("http://example.com/articles?page[number]=4&page[size]=1"))
                        }
                    }
                }
            }

            context("and response is empty (no content)") {
                it("should return empty document") {
                    let data = try? Data(with: "EmptyResponse", for: type(of: self))
                    var document: Document<[Resource]>?

                    expect {
                        document = try sut.deserializeCollection(data!)
                        }.toNot(throwError())

                    expect(document).toNot(beNil())
                }
            }
        }
        
        describe("isDebugModeOn") {

            context("debug mode is set") {
                it("should set the debug mode on resource deserializer") {
                    
                    expect(sut.resourceDeserializer.isDebugModeOn).to(equal(sut.isDebugModeOn))

                    var debugFlag = true
                    sut.isDebugModeOn = debugFlag
                    
                    expect(sut.resourceDeserializer.isDebugModeOn).to(equal(debugFlag))
                    expect(sut.resourceDeserializer.isDebugModeOn).to(equal(sut.isDebugModeOn))
                    
                    debugFlag = false
                    sut.isDebugModeOn = debugFlag
                    
                    expect(sut.resourceDeserializer.isDebugModeOn).to(equal(debugFlag))
                    expect(sut.resourceDeserializer.isDebugModeOn).to(equal(sut.isDebugModeOn))
                }
            }
        }
    }
}
