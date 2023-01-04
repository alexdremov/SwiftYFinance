//
//  QuoteSummarySelection.swift
//  SwiftYFinance
//
//  Created by Александр Дремов on 12.08.2020.
//

import Foundation

public enum QuoteSummarySelection: String {
    case assetProfile
    case incomeStatementHistory
    case incomeStatementHistoryQuarterly
    case balanceSheetHistory
    case balanceSheetHistoryQuarterly
    case cashFlowStatementHistory
    case cashFlowStatementHistoryQuarterly
    case defaultKeyStatistics
    case financialData
    case calendarEvents
    case secFilings
    case recommendationTrend
    case upgradeDowngradeHistory
    case institutionOwnership
    case fundOwnership
    case majorDirectHolders
    case majorHoldersBreakdown
    case insiderTransactions
    case insiderHolders
    case netSharePurchaseActivity
    case sectorTrend
    case earnings
    case companyOfficers
    case summaryProfile
    case quoteType
    case earningsHistory
    case earningsTrend
    case indexTrend
    case industryTrend
    case price
    case symbol
    case summaryDetail
    case fundProfile
    case topHoldings
    case fundPerformance
    case all = "quoteType,summaryProfile,assetProfile,incomeStatementHistory,incomeStatementHistoryQuarterly,balanceSheetHistory,balanceSheetHistoryQuarterly,cashFlowStatementHistory,cashFlowStatementHistoryQuarterly,defaultKeyStatistics,financialData,calendarEvents,secFilings,recommendationTrend,upgradeDowngradeHistory,institutionOwnership,fundOwnership,majorDirectHolders,insiderTransactions,insiderHolders,netSharePurchaseActivity,sectorTrend,earnings,companyOfficers,earningsHistory,earningsTrend,indexTrend,industryTrend,majorHoldersBreakdown,price,summaryDetail,symbol,fundProfile,topHoldings,fundPerformance"
    case supported = "quoteType,summaryProfile,recommendationTrend,price,indexTrend,calendarEvents,summaryDetail"
}
