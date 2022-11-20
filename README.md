# SDSXCTestExtension

convenient extension for testing

## PublisherReceiver
class for publisher test

test codes explain everything.
```
final class PublisherReceiver_tests: XCTestCase {

    func test_PublisherReceiver_lastValue() async throws {
        let pub = PassthroughSubject<Int,Error>()
        let checker = PublisherReceiver(pub)

        pub.send(1)
        try await Task.sleep(for: .seconds(1))

        let lastValue = try XCTUnwrap(checker.lastValue)
        XCTAssertEqual(lastValue, 1)
        XCTAssertFalse(checker.completed)
        XCTAssertNil(checker.error)
    }

    func test_PublisherReceiver_completion() async throws {
        let pub = PassthroughSubject<Int,Error>()
        let checker = PublisherReceiver(pub)

        pub.send(completion: .finished)
        try await Task.sleep(for: .seconds(1))

        XCTAssertNil(checker.lastValue)
        XCTAssertTrue(checker.completed)
        XCTAssertNil(checker.error)
    }

    func test_PublisherReceiver_error() async throws {
        let pub = PassthroughSubject<Int,MyError>()
        let checker = PublisherReceiver(pub)

        pub.send(completion: .failure(MyError.myError))
        try await Task.sleep(for: .seconds(1))

        XCTAssertNil(checker.lastValue)
        XCTAssertFalse(checker.completed)
        let error = try XCTUnwrap(checker.error)
        XCTAssertEqual(error, MyError.myError)
    }

    enum MyError: Error, Equatable {
            case myError
    }

    // for <Void,Errr> Publisher
    func test_PublisherReceiver_lastValue() async throws {
        let pub = PassthroughSubject<Void,Error>()
        let checker = PublisherReceiver(pub)

        pub.send()
        try await Task.sleep(for: .seconds(1))

        let lastValue = try XCTUnwrap(checker.lastValue)
        // lastValue is Void, but it means "received Void"
        XCTAssertFalse(checker.completed)
        XCTAssertNil(checker.error)
    }    
}
```
