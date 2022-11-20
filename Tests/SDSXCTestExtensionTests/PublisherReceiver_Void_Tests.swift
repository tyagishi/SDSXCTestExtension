//
//  PublisherReceiver_Void_Tests.swift
//
//  Created by : Tomoaki Yagishita on 2022/11/21
//  © 2022  SmallDeskSoftware
//

import XCTest
import Combine

final class PublisherReceiver_Void_Tests: XCTestCase {

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
