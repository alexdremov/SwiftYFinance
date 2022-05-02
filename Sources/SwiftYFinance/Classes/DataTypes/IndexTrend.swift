//
//  File.swift
//  SwiftYFinance
//
//  Created by Александр Дремов on 13.08.2020.
//

import Foundation

public struct IndexTrend {
    public var maxAge: Int?
    public var symbol: String?
    public var peRatio: Float?
    public var pegRatio: Float?
    public var estimates: [IndexTrendEstimates]?
}

public struct IndexTrendEstimates {
    public var period: String?
    public var growth: Float?
}
