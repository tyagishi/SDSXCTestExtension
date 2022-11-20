//
//  PublisherReceiver_tests.swift
//
//  Created by : Tomoaki Yagishita on 2022/11/20
//  © 2022  SmallDeskSoftware
//
@testable import SDSXCTestExtension
import Combine
import XCTest

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

    func test_PublisherReceiver_comletion() async throws {
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
}
