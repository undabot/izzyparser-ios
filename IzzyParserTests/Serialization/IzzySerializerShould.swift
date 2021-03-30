import Foundation
import Quick
import Nimble
@testable import IzzyParser

// swiftlint:disable function_body_length
// swiftlint:disable type_body_length
class IzzySerializerShould: QuickSpec {
    
    override func spec() {
        var sut: IzzySerializer!
        
        beforeEach {
            sut = IzzySerializer()
        }
        
        afterEach {
            sut = nil
        }
        
        describe("serialize(_ resource: Resource)") {
            
            context("Resource A has only identity (`id` and `type`)") {
                it("should create json from resource with `id` and `type` key-values") {
                    let book = Book(id: "1", author: nil)
                    let json = sut.serialize(resource: book)

                    let dataJson = json["data"] as? [String: Any]

                    expect(dataJson?["id"] as? String).to(match(book.id))
                    expect(dataJson?["type"] as? String).to(match(Book.type))
                }
            }

            context("Resource A has a title property") {
                it("should serialize title as value in `attributes` object") {
                    let book = Book(id: "2", title: "Some title", author: nil)

                    let json = sut.serialize(resource: book)

                    let dataJson = json["data"] as? [String: Any]
                    let attributesJson = dataJson?["attributes"] as? [String: Any]

                    expect(dataJson?["id"] as? String).to(equal(book.id))
                    expect(dataJson?["type"] as? String).to(equal(Book.type))
                    expect(attributesJson?["title"] as? String).to(match(book.title))
                }
            }

            context("Resource A has properties: title and author resource") {
                it("should serialize identity, title attribute and author as a relationship") {
                    let person = Person(id: "author", someIntAttribute: 1 as NSNumber, bones: nil)
                    let book = Book(id: "3", title: "Some title", author: person)

                    let json = sut.serialize(resource: book)

                    let dataJson = json["data"] as? [String: Any]
                    let attributesJson = dataJson?["attributes"] as? [String: Any]
                    let relationshipJson = dataJson?["relationships"] as? [String: Any]

                    expect(dataJson?["id"] as? String).to(equal(book.id))
                    expect(dataJson?["type"] as? String).to(equal(Book.type))
                    expect(attributesJson?["title"] as? String).to(match(book.title))
                    expect(dataJson?["author"]).to(beNil())
                    expect(attributesJson?["author"]).to(beNil())
                    expect(relationshipJson?["author"]).toNot(beNil())
                }
            }
            
            context("Resource SpecialBook is sublcass of Book that has properties: specialTitle and specialAuthor") {
                    it("should serialize identity, title attribute and author from superclass and specialTitle and specialAuthor") {
                        let person = Person(id: "author", someIntAttribute: 1 as NSNumber, bones: nil)
                        let specialAuthor = Person(id: "special", someIntAttribute: 4 as NSNumber, bones: nil)
                        let book = SpecialBook(specialTitle: "Special test title", specialAuthor: specialAuthor, author: person)

                        let json = sut.serialize(resource: book)

                        let dataJson = json["data"] as? [String: Any]
                        let attributesJson = dataJson?["attributes"] as? [String: Any]
                        let relationshipJson = dataJson?["relationships"] as? [String: Any]

                        expect(dataJson?["id"] as? String).to(equal(book.id))
                        expect(dataJson?["type"] as? String).to(equal(Book.type))
                        expect(attributesJson?["title"] as? String).to(match(book.title))
                        expect(attributesJson?["special_title"] as? String).to(match(book.specialTitle))
                        expect(dataJson?["author"]).to(beNil())
                        expect(attributesJson?["author"]).to(beNil())
                        expect(relationshipJson?["author"]).toNot(beNil())
                        expect(relationshipJson?["special_author"]).toNot(beNil())
                    }
                }

            context("Resource A has properties with Bool and Int values") {
                it("should serialize identity, Bool and Int values") {
                    let person = Person(id: "author", someBool: true, someIntAttribute: 4, bones: nil)

                    let json = sut.serialize(resource: person)

                    let dataJson = json["data"] as? [String: Any]
                    let attributesJson = dataJson?["attributes"] as? [String: Any]

                    expect(dataJson?["id"] as? String).to(match(person.id))
                    expect(dataJson?["type"] as? String).to(match(Person.type))
                    expect(attributesJson?["someBool"] as? Bool).to(equal(person.someBool?.boolValue))
                    expect(attributesJson?["some_int_attribute"] as? Int).to(equal(person.someIntAttribute?.intValue))
                }
            }
            
            context("Resource A has property B of type Array") {
                
                context("and property B is NOT array of Resources") {
                    it("should serialize property B as array in attributes") {
                        let similarBone = Bone(id: "2", name: .null)
                        let similarBones = [similarBone, similarBone]
                        let boneFamily = BoneFamily(id: "familyID")
                        let bone = Bone(id: "1", name: "Tibula", family: boneFamily, similar: similarBones, terminology: ["terminology"])
                        bone.numericIdentifiers = .null
                        let bones: [Bone] = [bone, bone]
                        let author = Person(id: "autor", someIntAttribute: 4 as NSNumber, bones: bones)

                        let json = sut.serialize(resource: author)

                        let dataJson = json["data"] as? [String: Any]
                        let attributesJson = dataJson?["attributes"] as? [String: Any]
                        
                        let bonesJson = attributesJson?["bones"] as? [[String: Any]]
                        let boneJson = bonesJson?.first
                        let similarBonesJson = boneJson?["similar"] as? [[String: Any]]
                        let similarBoneJson = similarBonesJson?.first
                        let terminologyJson = boneJson?["terminology"] as? [String]
                        let numericIdentifiersJson = boneJson?["numericIdentifiers"] as? [Any]
                        let firstNumericIdentifierJson = numericIdentifiersJson?.first as? NSNull
                        let boneAttributesJson = boneJson?["terminology"] as? [String]

                        expect(boneJson?["id"] as? String).to(equal(bone.id))
                        expect(boneJson?["name"] as? String).to(equal(bone.name))
                        expect(similarBoneJson?["id"] as? String).to(match(similarBone.id))
                        expect(similarBoneJson?["name"]).to(beAKindOf(NSNull.self))
                        expect(terminologyJson).to(equal(bone.terminology))
                        expect(firstNumericIdentifierJson).toNot(beNil())
                        expect(boneAttributesJson?.first).to(equal("terminology"))
                    }
                }
                
                context("and property B IS array of Resources") {
                    it("should serialize property B's identity as array in relationships") {
                        let tag = BookTag(id: "tagId", description: "tag description")
                        let tags = [tag, tag]
                        let book = Book(id: "id", title: nil, author: nil, home: nil, tags: tags)

                        let json = sut.serialize(resource: book)

                        let dataJson = json["data"] as? [String: Any]
                        let relationshipsJson = dataJson?["relationships"] as? [String: Any]
                        let tagsJson = relationshipsJson?["tags"] as? [[String: Any]]
                        let tagDataJson = tagsJson?.first?["data"] as? [String: Any]
                        
                        expect(tagDataJson?["id"] as? String).to(equal(tag.id))
                        expect(tagDataJson?["type"] as? String).to(equal(BookTag.type))
                        expect(tagDataJson?["decription"] as? String).to(beNil())
                    }
                }
            }

            context("Resource A has Int value, with NO Bool value") {
                it("should serialize base identifier and Int value as Int") {
                    let author = Person(id: "autor", someIntAttribute: 4, bones: nil)

                    let json = sut.serialize(resource: author)

                    let dataJson = json["data"] as? [String: Any]
                    let attributesJson = dataJson?["attributes"] as? [String: Any]

                    expect(dataJson?["id"] as? String).to(match(author.id))
                    expect(dataJson?["type"] as? String).to(match(Person.type))
                    expect(attributesJson?["someBool"]).to(beNil())
                    expect(attributesJson?["some_int_attribute"] as? Int).to(equal(author.someIntAttribute?.intValue))
                }
            }

            context("Resource A has property of type String") {

                context("and property value is String.null") {
                    it("should serialize property value as null") {
                        let book = Book(id: "id", title: .null, author: nil, home: nil)

                        let json = sut.serialize(resource: book)

                        let dataJson = json["data"] as? [String: Any]
                        let attributesJson = dataJson?["attributes"] as? [String: Any]

                        expect(attributesJson?["title"]).to(beAKindOf(NSNull.self))
                    }
                }
            }

            context("Resource A has object B as property") {

                context("and object B is not Resource type") {
                    it("should serialize object B as attribute") {
                        let home = Home(id: 1, address: "Imaginary street")
                        let book = Book(id: "id", title: "title", author: nil, home: home)
                        let subchapter = book.subchapters.first!["1"] as? [String]

                        let json = sut.serialize(resource: book)

                        let dataJson = json["data"] as? [String: Any]
                        let attributesJson = dataJson?["attributes"] as? [String: Any]
                        let homeJson = attributesJson?["home"] as? [String: Any]
                        let chaptersJson = attributesJson?["chapters"] as? [Any]
                        let firstChapterJson = chaptersJson?.first as? String
                        let lastChapterJson = chaptersJson?.last as? NSNull
                        let subchaptersJson = attributesJson?["subchapters"] as? [Any]
                        let firstSubchapterJson = subchaptersJson?.first as? [String: Any]
                        let firstSubchapterValueJson = firstSubchapterJson?["1"] as? [String]
                        let lastSubchapterJson = subchaptersJson?.last as? NSNull

                        expect(homeJson?["id"] as? Int).to(equal(book.home?.id))
                        expect(homeJson?["address"] as? String).to(equal(book.home?.address))
                        expect(firstChapterJson).to(equal(book.chapters.first))
                        expect(lastChapterJson).to(equal(NSNull()))
                        expect(firstSubchapterValueJson).to(equal(subchapter))
                        expect(lastSubchapterJson).toNot(beNil())
                    }
                }

                context("and object B is Resource type") {
                    it("should serialize object B as relationship") {
                        let author = Person(id: "2", someIntAttribute: 3 as NSNumber, bones: nil)
                        let book = Book(id: "1", title: "title", author: author, home: nil)

                        let json = sut.serialize(resource: book)

                        let dataJson = json["data"] as? [String: Any]
                        let relationshipsJson = dataJson?["relationships"] as? [String: Any]
                        let authorJson = relationshipsJson?["author"] as? [String: Any]
                        let authorDataJson = authorJson?["data"] as? [String: Any]

                        expect(authorDataJson?["id"] as? String).to(equal(author.id))
                        expect(authorDataJson?["type"] as? String).to(equal(Person.type))
                        expect(authorDataJson?["someIntAttribute"] as? Int).to(beNil())
                    }
                }
            }
        }

        describe("serialize(_ resource: Resource, with attributeKey: String, attributeValue: Any)") {

            context("Resource A has property B of type String") {
                it("should serialize resource A with custom attribute instead of serializing property B") {
                    let book = Book(id: "id", title: "title", author: nil, home: nil, tags: nil)

                    let json = sut.serialize(book, attributeKey: "title", attributeValue: "custom value")

                    let dataJson = json["data"] as? [String: Any]
                    let attributesJson = dataJson?["attributes"] as? [String: Any]

                    expect(attributesJson?["title"] as? String).to(match("custom value"))
                }
            }

            context("Resource A has property B of type NSObject") {
                it("should serialize resource A with custom attribute instead of serializing property B") {
                    let home = Home(id: 1, address: "address")
                    let book = Book(id: "id", title: "title", author: nil, home: home, tags: nil)
                    let homeDictionary: [String: Any] = ["id": 2, "address": "custom address"]

                    let json = sut.serialize(book, attributeKey: "home", attributeValue: homeDictionary)

                    let dataJson = json["data"] as? [String: Any]
                    let attributesJson = dataJson?["attributes"] as? [String: Any]
                    let homeJson = attributesJson?["home"] as? [String: Any]

                    expect(homeJson?["id"] as? Int).to(equal(2))
                    expect(homeJson?["address"] as? String).to(match("custom address"))
                }
            }
        }

        describe("serialize(_ resource: Resource, relationshipKey: String, relationshipValue: Any)") {

            context("Resource A has property B of type Resource") {
                it("should serialize resource A with custom relationship value instead of serializing property B") {
                    let tag = BookTag(id: "id", description: "description")
                    let book = Book(id: "id", title: "title", author: nil, home: nil, tags: [tag])
                    let tagsDictionary: [[String: Any]] = [
                        ["data": [
                            "id": "custom id",
                            "type": "custom type"
                            ]
                        ]]

                    let json = sut.serialize(book, relationshipKey: "tags", relationshipValue: tagsDictionary)

                    let dataJson = json["data"] as? [String: Any]
                    let relationshipsJson = dataJson?["relationships"] as? [String: Any]
                    let tagsJson = relationshipsJson?["tags"] as? [[String: Any]]
                    let tagDataJson = tagsJson?.first?["data"] as? [String: Any]

                    expect(tagDataJson?["id"] as? String).to(match("custom id"))
                    expect(tagDataJson?["type"] as? String).to(match("custom typ"))
                }
            }
        }

        describe("serialize(resourceCollection: [Resource]") {

            context("Object A is collection of resource objects B") {

                context("and object B has attribute of type String") {
                    it("should serialize collection as data array with attributes") {
                        let tag = BookTag(id: "tagId", description: "tag description")
                        let tags = [tag, tag]

                        let json = sut.serialize(resourceCollection: tags)

                        let dataJson = json["data"] as? [[String: Any]]
                        let tagJson = dataJson?.first
                        let attributesJson = tagJson?["attributes"] as? [String: Any]

                        expect(tagJson?["id"] as? String).to(match(tag.id))
                        expect(tagJson?["type"] as? String).to(match(BookTag.type))
                        expect(attributesJson?["description"] as? String).to(match(tag.desc))
                    }
                }

                context("and object B has relationships") {
                    it("should serialize collection as data array with relationships") {
                        let author = Person(id: "authorID", someIntAttribute: 1, bones: nil)
                        let book = Book(id: "bookID", title: "title", author: author, home: nil, tags: nil)
                        let books = [book, book]

                        let json = sut.serialize(resourceCollection: books)

                        let dataJson = json["data"] as? [[String: Any]]
                        let bookJson = dataJson?.first
                        let attributesJson = bookJson?["attributes"] as? [String: Any]
                        let relationshipsJson = bookJson?["relationships"] as? [String: Any]
                        let authorJSON = relationshipsJson?["author"] as? [String: Any]
                        let authorDataJSON = authorJSON?["data"] as? [String: Any]

                        expect(authorDataJSON?["id"] as? String).to(match(book.author?.id))
                        expect(authorDataJSON?["type"] as? String).to(match(Person.type))
                        expect(attributesJson?["title"] as? String).to(match(book.title))
                    }
                }
            }
        }
    }
}
