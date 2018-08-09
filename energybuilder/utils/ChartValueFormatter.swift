//
//  ChartValueFormatter.swift
//  energybuilder
//
//  Created by Thep To Kim on 8/3/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import Foundation
import Charts
class ChartValueFormatter: NSObject, IValueFormatter {

    
    convenience init(numberFormatter: NumberFormatter) {
        self.init()
    }
    
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        return value.getTextRatesFormat
    }
}
