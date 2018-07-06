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
    var listValue = [ObjectNumber]()
    override func viewDidLoad() {
        super.viewDidLoad()
        btClose.setRadiusForView(radius: 15, backGroundColor: UIColor.gray.cgColor)
        lbName.text = objName
        if listValue.count > 0 {
           showChart()
        }else{
             chartView.noDataText = "You need to provide data for the chart."
        }
        
    }
    
    func showChart(){
        
        var lineChartEntry = [ChartDataEntry]()
        listValue.append(ObjectNumber(value: "6", occurDate: "2018-02-21"))
        listValue.append(ObjectNumber(value: "10", occurDate: "2018-02-22"))
        listValue.append(ObjectNumber(value: "18", occurDate: "2018-02-23"))
        listValue.append(ObjectNumber(value: "1", occurDate: "2018-02-24"))
        var labels = [String]()
        for i in 0..<listValue.count{
            let dataEntry = ChartDataEntry(x: Double(i), y: listValue[i].value.doubleValue)
            labels.append(listValue[i].occurDate)
            lineChartEntry.append(dataEntry)
        }
        let line = LineChartDataSet(values: lineChartEntry, label: "")
        line.circleColors = [UIColor.blue]
        let data = LineChartData(dataSet: line)
        line.colors = [UIColor.red]
        
        chartView.xAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            return self.getShortDate(date: labels[Int(index)])
        })
        
        chartView.rightAxis.valueFormatter = DefaultAxisValueFormatter(block: {(index, _) in
            return ""
        })
        
        
        chartView.xAxis.spaceMin = 0.5
        chartView.xAxis.spaceMax = 0.5
        chartView.leftAxis.spaceMin = 0.8
        chartView.leftAxis.spaceMax = 0.8
//        chartView.rightAxis.drawAxisLineEnabled = false

        chartView.animate(xAxisDuration: 0.5)
        chartView.data = data
    }
    
    func getShortDate(date:String)->String{
        let arr = date.split(separator: "-")
        return arr[2]+"/"+arr[1]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}


