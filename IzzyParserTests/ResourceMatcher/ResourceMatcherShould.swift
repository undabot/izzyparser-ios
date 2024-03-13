import Quick
import Nimble
@testable import IzzyParser

// swiftlint:disable function_body_length
class ResourceMatcherShould: QuickSpec {

    override class func spec() {
        var sut: [Resource]!
        var author: Author!
        var comment: Comment!
        var post: Post!

        beforeEach {
            sut = [Resource]()
            author = Author(id: "123")
            comment = Comment(id: "321")
            post = Post(id: "1")
        }

        afterEach {
            sut = nil
            author = nil
            comment = nil
            post = nil
        }

        describe("linkResources()") {

            context("and there are no resources in dictionary") {
                it("should return empty dictionary") {
                    sut.linkResources()

                    expect(sut.isEmpty).to(beTrue())
                }
            }

            context("there is resource A with relationship to resource B") {

                context("but resource B is not included") {
                    it("should return resources with no linked relationships") {
                        author.comment = Comment(id: "2")

                        sut = [author, comment]
                        sut.linkResources()
                        let linkedAuthor = sut.first as? Author

                        expect(linkedAuthor?.comment).toNot(equal(comment))
                        expect(linkedAuthor?.comment).toNot(beNil())
                    }
                }

                context("and resource B is included") {
                    it("should return resources with linked relationships") {
                        author.comment = Comment(id: "321")

                        sut = [author, comment]
                        sut.linkResources()

                        let linkedAuthor = sut.first as? Author
                        let linkedComment = linkedAuthor?.comment

                        expect(linkedComment).to(equal(comment))
                    }

                    context("and resource B has relationship to resource A") {
                        it("should return resources with linked relationships") {
                            author.comment = Comment(id: "321")
                            comment.author = Author(id: "123")

                            sut = [author, comment]
                            sut.linkResources()

                            let linkedAuthor = sut.first as? Author
                            let linkedComment = linkedAuthor?.comment

                            expect(linkedComment).to(equal(comment))
                            expect(linkedComment?.author).to(equal(author))
                        }
                    }
                }
            }

            context("there is resource A with relationships to resource B and resource C") {
                it("should return resources with linked relationships") {
                    comment.author = Author(id: "123")
                    comment.reviewer = Author(id: "111")

                    let author = Author(id: "123")
                    let reviewer = Author(id: "111")

                    sut = [author, comment, reviewer]

                    sut.linkResources()
                    let linkedComment = sut[1] as? Comment

                    expect(linkedComment?.author).to(equal(author))
                    expect(linkedComment?.reviewer).to(equal(reviewer))
                }
            }

            context("there is resource A with list of relationships") {

                context("and all relationships are included") {
                    it("should return resources with linked relationships") {
                        let otherComment = Comment(id: "322")
                        post.comments = [Comment(id: "321"),
                                         Comment(id: "322")]

                        sut = [post, comment, otherComment]
                        sut.linkResources()
                        let linkedPost = sut.first as? Post

                        expect(linkedPost?.comments).to(contain(otherComment))
                        expect(linkedPost?.comments).to(contain(comment))
                        expect(linkedPost?.comments?.count).to(equal(2))
                    }
                }

                context("but some relationship objects are not included") {
                    it("should return resources with matched relationships and rest of resources with no relationships") {
                        let otherComment = Comment(id: "322")
                        let notIncludedComment = Comment(id: "523")

                        post.comments = [Comment(id: "321"),
                                         Comment(id: "322"),
                                         notIncludedComment]

                        sut = [post, comment, otherComment]
                        sut.linkResources()

                        let linkedPost = sut.first as? Post

                        expect(linkedPost?.comments).to(contain(otherComment))
                        expect(linkedPost?.comments).to(contain(comment))
                        expect(linkedPost?.comments).to(contain(notIncludedComment))
                        expect(linkedPost?.comments?.count).to(equal(3))
                    }
                }

                context("and additional relationship to resource B") {
                    it("should return resources with linked relationships") {
                        let otherComment = Comment(id: "322")

                        post.comments = [comment, otherComment]
                        post.author = Author(id: "123")

                        sut = [post, comment, otherComment, author]
                        sut.linkResources()

                        let linkedPost = sut.first as? Post

                        expect(linkedPost?.comments).to(contain(otherComment))
                        expect(linkedPost?.comments).to(contain(comment))
                        expect(linkedPost?.author).to(equal(author))
                        expect(linkedPost?.comments?.count).to(equal(2))
                    }
                }
            }
        }
    }
}
