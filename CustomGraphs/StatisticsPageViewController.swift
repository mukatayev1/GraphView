//
//  StatisticsPageViewController.swift
//  CustomGraphs
//
//  Created by Aidos Mukatayev on 2022/01/13.
//

import UIKit
import XCTest

protocol DeselectStickDelegate: AnyObject {
    func deselectStick()
}

class StatisticsPageViewController: UIViewController {

    //MARK: - Properties
    private let titleLabel: UILabel = UILabel()
    private var chartViewController: ChartViewController?
    private let valueCardView: ValueCardView = ValueCardView()
    private let segmentedView: UISegmentedControl = UISegmentedControl(items: ["Day", "Week", "Month"])
    
    private var entries: [Int : GlucoseGraphModel] = [:]
    private var biggestValue: Int = 300
    private let goalMax: Int = 200
    private let goalMin: Int = 100
    private let stickIndicatorView: IndicatorView = IndicatorView()
    private let stickIndicatorTriangleView: TriangleView = TriangleView()
    weak var deselectDelegate: DeselectStickDelegate?

    //Colors
    private let graphColor: UIColor = #colorLiteral(red: 0.9137254902, green: 0.9137254902, blue: 0.9137254902, alpha: 1)
    private let graphTextColor: UIColor = #colorLiteral(red: 0.4705882353, green: 0.4901960784, blue: 0.5647058824, alpha: 1)
    private let stickColor: UIColor = #colorLiteral(red: 0.937254902, green: 0.3254901961, blue: 0.3137254902, alpha: 1)
    private let unselectedColor: UIColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
    
    private var date: Date = Date()
    
    //ChangeDate button
    private let selectDateButton: UIButton = UIButton(type: .system)
    private let months: [String] = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    ]
    private var selectedRow = 0
    
    //MARK: - Lifecycle & Init
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWeeklyChart()
        view.backgroundColor = .white
        addSubviews()
        addSubviewChartVC()
        titleLabelAttributes()
        stickIndicatorAttributes()
        segmentedViewAttributes()
        stickIndicatorTriangleViewAttributes()
        selectDateButtonAttributes()
        
        titleLabelConstraint()
        segmentedViewConstraint()
        valueCardViewConstraint()
        selectDateButtonConstraint()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.post(name: NSNotification.Name("DeselectIndicators"), object: nil)
    }
    
    //MARK: - Subviews
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(valueCardView)
        view.addSubview(segmentedView)
        view.addSubview(selectDateButton)
    }
    
    private func addSubviewChartVC() {
        addChild(chartViewController!)
        view.addSubview(chartViewController!.view)
        chartViewController!.didMove(toParent: self)
    }
    
    //MARK: - Attributes
    private func titleLabelAttributes() {
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        titleLabel.text = "CandleChart"
    }
    
    private func stickIndicatorAttributes() {
        let indicatorGray: UIColor = #colorLiteral(red: 0.4674087167, green: 0.489362061, blue: 0.5558612347, alpha: 1)
        stickIndicatorView.setIndicatorColor(indicatorGray)
        stickIndicatorView.triangleDelegate = self
    }
    
    private func segmentedViewAttributes() {
        segmentedView.selectedSegmentIndex = 1
        segmentedView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let textAttributes: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.black]
        let selectedTextAttributes: [NSAttributedString.Key : Any] = [.foregroundColor : UIColor.white]
        segmentedView.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        segmentedView.setTitleTextAttributes(textAttributes, for: .normal)
        segmentedView.selectedSegmentTintColor = .black
        segmentedView.addTarget(self, action: #selector(tappedSegment(_:)), for: .valueChanged)
    }
    
    private func stickIndicatorTriangleViewAttributes() {
        stickIndicatorTriangleView.backgroundColor = .clear
    }
    
    private func selectDateButtonAttributes() {
        selectDateButton.setTitle("Change Date", for: .normal)
        selectDateButton.backgroundColor = .black
        selectDateButton.setTitleColor(.white, for: .normal)
        selectDateButton.layer.cornerRadius = 15
        selectDateButton.layer.masksToBounds = true
        selectDateButton.addTarget(self, action: #selector(changeDate), for: .touchUpInside)
    }
    
    //MARK: - Constraint
    private func titleLabelConstraint() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func segmentedViewConstraint() {
        segmentedView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }
    
    private func valueCardViewConstraint() {
        valueCardView.layer.cornerRadius = 8
        valueCardView.snp.makeConstraints {
            $0.top.equalTo(segmentedView.snp.bottom).offset(20)
            $0.trailing.leading.equalToSuperview().inset(14)
            $0.height.equalTo(115)
        }
    }
    
    private func chartViewControllerConstraint() {
        chartViewController!.view.snp.makeConstraints {
            $0.height.equalTo(330)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().inset(18)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }
    
    private func stickIndicatorTriangleViewConstraint() {
        stickIndicatorTriangleView.snp.makeConstraints {
            $0.height.equalTo(14)
            $0.width.equalTo(28)
            $0.top.equalTo(stickIndicatorView.snp.top)
            $0.centerX.equalTo(stickIndicatorView.snp.centerX)
        }
    }
    
    private func selectDateButtonConstraint() {
        selectDateButton.snp.makeConstraints {
            $0.top.height.equalTo(titleLabel)
            $0.left.equalTo(titleLabel.snp.right).offset(5)
            $0.right.equalToSuperview().inset(16)
        }
    }
    
    //MARK: - Helpers
    private func sortEntries(for period: ChartPeriodType) {
        var glucoseValues: [Int : [Int]] = [:]
        switch period {
        case .daily:
            glucoseValues = Dataset().dailyData
        case .weekly:
            glucoseValues = Dataset().weeklyData
        case .monthly:
            glucoseValues = Dataset().monthlyData(date: self.date)
        }
        entries = [:]
        glucoseValues.keys.forEach { integerKey in
            if let numberArray = glucoseValues[integerKey] {
                
                if !numberArray.isEmpty {
                    numberArray.forEach { number in
                        
                        if entries[integerKey] == nil {
                            entries[integerKey] = .init(maxValue: Double(number), minValue: Double(number))
                        } else {
                            
                            if Double(number) > entries[integerKey]!.maxValue {
                                entries[integerKey]!.maxValue = Double(number)
                            } else if Double(number) < entries[integerKey]!.maxValue {
                                entries[integerKey]!.minValue = Double(number)
                            }
                            
                        }
                        
                        //BiggestValue
                        if number > biggestValue && number > 300 {
                            biggestValue = number
                        }
                    }
                } else {
                    entries[integerKey] = .init(maxValue: 0, minValue: 0)
                }
            }
        }
    }
    
    private func showIndicatorView(originX: Double, height: Double, width: Double) {
        let topOffset = valueCardView.frame.origin.y + valueCardView.frame.height
        
        if self.stickIndicatorView.superview == nil {
            view.addSubview(stickIndicatorView)
        }
        
        stickIndicatorView.snp.remakeConstraints {
            $0.top.equalToSuperview().offset(topOffset)
            $0.leading.equalToSuperview().offset(originX)
            $0.width.equalTo(width)
            $0.height.equalTo(height - topOffset)
        }
    }
    
    private func configureStats(period: ChartPeriodType) {
        biggestValue = 0
        switch period {
        case .daily:
            loadDailyChart()
        case .weekly:
            loadWeeklyChart()
        case .monthly:
            loadMonthlyChart()
        }
    }
    
    //MARK: - LoadingData
    private func loadWeeklyChart() {
        sortEntries(for: .weekly)
        
        let secondNumber = Double(biggestValue) * 0.6666 + 1
        let thirdNumber = Double(biggestValue) * 0.3333 + 1
        
        let config = ChartViewConfig(maxNumber: self.biggestValue,
                                     yAxisSecondNumber: Int(secondNumber),
                                     yAxisThirdNumber: Int(thirdNumber),
                                     graphGridLinesColor: graphColor,
                                     graphTextColor: graphTextColor,
                                     periodType: .weekly,
                                     stickColor: stickColor,
                                     unselectedColor: unselectedColor,
                                     secondNumber: secondNumber,
                                     thirdNumber: thirdNumber)
        chartViewController?.removeFromParent()
        chartViewController?.view.removeFromSuperview()
        chartViewController = nil
        chartViewController = ChartViewController(config: config,
                                                  dataset: self.entries,
                                                  goalMax: goalMax,
                                                  goalMin: goalMin,
                                                  date: self.date)
        addSubviewChartVC()
        chartViewControllerConstraint()

        chartViewController?.indicatorDelegate = self
    }
    
    private func loadMonthlyChart() {
        sortEntries(for: .monthly)
        
        let secondNumber = Double(biggestValue) * 0.6666 + 1
        let thirdNumber = Double(biggestValue) * 0.3333 + 1
        let config = ChartViewConfig(maxNumber: self.biggestValue,
                                     yAxisSecondNumber: Int(secondNumber),
                                     yAxisThirdNumber: Int(thirdNumber),
                                     graphGridLinesColor: graphColor,
                                     graphTextColor: graphTextColor,
                                     periodType: .monthly,
                                     stickColor: stickColor,
                                     unselectedColor: unselectedColor,
                                     secondNumber: secondNumber,
                                     thirdNumber: thirdNumber)
        chartViewController?.removeFromParent()
        chartViewController?.view.removeFromSuperview()
        chartViewController = nil
        chartViewController = ChartViewController(config: config,
                                                  dataset: self.entries,
                                                  goalMax: goalMax,
                                                  goalMin: goalMin,
                                                  date: self.date)
        addSubviewChartVC()
        chartViewControllerConstraint()
        chartViewController?.indicatorDelegate = self
    }
    
    private func loadDailyChart() {
        sortEntries(for: .daily)
        
        let secondNumber = Double(biggestValue) * 0.6666 + 1
        let thirdNumber = Double(biggestValue) * 0.3333 + 1
        let config = ChartViewConfig(maxNumber: self.biggestValue,
                                     yAxisSecondNumber: Int(secondNumber),
                                     yAxisThirdNumber: Int(thirdNumber),
                                     graphGridLinesColor: graphColor,
                                     graphTextColor: graphTextColor,
                                     periodType: .daily,
                                     stickColor: stickColor,
                                     unselectedColor: unselectedColor,
                                     secondNumber: secondNumber,
                                     thirdNumber: thirdNumber)
        chartViewController?.removeFromParent()
        chartViewController?.view.removeFromSuperview()
        chartViewController = nil
        chartViewController = ChartViewController(config: config,
                                                  dataset: self.entries,
                                                  goalMax: goalMax,
                                                  goalMin: goalMin,
                                                  date: self.date)
        addSubviewChartVC()
        chartViewControllerConstraint()
        chartViewController?.indicatorDelegate = self
    }
    
    //MARK: - Selectors
    @objc private func tappedSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: configureStats(period: .daily)
        case 1: configureStats(period: .weekly)
        case 2: configureStats(period: .monthly)
        default: break
        }
    }
}

//MARK: - IndicatorDelegate
extension StatisticsPageViewController: IndicatorDelegate, IndicatorTriangleDelegate {
    func showIndicator(originX: Double, height: Double, width: Double, index: Int) {
        self.showIndicatorView(originX: originX, height: height, width: width)
        let element = entries[index]
        self.valueCardView.setValue(minValue: Int(element?.minValue ?? 69), maxValue: Int(element?.maxValue ?? 69))
    }
    
    func removeIndicator() {
        self.valueCardView.setValue(minValue: 0, maxValue: 0)
        if self.stickIndicatorView.superview != nil {
            stickIndicatorView.removeFromSuperview()
        }
        
        if stickIndicatorTriangleView.superview != nil {
            stickIndicatorTriangleView.removeFromSuperview()
        }
    }
    
    func showTriangleView() {
        presentIndicatorTriangle()
    }
    
    private func presentIndicatorTriangle() {
        
        if stickIndicatorTriangleView.superview == nil {
            view.addSubview(stickIndicatorTriangleView)
        }
        
        stickIndicatorTriangleViewConstraint()
        DispatchQueue.main.async {
            self.stickIndicatorTriangleView.isHidden = self.stickIndicatorTriangleView.frame.origin.x < 16
        }
    }
}

//MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension StatisticsPageViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return months.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 45
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 350, height: 35))
        label.text = months[row]
        label.sizeToFit()
        return label
    }
    
    @objc private func changeDate() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: view.frame.width, height: 150)
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(selectedRow, inComponent: 0, animated: false)
        vc.view.addSubview(pickerView)
        pickerView.snp.makeConstraints { $0.edges.equalToSuperview() }
    
        let alertController = UIAlertController(title: "Choose Date", message: "", preferredStyle: .actionSheet)
        alertController.setValue(vc, forKey: "contentViewController")
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Select", style: .default, handler: { _ in
            self.selectedRow = pickerView.selectedRow(inComponent: 0)
            let components = DateComponents(year: 2022, month: self.selectedRow + 1)
            self.date = Calendar.current.date(from: components)!
            self.segmentedView.selectedSegmentIndex = 2
            self.configureStats(period: .monthly)
        }))
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
