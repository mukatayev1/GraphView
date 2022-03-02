//
//  ChartViewConfig.swift
//  CustomGraphs
//
//  Created by Aidos Mukatayev on 2022/01/18.
//

import UIKit

struct ChartViewConfig {
    //Graph y-axis numbers
    var maxNumber: Int
    var yAxisSecondNumber: Int
    var yAxisThirdNumber: Int
    //graphBackgroundColor
    let graphGridLinesColor: UIColor
    let graphTextColor: UIColor
    //ChartPeriodType
    var periodType: ChartPeriodType
    //Stick Colors
    let stickColor: UIColor
    let unselectedColor: UIColor
    //Y Axis: Second and Third numbers
    let secondNumber: Double
    let thirdNumber: Double
}
