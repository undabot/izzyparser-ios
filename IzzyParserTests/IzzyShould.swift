import Foundation
import Quick
import Nimble
@testable import IzzyParser

// swiftlint:disable function_body_length
class IzzyShould: QuickSpec {

    override func spec() {
        var izzyDeserializer: IzzyDeserializerMock!
        var izzySerializer: IzzySerializerMock!
        var sut: Izzy!

        var emptyData: Data!
        var book: Book!

        beforeEach {
            izzyDeserializer = IzzyDeserializerMock()
            izzySerializer = IzzySerializerMock()

            sut = Izzy()
            sut.deserializer = izzyDeserializer
            sut.registerResources(resources: [])
            sut.serializer = izzySerializer

            emptyData = Data()
            book = Book(id: "bookID")
        }

        afterEach {
            izzyDeserializer = nil
            izzySerializer = nil

            sut = nil

            emptyData = nil
            book = nil
        }

        describe("deserializeResource<T: Resource>(from data: Data)") {
            it("should tell IzzyDeserializer to deserialize data with single resource") {
                _ = try? sut.deserializeResource(from: emptyData)

                expect(izzyDeserializer.didDeserializeSingle).to(beTrue())
            }
        }

        describe("deserializeCollection<T: Resource>(_ data: Data)") {
            it("should tell IzzyDeserializer to deserialize data with resource collection") {
                _ = try? sut.deserializeCollection(emptyData)

                expect(izzyDeserializer.didDeserializeCollection).to(beTrue())
            }
        }

        describe("serialize(resource: Resource)") {
            it("should tell IzzySerializer to serialize single resource") {
                _ = sut.serialize(resource: book)

                expect(izzySerializer.didSerializeSingle).to(beTrue())
            }
        }

        describe("serialize(resourceCollection: [Resource])") {
            it("should tell IzzySerializer to serialize resource collection") {
                _ = sut.serialize(resourceCollection: [book])

                expect(izzySerializer.didSerializeCollection).to(beTrue())
            }
        }

        describe("serializeCustom(resource: Resource, attributeKey: String, attributeValue: Any)") {
            it("should tell IzzySerializer to serialize resource with custom attribute") {
                _ = sut.serializeCustom(resource: book, attributeKey: "home", attributeValue: NSNull())

                expect(izzySerializer.didSerializeSingleWithCustomAttribute).to(beTrue())
            }
        }

        describe("serializeCustom(resource: Resource, relationshipKey: String, relationshipValue: Any)") {
            it("should tell IzzySerializer to serialize resource with custom relationship") {
                _ = sut.serializeCustom(resource: book, attributeKey: "author", attributeValue: NSNull())

                _ = sut.serializeCustom(resource: book, relationshipKey: "author", relationshipValue: NSNull())

                expect(izzySerializer.didSerializeSingleWithCustomRelationship).to(beTrue())
            }
        }
        
        describe("isDebugModeOn") {
            it("should set the debug mode on ResourceDeserializer") {
                sut.isDebugModeOn = true

                expect(izzyDeserializer.didSetDebugMode).to(beTrue())
                expect(izzyDeserializer.isDebugModeOn).to(beTrue())
            }
        }
    }
}
