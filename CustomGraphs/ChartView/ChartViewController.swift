//
//  ViewController.swift
//  CustomGraphs
//
//  Created by Aidos Mukatayev on 2022/01/07.
//

import UIKit
import SnapKit

class ChartViewController: UIViewController {
    
    //MARK: - Properties
    private let graphAxisView: GraphAxisView = GraphAxisView()
    private let stickViewPageVC: SticksViewPageViewController
    private let dataset: [Int : GlucoseGraphModel]
    private var config: ChartViewConfig
    weak var indicatorDelegate: IndicatorDelegate?
    
    //MARK: - Init & Lifecycle
    init(config: ChartViewConfig,
         dataset: [Int : GlucoseGraphModel],
         goalMax: Int,
         goalMin: Int,
         date: Date) {
        self.config = config
        self.dataset = dataset
        
        let stickVC = SticksViewController(maxNumber: Double(config.maxNumber),
                                           graphBackgroundColor: config.graphGridLinesColor,
                                           graphTextColor: config.graphTextColor,
                                           periodType: config.periodType,
                                           dataset: self.dataset,
                                           secondNumber: config.secondNumber,
                                           thirdNumber: config.thirdNumber,
                                           stickColor: config.stickColor,
                                           unselectedColor: config.unselectedColor,
                                           date: date)
        
        let stickVC1 = SticksViewController(maxNumber: Double(config.maxNumber),
                                            graphBackgroundColor: config.graphGridLinesColor,
                                            graphTextColor: config.graphTextColor,
                                            periodType: config.periodType,
                                            dataset: self.dataset,
                                            secondNumber: config.secondNumber,
                                            thirdNumber: config.thirdNumber,
                                            stickColor: config.stickColor,
                                            unselectedColor: config.unselectedColor,
                                            date: date)
        
        self.stickViewPageVC = SticksViewPageViewController(pages: [stickVC, stickVC1])
        super.init(nibName: nil, bundle: nil)
        
        stickVC.indicatorDelegate = self
        stickVC1.indicatorDelegate = self
        
        graphAxisView.setHeroValue(goalMax: goalMax, goalMin: goalMin)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGraphAxisView()
        addsubviews()
    
        verticalChartViewConstraint()
        sticksPageViewControllerConstraint()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        graphAxisView.setupGridView(leftDashLine: config.periodType == .weekly)
    }
    
    //MARK: - Helpers
    private func setupGraphAxisView() {
        graphAxisView.setColors(textColor: config.graphTextColor, gridColor: config.graphGridLinesColor)
        graphAxisView.setYAxisLabels(firstValue: config.maxNumber, secondValue: config.yAxisSecondNumber, thirdValue: config.yAxisThirdNumber)
    }
    
    //MARK: - Subviews
    private func addsubviews() {
        view.addSubview(graphAxisView)
        view.addSubview(stickViewPageVC.view)
        addChild(stickViewPageVC)
        stickViewPageVC.didMove(toParent: self)
    }
    
    //MARK: - Constraint
    private func verticalChartViewConstraint() {
        graphAxisView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func sticksPageViewControllerConstraint() {
        stickViewPageVC.view.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(37)
        }
    }
    
    //MARK: - Public methods
//    public func updateYAxisTopNumber(number: Int) {
//        self.config.maxNumber = number
//        self.setupGraphAxisView()
//        self.graphAxisView.setupGridView(leftDashLine: config.periodType == .weekly)
//    }
//    
//    public func updateYAxisSecondAndThirdNumber(second: Int, third: Int) {
//        self.config.yAxisSecondNumber = second
//        self.config.yAxisThirdNumber = third
//        self.setupGraphAxisView()
//        self.graphAxisView.setupGridView(leftDashLine: config.periodType == .weekly)
//    }
    
}

//MARK: - IndicatorDelegate
extension ChartViewController: IndicatorDelegate {
    func showIndicator(originX: Double, height: Double, width: Double, index: Int) {
        indicatorDelegate?.showIndicator(originX: originX, height: height, width: width, index: index)
    }
    
    func removeIndicator() {
        indicatorDelegate?.removeIndicator()
    }
}
