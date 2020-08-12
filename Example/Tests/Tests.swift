// https://github.com/Quick/Quick

import Quick
import Nimble
import SwiftYFinance

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        describe("basic SwiftYFinance tests") {
            
            it("RecentStockData") {
                SwiftYFinance.recentDataBy(identifier: "asdafdfasd")
                {data, error in
                    expect(data) == nil
                    expect(error) != nil
                }
                SwiftYFinance.recentDataBy(identifier: "AAPL")
                {data, error in
                    expect(data) != nil
                    expect(error) == nil
                }
            }
        }
    }
}
