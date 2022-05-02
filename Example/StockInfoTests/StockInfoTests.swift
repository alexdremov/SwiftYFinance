//
//  StockInfoTests.swift
//  StockInfoTests
//
//  Created by Александр Дремов on 13.08.2020.
//  Copyright © 2020 alexdremov. All rights reserved.
//

@testable import SwiftYFinance
import XCTest

/*
 xcodebuild test -workspace StockInfo.xcworkspace -scheme StockInfo -destination 'platform=iOS Simulator,name=iPhone 11 Pro Max,OS=13.6'
 */

class StockInfoTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_fetchSearchDataBy() throws {
        //        Empty request check
        let promise = expectation(description: "Request finished")
        SwiftYFinance.fetchSearchDataBy(searchTerm: "    ") {
            data, error in
            XCTAssertTrue(data?.count == 0)
            XCTAssertNil(error)
            promise.fulfill()
        }

        let promise2 = expectation(description: "Request finished")

        SwiftYFinance.fetchSearchDataBy(searchTerm: "AAPL") {
            data, error in
            XCTAssertTrue(data?.count != 0)
            XCTAssertNil(error)
            promise2.fulfill()
        }

        let (data, error) = SwiftYFinance.syncFetchSearchDataBy(searchTerm: "AAPL")

        XCTAssertTrue(data?.count != 0)
        XCTAssertNil(error)

        wait(for: [promise, promise2], timeout: 5)
    }

    func test_fetchSearchDataByNews() throws {
        let promise = expectation(description: "Request finished")
        SwiftYFinance.fetchSearchDataBy(searchNews: "sdfasdfasfasdasdfas") {
            data, error in
            XCTAssertTrue(data?.count == 0)
            XCTAssertNil(error)
            promise.fulfill()
        }

        let promise2 = expectation(description: "Request finished")

        SwiftYFinance.fetchSearchDataBy(searchNews: "AAPL") {
            data, error in
            XCTAssertTrue(data?.count != 0)
            XCTAssertNil(error)
            promise2.fulfill()
        }

        let (data, error) = SwiftYFinance.syncFetchSearchDataBy(searchNews: "AAPL")

        XCTAssertTrue(data?.count != 0)
        XCTAssertNil(error)

        wait(for: [promise, promise2], timeout: 5)
    }

    func test_summaryDataBy() throws {
        var promises: [XCTestExpectation] = []
        promises.append(expectation(description: "Request finished"))

        SwiftYFinance.summaryDataBy(identifier: "AAPL", selection: .all) {
            data, error in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            promises[0].fulfill()
        }
        promises.append(expectation(description: "Request finished"))

        SwiftYFinance.summaryDataBy(identifier: "", selection: .all) {
            data, error in
            XCTAssertNil(data)
            XCTAssertNotNil( try? XCTUnwrap(error))
            promises[1].fulfill()
        }

        promises.append(expectation(description: "Request finished"))

        SwiftYFinance.summaryDataBy(identifier: "akdjglkadjskdljfklas", selection: [.assetProfile, .cashFlowStatementHistoryQuarterly]) {
            data, error in
            XCTAssertNil(data)
            XCTAssertNotNil( try? XCTUnwrap(error))
            promises[2].fulfill()
        }

        promises.append(expectation(description: "Request finished"))

        SwiftYFinance.summaryDataBy(identifier: "AAPL", selection: [.assetProfile, .cashFlowStatementHistoryQuarterly, .financialData]) {
            data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            promises[3].fulfill()
        }

        wait(for: promises, timeout: 5)
    }

    func test_syncSummaryDataBy() throws {
        let (data, error) = SwiftYFinance.syncSummaryDataBy(identifier: "AAPL", selection: [.assetProfile, .cashFlowStatementHistoryQuarterly, .financialData])

        XCTAssertNotNil(data)
        XCTAssertNil(error)

        let (data2, error2) = SwiftYFinance.syncSummaryDataBy(identifier: "AAPL", selection: .all)

        XCTAssertNotNil(data2)
        XCTAssertNil(error2)
    }

    func test_recentDataBy() throws {
        var promises: [XCTestExpectation] = []
        promises.append(expectation(description: "Request finished"))
        SwiftYFinance.recentDataBy(identifier: "AAPL") {
            data, error in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            promises[0].fulfill()
        }

        promises.append(expectation(description: "Request finished"))
        SwiftYFinance.recentDataBy(identifier: "/asd+=?&") {
            data, error in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
            promises[1].fulfill()
        }

        promises.append(expectation(description: "Request finished"))
        SwiftYFinance.recentDataBy(identifier: "") {
            data, error in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
            promises[2].fulfill()
        }

        let (data, error) = SwiftYFinance.syncRecentDataBy(identifier: "AAPL")

        XCTAssertNotNil(data)
        XCTAssertNil(error)

        wait(for: promises, timeout: 5)
    }

    func test_chartDataBy() throws {
        var promises: [XCTestExpectation] = []

        //        promises.append(expectation(description: "Request finished"))
        //        SwiftYFinance.chartDataBy(identifier: "AAPL"){
        //            data, error in
        //            XCTAssertNil(error)
        //            XCTAssertNotNil(data)
        //            promises[0].fulfill()
        //        }
        //
        promises.append(expectation(description: "Request finished"))
        SwiftYFinance.chartDataBy(identifier: "AAPL", start: Date(timeIntervalSince1970: 1)) {
            data, error in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            promises[0].fulfill()
        }

        promises.append(expectation(description: "Request finished"))
        SwiftYFinance.chartDataBy(identifier: "", start: Date(timeIntervalSince1970: 1)) {
            data, error in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
            promises[1].fulfill()
        }

        promises.append(expectation(description: "Request finished"))
        SwiftYFinance.chartDataBy(identifier: "AAPL", start: Date(timeIntervalSince1970: 1), interval: .oneminute) {
            data, error in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
            promises[2].fulfill()
        }

        let (data, error) = SwiftYFinance.syncChartDataBy(identifier: "AAPL", start: Date(timeIntervalSince1970: 1), interval: .oneminute)

        XCTAssertNotNil(error)
        XCTAssertNil(data)

        wait(for: promises, timeout: 5)
    }

    func test_recentChartDataAtMoment() throws {
        var promises: [XCTestExpectation] = []

        promises.append(expectation(description: "Request finished"))
        SwiftYFinance.recentChartDataAtMoment(identifier: "AAPL") {
            data, error in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            promises[0].fulfill()
        }

        promises.append(expectation(description: "Request finished"))
        SwiftYFinance.recentChartDataAtMoment(identifier: "") {
            data, error in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
            promises[1].fulfill()
        }

        promises.append(expectation(description: "Request finished"))
        SwiftYFinance.recentChartDataAtMoment(identifier: "", moment: Date(timeIntervalSince1970: 9e10)) {
            data, error in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
            promises[2].fulfill()
        }

        let (data, error) = SwiftYFinance.syncRecentChartDataAtMoment(identifier: "AAPL")

        XCTAssertNotNil(data)
        XCTAssertNil(error)

        wait(for: promises, timeout: 5)
    }
}
