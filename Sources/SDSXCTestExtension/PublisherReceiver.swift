//
//  PublisherReceiver.swift
//
//  Created by : Tomoaki Yagishita on 2022/11/20
//  © 2022  SmallDeskSoftware
//

import Combine
import XCTest

extension XCTestCase {
    class PublisherReceiver<P: Publisher> {
        private(set) var value: P.Output? = nil
        private(set) var _error: P.Failure? = nil
        private(set) var _completed: Bool = false
        var cancellable: AnyCancellable? = nil
        init(_ publisher: P) {
            cancellable = publisher.sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self._error = error
                    case .finished:
                        self._completed = true
                    }
                },
                receiveValue: { value in
                    self.value = value
                }
            )
        }

        public var lastValue: P.Output? {
            return value
        }

        public var error: P.Failure? {
            return _error
        }
        public var completed: Bool {
            return _completed
        }
    }
}
