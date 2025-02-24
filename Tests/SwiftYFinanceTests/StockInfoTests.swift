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
    let validTicker: String = "AAPL"
    let invalidTicker: String = "INVALID_TICKER"
    let emptyTicker: String = ""
    let whitespaceTicker: String = "    "
    let requestFinished: String = "Request finished"
    let selectionAll: QuoteSummarySelection = .all
    let selectionSet: [QuoteSummarySelection] = [.assetProfile, .cashFlowStatementHistoryQuarterly, .financialData]
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_fetchSearchDataBy_searchTermWithValidTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.fetchSearchDataBy(searchTerm: validTicker) { data, error in
            XCTAssertTrue(data?.count != 0)
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_fetchSearchDataBy_searchTermWithInvalidTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.fetchSearchDataBy(searchTerm: invalidTicker) { data, error in
            XCTAssertTrue(data?.count == 0)
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_fetchSearchDataBy_searchTermWithEmptyTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.fetchSearchDataBy(searchTerm: emptyTicker) { data, error in
            XCTAssertTrue(data?.count == 0)
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }

    func test_fetchSearchDataBy_searchTermWithWhitespaceTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.fetchSearchDataBy(searchTerm: whitespaceTicker) { data, error in
            XCTAssertTrue(data?.count == 0)
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_syncFetchSearchDataBy_searchTermWithValidTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncFetchSearchDataBy(searchTerm: validTicker)
        // Assert
        XCTAssertTrue(data?.count != 0)
        XCTAssertNil(error)
    }
    
    func test_syncFetchSearchDataBy_searchTermWithInvalidTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncFetchSearchDataBy(searchTerm: invalidTicker)
        // Assert
        XCTAssertTrue(data?.count == 0)
        XCTAssertNil(error)
    }
    
    func test_syncFetchSearchDataBy_searchTermWithEmptyTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncFetchSearchDataBy(searchTerm: emptyTicker)
        // Assert
        XCTAssertTrue(data?.count == 0)
        XCTAssertNil(error)
    }
    
    func test_syncFetchSearchDataBy_searchTermWithWhitespaceTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncFetchSearchDataBy(searchTerm: whitespaceTicker)
        // Assert
        XCTAssertTrue(data?.count == 0)
        XCTAssertNil(error)
    }

    func test_fetchSearchDataByNews_searchNewsWithValidTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.fetchSearchDataBy(searchNews: invalidTicker) { data, error in
            XCTAssertTrue(data?.count == 0)
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_fetchSearchDataByNews_searchNewsWithInvalidTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.fetchSearchDataBy(searchNews: invalidTicker) { data, error in
            XCTAssertTrue(data?.count == 0)
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_fetchSearchDataByNews_searchNewsWithEmptyTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.fetchSearchDataBy(searchNews: emptyTicker) { data, error in
            XCTAssertTrue(data?.count == 0)
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_fetchSearchDataByNews_searchNewsWithWhitespaceTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.fetchSearchDataBy(searchNews: whitespaceTicker) { data, error in
            XCTAssertTrue(data?.count == 0)
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_syncFetchSearchDataBy_searchNewsWithValidTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncFetchSearchDataBy(searchNews: validTicker)
        // Assert
        XCTAssertTrue(data?.count != 0)
        XCTAssertNil(error)
    }
    
    func test_syncFetchSearchDataBy_searchNewsWithInvalidTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncFetchSearchDataBy(searchNews: invalidTicker)
        // Assert
        XCTAssertTrue(data?.count == 0)
        XCTAssertNil(error)
    }
    
    func test_syncFetchSearchDataBy_searchNewsWithEmptyTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncFetchSearchDataBy(searchNews: emptyTicker)
        // Assert
        XCTAssertTrue(data?.count == 0)
        XCTAssertNil(error)
    }
    
    func test_syncFetchSearchDataBy_searchNewsWithWhitespaceTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncFetchSearchDataBy(searchNews: whitespaceTicker)
        // Assert
        XCTAssertTrue(data?.count == 0)
        XCTAssertNil(error)
    }

    func test_summaryDataBy_selectionAllWithValidTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.summaryDataBy(identifier: validTicker, selection: selectionAll) { data, error in
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_summaryDataBy_selectionAllWithInvalidTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.summaryDataBy(identifier: invalidTicker, selection: selectionAll) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil( try? XCTUnwrap(error))
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_summaryDataBy_selectionAllWithEmptyTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.summaryDataBy(identifier: emptyTicker, selection: selectionAll) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil( try? XCTUnwrap(error))
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_summaryDataBy_selectionAllWithWhitespaceTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.summaryDataBy(identifier: emptyTicker, selection: selectionAll) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil( try? XCTUnwrap(error))
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_summaryDataBy_selectionSetWithValidTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.summaryDataBy(identifier: validTicker, selection: selectionSet) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_summaryDataBy_selectionSetWithInvalidTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.summaryDataBy(identifier: invalidTicker, selection: selectionSet) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil( try? XCTUnwrap(error))
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_summaryDataBy_selectionSetWithEmptyTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.summaryDataBy(identifier: emptyTicker, selection: selectionSet) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil( try? XCTUnwrap(error))
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_summaryDataBy_selectionSetWithWhitespaceTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.summaryDataBy(identifier: whitespaceTicker, selection: selectionSet) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil( try? XCTUnwrap(error))
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_syncSummaryDataBy_selectionAllWithValidTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncSummaryDataBy(identifier: validTicker, selection: selectionAll)
        // Assert
        XCTAssertNotNil(data)
        XCTAssertNil(error)
    }
    
    func test_syncSummaryDataBy_selectionAllWithInvalidTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncSummaryDataBy(identifier: invalidTicker, selection: selectionAll)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
    
    func test_syncSummaryDataBy_selectionAllWithEmptyTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncSummaryDataBy(identifier: emptyTicker, selection: selectionAll)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
    
    func test_syncSummaryDataBy_selectionAllWithWhitespaceTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncSummaryDataBy(identifier: whitespaceTicker, selection: selectionAll)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }

    func test_syncSummaryDataBy_selectionSetWithValidTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncSummaryDataBy(identifier: validTicker, selection: selectionSet)
        // Assert
        XCTAssertNotNil(data)
        XCTAssertNil(error)
    }
    
    func test_syncSummaryDataBy_selectionSetWithInvalidTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncSummaryDataBy(identifier: invalidTicker, selection: selectionSet)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
    
    func test_syncSummaryDataBy_selectionSetWithEmptyTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncSummaryDataBy(identifier: emptyTicker, selection: selectionSet)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
    
    func test_syncSummaryDataBy_selectionSetWithWhitespaceTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncSummaryDataBy(identifier: whitespaceTicker, selection: selectionSet)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
    
    func test_recentDataBy_validTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.recentDataBy(identifier: validTicker) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_recentDataBy_invalidTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.recentDataBy(identifier: invalidTicker) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_recentDataBy_emptyTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.recentDataBy(identifier: emptyTicker) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_recentDataBy_whitespaceTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.recentDataBy(identifier: whitespaceTicker) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
        
    func test_syncRecentDataBy_validTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncRecentDataBy(identifier: validTicker)
        // Assert
        XCTAssertNotNil(data)
        XCTAssertNil(error)
    }
    
    func test_syncRecentDataBy_invalidTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncRecentDataBy(identifier: invalidTicker)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
    
    func test_syncRecentDataBy_emptyTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncRecentDataBy(identifier: emptyTicker)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
    
    func test_syncRecentDataBy_whitespaceTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncRecentDataBy(identifier: whitespaceTicker)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
        
    func test_chartDataBy_validTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.chartDataBy(identifier: validTicker) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_chartDataBy_invalidTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.chartDataBy(identifier: invalidTicker) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_chartDataBy_emptyTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.chartDataBy(identifier: emptyTicker) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_chartDataBy_whitespaceTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.chartDataBy(identifier: whitespaceTicker) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
        
    func test_syncChartDataBy_validTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncChartDataBy(identifier: validTicker)
        // Assert
        XCTAssertNotNil(data)
        XCTAssertNil(error)
    }
    
    func test_syncChartDataBy_invalidTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncChartDataBy(identifier: invalidTicker)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
    
    func test_syncChartDataBy_emptyTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncChartDataBy(identifier: emptyTicker)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
    
    func test_syncChartDataBy_whitespaceTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncChartDataBy(identifier: whitespaceTicker)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
        
    func test_recentChartDataAtMoment_validTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.recentChartDataAtMoment(identifier: validTicker) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_recentChartDataAtMoment_invalidTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.recentChartDataAtMoment(identifier: invalidTicker) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_recentChartDataAtMoment_emptyTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.recentChartDataAtMoment(identifier: emptyTicker) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_recentChartDataAtMoment_whitespaceTicker() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        // Act + Assert
        SwiftYFinance.recentChartDataAtMoment(identifier: whitespaceTicker) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_recentChartDataAtMoment_validTickerWithInvalidTime() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        let moment = Date(timeIntervalSince1970: 9e10)
        // Act + Assert
        SwiftYFinance.recentChartDataAtMoment(identifier: emptyTicker, moment: moment) { data, error in
            XCTAssertNotNil(error)
            XCTAssertNil(data)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
        
    func test_syncRecentChartDataAtMoment_validTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncRecentChartDataAtMoment(identifier: validTicker)
        // Assert
        XCTAssertNotNil(data)
        XCTAssertNil(error)
    }
    
    func test_syncRecentChartDataAtMoment_invalidTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncRecentChartDataAtMoment(identifier: invalidTicker)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
    
    func test_syncRecentChartDataAtMoment_emptyTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncRecentChartDataAtMoment(identifier: emptyTicker)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
    
    func test_syncRecentChartDataAtMoment_whitespaceTicker() throws {
        // Arrange + Act
        let (data, error) = SwiftYFinance.syncRecentChartDataAtMoment(identifier: whitespaceTicker)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
    
    func test_chartDataBy_validTickerWithStartDate() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        let startDate = Date(timeIntervalSince1970: 1)
        // Act + Assert
        SwiftYFinance.chartDataBy(identifier: validTicker, start: startDate) { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_chartDataBy_invalidTickerWithStartDate() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        let startDate = Date(timeIntervalSince1970: 1)
        // Act + Assert
        SwiftYFinance.chartDataBy(identifier: invalidTicker, start: startDate) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_chartDataBy_emptyTickerWithStartDate() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        let startDate = Date(timeIntervalSince1970: 1)
        // Act + Assert
        SwiftYFinance.chartDataBy(identifier: emptyTicker, start: startDate) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_chartDataBy_whitespaceTickerWithStartDate() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        let startDate = Date(timeIntervalSince1970: 1)
        // Act + Assert
        SwiftYFinance.chartDataBy(identifier: whitespaceTicker, start: startDate) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
        
    func test_chartDataBy_validTickerWithStartDateAndInterval() throws {
        // Arrange
        let promise = expectation(description: requestFinished)
        let startDate = Date(timeIntervalSince1970: 1)
        // Act + Assert
        SwiftYFinance.chartDataBy(identifier: validTicker, start: startDate, interval: .oneminute) { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_syncChartDataBy_validTickerWithStartDateAndInterval() throws {
        // Arrange
        let startDate = Date(timeIntervalSince1970: 1)
        // Act
        let (data, error) = SwiftYFinance.syncChartDataBy(identifier: validTicker, start: startDate, interval: .oneminute)
        // Assert
        XCTAssertNil(data)
        XCTAssertNotNil(error)
    }
}
