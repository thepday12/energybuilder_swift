//
//  DialogNumberChart.swift
//  energybuilder
//
//  Created by Thep To Kim on 7/5/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import UIKit
import Charts

class DialogNumberChart: UIViewController, ChartViewDelegate {
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var btClose: UIButton!
    @IBOutlet weak var chartView: LineChartView!
    
    var objName = ""
    var decimals = 0
    var listValue = [ObjectNumber]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //btClose.setRadiusForView(radius: 15, backGroundColor: UIColor.gray.cgColor)
        btClose.setRadiusForButton(radius: 15)
        lbName.text = objName
        if listValue.count > 0 {
//            listValue.append(ObjectNumber(value: "6", occurDate: "2018-02-21"))
//            listValue.append(ObjectNumber(value: "10", occurDate: "2018-02-22"))
//            listValue.append(ObjectNumber(value: "18", occurDate: "2018-02-23"))
//            listValue.append(ObjectNumber(value: "1", occurDate: "2018-02-24"))
//            listValue.append(ObjectNumber(value: "6", occurDate: "2018-02-25"))
//            listValue.append(ObjectNumber(value: "10", occurDate: "2018-02-26"))
//            listValue.append(ObjectNumber(value: "18", occurDate: "2018-02-27"))
//            listValue.append(ObjectNumber(value: "1", occurDate: "2018-02-28"))
//            listValue.append(ObjectNumber(value: "6", occurDate: "2018-03-01"))
//            listValue.append(ObjectNumber(value: "10", occurDate: "2018-03-02"))
//            listValue.append(ObjectNumber(value: "18", occurDate: "2018-03-23"))
//            listValue.append(ObjectNumber(value: "1", occurDate: "2018-03-24"))
            listValue = listValue.sorted(by: { $0.occurDate < $1.occurDate })
            showChart()
        }else{
            chartView.noDataText = "You need to provide data for the chart."
        }
        
        
    }
    
    func showChart(){
        
        var lineChartEntry = [ChartDataEntry]()
        var labels = [String]()
        var endIndex = 0
        if listValue.count > 10 {
            endIndex = listValue.count-10
        }
        var tmpList = [ObjectNumber]()
        for i in endIndex..<listValue.count{
            tmpList.append(listValue[i])
        }
        
        let valuesNumberFormatter = ChartValueFormatter(decimals: decimals)
        for i in 0..<tmpList.count{
            let value = tmpList[i].value
            let dataEntry = ChartDataEntry(x: Double(i), y: value.doubleValue)
            labels.append(tmpList[i].occurDate)
            lineChartEntry.append(dataEntry)
        }
        let line = LineChartDataSet(values: lineChartEntry, label: " ")
        //        line.circleColors = [UIColor.blue]
        //format value
        line.valueFormatter = valuesNumberFormatter
        
        let data = LineChartData(dataSet: line)
        //        line.colors = [UIColor.red]
        chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            return self.getShortDate(date: labels[Int(index)])
        })
        
        
        chartView.rightAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            return ""
        })
        
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = true
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.chartDescription?.text = ""
        chartView.xAxis.spaceMin = 0.5
        chartView.xAxis.spaceMax = 0.5
        chartView.leftAxis.spaceTop = 0.8
        chartView.leftAxis.spaceBottom = 0.5
        chartView.xAxis.granularity =  1.0
        chartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        chartView.legend.enabled = false
        chartView.animate(xAxisDuration: 0.5)
        
        chartView.data = data
    }
    
    func getShortDate(date:String)->String{
        if !date.isEmpty{
            let arr = date.split(separator: "-")
            return arr[2]+"/"+arr[1]
        }else{
            return ""
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}


